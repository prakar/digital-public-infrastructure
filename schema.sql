-- India Public Digital Infrastructure — Capability Ontology
-- Schema v1
--
-- Design intent: this database is a DICTIONARY, not an application.
-- It maps public-good tech (government, private-sector, foundation, or
-- international) to REAL-WORLD CAPABILITIES using plain-language verbs,
-- independent of implementation detail. Downstream apps consume this
-- as a read-only, versioned artifact — see README.md for the consumption
-- model. Do not add app-specific columns here; extend in the app's own
-- database instead, keyed on capabilities.id.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS capabilities;
DROP TABLE IF EXISTS providers;

-- One row per organisation/initiative that publishes or maintains
-- the infrastructure (not per API call).
CREATE TABLE providers (
    id              INTEGER PRIMARY KEY,
    name            TEXT NOT NULL,                 -- e.g. "ONDC", "WHO", "Infosys"
    org_type        TEXT NOT NULL CHECK (org_type IN (
                        'gov_india',
                        'private_india',
                        'foundation_india',
                        'international_gov_or_un',
                        'international_ngo_or_foundation',
                        'open_source_community'
                    )),
    country_scope   TEXT NOT NULL,                 -- 'india', 'global', 'global_with_india_deployment'
    homepage_url    TEXT,
    notes           TEXT
);

-- One row per distinct capability/verb/product surfaced by a provider.
-- This is the actual dictionary content.
CREATE TABLE capabilities (
    id                  INTEGER PRIMARY KEY,
    provider_id         INTEGER NOT NULL REFERENCES providers(id),
    domain_bucket       TEXT NOT NULL,              -- personal-problem bucket, see README for controlled vocabulary
    layer               TEXT NOT NULL CHECK (layer IN (
                            'protocol',             -- shared grammar, e.g. ONDC transaction verbs
                            'core_service',          -- reusable primitive, e.g. DIGIT Workflow Service
                            'product',               -- assembled end-user product, e.g. PGR, SightConnect
                            'dataset_or_registry'    -- raw data / registry access, e.g. data.gov.in, Bhuvan
                        )),
    name                TEXT NOT NULL,               -- short name, e.g. "search / on_search"
    real_world_capability TEXT NOT NULL,             -- plain-language "what you can actually do"
    verb                TEXT,                        -- single action verb where applicable: discover, transact, track...
    access_pattern      TEXT,                        -- api, sdk, reference_app, dataset, spec_only
    endpoint_or_repo    TEXT,                         -- URL: API base, GitHub repo, or docs
    maturity_status     TEXT NOT NULL CHECK (maturity_status IN (
                            'active_maintained',
                            'active_but_deprecating', -- e.g. WHO GHO OData API scheduled for replacement
                            'legacy_unmaintained_but_usable', -- e.g. WHO Athena API
                            'draft_or_early_stage',
                            'mixed_or_unverified'
                        )),
    source_pass         TEXT NOT NULL,                -- which research pass surfaced this: v1, v2
    notes               TEXT
);

CREATE INDEX idx_capabilities_provider ON capabilities(provider_id);
CREATE INDEX idx_capabilities_domain ON capabilities(domain_bucket);
CREATE INDEX idx_capabilities_maturity ON capabilities(maturity_status);
