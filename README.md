# India Public Digital Infrastructure — Capability Ontology

A dictionary mapping public-good tech in/for India — government, private-sector,
foundation, and international — to **real-world capabilities**, in plain
language, independent of implementation detail.

This repo is a **dictionary, not an application**. That's a deliberate,
permanent scope decision — see "How downstream apps should consume this"
below before adding anything beyond data.

## What's actually in here

- `schema.sql` — two tables: `providers` (who publishes/maintains something)
  and `capabilities` (what you can actually *do* with it — the real content).
- `seed.sql` — the current dictionary content, as plain SQL inserts. This is
  the file you edit when adding/correcting an entry.
- `build_db.py` — regenerates `dictionary.sqlite` from `schema.sql` +
  `seed.sql`. The **only** script that should ever write to the `.sqlite`
  file. Run it after any edit to `schema.sql` or `seed.sql`.
- `dictionary.sqlite` — the built artifact. Committed to the repo so it's
  fetchable by URL without a build step on the consuming end.
- `web/index.html` — a static, read-only viewer. Loads `dictionary.sqlite`
  client-side via [sql.js](https://sql.js.org) (WASM SQLite compiled to
  JS, loaded from cdnjs) and renders every capability grouped by domain.
  No backend, no interactivity beyond following links — by design, at this
  stage.

## Data model

```
providers (id, name, org_type, country_scope, homepage_url, notes)
    ↓ 1-to-many
capabilities (id, provider_id, domain_bucket, layer, name,
              real_world_capability, verb, access_pattern,
              endpoint_or_repo, maturity_status, source_pass, notes)
```

`domain_bucket` is a flat controlled vocabulary (see top of `seed.sql`),
loosely aligned to personal-problem categories: identity, payments_finance,
commerce_logistics, mobility_transport, urban_environment,
geospatial_earth_observation, health, education_pedagogy,
social_protection_welfare, civic_governance_process, language_translation,
agriculture, disaster_humanitarian, justice_legal,
data_infrastructure_generic, procurement.

`maturity_status` is deliberately honest, including the "hidden in plain
sight" cases this project cares about: `active_maintained`,
`active_but_deprecating`, `legacy_unmaintained_but_usable` (e.g. WHO's
Athena API — officially unmaintained, still returns data),
`draft_or_early_stage`, `mixed_or_unverified`.

## Regenerating the database

```bash
python3 build_db.py
```

Rebuilds `dictionary.sqlite` from `schema.sql` + `seed.sql` and copies it
into `web/` for the viewer. Commit both the `.sql` source and the rebuilt
`.sqlite` file together.

## Viewing locally

`web/index.html` fetches `dictionary.sqlite` via a relative path, so it
needs to be served over HTTP (not opened as a `file://` URL, which most
browsers block for fetch). From the repo root:

```bash
cd web && python3 -m http.server 8000
```

Then open `http://localhost:8000`.

## Adding an entry

1. Add or find the relevant row in `providers` (in `seed.sql`).
2. Add one or more rows to `capabilities`, one per distinct
   verb/product/dataset that provider exposes. Prefer several narrow rows
   over one row trying to describe everything a provider does.
3. Run `python3 build_db.py`.
4. Commit `seed.sql` and the regenerated `dictionary.sqlite` together.
5. Cut a new release tag if any downstream app needs the update (see below).

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

Content was assembled across two research passes, logged per-row in
`capabilities.source_pass`:

- `v1` — ONDC (`resources.ondc.org/tech-resources`) and eGov DIGIT
  (`egov.org.in/digit`).
- `v2` — wider dragnet: Indian private sector (TCS, Infosys, Wipro),
  foreign/international bodies (WHO, World Bank, UN agencies), and
  lesser-known India-specific and globally-maintained digital public goods.

This is a living document, not a finished inventory. Coverage gaps are
expected — see the "Open items" style notes carried over from the source
research passes for what's not yet in here (India Stack core — Aadhaar,
UPI, DigiLocker, Account Aggregator — is the largest known gap as of this
writing).
