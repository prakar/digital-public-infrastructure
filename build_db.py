#!/usr/bin/env python3
"""
Rebuilds dictionary.sqlite from schema.sql + seed.sql.

This is the ONLY script that should write to dictionary.sqlite.
Run it after editing schema.sql or seed.sql, commit the resulting
.sqlite file, and cut a new release tag for downstream apps to pin to.

Usage: python3 build_db.py
"""
import shutil
import sqlite3
import pathlib

ROOT = pathlib.Path(__file__).parent
DB_PATH = ROOT / "dictionary.sqlite"
WEB_DB_PATH = ROOT / "web" / "dictionary.sqlite"
SCHEMA_PATH = ROOT / "schema.sql"
SEED_PATH = ROOT / "seed.sql"


def main():
    if DB_PATH.exists():
        DB_PATH.unlink()

    conn = sqlite3.connect(DB_PATH)
    try:
        conn.executescript(SCHEMA_PATH.read_text())
        conn.executescript(SEED_PATH.read_text())
        conn.commit()

        cur = conn.cursor()
        n_providers = cur.execute("SELECT COUNT(*) FROM providers").fetchone()[0]
        n_capabilities = cur.execute("SELECT COUNT(*) FROM capabilities").fetchone()[0]
        print(f"Built {DB_PATH.name}: {n_providers} providers, {n_capabilities} capabilities.")
    finally:
        conn.close()

    # web/dictionary.sqlite is a copy for the static viewer to fetch (GitHub
    # Pages typically serves /web or /docs as the site root — copying keeps
    # index.html's relative fetch('dictionary.sqlite') working regardless of
    # which directory ends up as the Pages root).
    shutil.copyfile(DB_PATH, WEB_DB_PATH)
    print(f"Copied to {WEB_DB_PATH.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
