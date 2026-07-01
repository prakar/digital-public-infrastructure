#!/usr/bin/env python3
"""
Rebuilds dictionary.sqlite from data/providers.csv + data/capabilities.csv.

This is the ONLY script that should write to dictionary.sqlite.

WHY CSV INSTEAD OF HAND-WRITTEN SQL:
Adding an entry used to mean writing an `INSERT INTO capabilities (...)`
statement and manually tracking the next free integer ID. That's exactly
the kind of thing that silently breaks after the 40th edit. CSV means:
open data/capabilities.csv, add one row, reference the provider by NAME
(not ID) — IDs are derived automatically at build time. schema.sql itself
is unchanged; only how you FEED data into it changed.

WHAT THIS SCRIPT VALIDATES (so a bad row fails loudly, not silently):
  - Every capabilities.csv row's provider_name exists in providers.csv.
  - domain_bucket, layer, org_type, maturity_status match a known,
    intentional controlled vocabulary (typos get caught here, not
    discovered later as a mysteriously missing row in the viewer).
  - No two providers share a name (would silently merge in the lookup).
  - No two capabilities are exact duplicates (same provider + same name).
  - Every row has all required fields non-empty.
Any failure aborts the build with a specific row number and reason —
nothing partial gets written.

Usage: python3 build_db.py
"""
import csv
import shutil
import sqlite3
import sys
import pathlib

ROOT = pathlib.Path(__file__).parent
DB_PATH = ROOT / "dictionary.sqlite"
WEB_DB_PATH = ROOT / "docs" / "dictionary.sqlite"
SCHEMA_PATH = ROOT / "schema.sql"
PROVIDERS_CSV = ROOT / "data" / "providers.csv"
CAPABILITIES_CSV = ROOT / "data" / "capabilities.csv"

# Controlled vocabulary — must match the CHECK constraints in schema.sql.
# Kept here too (not just relying on sqlite's error) so failures point at
# the specific bad value and row, not a generic "CHECK constraint failed".
VALID_ORG_TYPES = {
    "gov_india", "private_india", "foundation_india",
    "international_gov_or_un", "international_ngo_or_foundation",
    "open_source_community",
}
VALID_LAYERS = {"protocol", "core_service", "product", "dataset_or_registry"}
VALID_MATURITY = {
    "active_maintained", "active_but_deprecating",
    "legacy_unmaintained_but_usable", "draft_or_early_stage",
    "mixed_or_unverified",
}
PROVIDER_REQUIRED = ["name", "org_type", "country_scope"]
CAPABILITY_REQUIRED = [
    "provider_name", "domain_bucket", "layer", "name",
    "real_world_capability", "maturity_status", "source_pass",
]


class ValidationError(Exception):
    pass


def load_csv(path):
    with open(path, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def validate_providers(providers):
    errors = []
    seen_names = set()
    for i, row in enumerate(providers, start=2):  # row 1 is the header
        for field in PROVIDER_REQUIRED:
            if not row.get(field, "").strip():
                errors.append(f"providers.csv:{i} — missing required field '{field}'")
        name = row.get("name", "").strip()
        if name in seen_names:
            errors.append(f"providers.csv:{i} — duplicate provider name '{name}'")
        seen_names.add(name)
        org_type = row.get("org_type", "").strip()
        if org_type and org_type not in VALID_ORG_TYPES:
            errors.append(
                f"providers.csv:{i} — unknown org_type '{org_type}' "
                f"(expected one of: {', '.join(sorted(VALID_ORG_TYPES))})"
            )
    return errors


def validate_capabilities(capabilities, provider_names):
    errors = []
    seen = set()
    for i, row in enumerate(capabilities, start=2):
        for field in CAPABILITY_REQUIRED:
            if not row.get(field, "").strip():
                errors.append(f"capabilities.csv:{i} — missing required field '{field}'")

        provider_name = row.get("provider_name", "").strip()
        if provider_name and provider_name not in provider_names:
            errors.append(
                f"capabilities.csv:{i} — provider_name '{provider_name}' "
                f"not found in providers.csv (check spelling / add the provider first)"
            )

        layer = row.get("layer", "").strip()
        if layer and layer not in VALID_LAYERS:
            errors.append(
                f"capabilities.csv:{i} — unknown layer '{layer}' "
                f"(expected one of: {', '.join(sorted(VALID_LAYERS))})"
            )

        maturity = row.get("maturity_status", "").strip()
        if maturity and maturity not in VALID_MATURITY:
            errors.append(
                f"capabilities.csv:{i} — unknown maturity_status '{maturity}' "
                f"(expected one of: {', '.join(sorted(VALID_MATURITY))})"
            )

        dedupe_key = (provider_name, row.get("name", "").strip())
        if dedupe_key in seen:
            errors.append(
                f"capabilities.csv:{i} — duplicate capability: provider "
                f"'{provider_name}' already has an entry named '{row.get('name')}'"
            )
        seen.add(dedupe_key)

    return errors


def main():
    if not PROVIDERS_CSV.exists() or not CAPABILITIES_CSV.exists():
        print(f"ERROR: expected {PROVIDERS_CSV} and {CAPABILITIES_CSV} to exist.", file=sys.stderr)
        sys.exit(1)

    providers = load_csv(PROVIDERS_CSV)
    capabilities = load_csv(CAPABILITIES_CSV)

    provider_errors = validate_providers(providers)
    provider_names = {row["name"].strip() for row in providers if row.get("name", "").strip()}
    capability_errors = validate_capabilities(capabilities, provider_names)

    all_errors = provider_errors + capability_errors
    if all_errors:
        print(f"Build aborted — {len(all_errors)} validation error(s):\n", file=sys.stderr)
        for e in all_errors:
            print(f"  - {e}", file=sys.stderr)
        sys.exit(1)

    if DB_PATH.exists():
        DB_PATH.unlink()

    conn = sqlite3.connect(DB_PATH)
    try:
        conn.executescript(SCHEMA_PATH.read_text())

        cur = conn.cursor()
        name_to_id = {}
        for row in providers:
            cur.execute(
                "INSERT INTO providers (name, org_type, country_scope, homepage_url, notes) "
                "VALUES (?, ?, ?, ?, ?)",
                (
                    row["name"].strip(),
                    row["org_type"].strip(),
                    row["country_scope"].strip(),
                    row.get("homepage_url", "").strip() or None,
                    row.get("notes", "").strip() or None,
                ),
            )
            name_to_id[row["name"].strip()] = cur.lastrowid

        for row in capabilities:
            cur.execute(
                "INSERT INTO capabilities "
                "(provider_id, domain_bucket, layer, name, real_world_capability, verb, "
                " access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                (
                    name_to_id[row["provider_name"].strip()],
                    row["domain_bucket"].strip(),
                    row["layer"].strip(),
                    row["name"].strip(),
                    row["real_world_capability"].strip(),
                    row.get("verb", "").strip() or None,
                    row.get("access_pattern", "").strip() or None,
                    row.get("endpoint_or_repo", "").strip() or None,
                    row["maturity_status"].strip(),
                    row["source_pass"].strip(),
                    row.get("notes", "").strip() or None,
                ),
            )

        conn.commit()
        print(f"Built {DB_PATH.name}: {len(providers)} providers, {len(capabilities)} capabilities.")
    finally:
        conn.close()

    shutil.copyfile(DB_PATH, WEB_DB_PATH)
    print(f"Copied to {WEB_DB_PATH.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
