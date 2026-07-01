# Digital Public Infrastructure

A dictionary of public-good tech (government, private-sector, foundation, and international) mapped to **real-world capabilities** in everyday language rather than implementation detail, to enable better discovery by entrepreneurs, NGOs, and developers. Read-only view, rendered client-side from dictionary.sqlite via sql.js.


This repo is a **dictionary, not an application**. That's a deliberate,
permanent scope decision — see "How downstream apps should consume this"
below before adding anything beyond data.

## What's actually in here

- `schema.sql` — two tables: `providers` (who publishes/maintains something)
  and `capabilities` (what you can actually *do* with it — the real content).
  This defines the *structure*; you should rarely need to touch it.
- `data/providers.csv`, `data/capabilities.csv` — **the source of truth you
  actually edit.** Plain CSV, one row per provider or capability. Capability
  rows reference their provider by *name*, not by a numeric ID you have to
  track — the build script resolves that automatically.
- `build_db.py` — regenerates `dictionary.sqlite` from the two CSVs, after
  validating every row (see "Adding an entry" below). The **only** script
  that should ever write to the `.sqlite` file. Run it after any edit to
  `data/*.csv` or `schema.sql`.
- `dictionary.sqlite` — the built artifact. Committed to the repo so it's
  fetchable by URL without a build step on the consuming end.
- `docs/index.html` — a static, read-only viewer. Loads `dictionary.sqlite`
  client-side via [sql.js](https://sql.js.org) (WASM SQLite compiled to
  JS, loaded from cdnjs) and renders every capability grouped into tabs by
  domain. No backend.

## Data model

```
providers (id, name, org_type, country_scope, homepage_url, notes)
    ↓ 1-to-many
capabilities (id, provider_id, domain_bucket, layer, name,
              real_world_capability, verb, access_pattern,
              endpoint_or_repo, maturity_status, source_pass, notes)
```

`domain_bucket` is a flat controlled vocabulary, loosely aligned to
personal-problem categories: identity, payments_finance,
commerce_logistics, mobility_transport, urban_environment,
geospatial_earth_observation, health, education_pedagogy,
social_protection_welfare, civic_governance_process, language_translation,
agriculture, disaster_humanitarian, justice_legal,
data_infrastructure_generic, procurement. (Unlike `org_type`, `layer`, and
`maturity_status`, this one isn't enforced by a CHECK constraint — new
buckets are fine to add as coverage grows; just keep the list flat and
avoid near-duplicates.)

`maturity_status` is deliberately honest, including the "hidden in plain
sight" cases this project cares about: `active_maintained`,
`active_but_deprecating`, `legacy_unmaintained_but_usable` (e.g. WHO's
Athena API — officially unmaintained, still returns data),
`draft_or_early_stage`, `mixed_or_unverified`.

## Adding an entry

1. Open `data/providers.csv`. If the provider isn't already a row, add one
   (`name`, `org_type`, `country_scope` are required; `homepage_url` and
   `notes` are optional). `org_type` must be one of the values listed in
   `build_db.py`'s `VALID_ORG_TYPES`.
2. Open `data/capabilities.csv`. Add one row per distinct verb/product/
   dataset that provider exposes — prefer several narrow rows over one row
   trying to describe everything a provider does. `provider_name` must
   match a `name` in `providers.csv` exactly (copy-paste it, don't retype).
   `layer` and `maturity_status` must match the controlled vocabulary (see
   above); `domain_bucket` should reuse an existing value where it fits.
3. Run:
   ```bash
   python3 build_db.py
   ```
   If any row is wrong — unknown provider, mistyped `maturity_status`,
   missing required field, a duplicate — the build **aborts** and prints
   the exact CSV file, line number, and reason. Nothing partial gets
   written to `dictionary.sqlite`; either the whole build succeeds or the
   old `.sqlite` file is left untouched. Fix the reported row(s) and
   re-run.
4. Once it prints `Built dictionary.sqlite: N providers, M capabilities.`,
   commit `data/providers.csv`, `data/capabilities.csv`, and the
   regenerated `dictionary.sqlite` together.
5. Cut a new release tag if any downstream app needs the update (see
   below).

This is intentionally the entire process — no migrations framework, no
ORM, no admin UI. CSV + one validating build script is as much machinery
as a solo-maintained dictionary that gets edited in small batches needs.
If this repo ever gets multiple concurrent editors or needs row-level
audit history beyond what git already gives you, that's the point to
reconsider — not before.

## Viewing locally

`docs/index.html` fetches `dictionary.sqlite` via a relative path, so it
needs to be served over HTTP (not opened as a `file://` URL, which most
browsers block for fetch). From the repo root:

```bash
cd docs && python3 -m http.server 8000
```

Then open `http://localhost:8000`.

## How downstream apps should consume this

This repo stays a dictionary permanently. Apps that use it are **separate
repos**, and they depend on this one as a versioned artifact — they do not
fork it, branch it, or add app code here.

- **Fork** implies permanent divergence — a copy that stops syncing with
  this repo by default. Wrong model: every app should stay traceable to one
  canonical dictionary.
- **Branch** implies temporary divergence meant to merge back. Also wrong —
  an app isn't going to merge back into the dictionary.
- **Correct model: composition.** Tag releases here (e.g. `v1.0.0`,
  `v1.1.0`) whenever `seed.sql`/`schema.sql` change meaningfully. A new app
  repo either:
  - fetches the released `dictionary.sqlite` (or a future `dictionary.json`
    export) by URL at build time and treats it as read-only reference data,
    or
  - adds this repo as a **git submodule** if it needs the raw `.sql` source
    to extend locally (rare — prefer the fetch approach for most apps).

If an app needs fields this schema doesn't have, those fields belong in the
**app's own database**, referencing `capabilities.id` as a foreign key —
not bolted onto this schema. This keeps the dictionary generic and reusable
across every future app rather than shaped by whichever app touched it last.

## Provenance

Content was assembled across three research passes, logged per-row in
`capabilities.source_pass`:

- `v1` — ONDC (`resources.ondc.org/tech-resources`) and eGov DIGIT
  (`egov.org.in/digit`).
- `v2` — wider dragnet: Indian private sector (TCS, Infosys, Wipro),
  foreign/international bodies (WHO, World Bank, UN agencies), and
  lesser-known India-specific and globally-maintained digital public goods.
- `v3` — India Stack core: Aadhaar (UIDAI), UPI (NPCI), DigiLocker (MeitY),
  Account Aggregator (Sahamati/RBI framework), and ABDM (health-data
  consent layer, NHA). Access to most of this tier is tiered/permissioned
  rather than open — that's reflected honestly in each row's `notes` and
  `access_pattern` rather than glossed over.

This is a living document, not a finished inventory. Coverage gaps are
expected — known open items as of this writing: Aadhaar's biometric
authentication tier (as opposed to eKYC/offline verification) has no
low-friction unlicensed access path, so it's documented but not directly
usable without a KUA/sub-AUA partnership; OCEN (credit-origination
protocol) and eSign are adjacent India Stack layers not yet added; Bhuvan
and data.gov.in both still want a documentation-quality audit before
anything gets built against them.
