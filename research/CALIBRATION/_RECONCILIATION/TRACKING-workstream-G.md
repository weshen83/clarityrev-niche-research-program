# WORKSTREAM G + QUICK WINS -- EXECUTION TRACKING
# Started: 2026-07-23

## WORKSTREAM G
- [x] G-C1 (SEC-01): FRED entry updated in DATA-OPERATIONS-ARCHITECTURE.md
- [x] G-H1 (SEC-02): Reddit MCP ToS verified — official API via PRAW, documented in COMPLIANCE_BLACKLIST.yaml
- [x] G-H2 (SEC-03): DONE (confirmed: .bashrc cleaned, creds in settings.json)
- [x] G-H3 (SEC-04): Credential rotation/expiry — ADDED expires+last_rotated to CREDENTIALS.yaml
- [x] G-H4 (SEC-05): COMPLIANCE_BLACKLIST.yaml CREATED (G2=PROHIBITED, Reddit=OFFICIAL_API_ONLY, LinkedIn=PROHIBITED, Capterra=PROBABLY_PROHIBITED, Trustpilot=PROBABLY_PROHIBITED)
- [x] G-M1 (SEC-06): Prompt injection — DONE (added R9 Credential Secrecy to AGENT-CONTEXT-SPEC.md)
- [x] G-M2 (SEC-07): clean-raw-fetches run — .firecrawl/ and .dataforseo/ non-existent (no PII risk)
- [x] G-M3 (SEC-08): DONE — transcript scan, no broad credential leak found
- [x] G-M4 (SEC-09): Data disposal plan — ADDED Program Closure Data Lifecycle to DATA-OPERATIONS-ARCHITECTURE.md §9.4
- [x] G-M5 (SEC-10): YouTube quota tracking — ADDED to CREDENTIALS.yaml google: entry
- [x] G-L1 (SEC-11): Brandfetch attribution — ADDED best-practice note to SME-tool-reference-expansion.md §2.8
- [x] G-L2 (SEC-12): Companies House commercial use — VERIFIED + documented in CREDENTIALS.yaml
- [x] G-L3 (SEC-13): Security contact + incident response — ADDED to RUNBOOK.md
- [x] G.5: Source URL death — ADDED redirect check to DATA-OPERATIONS-ARCHITECTURE.md §4.7 step 4
- [x] G.6: BINDING compliance audit script — CREATED _pipelines/audit-binding-compliance.sh

## 34 QUICK WINS

### A1: settings.json MCP configs
- [x] MCP-A1: PaperPlain MCP — ADDED to settings.json
- [x] MCP-A2: Reddit Research SSE — ADDED to settings.json
- [x] MCP-A3: Financial Hub MCP — ADDED to settings.json

### A2: DATA-OPERATIONS-ARCHITECTURE.md (all already applied in v1.1)
- [x] MCP-A4, SRE-H04, SRE-C05, SRE-H01, SRE-H02, SRE-H03, SRE-H11, SRE-M04

### A3: SME-tool-reference-expansion.md
- [x] MCP-A5: Serper free tier fixed (line 1530 table)
- [x] SEC-11: Brandfetch attribution added (§2.8)

### A4: RUNBOOK.md (all already applied)
- [x] SRE-C03, SRE-L01, SRE-L07

### A5: TIMEOUT_CONFIG.yaml (all already applied)
- [x] SRE-C01, SRE-MB5

### A6: SLI_DEFINITIONS.yaml (all already applied)
- [x] SRE-M01, SRE-M02, SRE-M03

### A7: PIPELINE_CHECKPOINTS.yaml (already applied)
- [x] SRE-L04

### A8: Filesystem
- [x] SRE-L02: _postmortems/ dir created
- [ ] MCP-B5: Google CSE engine ID (manual — Wesley needs to visit programmablesearchengine.google.com)

### A9: CREDENTIALS.yaml
- [x] SRE-H12: Currents verified already configured
- [x] G-H3: Rotation/expiry fields added
- [x] G-M5: YouTube quota tracking added

### A10: Method docs
- [x] DQ-P3_1: Budget verification — noted in DATA-OPERATIONS-ARCHITECTURE.md §9.2
- [x] DQ-B02: Vendor-commissioned source flag — noted in §9.2
- [x] DQ-B03: Tech inference tool gap — noted in §9.2 (cross-ref DQ-P2_4)
- [x] DQ-B04: Ecosystem design work — noted in §9.2
- [x] DQ-B05: Signal catalog limitation — noted in §9.2
- [x] DQ-B06: Customer journey design — noted in §9.2

### Manual items for Wesley
- MCP-B5: Create Google CSE engine ID at https://programmablesearchengine.google.com (needs browser)
- MCP-B1 through B4, B6, B7: Sign up for Serper, Brave, Jina AI, CrawlForge, FetchSERP API keys (needs browser)
