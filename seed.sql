-- India Public Digital Infrastructure — Capability Ontology
-- Seed data v1
-- Sourced from two research passes:
--   v1 = ONDC tech-resources + eGov DIGIT
--   v2 = Indian private sector, foreign/international bodies, wide dragnet
--
-- domain_bucket controlled vocabulary used below (extend as needed, keep flat):
--   identity, payments_finance, commerce_logistics, mobility_transport,
--   urban_environment, geospatial_earth_observation, health,
--   education_pedagogy, social_protection_welfare, civic_governance_process,
--   language_translation, agriculture, disaster_humanitarian, justice_legal,
--   data_infrastructure_generic, procurement

-- ============================================================
-- PROVIDERS
-- ============================================================
INSERT INTO providers (id, name, org_type, country_scope, homepage_url, notes) VALUES
(1,  'ONDC (Open Network for Digital Commerce)', 'gov_india', 'india', 'https://ondc.org', 'Section 8 non-profit, govt-backed; extends Beckn Protocol for commerce/mobility/logistics/finance.'),
(2,  'eGov Foundation / DIGIT', 'foundation_india', 'india', 'https://egov.org.in/digit', 'Open-source platform for local governance; certified Digital Public Good.'),
(3,  'MOSIP (Modular Open Source Identity Platform)', 'open_source_community', 'global_with_india_deployment', 'https://mosip.io', 'Originated at IIIT-Bangalore; Infosys TechForGood contributes modules. Adopted 10+ countries.'),
(4,  'Infosys Springboard', 'private_india', 'global', 'https://infosysspringboard.org', 'Open-source digital skilling platform, Infosys Foundation.'),
(5,  'WHO (World Health Organization)', 'international_gov_or_un', 'global', 'https://who.int', NULL),
(6,  'World Bank', 'international_gov_or_un', 'global', 'https://data.worldbank.org', NULL),
(7,  'UNICEF / Nyaruka (RapidPro)', 'international_gov_or_un', 'global_with_india_deployment', 'https://github.com/rapidpro/rapidpro', 'Used in several India state govt programs.'),
(8,  'UN OCHA (Humanitarian Data Exchange)', 'international_gov_or_un', 'global', 'https://data.humdata.org', NULL),
(9,  'OpenSPP community', 'open_source_community', 'global', 'https://openspp.org', 'Social protection / benefit delivery platform.'),
(10, 'Medic (Community Health Toolkit)', 'international_ngo_or_foundation', 'global', 'https://communityhealthtoolkit.org', 'Offline-first frontline health worker platform.'),
(11, 'Mojaloop Foundation', 'international_ngo_or_foundation', 'global', 'https://mojaloop.io', 'Gates Foundation-backed open payment switch reference implementation.'),
(12, 'MeitY — API Setu', 'gov_india', 'india', 'https://apisetu.gov.in', 'Govt of India open API aggregator/directory.'),
(13, 'ISRO/NRSC — Bhuvan', 'gov_india', 'india', 'https://bhuvan-app1.nrsc.gov.in/api', 'India''s own satellite/geospatial data platform. Functional, sparsely documented.'),
(14, 'CDPG — India Urban Data Exchange (IUDX)', 'gov_india', 'india', 'https://iudx.org.in', 'MeitY/Ministry of Housing & Urban Affairs backed; open source, IISc Bangalore CDPG.'),
(15, 'Bhashini (National Language Technology Mission)', 'gov_india', 'india', 'https://bhashini.gov.in', 'Open-source ASR/MT/TTS across Indian languages.'),
(16, 'data.gov.in (Open Government Data Platform India)', 'gov_india', 'india', 'https://data.gov.in', 'MeitY open-data catalogue; per-dataset freshness varies widely.'),
(17, 'Sunbird', 'open_source_community', 'global_with_india_deployment', 'https://sunbird.org', 'India-origin education infrastructure stack; underlies DIKSHA.'),
(18, 'OpenCRVS community', 'open_source_community', 'global', 'https://opencrvs.org', 'Open-source civil registration (births/deaths).'),
(19, 'Apache Fineract / Mifos Initiative', 'open_source_community', 'global', 'https://fineract.apache.org', 'Open-source core banking for microfinance/financial inclusion.'),
(20, 'ODK (Open Data Kit)', 'open_source_community', 'global', 'https://getodk.org', 'Offline-first mobile data collection framework.'),
(21, 'KoboToolbox', 'open_source_community', 'global', 'https://kobotoolbox.org', 'Form-based data collection for humanitarian/research use.'),
(22, 'OpenMRS / Bahmni', 'open_source_community', 'global_with_india_deployment', 'https://openmrs.org', 'Open-source EMR; Bahmni is India-origin (Thoughtworks + collaborators).'),
(23, 'Primero / CPIMS+ (UNICEF-backed)', 'international_ngo_or_foundation', 'global', 'https://primero.org', 'Open-source child-protection case management.'),
(24, 'OpenClimate', 'open_source_community', 'global', 'https://openclimate.network', 'Open climate/emissions-accounting tracking platform.'),
(25, 'SEPAL (FAO)', 'international_gov_or_un', 'global', 'https://sepal.io', 'Cloud platform for satellite land-monitoring.'),
(26, 'X-Road (Estonia-origin, reused elsewhere)', 'international_gov_or_un', 'global', 'https://x-road.global', 'Secure gov-to-gov data exchange layer; architectural reference, not India-deployed.'),
(27, 'TCS (Public Services India / DigiGOV)', 'private_india', 'india', 'https://tcs.com', 'System integrator for govt mission-mode programs (GeM, passports, pensions). Not a public-good API itself.'),
(28, 'Wipro Foundation', 'foundation_india', 'india', 'https://wiprofoundation.org', 'CSR programs; not a software/API platform.');

-- ============================================================
-- CAPABILITIES
-- ============================================================

-- ---- ONDC (provider 1) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(1, 'commerce_logistics', 'protocol', 'search / on_search', 'Discover any seller/provider offering X across the whole network from one query', 'discover', 'spec_only', 'https://github.com/ONDC-Official/ONDC-Protocol-Specs', 'active_maintained', 'v1', 'Core transaction grammar, domain-agnostic.'),
(1, 'commerce_logistics', 'protocol', 'select / on_select', 'Provisionally construct an order and get a live quote back', 'quote', 'spec_only', 'https://github.com/ONDC-Official/ONDC-Protocol-Specs', 'active_maintained', 'v1', NULL),
(1, 'commerce_logistics', 'protocol', 'init / confirm', 'Lock in terms and place an order, triggering fulfilment', 'commit', 'spec_only', 'https://github.com/ONDC-Official/ONDC-Protocol-Specs', 'active_maintained', 'v1', NULL),
(1, 'commerce_logistics', 'protocol', 'status / track', 'Pull current order state and live fulfilment/shipment tracking', 'track', 'spec_only', 'https://github.com/ONDC-Official/ONDC-Protocol-Specs', 'active_maintained', 'v1', NULL),
(1, 'commerce_logistics', 'protocol', 'update / cancel', 'Modify or cancel an order post-confirm', 'modify', 'spec_only', 'https://github.com/ONDC-Official/ONDC-Protocol-Specs', 'active_maintained', 'v1', NULL),
(1, 'commerce_logistics', 'protocol', 'rating / support', 'Rate a completed transaction; escalate to order-specific support', 'evaluate', 'spec_only', 'https://github.com/ONDC-Official/ONDC-Protocol-Specs', 'active_maintained', 'v1', NULL),
(1, 'commerce_logistics', 'product', 'Retail domains (RET10-15)', 'Discover/order groceries, food, fashion, electronics, home goods, beauty products across any listed seller', 'transact', 'reference_app', 'https://github.com/ONDC-Official/ondc-sdk', 'active_maintained', 'v1', 'Production-live.'),
(1, 'commerce_logistics', 'product', 'Logistics (LOG)', 'Book courier/freight capacity from any listed logistics provider, domestic and international, B2B', 'ship', 'reference_app', 'https://github.com/ONDC-Official/ref-logistics-app-sdk', 'active_maintained', 'v1', NULL),
(1, 'mobility_transport', 'product', 'Ride hailing (TRV10)', 'Book any listed cab/auto from one interface, no app-switching', 'travel', 'reference_app', 'https://ondc-official.github.io/mobility-specification/', 'active_maintained', 'v1', NULL),
(1, 'mobility_transport', 'product', 'Metro/bus unreserved (TRV11)', 'Discover and buy transit tickets city-wide from one interface', 'travel', 'reference_app', 'https://ondc-official.github.io/mobility-specification/', 'active_maintained', 'v1', NULL),
(1, 'mobility_transport', 'product', 'Intercity bus / airline / hotel / heritage entry (TRV12-14)', 'Cross-operator discovery/booking for intercity bus, airlines, hotels, heritage/museum entry', 'travel', 'spec_only', 'https://ondc-official.github.io/mobility-specification/', 'draft_or_early_stage', 'v1', 'Draft-stage beyond ride-hailing.'),
(1, 'payments_finance', 'product', 'Financial Services (FIS)', 'Discover/apply for credit, insurance and other financial products across listed NBFCs/insurers from one interface', 'compare', 'spec_only', 'https://ondc-official.github.io/ONDC-FIS-Specifications/', 'draft_or_early_stage', 'v1', 'Mostly draft-stage.'),
(1, 'commerce_logistics', 'core_service', 'IGM (Issue & Grievance Mgmt)', 'Standardised dispute-resolution protocol between any two network participants', 'dispute', 'spec_only', 'https://github.com/ONDC-Official', 'active_maintained', 'v1', NULL),
(1, 'commerce_logistics', 'core_service', 'RSF (Reconciliation & Settlement)', 'Standardised ledger of what is owed between network participants post-transaction', 'reconcile', 'spec_only', 'https://github.com/ONDC-Official', 'active_maintained', 'v1', NULL);

-- ---- DIGIT / eGov Foundation (provider 2) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(2, 'civic_governance_process', 'core_service', 'Workflow Service', 'Model any multi-step approval/application process generically, config-driven, no code per new process', 'process', 'api', 'https://core.digit.org/platform/core-services/workflow-service', 'active_maintained', 'v1', 'The reusable pattern — a universal process-modelling grammar.'),
(2, 'civic_governance_process', 'core_service', 'Registries (Individual/Property/HRMS/Boundary)', 'Authoritative, real-time, consent-gated lookup of a person/asset/place as single source of truth', 'lookup', 'api', 'https://docs.digit.org', 'active_maintained', 'v1', NULL),
(2, 'civic_governance_process', 'core_service', 'Notification Service', 'Trigger SMS/email at any workflow state transition, localized', 'notify', 'api', 'https://docs.digit.org', 'active_maintained', 'v1', NULL),
(2, 'civic_governance_process', 'core_service', 'HRMS', 'Manage government staff: create, assign role/jurisdiction, deactivate, reused across every module', 'administer', 'api', 'https://docs.digit.org/local-governance/access/local-governance-stack/hrms', 'active_maintained', 'v1', 'egov-hrms/employees/_create, /_search endpoints documented.'),
(2, 'civic_governance_process', 'product', 'Citizen Complaint Resolution (PGR)', 'File a civic complaint, get tracked/routed/resolved with SMS updates, reopen if unsatisfied', 'resolve', 'reference_app', 'https://urban.digit.org', 'active_maintained', 'v1', '/requests/_create, /_search, /_update endpoints documented.'),
(2, 'civic_governance_process', 'product', 'Residential Construction Permit', 'Apply for and track a building permit end-to-end', 'permit', 'reference_app', 'https://egov.org.in/product/residential-construction-permit-system', 'active_maintained', 'v1', NULL),
(2, 'urban_environment', 'product', 'Water & Sewerage Connections', 'Apply for/manage utility connections', 'connect', 'reference_app', 'https://egov.org.in/product/water-sewerage', 'active_maintained', 'v1', NULL),
(2, 'civic_governance_process', 'product', 'Local Business License Issuing', 'Apply for/renew a trade license', 'license', 'reference_app', 'https://egov.org.in/product/local-business-license-issuing-system', 'active_maintained', 'v1', NULL),
(2, 'civic_governance_process', 'product', 'Birth & Death Certificate Issuance', 'Request vital-event certificates', 'certify', 'reference_app', 'https://egov.org.in/product/birth-death-certificate-issuance', 'active_maintained', 'v1', NULL),
(2, 'civic_governance_process', 'product', 'Property Tax System', 'Assess, bill, and collect property tax', 'bill', 'reference_app', 'https://egov.org.in/product/property-tax-system', 'active_maintained', 'v1', NULL),
(2, 'civic_governance_process', 'product', 'mCollect', 'Collect any demand-based revenue, not just property tax', 'collect', 'reference_app', 'https://egov.org.in/product/mcollect-demand-based-revenue-collection', 'active_maintained', 'v1', NULL),
(2, 'urban_environment', 'product', 'Waste Management System', 'Route/track municipal waste collection', 'route', 'reference_app', 'https://egov.org.in/product/waste-management', 'active_maintained', 'v1', NULL),
(2, 'health', 'product', 'Health Campaign Management (HCM)', 'Plan/execute public health campaigns at scale', 'campaign', 'reference_app', 'https://egov.org.in/product/health-campaign-management', 'active_maintained', 'v1', NULL),
(2, 'health', 'product', 'Digital Verifiable Credentialing (DIVOC)', 'Issue tamper-proof, verifiable digital certificates', 'certify', 'reference_app', 'https://divoc.egov.org.in', 'active_maintained', 'v1', 'Built for COVID vaccination certs, now general-purpose.'),
(2, 'social_protection_welfare', 'product', 'Social Benefit Delivery System', 'Administer eligibility + disbursal for welfare schemes', 'disburse', 'reference_app', 'https://egov.org.in/product/social-benefit-delivery-system', 'active_maintained', 'v1', NULL),
(2, 'justice_legal', 'product', 'DRISTI', 'Online dispute resolution for courts', 'adjudicate', 'reference_app', 'https://egov.org.in/product/dristi-by-pucar', 'active_maintained', 'v1', NULL);

-- ---- MOSIP (provider 3) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(3, 'identity', 'core_service', 'MOSIP identity stack', 'Build a national or org-level digital identity + authentication system without starting from scratch', 'authenticate', 'sdk', 'https://github.com/mosip', 'active_maintained', 'v2', 'DPG-certified, adopted 10+ countries.'),
(3, 'identity', 'core_service', 'eSignet module', 'Single sign-on against a country''s own digital identity platform', 'authenticate', 'sdk', 'https://github.com/mosip', 'active_maintained', 'v2', 'Infosys-contributed module.');

-- ---- Infosys Springboard (provider 4) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(4, 'education_pedagogy', 'product', 'Infosys Springboard', 'Deploy free multi-language skilling courseware infrastructure at scale', 'skill', 'reference_app', 'https://infosysspringboard.org', 'active_maintained', 'v2', NULL);

-- ---- WHO (provider 5) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(5, 'health', 'dataset_or_registry', 'GHO OData API', 'Query 2,300+ published global-health indicators across 245 countries/regions programmatically', 'query', 'api', 'https://ghoapi.azureedge.net/api', 'active_but_deprecating', 'v2', 'Current implementation scheduled for replacement near end of 2025 — verify before building on it.'),
(5, 'health', 'dataset_or_registry', 'Athena API (legacy)', 'Same underlying health-indicator data via an older query grammar', 'query', 'api', 'https://apps.who.int/gho/athena/api', 'legacy_unmaintained_but_usable', 'v2', 'WHO explicitly states this is no longer maintained; still returns data — the textbook "hidden in plain sight" case.'),
(5, 'health', 'dataset_or_registry', 'ICD-11 API', 'Look up/validate diagnosis codes; build clinical or health-data tooling that speaks ICD-11', 'classify', 'api', 'https://icd.who.int/icdapi', 'active_maintained', 'v2', NULL);

-- ---- World Bank (provider 6) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(6, 'data_infrastructure_generic', 'dataset_or_registry', 'World Bank Open Data API', 'Pull GDP, poverty, demographic, climate indicator series by country/year, including India', 'query', 'api', 'https://data.worldbank.org', 'active_maintained', 'v2', NULL);

-- ---- RapidPro (provider 7) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(7, 'civic_governance_process', 'core_service', 'RapidPro flow engine', 'Build a low-bandwidth conversational service (health reminders, agri advisories, grievance intake) reachable on basic phones via SMS/USSD/voice', 'converse', 'sdk', 'https://github.com/rapidpro/rapidpro', 'active_maintained', 'v2', 'Already used in several India state programs. No-code flow builder.');

-- ---- HDX (provider 8) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(8, 'disaster_humanitarian', 'dataset_or_registry', 'Humanitarian Data Exchange', 'Pull structured crisis/vulnerability/disaster-response datasets instead of scraping news', 'query', 'api', 'https://data.humdata.org', 'active_maintained', 'v2', 'India-relevant subsets exist (disaster, refugee, food security).');

-- ---- OpenSPP (provider 9) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(9, 'social_protection_welfare', 'core_service', 'OpenSPP platform', 'Build a beneficiary registry + eligibility + payout system for any welfare-style program, not limited to government', 'disburse', 'sdk', 'https://openspp.org', 'active_maintained', 'v2', NULL);

-- ---- Community Health Toolkit (provider 10) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(10, 'health', 'core_service', 'Community Health Toolkit', 'Build an offline-first frontline community-health-worker workflow app usable with poor connectivity', 'coordinate', 'sdk', 'https://communityhealthtoolkit.org', 'active_maintained', 'v2', NULL);

-- ---- Mojaloop (provider 11) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(11, 'payments_finance', 'core_service', 'Mojaloop payment switch', 'Build interoperable real-time payment rails for a closed ecosystem (local currency, loyalty network, cooperative)', 'settle', 'sdk', 'https://mojaloop.io', 'active_maintained', 'v2', 'Reference implementation of a UPI-like switch.');

-- ---- API Setu (provider 12) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(12, 'identity', 'dataset_or_registry', 'API Setu directory', 'Single aggregator/directory to citizen-identity and records APIs: Aadhaar, PAN, GSTN, DigiLocker, Sarathi, VAHAN, PMJAY, PM-KISAN, India Post', 'verify', 'api', 'https://apisetu.gov.in', 'mixed_or_unverified', 'v2', 'Some services publicly callable today (CoWIN, ABHA, VAHAN lookup, PIN code, GSTN search); others require regulated-entity onboarding. Highest-value single addition from the v2 pass — turns identity verification from bespoke integration into directory lookup.');

-- ---- Bhuvan (provider 13) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(13, 'geospatial_earth_observation', 'dataset_or_registry', 'Bhuvan API', 'Programmatic access to India''s own satellite/geospatial data: land use, disaster monitoring, thematic maps, district-level codes', 'observe', 'api', 'https://bhuvan-app1.nrsc.gov.in/api', 'active_maintained', 'v2', 'Government-run, functional, but documentation is sparse/dated — genuinely hidden in plain sight. Direct relevance to pollution/environment/energy problem bucket.');

-- ---- IUDX (provider 14) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(14, 'urban_environment', 'core_service', 'IUDX data exchange', 'Open-standard data exchange layer for city/ULB data: traffic, air quality, water, waste', 'exchange', 'api', 'https://github.com/datakaveri', 'active_maintained', 'v2', 'Purpose-built for the noise/pollution/urban-environment bucket. Several cities publish live datasets.');

-- ---- Bhashini (provider 15) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(15, 'language_translation', 'core_service', 'Bhashini ASR/MT/TTS models', 'Add multilingual voice/text interfaces across Indian languages without building translation from scratch', 'translate', 'api', 'https://bhashini.gov.in', 'active_maintained', 'v2', 'Actively expanding. Reusable across pedagogy and service-access solutions.');

-- ---- data.gov.in (provider 16) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(16, 'data_infrastructure_generic', 'dataset_or_registry', 'OGD Platform India datasets', 'Query the central catalogue of datasets published by every ministry/department', 'query', 'api', 'https://data.gov.in/apis', 'mixed_or_unverified', 'v2', 'Platform is alive; individual dataset freshness ranges from live to years-stale. Check per dataset.');

-- ---- Sunbird (provider 17) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(17, 'education_pedagogy', 'core_service', 'Sunbird stack', 'Deploy a content repository, learning analytics, and credentialing infrastructure for education at scale', 'educate', 'sdk', 'https://sunbird.org', 'active_maintained', 'v2', 'India-origin, DPG-certified, underlies DIKSHA (national teacher/student platform).');

-- ---- OpenCRVS (provider 18) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(18, 'civic_governance_process', 'product', 'OpenCRVS', 'Open-source civil registration system for births/deaths, alternative lens to DIGIT''s own product', 'register', 'reference_app', 'https://opencrvs.org', 'mixed_or_unverified', 'v2', 'Active globally; limited verified direct India deployment so far.');

-- ---- Fineract/Mifos (provider 19) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(19, 'payments_finance', 'core_service', 'Apache Fineract / Mifos X', 'Build a lending/savings-product backend without a bank''s core-banking cost, built for microfinance/financial inclusion', 'lend', 'sdk', 'https://fineract.apache.org', 'active_maintained', 'v2', 'Relevant to investing/portfolio tooling interests.');

-- ---- ODK (provider 20) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(20, 'data_infrastructure_generic', 'core_service', 'Open Data Kit (ODK)', 'Collect structured field data offline-first on mobile, sync when connected', 'collect', 'sdk', 'https://getodk.org', 'active_maintained', 'v2', 'Underlies a large share of India''s own NGO/survey data pipelines.');

-- ---- KoboToolbox (provider 21) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(21, 'data_infrastructure_generic', 'core_service', 'KoboToolbox', 'Form-based structured data collection for humanitarian/research use', 'collect', 'sdk', 'https://kobotoolbox.org', 'active_maintained', 'v2', 'Same use case as ODK, different ecosystem.');

-- ---- OpenMRS/Bahmni (provider 22) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(22, 'health', 'product', 'OpenMRS / Bahmni EMR', 'Run a clinic-scale electronic medical record backend', 'record', 'reference_app', 'https://openmrs.org', 'active_maintained', 'v2', 'Bahmni is India-origin (Thoughtworks + collaborators).');

-- ---- Primero/CPIMS+ (provider 23) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(23, 'social_protection_welfare', 'product', 'Primero / CPIMS+', 'Run case management for child-protection services', 'protect', 'reference_app', 'https://primero.org', 'active_maintained', 'v2', 'UNICEF-backed. Niche but real, protective-services angle.');

-- ---- OpenClimate (provider 24) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(24, 'urban_environment', 'dataset_or_registry', 'OpenClimate', 'Track emissions accounting by jurisdiction on an open climate-data platform', 'track', 'api', 'https://openclimate.network', 'draft_or_early_stage', 'v2', 'Newer, less battle-tested than the rest of the dragnet.');

-- ---- SEPAL (provider 25) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(25, 'geospatial_earth_observation', 'core_service', 'SEPAL (FAO)', 'Run satellite-imagery-based land monitoring in the cloud', 'observe', 'sdk', 'https://sepal.io', 'active_maintained', 'v2', 'Alternative/complement to Bhuvan, globally maintained by FAO.');

-- ---- X-Road (provider 26) ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(26, 'data_infrastructure_generic', 'core_service', 'X-Road', 'Design a secure, interoperable data-exchange layer between independent systems', 'exchange', 'sdk', 'https://x-road.global', 'active_maintained', 'v2', 'Architectural reference (Estonia-origin), not India-deployed but codebase usable anywhere.');

-- ---- TCS / Wipro (providers 27, 28) — included for completeness, explicitly non-public-good ----
INSERT INTO capabilities (provider_id, domain_bucket, layer, name, real_world_capability, verb, access_pattern, endpoint_or_repo, maturity_status, source_pass, notes) VALUES
(27, 'procurement', 'product', 'GeM (Government e-Marketplace)', 'Discover/bid on government procurement opportunities; TCS is current SI rebuilding it on open-API architecture', 'procure', 'reference_app', 'https://gem.gov.in', 'active_maintained', 'v2', 'Government-owned platform, not a TCS public good; included because govt-as-customer is a relevant angle.'),
(27, 'data_infrastructure_generic', 'product', 'TCS DigiGOV suite', 'TCS''s internal IP for building/operating govt mission-mode systems', 'n/a', 'n/a', NULL, 'mixed_or_unverified', 'v2', 'Not directly usable by outsiders. Logged so it is not chased again.');
