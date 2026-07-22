# Niche Program — 25-Niche Evaluation Architecture

**Status:** ACTIVE — Methodology + Data Architecture complete. Operational scripts built, audited, and tested.
**Last Updated:** 2026-07-23
**Binding specifications:**
- `NICHE-METHODOLOGY.md` — 15-section canvas, research protocol, scoring rubric, quality gates
- `DATA-OPERATIONS-ARCHITECTURE.md` v1.1 — tools, commands, schemas, budgets, pipeline (post 6-lens audit)

---

## What's Here

This directory contains the complete Niche Research Program: the methodology for evaluating 25 B2B niches, the data operations architecture for gathering research data, verified toolchain specifications, structured data schemas, operational automation scripts, quality monitoring infrastructure, incident recovery runbooks, a comprehensive test suite, and partner-ready documentation for sharing with the founding team.

---

## Directory Map

```
niche-program/
│
├── README.md                                 ← You are here
├── NICHE-METHODOLOGY.md                      ← BINDING: 15-section canvas + research protocol + scoring (4,515 lines)
├── DATA-OPERATIONS-ARCHITECTURE.md           ← BINDING: tools, schemas, budgets, pipeline v1.1 (1,243 lines)
├── SESSION-STARTER.md                        ← Program context: what's built, what remains
│
├── PARTNER-SHARE-MANIFEST.md                 ← Which files to share with Bob & Adriaan + why
├── PARTNER-LLM-PROMPT.md                     ← Prompt to paste into LLM to explain the program
│
├── schemas/                                  ← Structured data validation schemas
│   ├── README.md                             ← Schema directory guide
│   ├── competitor-profile-schema.yaml        ← Competitor profile validation (349 lines)
│   ├── review-corpus-schema.yaml             ← Review corpus validation (284 lines)
│   ├── market-sizing-schema.yaml             ← Market sizing validation (234 lines)
│   └── canvas-frontmatter-schema.yaml        ← Canvas YAML frontmatter validation (337 lines)
│
├── discovery/                                ← Phase 0: tool & data source discovery (reference)
│   ├── mcp-discovery-report.md               ← 65+ MCP servers across 16 categories
│   ├── free-apis-b2b-niche-research.md       ← 10 categories of free APIs, verified limits
│   ├── free-b2b-research-data-sources.md     ← Free alternatives to 10 paid tool categories
│   ├── niche-data-sources-europe-staffing-crm.md ← EU/Benelux, staffing, CRM data sources
│   └── alternative-tools/                    ← Deep dives per tool category
│
├── lenses/                                   ← Phase 1: 6-lens architecture designs (reference)
│   ├── 01-data-operations-architect.md       ← Tool-to-task mapping, parallelization
│   ├── 02-schema-storage-designer.md         ← Directory structure, JSON schemas, traceability
│   ├── 03-workflow-automation-designer.md    ← Execution pipeline, pre-flight checks, idempotency
│   ├── 04-cross-agent-data-sharing.md        ← Shared vs. isolated data, benchmark database
│   ├── 05-cost-efficiency-auditor.md         ← 3-tier budget, diminishing returns, kill switches
│   └── 06-quality-freshness-controller.md    ← Freshness SLAs, evidence grades, audit trails
│
├── references/                               ← Tool reference documentation (reference)
│   ├── firecrawl-comprehensive-reference.md  ← All 30+ Firecrawl capabilities
│   └── data-sources-reference.md             ← DataForSEO + free APIs + MCP servers catalog
│
└── research/                                 ← Runtime data + operational infrastructure
    │
    ├── _program/                             ← Cross-niche program management
    │   ├── QUALITY_METRICS.yaml              ← Aggregated quality metrics across all niches
    │   ├── FRESHNESS_VIOLATION_LOG.yaml      ← Append-only freshness violation log
    │   ├── TOOL_ERROR_LOG.yaml               ← Append-only tool error log
    │   ├── SLI_DEFINITIONS.yaml              ← 6 Service Level Indicators + 5 alert thresholds
    │   ├── CREDIT_BUDGET.yaml                ← Running credit consumption tracker
    │   ├── DEAD_HOST_REGISTRY.yaml           ← Shared dead-host list
    │   └── PIPELINE_CHECKPOINTS.yaml         ← Per-niche checkpoint state
    │
    ├── SHARED/                               ← Cross-niche reusable data
    │   ├── _REGISTRY.yaml                    ← Index of all shared data files
    │   ├── benchmarks/                       ← B2B benchmarks (churn, conversion, CAC)
    │   ├── competitors/                      ← Cross-niche competitor profiles
    │   ├── regulatory/                       ← GDPR, AI Act, industry regulations
    │   ├── tools/                            ← Tool/capability inventory
    │   ├── taxonomy/                         ← Niche categories, signal types, buyer roles
    │   └── triggers/                         ← Cross-niche trigger registry
    │
    ├── _pipelines/                           ← Operational scripts + infrastructure
    │   ├── lib/pipeline_ops.py               ← Shared library (540 lines) — all scripts import from here
    │   ├── preflight-check                   ← Script 1: cache-hit, credit gate, dead-host check (940 lines)
    │   ├── freshness-audit                   ← Script 2: staleness audit, BLOCK enforcement (1,160 lines)
    │   ├── validate-schema                   ← Script 3: schema validation at ingestion time (1,270 lines)
    │   ├── clean-raw-fetches                 ← Script 4: 30-day raw content auto-clean (320 lines)
    │   ├── generate-quality-dashboard        ← Script 5: SLI compliance, trends, alerts (1,150 lines)
    │   ├── CACHE_MANIFEST.yaml               ← URL-normalized content-addressed cache index
    │   ├── dedup-manifest.yaml               ← Cross-niche deduplication tracking
    │   ├── RUNBOOK.md                        ← 5 failure scenario recovery procedures
    │   ├── IMPLEMENTATION-SPEC.md            ← Binding script implementation specification
    │   ├── SCRIPTS-AUDIT-PROMPT.md           ← 8-lens audit prompt (executed 2026-07-23)
    │   ├── test/                             ← Test suite (149 tests)
    │   │   ├── conftest.py                   ← Shared pytest fixtures
    │   │   ├── test_pipeline_ops.py          ← 70 unit tests for shared library
    │   │   ├── test_preflight_check.sh       ← 21 integration tests
    │   │   ├── test_freshness_audit.sh       ← 20 integration tests
    │   │   ├── test_validate_schema.sh       ← 13 integration tests
    │   │   ├── test_clean_raw_fetches.sh     ← 10 integration tests
    │   │   ├── test_quality_dashboard.sh     ← 15 integration tests
    │   │   └── run_all_tests.sh              ← Master test runner
    │   └── test_data/                        ← Test fixtures
    │
    ├── CALIBRATION/                          ← Calibration niche (evaluated first by 2 agents)
    ├── N-001/ ... N-025/                     ← Per-niche structured research data
    └── _archive/                             ← Completed/archived niche data
```

---

## Quick Start

### To understand the program (founders, partners):
1. **Read the methodology:** `NICHE-METHODOLOGY.md` — the 15-section canvas, research protocol, scoring rubric
2. **Read the data architecture:** `DATA-OPERATIONS-ARCHITECTURE.md` — exact tools, commands, schemas, budgets
3. **Share with your LLM:** Use `PARTNER-SHARE-MANIFEST.md` to pick files + `PARTNER-LLM-PROMPT.md` as the prompt

### To run the pipeline (Wesley / operators):
1. **Verify Phase 0:** Run calibration tests from `DATA-OPERATIONS-ARCHITECTURE.md` §4.0
2. **Run pre-flight check:** `./research/_pipelines/preflight-check N-001 competitor-pricing --target-url "https://example.com"`
3. **Validate schemas:** `./research/_pipelines/validate-schema competitor-profile <file>`
4. **Run freshness audit:** `./research/_pipelines/freshness-audit N-001`
5. **Incident recovery:** See `research/_pipelines/RUNBOOK.md` for 5 failure scenarios

### To run the test suite:
```bash
cd niche-program/research/_pipelines
./test/run_all_tests.sh
```

---

## Key Numbers

| Metric | Value | Source |
|---|---|---|
| Niches to evaluate | 25 | NICHE-METHODOLOGY.md |
| Firecrawl credits available | 100,000 | DATA-OPERATIONS-ARCHITECTURE.md §1.2 |
| Firecrawl per niche (DEEP, estimated) | ~132 credits | §4 pipeline detail tables — measure on calibration niche |
| DataForSEO credits available | $50 (~83,000 SERP checks) | §1.2 |
| DataForSEO per niche (DEEP, estimated) | ~$0.04 | §4 pipeline detail tables |
| Wall-clock per niche (estimated) | ~13-16 min (network I/O) + ~5-8 min (canvas authoring) = ~20-25 min total | §1.2 |
| Per-niche hard timeout | 45 minutes | §1.2 |
| Concurrent niches (max) | 4 | §1.2 (per G-026 concurrency findings) |
| Free tools available | 65+ MCP servers, 20+ free APIs | discovery/ |
| Evidence grades | `[P]` Proven, `[E]` Evidenced, `[H]` Hypothesis, `[S]` Speculation | §6.2 |
| Freshness SLA range | 7 days (job postings) to 365 days (certifications) | §6.1 |
| Operational scripts | 5 (5,227 lines Python) + shared library (540 lines) | research/_pipelines/ |
| Test coverage | 149 tests (70 pytest + 79 bash integration) | research/_pipelines/test/ |
| Schema validators | 4 (competitor-profile, review-corpus, market-sizing, canvas-frontmatter) | schemas/ |

---

## How This Was Built

### Phase 0: Tool Discovery
4 parallel discovery agents searched MCP registries, free API catalogs, open data sources, and EU/niche-specific data providers. Output: 65+ verified MCP servers, 20+ verified free APIs.

### Phase 1: 6-Lens Architecture Design
6 expert lenses designed the data operations architecture: Data Operations Architect, Schema & Storage Designer, Workflow Automation Designer, Cross-Agent Data Sharing Architect, Cost & Efficiency Auditor, Quality & Freshness Controller. All 6 integrated into `DATA-OPERATIONS-ARCHITECTURE.md`.

### Phase 2: Methodology Enhancement
NICHE-METHODOLOGY.md Parts 2, 4, and 5 enhanced with 5-lens audits. Research Protocol rewritten to reference the actual toolchain (Firecrawl, DataForSEO, MCP servers). Workflow catalog (W1-W9) updated with actual tools. Cross-Niche Comparability extended with 2 new drift prevention mechanisms (Independent Verification Sampling, Concurrent Execution Guard).

### Phase 3: 6-Lens Architecture Audit
6 adversarial expert lenses (Pipeline Architect, SRE, API Architect, Data Quality Engineer, Security Auditor, Chaos Engineer) audited DATA-OPERATIONS-ARCHITECTURE.md. 40 findings, 5 blocking/critical. ALL fixes applied. Document upgraded to v1.1.

### Phase 4: Operational Script Implementation
5 production Python scripts + shared library written from a 1,200-line binding implementation specification (Google SRE, Stripe API, Netflix Chaos Engineering patterns). Total: 5,227 lines.

### Phase 5: 8-Lens Script Audit + Fixes + Tests
8 adversarial expert lenses (SRE, API Design, Chaos Engineering, Security, Formal Correctness, Observability, Code Quality, Agent Usability) audited all scripts. 54 findings. ALL 6 BLOCKING + 18 CRITICAL + ~28 HIGH/MEDIUM/LOW fixes applied. 149 tests written (70 pytest + 79 bash integration). All 6 P0 fixes verified present. All 6 files compile clean. 70/70 pytest tests pass.

---

## What Is NOT Here (Intentionally Excluded)

- **No real niche evaluations yet** — the `N-001/` through `N-099/` directories contain test fixtures only, created during script testing. Real niche evaluations begin after Phase 0 calibration.
- **No credentials** — API keys and passwords are stored in environment variables, never in these files. `CREDENTIALS.yaml` is gitignored.
- **No raw fetched content** — `.firecrawl/` and `.dataforseo/` directories are gitignored. Only structured data is committed.

---

## Related Documents

- `CLAUDE.md` — Project instructions (niche research phase is active)
- `strategy/clarityrev-context-pack.md` — Canonical ClarityRev strategy and positioning
- `strategy/clarityrev-offer-framework.md` — RIOS offer design system
- `.planning/SOURCE_OF_TRUTH.yaml` — Consolidated ClarityRev decisions and constraints
