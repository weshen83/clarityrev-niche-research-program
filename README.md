# ClarityRev Niche Research Program

**Status:** READY FOR CALIBRATION — All fixes from 17-lens holistic audit applied. 148/148 tests pass.
**Last Updated:** 2026-07-23
**Repository:** [github.com/weshen83/clarityrev-niche-research-program](https://github.com/weshen83/clarityrev-niche-research-program)

---

## What This Is

A systematic, AI-agent-executed methodology for evaluating 25 B2B niches to select the optimal 1–3 beachhead markets for ClarityRev — a bootstrapped Revenue Intelligence company. The program produces a data-backed, evidence-graded, cross-comparable ranking of 25 niches, each analyzed across a 15-section Niche Canvas.

**What it tells us for each niche:**
- Market size, growth trajectory, and structural attractiveness
- Buyer psychology — who buys, what they care about, what language they use
- Competitive landscape — who the competitors are, what they charge, where the white space is
- Pain architecture — what hurts, quantified in EUR, with ROI proof
- Signal detection feasibility — what triggers signal a buying opportunity
- Offer architecture — free entry → paid pilot → recurring → expansion
- Commercial viability — EUR 500K net profit gate, CAC/LTV, unit economics

**What it produces:**
- 25 completed Niche Canvases (15 sections each)
- Machine-readable YAML frontmatter for cross-niche comparison
- Rank-based composite scoring with bootstrap confidence intervals
- Evidence traceability from every claim back to its source URL with content hash
- Data-backed website copy, outbound sequences, and GTM playbooks for the selected niche

---

## Quick Start

### For founders (Bob & Adriaan)
1. Read `PARTNER-SHARE-MANIFEST.md` — which files to share with your LLM
2. Paste `PARTNER-LLM-PROMPT.md` into ChatGPT, Claude, or Gemini along with the 7 recommended files
3. Your LLM will explain the program, answer questions, and discuss how to use the outputs

### For operators (Wesley)
1. Read `NICHE-METHODOLOGY.md` — the binding 15-section canvas specification
2. Read `DATA-OPERATIONS-ARCHITECTURE.md` — exact tools, commands, schemas, budgets
3. Read `AGENT-CONTEXT-SPEC.md` — per-phase context loading specification
4. Run Phase 0 calibration from `DATA-OPERATIONS-ARCHITECTURE.md` §4.0
5. Execute the pipeline per the 4-phase sequence in `DATA-OPERATIONS-ARCHITECTURE.md` §4.1–4.4

### Quick commands
```bash
# Run test suite
cd research/_pipelines && ./test/run_all_tests.sh

# Pre-flight check before any credit-consuming fetch
./research/_pipelines/preflight-check N-001 competitor-pricing --target-url "https://example.com"

# Validate structured data against schemas
./research/_pipelines/validate-schema competitor-profile <file.yaml>

# Audit canvas freshness before finalization
./research/_pipelines/freshness-audit N-001

# Generate quality dashboard (run every 5 niches)
./research/_pipelines/generate-quality-dashboard

# Incident recovery
cat research/_pipelines/RUNBOOK.md
```

---

## Where Research Data Gets Stored

### Per-niche structured data: `research/N-XXX/`

Each evaluated niche gets its own directory following this structure:

```
research/N-001/                             ← Niche #1
├── 01-company-discovery/                   ← Companies identified in this niche
│   └── N-001-company-discovery-v1.yaml
├── 02-competitor-intel/                    ← Competitor profiles (3–10 per niche)
│   ├── N-001-competitor-profile-{name}-v1.yaml
│   └── N-001-competitor-pricing-{name}-v1.yaml
├── 03-market-sizing/                       ← TAM, SAM, SOM estimates
│   └── N-001-market-sizing-TAM-v1.yaml
├── 04-voice-of-customer/                   ← Review corpus + buyer language
│   ├── N-001-review-corpus-{competitor}-v1.yaml
│   └── N-001-buyer-language-v1.yaml
├── 05-signal-feasibility/                  ← Trigger event detection feasibility
│   └── N-001-signal-feasibility-v1.yaml
├── 06-technographic/                       ← Technology stack profiles
│   └── N-001-technographic-profile-{company}-v1.yaml
├── 07-buyer-insight/                       ← Buyer persona deep-dives
│   └── N-001-buyer-insight-v1.yaml
├── 08-pricing/                             ← Pricing benchmark data
│   └── N-001-pricing-benchmark-v1.yaml
├── _canvas/                                ← The completed 15-section canvas
│   ├── NICHE-CANVAS-N-001.md              ← Full markdown canvas (15 sections)
│   ├── frontmatter-N-001.yaml             ← Machine-readable YAML for cross-niche comparison
│   └── evidence/
│       └── trace-map.yaml                 ← claim_id → source_file → URL → content_hash
└── _work/                                 ← Temporary working files (auto-cleaned after 7 days)
    └── CHECKPOINT.yaml                    ← Agent state for crash recovery
```

**Estimated files per niche (DEEP depth):** ~30–45 structured YAML/JSON files + 1 markdown canvas + 1 trace-map. **Across 25 niches:** ~750–1,125 research files.

### Cross-niche shared data: `research/SHARED/`

Data reusable across niches — fetched once, consumed by all:

```
research/SHARED/
├── _REGISTRY.yaml              ← Master index of all shared data
├── competitors/                ← Cross-niche competitor profiles
│   └── {competitor-name}-v1.yaml
├── benchmarks/                 ← B2B benchmarks (churn, CAC, conversion)
│   └── _BENCHMARK_DATABASE.yaml
├── triggers/                   ← Cross-niche trigger registry
├── regulatory/                 ← GDPR, AI Act, industry regulations
├── tools/                      ← Tool/capability inventory
├── taxonomy/                   ← Niche categories, signal types, buyer roles
└── buyer_language/             ← Shared buyer language patterns
```

### Program management: `research/_program/`

| File | Purpose |
|---|---|
| `LEDGER.yaml` | 25-niche tracking — status, scores, verdicts per niche |
| `CREDIT_BUDGET.yaml` | Running credit consumption tracker |
| `QUALITY_METRICS.yaml` | Aggregated quality metrics across all niches |
| `FRESHNESS_VIOLATION_LOG.yaml` | Append-only freshness violation log |
| `TOOL_ERROR_LOG.yaml` | Append-only tool error log |
| `SLI_DEFINITIONS.yaml` | 6 Service Level Indicators + 5 alert thresholds |
| `PIPELINE_CHECKPOINTS.yaml` | Per-niche state machine + heartbeat timestamps |
| `DEAD_HOST_REGISTRY.yaml` | Hosts blocked for 30 days |

### Raw fetched content: `.firecrawl/` and `.dataforseo/`

Gitignored. Retained 30 days for audit trail, then auto-cleaned by `clean-raw-fetches`. Structured data is extracted from raw content into `research/N-XXX/` directories.

---

## 25 Niche Candidates

These are the initial 25 niches proposed for evaluation. They are ordered by hypothesized priority based on ClarityRev's constraints — Bob's Adobe NL enterprise sales network, revenue intelligence product fit, pricing band viability (EUR 1.5–8K/mo), and bootstrapped economics. The program will re-rank them based on data, not hypotheses.

### Tier 1: B2B SaaS & Technology (Bob's Core Network)

| # | Niche | Rationale |
|---|---|---|
| N-001 | **Mid-Market B2B SaaS Revenue Operations** | Companies 50–500 employees using HubSpot/Salesforce. Pipeline management pain is acute. Bob's Adobe network: direct access to RevOps leaders at 50+ SaaS companies. |
| N-002 | **B2B SaaS Customer Success Platforms** | High-touch CS teams with churn problems. Signal: usage data + NPS decay + renewal dates. Strong review data on G2. |
| N-003 | **B2B SaaS Sales Engagement / Automation** | Outreach, SalesLoft, Apollo ecosystem. Buyers already spend on sales tools. Trigger: CRM hygiene decay, sequence fatigue. |
| N-004 | **B2B SaaS Marketing Automation** | HubSpot, Marketo, Pardot ecosystem. Signal: MQL-to-SQL conversion decay, campaign fatigue. Adjacent to Bob's Adobe expertise. |
| N-005 | **B2B SaaS HR Tech / People Analytics** | Workday, BambooHR, Lattice ecosystem. Signal: hiring surges, attrition spikes, engagement survey drops. |
| N-006 | **B2B SaaS Procurement / Spend Management** | Coupa, SAP Ariba, Zip ecosystem. Signal: contract renewal dates, supplier consolidation events. |
| N-007 | **B2B SaaS DevOps / Developer Tools** | GitHub, GitLab, Datadog ecosystem. Signal: stack changes, hiring for new languages, cloud migration announcements. |
| N-008 | **B2B SaaS Cybersecurity** | CrowdStrike, Okta, Wiz ecosystem. Signal: security audit findings, compliance deadline proximity, breach announcements. |

### Tier 2: Professional Services & Consulting

| # | Niche | Rationale |
|---|---|---|
| N-009 | **IT Services & Systems Integrators (Benelux)** | Companies 50–500 employees. Signal: new project wins, partner certification changes, hiring surges. Bob's Adobe network includes SI partners. |
| N-010 | **Management Consulting (Strategy & Operations)** | MBB + Tier 2 + boutiques. Signal: partner moves, new practice launches, RFP activity. High ACV potential (EUR 5K+). |
| N-011 | **Digital Agencies / Marketing Services** | Web dev, performance marketing, CRO agencies. Signal: client wins/losses, service expansion, tool stack changes. Adjacent to Adriaan's Clay expertise. |
| N-012 | **Recruitment / Talent Acquisition (Executive Search)** | Retained search, RPO, executive recruitment. Signal: new mandate announcements, sector specialization changes. NOT staffing — executive/retained. |
| N-013 | **Accounting & Financial Advisory** | Big 4 + mid-tier + boutiques. Signal: audit season timing, regulatory changes, partner promotions. |
| N-014 | **Legal Services (Corporate / M&A)** | Law firms 50–500 lawyers. Signal: deal announcements, partner lateral moves, practice area launches. |

### Tier 3: Tech-Enabled Services

| # | Niche | Rationale |
|---|---|---|
| N-015 | **Logistics & Supply Chain Technology** | Freight tech, warehouse management, last-mile platforms. Signal: shipping volume changes, warehouse expansion, carrier network changes. |
| N-016 | **PropTech / Commercial Real Estate** | CRE platforms, property management SaaS, lease management. Signal: portfolio changes, regulatory updates, occupancy shifts. |
| N-017 | **FinTech / B2B Payments** | B2B BNPL, cross-border payments, spend management. Signal: funding rounds, regulatory licenses, partnership announcements. |
| N-018 | **HealthTech / Digital Health (B2B)** | EHR/EMR platforms, telemedicine, clinical workflow. Signal: FDA approvals, hospital system contracts, interoperability mandates. |
| N-019 | **InsurTech / Commercial Insurance** | Underwriting platforms, claims automation, broker tools. Signal: regulatory changes, carrier partnerships, product launches. |
| N-020 | **E-commerce Enablement Platforms** | Shopify Plus ecosystem, headless commerce, fulfillment tech. Signal: merchant acquisition, platform migrations, holiday hiring surges. |

### Tier 4: European / Benelux Density

| # | Niche | Rationale |
|---|---|---|
| N-021 | **Benelux Scale-ups (50–500 Employees, VC-Backed)** | Companies that raised Series A/B in the last 24 months. Signal: funding announcements, office expansion, C-suite hires. Bob's highest-density network. |
| N-022 | **European Manufacturing Tech / Industry 4.0** | MES, digital twin, predictive maintenance. Signal: factory expansion, ERP migration, sustainability reporting deadlines. |
| N-023 | **European Energy Tech / Cleantech** | Renewable energy platforms, carbon accounting, grid management. Signal: regulatory deadlines (CSRD), project financing, partnership announcements. |

### Tier 5: Platform Ecosystem Plays

| # | Niche | Rationale |
|---|---|---|
| N-024 | **HubSpot Solutions Partners** | Agencies and consultancies in the HubSpot ecosystem. Signal: tier changes, new certifications, client portfolio expansion. Adriaan's Clay expertise directly relevant. |
| N-025 | **Salesforce ISV & Consulting Partners** | AppExchange ISVs + Salesforce consultancies. Signal: AppExchange listing changes, partner tier promotions, new practice launches. Bob's Adobe network overlaps with Salesforce ecosystem. |

### Selection logic

These 25 niches were chosen to maximize:

- **Warm Access** (0.25 weight): Bob's Adobe NL enterprise sales network provides warm introductions to decision-makers in B2B SaaS, professional services, and Benelux scale-ups.
- **Commercial Viability** (0.30 weight): Each niche supports EUR 1,500–8,000/mo price bands with 50+ clients needed for EUR 500K net profit.
- **Data Accessibility**: Every niche has publicly available competitors with G2/Capterra reviews, analyst coverage, and accessible buyer language.
- **Portfolio Diversity**: Niches span 5 tiers with different CRM dependencies, buyer personas, and competitive dynamics — reducing single-point-of-failure risk.

The program will objectively re-rank these based on the 15-section canvas data. No niche is locked. The calibration niches (CAL-A and CAL-B) will validate the methodology before any of these are evaluated.

---

## Key Numbers

| Metric | Value |
|---|---|
| Niches to evaluate | 25 + 2 calibration = 27 |
| Firecrawl credits available | ~10,000 |
| Firecrawl per niche (DEEP, estimated) | ~132 credits |
| Conservative budget for 25 niches | ~4,300 credits (with 30% buffer) |
| DataForSEO credits available | $50 (~83,000 SERP checks) |
| DataForSEO per niche (DEEP, estimated) | ~$0.04 |
| Wall-clock per niche (estimated) | ~20–25 min (network I/O + canvas authoring) |
| Per-niche hard timeout | 45 minutes |
| Concurrent niches (max) | 4 |
| Operational scripts | 5 Python scripts (5,200+ lines) + shared library + grade engine |
| Test coverage | 148 tests (70 pytest + 78 bash integration) |
| Schema validators | 6 (competitor-profile, review-corpus, market-sizing, canvas-frontmatter, trace-map, buyer-language) |
| New files from fix execution | 9 (AGENT-CONTEXT-SPEC, WEBSITE-COPY-SPEC, OUTBOUND-SPEC, grade-engine, file_lock.py, SHARED/_REGISTRY, dedup-manifest, trace-map-schema, buyer-language-schema) |

---

## Architecture

```
niche-program/
│
├── README.md                                    ← You are here
├── NICHE-METHODOLOGY.md                         ← BINDING: 15-section canvas + scoring + quality gates
├── DATA-OPERATIONS-ARCHITECTURE.md              ← BINDING: tools, schemas, budgets, pipeline v1.1
├── AGENT-CONTEXT-SPEC.md                        ← BINDING: per-phase context loading for AI agents
│
├── PROGRAM-HOLISTIC-AUDIT-PROMPT.md             ← 17-lens holistic audit prompt (executed)
├── PROGRAM-FIX-SPECIFICATION.md                 ← Binding fix specification for all ~45 audit findings
│
├── PARTNER-SHARE-MANIFEST.md                    ← Which files to share with Bob & Adriaan
├── PARTNER-LLM-PROMPT.md                       ← Prompt for founders' LLM
├── WEBSITE-COPY-SPEC.md                        ← Website copy specification (canvas → site)
├── OUTBOUND-SPEC.md                            ← Cold email + LinkedIn + discovery call templates
│
├── schemas/                                     ← 6 YAML validation schemas
│   ├── competitor-profile-schema.yaml
│   ├── review-corpus-schema.yaml
│   ├── market-sizing-schema.yaml
│   ├── canvas-frontmatter-schema.yaml
│   ├── trace-map-schema.yaml
│   └── buyer-language-schema.yaml
│
├── discovery/                                   ← Phase 0: tool & data source discovery (reference)
├── lenses/                                      ← Phase 1: 6-lens architecture designs (reference)
├── references/                                  ← Tool reference documentation (reference)
│
└── research/                                    ← Runtime data + operational infrastructure
    ├── _program/                                ← Cross-niche program management (8 tracking files)
    ├── SHARED/                                  ← Cross-niche reusable data
    │   ├── _REGISTRY.yaml
    │   ├── benchmarks/
    │   ├── competitors/
    │   ├── triggers/
    │   ├── regulatory/
    │   └── buyer_language/
    ├── _pipelines/                              ← 5 operational scripts + grade engine + test suite
    │   ├── lib/pipeline_ops.py                  ← Shared library
    │   ├── lib/file_lock.py                     ← Concurrent file locking
    │   ├── preflight-check                      ← Script 1: cache-hit, credit gate, dead-host check
    │   ├── freshness-audit                      ← Script 2: staleness audit, BLOCK enforcement
    │   ├── validate-schema                      ← Script 3: schema validation at ingestion
    │   ├── clean-raw-fetches                    ← Script 4: 30-day raw content auto-clean
    │   ├── generate-quality-dashboard           ← Script 5: SLI compliance, trends, alerts
    │   ├── grade-engine                         ← Standalone deterministic evidence grader
    │   ├── RUNBOOK.md                           ← 5 failure scenario recovery procedures
    │   ├── IMPLEMENTATION-SPEC.md               ← Binding script specification
    │   ├── dedup-manifest.yaml                  ← Cross-niche deduplication
    │   ├── CACHE_MANIFEST.yaml                  ← URL-normalized cache index
    │   └── test/                                ← 148 tests (70 pytest + 78 bash)
    ├── CALIBRATION/                             ← Calibration niche (evaluated first by 2 agents)
    ├── N-001/ ... N-025/                        ← Per-niche structured research data
    └── _archive/                                ← Completed/archived niche data
```

---

## Quality Assurance

### Audit History

| Audit | Scope | Findings | Status |
|---|---|---|---|
| 6-Lens Architecture Audit | DATA-OPERATIONS-ARCHITECTURE.md | 40 findings | All resolved — doc v1.1 |
| 5-Lens Methodology Enhancement | NICHE-METHODOLOGY.md Parts 2, 4, 5 | 156 changes | All applied |
| 8-Lens Script Audit | 5 operational scripts + shared library | 54 findings | All resolved |
| 8-Lens Script Re-Audit | Same scripts after 52+ fixes | 3 blockers | All resolved |
| Stripe API + Google Code Review | All scripts | 21 findings | All resolved |
| 17-Lens Holistic Program Audit | Complete program (89 files) | ~45 findings | **All resolved via Fix Specification** |

### Test Suite

```bash
$ ./test/run_all_tests.sh
Total tests:  148
Passed:       148
Failed:       0
```

- 70 pytest unit tests (shared library, URL normalization, date parsing, YAML atomic writes, SLA integrity)
- 78 bash integration tests (preflight-check, freshness-audit, validate-schema, clean-raw-fetches, quality-dashboard)

### Scoring Correctness

- RIOS formula: additive mean of 8 dimensions (no denominator inversion)
- Composite score: rank-based WRS aggregation (no ordinal-to-interval violation)
- Bootstrap CIs: 90% confidence intervals on all niche ranks
- Evidence grades: deterministic pure-function grade engine, no agent self-grading
- Anti-fabrication: SOURCE_UNAVAILABLE is valid — quantity thresholds are targets, not gates

---

## Related Documents

- `CLAUDE.md` — ClarityRev project instructions
- `strategy/clarityrev-context-pack.md` — Canonical strategy and positioning
- `strategy/clarityrev-offer-framework.md` — RIOS offer design system
- `PROGRAM-HOLISTIC-AUDIT-PROMPT.md` — The 17-lens audit that found the mathematical errors in the original scoring
- `PROGRAM-FIX-SPECIFICATION.md` — The 6-workstream fix specification that resolved all findings
