# Plan: Workstream G (Security & Compliance) + 34 Quick Wins

**Author:** AWS Security Engineer (Wesley)
**Date:** 2026-07-23
**Status:** PLAN ONLY -- wait for review before executing

---

## CONTEXT SUMMARY

- **FRED removal (SEC-01/G-C1)** -- ALREADY DONE. API key removed from `~/.claude/settings.json` env block. CREDENTIALS.yaml shows `status: REMOVED` with date `2026-07-23`. World Bank + IMF documented as replacement.
- **Credential consolidation (SEC-03/G-H2)** -- ALREADY DONE. FIRECRAWL_API_KEY, DATAFORSEO_LOGIN, DATAFORSEO_PASSWORD moved from `~/.bashrc` to `~/.claude/settings.json` env block on 2026-07-23. CREDENTIALS.yaml reflects this.
- DATA-OPERATIONS-ARCHITECTURE.md is v1.1 with several C-fixes already applied (TIMEOUT_CONFIG has 310s DFS, 90s JS, free_apis section; SLI_DEFINITIONS has SRE-M01/M02/M03).
- TIMEOUT_CONFIG.yaml already has 3-level connect+read+total structure. DATA-OPERATIONS-ARCHITECTURE.md already has corrected OECD, IMF, TED, Wikidata, OpenRegistry limits from lens audits.

---

## WORKSTREAM G -- EVERY FINDING, EXACT CHANGE

### G-C1: SEC-01 -- FRED API ToS Violation (CRITICAL)
**Status:** DONE. No action needed.
- FRED_API_KEY removed from settings.json -- verified (not in env block)
- CREDENTIALS.yaml marks `fred: { status: REMOVED, reason: "...", removed_date: "2026-07-23", replacement: "World Bank API + IMF Data API" }`
- DATA-OPERATIONS-ARCHITECTURE.md still lists FRED in Tier 3 table with "verify applicability" note -- should update to REMOVED/COMMERCIAL_LICENSE_REQUIRED
- **File:** DATA-OPERATIONS-ARCHITECTURE.md line 119 (`FRED API` entry in Tier 3 table)
- **Change:** Replace `"FRED API | 120 req/min (non-commercial use only -- verify applicability) | US macro-economic data | SUFFICIENT"` with `"FRED API | REMOVED (2026-07-23) -- non-commercial use only. Use World Bank API + IMF Data API instead. See CREDENTIALS.yaml."`
- **Verification:** grep for FRED in DATA-OPERATIONS-ARCHITECTURE.md should show REMOVED status, not active listing
- **Estimate:** 2 min

### G-H1: SEC-02 -- Reddit Research MCP ToS Ambiguity (HIGH)
**Status:** NOT DONE
- Need to verify whether the Reddit Research MCP (`https://reddit-research-mcp.fastmcp.app/mcp`) uses official Reddit API or scraping
- If scraping: DO NOT CONFIGURE; use Firecrawl search with Reddit as fallback instead
- If official API: document in CREDENTIALS.yaml, ensure attribution
- **File:** CREDENTIALS.yaml -- add `reddit_research_mcp:` entry with `tos_verified:`, `method:`, `verification_date:`
- **File:** DATA-OPERATIONS-ARCHITECTURE.md -- update §2.1 Reddit Research entry and §4.0.3 authenticated session setup with ToS status
- **Plan:** Visit https://github.com/fastmcp/server-reddit-research OR the SSE endpoint provider to verify method. If not determinable, default to "use Firecrawl /search only" (conservative).
- **Verification:** CREDENTIALS.yaml has reddit_research_mcp section with tos_verification documented
- **Estimate:** 30 min (research) + 5 min (doc update)

### G-H2: SEC-03 -- Credential Consolidation (HIGH)
**Status:** DONE. No action needed.
- FIRECRAWL_API_KEY, DATAFORSEO_LOGIN, DATAFORSEO_PASSWORD moved from .bashrc to settings.json
- Verification: `grep -c "DATAFORSEO\|FIRECRAWL" ~/.bashrc` should return 0 for these values

### G-H3: SEC-04 -- Credential Rotation & Expiry Tracking (HIGH)
**Status:** NOT DONE
- CREDENTIALS.yaml is MISSING `expires` and `last_rotated` fields for all 9+ keys
- **File:** CREDENTIALS.yaml -- add to each credential entry:
  ```yaml
  expires: "YYYY-MM-DD" (or "unknown")
  last_rotated: "YYYY-MM-DD"
  ```
- For keys without documented expiry (Companies House, Brandfetch): set `expires: unknown`, note "verify annually"
- For Google API Key: note YouTube quota (10K/day)
- Document emergency rotation procedure in RUNBOOK.md
- **Verification:** CREDENTIALS.yaml `yq eval '.firecrawl.expires'` returns a non-null value for every top-level credential
- **Estimate:** 20 min

### G-H4: SEC-05 -- G2/Capterra Scraping ToS (HIGH)
**Status:** NOT DONE
- G2 ToS Section 4.3 reportedly prohibits scraping (not yet verified in current session)
- Capterra ToS also needs verification
- **Plan:** Read both ToS pages. If scraping prohibited: use DataForSEO SERP API instead. If allowed: document restrictions.
- **File:** Create `research/_program/COMPLIANCE_BLACKLIST.yaml` listing domains that prohibit automated access:
  ```yaml
  compliance_blacklist:
    - domain: "g2.com"
      status: "PROHIBITED" # or "ALLOWED_WITH_RESTRICTIONS"
      restriction_detail: "Describe the restriction"
      tos_url: "https://legal.g2.com/terms-of-use"
      verified_date: "2026-07-23"
      fallback: "DataForSEO SERP API"
  ```
- **Verification:** COMPLIANCE_BLACKLIST.yaml exists with at minimum G2 and Capterra entries
- **Estimate:** 45 min (ToS reading + decision + file creation)

### G-M1: SEC-06 -- Prompt Injection Defense (MEDIUM)
**Status:** NOT DONE. Duplicate of AGT-B5 (Workstream B).
- **COORDINATION REQUIRED with Workstream B.** This fix modifies AGENT-CONTEXT-SPEC.md.
- The fix: Add binding rule to AGENT-CONTEXT-SPEC.md: "NEVER write full scraped page content into context. Extract via grep/jq from file."
- Also add Firecrawl Ref §31 loading to Phase 1 spec (covered by Workstream B's TOOL-EXECUTION-SPEC.md creation)
- **File:** AGENT-CONTEXT-SPEC.md (Phase 2 section, BINDING section R8)
- **Change:** The BINDING -- Prompt Injection Defense (R8) section at lines 121-127 already EXISTS in the file. Verify it says "NEVER inline >10 lines" and references TOOL-EXECUTION-SPEC.md.
- **Conflict with Workstream B:** Workstream B rewrites AGENT-CONTEXT-SPEC.md's Phase 2 loading spec and creates TOOL-EXECUTION-SPEC.md. Any R8 prompt injection text added here must be coordinated. See Conflict Resolution section below.
- **Verification:** AGENT-CONTEXT-SPEC.md has active prompt injection defense section
- **Estimate:** 15 min (assuming Workstream B has already created TOOL-EXECUTION-SPEC.md)

### G-M2: SEC-07 -- Raw Content Retention (MEDIUM)
**Status:** NOT DONE
- Raw scraped content accumulates in `.firecrawl/` directory
- clean-raw-fetches script exists but never run
- **Plan:**
  1. Run `_pipelines/clean-raw-fetches.sh` (or equivalent) to clear old content
  2. Set 30-day retention policy in DATA-OPERATIONS-ARCHITECTURE.md §9.4 (already exists at lines 1110-1111 -- verify it says 30 days)
  3. Add pre-niche cleanup step to execution pipeline
  4. Spot-check 10 random files in .firecrawl/ for PII
- **File:** DATA-OPERATIONS-ARCHITECTURE.md §9.4 (Data Retention Policy) -- already has 30-day retention for raw fetched content. Verify text matches retention policy.
- **File:** RUNBOOK.md or PIPELINE_CHECKPOINTS.yaml -- add pre-niche cleanup step
- **Verification:** After running cleanup, `.firecrawl/` files have no timestamps older than 30 days
- **Estimate:** 20 min

### G-M3: SEC-08 -- Session Transcript Credential Search (MEDIUM)
**Status:** NOT DONE
- Session transcripts in `~/.claude/projects/` may contain credential values
- **Action:** Run grep for known credential patterns:
  ```bash
  grep -rnl "fc-\|5a6904eff\|DATAFORSEO\|FIRECRAWL" ~/.claude/projects/ 2>/dev/null
  ```
- If found: redact or delete affected transcript files
- Add binding rule to AGENT-CONTEXT-SPEC.md: "Never echo credential values. Use `${VAR:0:8}...` for verification."
- **File:** ~/.claude/projects/ (transcripts, not repo files)
- **File:** AGENT-CONTEXT-SPEC.md -- add credential echo rule
- **Verification:** grep returns no hits (or hits are confirmed safe/redacted)
- **Estimate:** 15 min

### G-M4: SEC-09 -- Data Disposal Plan (MEDIUM)
**Status:** NOT DONE
- No documented data lifecycle for post-program data
- DATA-OPERATIONS-ARCHITECTURE.md §9.4 already has a Data Lifecycle section with retention per data type
- **Plan:** Verify and supplement §9.4 to clarify post-program disposal:
  - Active (during program) -> Archive (30 days post) -> Dispose (90 days post)
  - Competitor pricing: archive for historical reference
  - Raw scraped: dispose at 30 days
  - Canvas outputs: retain indefinitely
- **File:** DATA-OPERATIONS-ARCHITECTURE.md §9.4 -- add "Program Closure" section with archive/dispose timeline
- **Verification:** DATA-OPERATIONS-ARCHITECTURE.md §9.4 has a "Program Closure" subsection
- **Estimate:** 15 min

### G-M5: SEC-10 -- YouTube API Quota Tracking (MEDIUM)
**Status:** NOT DONE
- YouTube Data API v3: 10,000 quota units/day
- **File:** CREDENTIALS.yaml -- add YouTube quota tracking under `google:` entry:
  ```yaml
  google:
    youtube_quota_budget_per_niche: 500
    youtube_quota_unit_cost_search: 100
    youtube_quota_remaining_today: null  # updated per-call
    youtube_quota_last_check: "2026-07-23"
  ```
- **File:** DATA-OPERATIONS-ARCHITECTURE.md §2.5 -- add YouTube quota note
- **Verification:** CREDENTIALS.yaml has youtube_quota tracking fields
- **Estimate:** 10 min

### G-L1: SEC-11 -- Brandfetch Attribution (LOW)
**Status:** NOT DONE. But this is Quick Win #16 (5 min).
- **File:** `niche-program/references/SME-tool-reference-expansion.md` §2.8
- **Change:** Add "Attribution required: 'Powered by Brandfetch' on any logo display output"
- **Verification:** SME-tool-reference-expansion.md contains "Powered by Brandfetch" or "attribution" text
- **Estimate:** 5 min

### G-L2: SEC-12 -- UK Companies House Commercial Terms (LOW)
**Status:** NOT DONE
- **File:** CREDENTIALS.yaml -- add `companies_house:` entry with `commercial_use_verified:`
- Need to verify terms at https://developer.company-information.service.gov.uk/
- Current usage (10-20 queries/niche) well within acceptable use
- **Verification:** CREDENTIALS.yaml has companies_house with commercial_use_verified field
- **Estimate:** 10 min

### G-L3: SEC-13 -- Security Contact / Incident Response (LOW)
**Status:** NOT DONE
- **File:** RUNBOOK.md -- add security contact (Wesley) and incident response procedure
- Add to RUNBOOK.md Escalation Contacts section:
  ```markdown
  **Security Contact:** Wesley (phone primary, Slack secondary)
  **Incident Response (Credential Leak):**
  1. REVOKE affected keys immediately at provider dashboard
  2. ROTATE ALL credentials in ~/.claude/settings.json
  3. CHECK git history for leaked values: `git log -p | grep -i "API_KEY\|PASSWORD\|SECRET"`
  4. CHECK transcripts: `grep -rnl "fc-\|API_KEY\|PASSWORD" ~/.claude/projects/`
  5. NOTIFY affected service providers (Firecrawl, DataForSEO)
  ```
- **Verification:** RUNBOOK.md has "Security Contact" and "Incident Response" sections
- **Estimate:** 10 min

### G.5: Source URL Death Detection (Cross-Lens Item)
**Status:** NOT DONE. From cross-lens resolution table.
- Add to verifier protocol: when re-fetching source URLs, record the resolved URL (after redirects).
- If resolved URL differs from documented source URL, flag `URL_REDIRECT_DETECTED` in trace-map.
- **File:** DATA-OPERATIONS-ARCHITECTURE.md §4.7 (Independent Verification) -- add URL death section
- **Verification:** DATA-OPERATIONS-ARCHITECTURE.md §4.7 contains URL redirect check
- **Estimate:** 10 min

### G.6: BINDING Rule Compliance Audit Script (Cross-Lens Item)
**Status:** NOT DONE.
- Create post-hoc audit script that checks agent output against binding rules:
  - search-feedback was run after every /search
  - --query was not used
  - --wait-for was used where required
  - --only-main-content was used on competitor pages
  - No echo of credential values
- **File:** `niche-program/research/_pipelines/audit-binding-compliance.sh` (new file)
- **Verification:** Script exists and can be run against a completed niche directory
- **Estimate:** 20 min

---

## 34 QUICK WINS -- GROUPED BY FILE

Each group touches ONE file. Edit once per file, not once per finding.

### GROUP A1: settings.json (3 edits, 7 min total)
Files: `~/.claude/settings.json` (mcpServers block)
| QW# | ID | Change | Min |
|-----|-----|--------|-----|
| 1 | MCP-A1 | Add PaperPlain MCP stdio config | 2 |
| 2 | MCP-A2 | Add Reddit Research hosted SSE config | 2 |
| 3 | MCP-A3 | Add Financial Hub MCP config with SEC_USER_AGENT_EMAIL | 3 |

### GROUP A2: DATA-OPERATIONS-ARCHITECTURE.md (9 edits, 40 min total)
| QW# | ID | Change | Section | Min |
|-----|-----|--------|---------|-----|
| 4 | MCP-A4 | Fix Brave Search: 2K queries/mo, API key required | §2.1 | 5 |
| 18 | SRE-H04 | Fix OpenRegistry: 3 countries/60s, NOT 30 national registries | §2.1 | 5 |
| 19 | SRE-C05 | Fix OECD: 20 req/min, NOT unlimited | §2.1 | 10 |
| 20 | SRE-H01 | Fix IMF: 50 req/s, unique user_agent needed | §2.1 | 10 |
| 21 | SRE-H02 | Fix TED: undocumented per-IP limits, 429 handling | §2.1 | 10 |
| 22 | SRE-H03 | Fix Wikidata: 5 concurrent/IP, 60s timeout, NOT 5s | §2.1 | 10 |
| 23 | SRE-H11 | Add DataForSEO Google Ads Live: 12 req/min | §2.1 / §2.3 | 10 |
| 26 | SRE-M04 | Replace HEAD hash comparison with ETag/Last-Modified | §6.4a | 10 |

Note: Some or all of MCP-A4, SRE-H04, SRE-C05, SRE-H01, SRE-H02, SRE-H03 may already be applied (DATA-OPERATIONS-ARCHITECTURE.md v1.1 post-audit). Verify before editing by grep for existing corrections.

### GROUP A3: SME-tool-reference-expansion.md (1 edit, 5 min)
| QW# | ID | Change | Section | Min |
|-----|-----|--------|---------|-----|
| 5 | MCP-A5 | Fix Serper free tier: 2,500/mo recurring, NOT one-time | §1.4 | 5 |

### GROUP A4: RUNBOOK.md (3 edits, 15 min total)
| QW# | ID | Change | Min |
|-----|-----|--------|-----|
| 8 | SRE-C03 | Replace status.firecrawl.com with test-request procedure | 5 |
| 12 | SRE-L01 | Add stale lock cleanup: >5min old may be broken | 5 |
| 15 | SRE-L07 | Add --force flag documentation | 5 |

Also add G-L3 (incident response) here.

### GROUP A5: TIMEOUT_CONFIG.yaml (2 edits, 10 min total)
| QW# | ID | Change | Min |
|-----|-----|--------|-----|
| 7 | SRE-C01 | DataForSEO standard queue: 30s -> 310s | 5 |
| 17 | SRE-MB5 | Firecrawl JS-rendered: 60s -> 90s | 5 |

Note: Both may already be applied. Verify: TIMEOUT_CONFIG.yaml line 57 shows `total: 310`, line 32 shows `total: 90`.

### GROUP A6: SLI_DEFINITIONS.yaml (3 edits, 10 min total)
| QW# | ID | Change | Min |
|-----|-----|--------|-----|
| 10 | SRE-M01 | Loosen credit_forecast_accuracy target from 20% to 50% | 5 |
| 11 | SRE-M02 | Exclude NON_RETRYABLE from fetch_success_rate denominator | 5 |
| 25 | SRE-M03 | Add single_source_ratio qualifier to evidence_quality SLI | 10 |

Note: All three appear already applied (SLI_DEFINITIONS.yaml lines 4-6). Verify before re-editing.

### GROUP A7: PIPELINE_CHECKPOINTS.yaml (1 edit, 5 min)
| QW# | ID | Change | Min |
|-----|-----|--------|-----|
| 14 | SRE-L04 | Add PHASE_0_DELTA_COUNTER field | 5 |

### GROUP A8: Filesystem Operations (2 items, 10 min total)
| QW# | ID | Change | Min |
|-----|-----|--------|-----|
| 13 | SRE-L02 | Create `_program/_postmortems/` dir + INDEX.yaml | 5 |
| 25 | MCP-B5 | Go to programmablesearchengine.google.com, create CSE engine ID, add to settings.json | 10 |

### GROUP A9: CREDENTIALS.yaml (2 edits, 10 min total)
| QW# | ID | Change | Min |
|-----|-----|--------|-----|
| 24 | SRE-H12 | Add Currents API key or document Firecrawl-only fallback | 10 |

### GROUP A10: NICHE-METHODOLOGY.md / method docs (6 edits, 30 min total)
Quick Wins from Workstream E (documentation changes, 5 min each):
| QW# | ID | Change | Min |
|-----|-----|--------|-----|
| 16 | SEC-11 | Add Brandfetch attribution to SME-tool-reference-expansion.md §2.8 | 5 |
| 17 | DQ-P3_1 | Accept budget verification as human; flag in §15 | 5 |
| 18 | DQ-B02 | Document vendor-commissioned source flag (26% revenue leak) | 5 |
| 19 | DQ-B03 | Document tech inference tool gap (or cross-ref DQ-P2_4) | 5 |
| 20 | DQ-B04 | Accept ecosystem as design work; flag economic estimates | 5 |
| 21 | DQ-B05 | Accept signal catalog limitation for zero-client stage | 5 |
| 22 | DQ-B06 | Accept customer journey as design section | 5 |

---

## EXECUTION ORDER RECOMMENDATION

### Phase 0a: Workstream G Security (priority, before Quick Wins)
Suggested execution order within Workstream G:
1. G-M3 (SEC-08): Session transcript grep -- quick, exposes actual leak risk (15 min)
2. G-H4 (SEC-05): G2/Capterra ToS compliance (45 min) -- creates COMPLIANCE_BLACKLIST.yaml
3. G-H3 (SEC-04): Credential rotation/expiry (20 min)
4. G-M2 (SEC-07): Run clean-raw-fetches (20 min)
5. G-H1 (SEC-02): Reddit MCP ToS verification (35 min)
6. G-M5 (SEC-10): YouTube quota tracking (10 min)
7. G-M4 (SEC-09): Data disposal plan (15 min)
8. G-L1 (SEC-11): Brandfetch attribution (5 min)
9. G-L2 (SEC-12): Companies House terms (10 min)
10. G-L3 (SEC-13): Security contact + incident response (10 min)
11. G.5: Source URL death in verifier protocol (10 min)
12. G.6: BINDING compliance audit script (20 min)

**Total Workstream G:** ~215 min (~3.6 hours)
**Minus already done (G-C1, G-H2):** ~200 min

### Phase 0b: 34 Quick Wins (by file group, edit once per file)
1. **GROUP A5** (TIMEOUT_CONFIG.yaml, verify existing fixes first): 5 min
2. **GROUP A6** (SLI_DEFINITIONS.yaml, verify existing fixes first): 5 min
3. **GROUP A10** (method docs, 6 doc changes): 30 min
4. **GROUP A4** (RUNBOOK.md, 3 changes + G-L3): 25 min
5. **GROUP A2** (DATA-OPERATIONS-ARCHITECTURE.md, up to 8 docs changes, verify existing): 40 min
6. **GROUP A1** (settings.json, 3 MCP configs): 7 min
7. **GROUP A3** (SME-tool reference, Serper fix): 5 min
8. **GROUP A7** (PIPELINE_CHECKPOINTS, delta counter): 5 min
9. **GROUP A8** (filesystem: postmortems dir + CSE ID): 15 min
10. **GROUP A9** (CREDENTIALS.yaml, Currents key): 10 min

**Total Quick Wins:** ~147 min (~2.5 hours)

**Grand total Workstream G + Quick Wins:** ~347 min (~5.8 hours)

---

## SESSION TRANSCRIPT SEARCH FOR CREDENTIAL LEAKS

To be run BEFORE any other action (G-M3):

```bash
# Search for known credential patterns in session transcripts
echo "=== FIRECRAWL API KEY ==="
grep -rnl "fc-\|fc_[A-Za-z0-9]\{16,\}" ~/.claude/projects/ 2>/dev/null

echo "=== DATAFORSEO PASSWORD ==="
grep -rnl "5a6904eff" ~/.claude/projects/ 2>/dev/null

echo "=== DATAFORSEO env var names ==="
grep -rnl "DATAFORSEO\|FIRECRAWL" ~/.claude/projects/ 2>/dev/null

echo "=== Generic API key patterns ==="
grep -rnl "API_KEY\|api_key\|API Key\|api-key" ~/.claude/projects/ 2>/dev/null

echo "=== .bashrc credential echoes ==="
grep -rnl "bashrc\|export.*API_KEY\|export.*PASSWORD\|export.*LOGIN" ~/.claude/projects/ 2>/dev/null
```

If any hits: determine if actual credential values are exposed (not just env var names). If actual values found, redact or delete the file. Always add `--silent` flag info before final output.

---

## DATA LIFECYCLE DOCUMENTATION

Current state: DATA-OPERATIONS-ARCHITECTURE.md §9.4 already has:
- Niche canvas: 2 years post-program (Move to `_archive/`)
- Structured data files: 2 years post-evaluation (Delete N-XXX/ if NO_GO)
- Raw fetched content: 30 days (Auto-clean)
- SHARED/ competitor profiles: Retain while competitor exists
- SHARED/ benchmarks: Retain indefinitely
- Review data: 2 years
- CREDENTIALS.yaml: Delete immediately on rotation

Needs supplement:
- Section 9.4 should add "Program Closure" subsection clarifying:
  - At program completion: retain ALL N-XXX/ canvases for reference (even NO_GO verdicts, for future pattern analysis)
  - At 90 days post-program: archive all raw .firecrawl/ content (already covered by 30-day retention)
  - At 180 days post-program: sunset SHARED/ competitor profiles not referenced in any active canvas
- Add to §3.1 (Directory Structure) a note about `_archive/` lifecycle

---

## TOS COMPLIANCE NOTES

### G2 (g2.com)
- Pipeline uses `firecrawl scrape "https://www.g2.com/products/{product}/reviews" --wait-for 3000`
- G2 ToS Section 4.3 reportedly prohibits scraping
- **Action:** Read G2 ToS at https://legal.g2.com/terms-of-use. If prohibited, switch to DataForSEO SERP API for review data.
- **Fallback:** DataForSEO Business Data API ($0.012/task) for review extraction from Google Maps listings that cross-reference G2

### Reddit (reddit.com)
- Pipeline lists Reddit Research MCP as free, no auth, 20K+ subreddits
- Reddit API terms: commercial use requires paid access (https://www.reddit.com/wiki/api-terms)
- **Must verify** whether the SSE MCP at `https://reddit-research-mcp.fastmcp.app/mcp` uses official API or scraping
- **Conservative approach:** If unverifiable, use Firecrawl /search with `site:reddit.com` queries (public pages only)
- Document in CREDENTIALS.yaml

### YouTube (youtube.com)
- YouTube Data API v3 used within normal quota limits
- Budget 500 units/niche max (5 searches at 100 units each)
- 4 concurrent agents max = 2,000 units/day -- well within 10K limit
- **Action:** Add quota check before YouTube API calls
- **Fallback:** Firecrawl /search for video content discovery (no quota)

---

## CONFLICTS WITH WORKSTREAM B (AGENT INSTRUCTIONS)

### Overlapping file: AGENT-CONTEXT-SPEC.md
- **Workstream B edits:** Replaces tool reference section loads with TOOL-EXECUTION-SPEC.md link. Rewrites Phase 2 loading spec. Creates TOOL-EXECUTION-SPEC.md (new file).
- **Workstream G edits (G-M1):** Adds prompt injection defense rule (R8). May add credential echo prohibition rule.
- **Resolution:** Both workstreams modify the same sections of AGENT-CONTEXT-SPEC.md. To avoid conflicts:
  1. **Workstream B MUST finish first** (it rewrites the structure of the Phase 2 section, moves tool references, creates the TOOL-EXECUTION-SPEC.md framework)
  2. **Workstream G then adds** to the already-restructured AGENT-CONTEXT-SPEC.md:
     - The existing R8 prompt injection defense section (lines 121-127) should be verified/enhanced
     - Add credential echo prohibition line

### Overlapping file: DATA-OPERATIONS-ARCHITECTURE.md
- **Workstream B edits:** None specifically listed for this file. B focuses on AGENT-CONTEXT-SPEC.md and TOOL-EXECUTION-SPEC.md.
- **Workstream G edits:** 8+ documentation corrections, data lifecycle additions, source URL death detection.
- **No conflict** -- B does not touch this file.

### Sequencing recommendation:
1. Workstream B creates TOOL-EXECUTION-SPEC.md and restructures AGENT-CONTEXT-SPEC.md
2. Then Workstream G applies MCP corrections to DATA-OPERATIONS-ARCHITECTURE.md, adds lifecycle docs
3. Then prompt injection defense (G-M1) can be added to the restructured AGENT-CONTEXT-SPEC.md

---

## TIME ESTIMATES SUMMARY

| Category | Items | Min estimate | Hrs |
|----------|-------|-------------|-----|
| Workstream G (not Quick Wins) | 12 items | ~200 min | ~3.3 |
| Workstream G (Quick Wins) | 2 items (1 already done) | ~5 min | ~0.1 |
| Quick Wins (A+MCP) | 7 items | ~47 min | ~0.8 |
| Quick Wins (C+SRE) | 17 items (some already applied) | ~85 min | ~1.4 |
| Quick Wins (E+Data) | 6 items | ~30 min | ~0.5 |
| **Total** | **44 items** | **~367 min** | **~6.1 hrs** |

Note: Several Quick Wins (TIMEOUT_CONFIG 310s/90s, SLI M01/M02/M03, OECD/IMF/Wikidata docs) appear already applied in v1.1 documents. Actual execution time likely ~3-4 hours when already-applied items are skipped.

---

## VERIFICATION CHECKLIST

After all changes:

- [ ] G-G1: FRED_API_KEY removed from settings.json; updated in DATA-OPERATIONS-ARCHITECTURE.md
- [ ] G-G2: Reddit Research MCP ToS verified and documented in CREDENTIALS.yaml
- [ ] G-G3: All credentials in settings.json only; .bashrc verified free of API keys
- [ ] G-G4: CREDENTIALS.yaml has `expires` and `last_rotated` for all 9+ keys
- [ ] G-G5: G2/Capterra ToS compliance documented in COMPLIANCE_BLACKLIST.yaml
- [ ] G-G6: clean-raw-fetches run; 30-day retention policy documented
- [ ] G-G7: Session transcripts searched for credential leaks
- [ ] G-G8: Data disposal lifecycle in DATA-OPERATIONS-ARCHITECTURE.md §9.4
- [ ] G-G9: YouTube API quota tracking in CREDENTIALS.yaml
- [ ] G-G10: Incident response plan in RUNBOOK.md
- [ ] G-G11: Source URL death detection in verifier protocol §4.7
- [ ] G-G12: BINDING rule compliance audit script created

---

## DIFF GENERATION (rollback safety net)

Before making ANY edit to an existing file, run:
```bash
cp {filepath} {filepath}.PRE-G-FIX
```

After all changes, generate a summary:
```bash
for f in $(find niche-program/ -name "*.PRE-G-FIX"); do
  echo "=== Changes to ${f%.PRE-G-FIX} ==="
  diff <(cat "$f") <(cat "${f%.PRE-G-FIX}") 2>/dev/null
done
```

This allows clean rollback if any edit has unintended consequences.

---

**End of Plan. Review before execution.**
