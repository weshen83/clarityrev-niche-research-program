# RUNBOOK — 25-Niche Evaluation Pipeline Recovery Procedures

**Status:** BINDING — Apply these procedures when any failure scenario is detected.
**Version:** 1.0
**Last Updated:** 2026-07-23
**Audience:** Pipeline operator (Wesley). Escalation to Bob per severity schedule below.

---

## Escalation Contacts

| Contact | Channel | Reach | Severity Coverage |
|---|---|---|---|
| **Wesley** | Phone (primary), Slack (secondary) | Immediate | P1, P2, P3 |
| **Bob** | Slack (business hours only: 09:00-18:00 CET) | <30 min | P2 (business impact or decision needed) |

**P1 = Production pipeline halted, credits at risk, data loss possible.**
**P2 = Pipeline degraded, niche(s) blocked, workaround available.**
**P3 = Non-urgent issue. Resolve within current or next operating session.**

---

## Scenario 1: Pipeline Stuck

**Severity:** P2 (single niche) / P1 (all niches)

**Detection:**
- `_program/PIPELINE_CHECKPOINTS.yaml` shows a niche with `last_updated` >45 minutes ago and status is not COMPLETE or FAILED
- Agent process for a niche has not produced output for >10 minutes
- Queue progress stalled — subsequent niches not advancing

**Recovery Procedure:**

1. **IDENTIFY** the stuck niche. Open `_program/PIPELINE_CHECKPOINTS.yaml`. Find the entry with the oldest `last_updated` timestamp whose status is QUEUED, P1, P2, P3, or P4 (not COMPLETE or FAILED).

2. **CHECK** `_program/TOOL_ERROR_LOG.yaml` for any recent errors associated with this niche_id. Search for entries timestamped within the stuck window.

3. **DIAGNOSE** scope: is this niche-specific or system-wide?
   - **Single niche stuck:** Kill the stuck agent process. Mark the niche as `FAILED: TIMEOUT` in `_program/LEDGER.yaml` with the `last_updated` timestamp and a brief root cause note. Advance the queue — next scheduled niche may proceed.
   - **All niches stuck simultaneously:** Proceed to Step 4 — this is likely a provider outage (go to Scenario 3 or 4).

4. **CHECK** concurrent load limits if stuck during Phase 2:
   - Firecrawl: Are 50 concurrent requests saturated? Check Firecrawl dashboard for active request count.
   - DataForSEO: Are 30 concurrent queries saturated? Check DataForSEO dashboard.
   - If concurrency limit hit: reduce parallel worker count by 1 (from max 4 to 3 concurrent niches). Wait 2 minutes for backpressure to clear. Resume.
   - If concurrency is fine: proceed to Step 5.

5. **CHECK** dead host: If the niche was fetching from a specific host, verify it is not in `_program/DEAD_HOST_REGISTRY.yaml`. If the host was added mid-fetch, the agent may not have received the signal. Mark the failed step as `SOURCE_UNAVAILABLE: DEAD_HOST` and advance.

6. **RESOLUTION LOGGING:** In `_program/TOOL_ERROR_LOG.yaml`, append:
   ```yaml
   - tool: "<agent_or_tool_name>"
     error_code: "PIPELINE_STUCK"
     niche_id: "N-XXX"
     timestamp: "<YYYY-MM-DDTHH:MM:SSZ>"
     context: "last_heartbeat: <timestamp>, status: <status>, phase: <phase>"
     resolution: "killed agent / resumed queue / any credits_lost"
   ```

7. **VERIFY** upstream queue is advancing. Confirm the next niche in the queue has progressed past its previous checkpoint within 5 minutes.

**Prevention:**
- All agents MUST heartbeat to `PIPELINE_CHECKPOINTS.yaml` every 5 minutes during active work, not only at phase transitions.
- Pipeline operator monitors heartbeat freshness every 30 minutes during active batch runs.
- Concurrency limits are enforced at the queue level (max 4 niches), not left to agent discretion.
- A `max_execution_time` field in each PIPELINE_CHECKPOINTS entry allows automated timeout detection — agents set this when they start a phase.

---

## Scenario 2: Credit Runaway

**Severity:** P1

**Detection:**
- `_program/CREDIT_BUDGET.yaml` shows per-niche consumption exceeding 9,000 Firecrawl credits (halt threshold) OR aggregate burn rate exceeding 4,000 credits/hour.
- `CREDIT_BUDGET.yaml` shows DataForSEO per-niche consumption exceeding $5.00.
- Automated alert: `firecrawl credit-usage` returns balance dropping faster than expected for number of niches completed.
- Dashboard reveals a single niche burning credits in a loop without checkpoint updates.

**Recovery Procedure:**

1. **KILL ALL** agent processes immediately. Do not pause — kill. Every second of a runaway costs credits.

2. **IDENTIFY** the culprit niche(s). Read `_program/CREDIT_BUDGET.yaml` and sort per-niche `total_credits_consumed` descending. The highest consumer(s) are the likely runaway.

3. **CHECK** for infinite loop patterns:
   - Did Step 2.1 (competitor discovery via Firecrawl /search) → Step 2.2 (pricing extraction via /scrape) form a loop where discovered competitors trigger new searches that discover more competitors? Check the agent's work log for repeated same-domain queries.
   - Is the cache layer failing? If URLs are dynamically generated with timestamp/query params, Firecrawl sees every request as a new URL — cache key never matches, every fetch burns credits. Check `_program/CREDIT_BUDGET.yaml` for high `credits_consumed` against a single tool endpoint with no corresponding `cache_hit` entries.
   - Is a dead host being retried? Check `_program/DEAD_HOST_REGISTRY.yaml` — if an agent is retrying a dead host instead of skipping, it burns credits on every attempt.

4. **FIX** the root cause:
   - For loop between Steps 2.1 and 2.2: Add a `max_discovered_competitors` limit (default: 15) to the competitor discovery agent prompt. Instruct the agent to stop discovery once 15 unique competitors are found.
   - For cache failure: Ensure all scraper calls use canonical (non-dynamic) URLs. If the page redirects, cache the canonical URL, not the redirect chain. Add `--skip-redirect-cache` awareness.
   - For dead-host retries: The agent MUST check `_program/DEAD_HOST_REGISTRY.yaml` before every fetch. If the host is listed, skip immediately (0 credits). Retrofit this check into the agent prompt if missing.

5. **RESUME** from last known-good checkpoint. Read `_program/PIPELINE_CHECKPOINTS.yaml` for the niche's last checkpoint before the runaway began. Restart the agent from that checkpoint, not from the beginning.

6. **LOG** the incident in `_program/TOOL_ERROR_LOG.yaml`:
   ```yaml
   - tool: "<agent_or_tool_name>"
     error_code: "CREDIT_RUNAWAY"
     niche_id: "N-XXX"
     timestamp: "<YYYY-MM-DDTHH:MM:SSZ>"
     context: "credits_consumed: <amount>, burn_rate: <rate_per_hour>, loop_pattern: <description>"
     resolution: "killed agents, fixed loop cause, resumed from checkpoint, credits_wasted: <amount>"
   ```

7. **UPDATE** `_program/CREDIT_BUDGET.yaml` with corrected remaining balance. Reduce by credits wasted in the incident. Flag the correction with a note: `# POST-INCIDENT CORRECTION: <date> — <credits> wasted by runway loop <description>`.

**Prevention:**
- Every agent checks `_program/CREDIT_BUDGET.yaml` before each credit-consuming operation — if projected consumption would exceed per-niche halt threshold, the agent self-terminates.
- Add a `max_credits_per_niche` field to `_program/PIPELINE_CHECKPOINTS.yaml` — agents enforce this limit locally and stop when reached.
- Firecrawl /search pagination is capped at 3 pages per query. No agent may request page 4+ without explicit override.
- DataForSEO keyword batches are always a single API call with up to 1,000 keywords — never loop with 1 keyword per call.
- Cache hit rate is tracked weekly. If overall cache hit rate drops below 60%, investigate the cache layer.

---

## Scenario 3: Firecrawl 500s / Outage

**Severity:** P1 (confirmed outage) / P2 (intermittent errors)

**Detection:**
- Multiple niches return HTTP 500, 502, or 503 errors from Firecrawl within the same 5-minute window.
- `_program/TOOL_ERROR_LOG.yaml` shows >30% failure rate across all Firecrawl calls in the last 5 minutes.
- Firecrawl `/search` returns non-JSON responses or empty result sets where content is expected.
- `firecrawl credit-usage` fails or returns unexpected results.

**Recovery Procedure:**

1. **DIAGNOSE** root cause — outage vs. rate-limiting vs. account issue:
   - NOTE: status.firecrawl.com DNS NXDOMAIN — this page does NOT exist. Do not attempt to use it.
   - Run `firecrawl --status` to check CLI connectivity. If it fails, the CLI itself may be down.
   - Run `firecrawl search "test sanity check 2026" --limit 1` as a live health check. If it returns valid results, Firecrawl is operational.
   - Check Firecrawl dashboard (app.firecrawl.dev) for concurrent request count. If at 50/50, this is rate-limiting, not an outage.
   - For DataForSEO health: send a test request to the DataForSEO API (`serp/google/organic/live/advanced` with a simple keyword). If it returns results, DataForSEO is operational.
   - Check Firecrawl dashboard for concurrent request count. If at 50/50, this is rate-limiting, not an outage.
   - Check Firecrawl account page for billing/payment issues. If account is suspended, this is an account issue, not an outage.

2. **ACT** based on root cause:

   **If outage confirmed (status page shows RED):**
   a. **Stop** all niches currently executing Firecrawl-dependent steps. Do NOT kill the niche entirely — pause them.
   b. For each paused niche, open `_program/PIPELINE_CHECKPOINTS.yaml` and mark the current step as `DEFERRED: FIRECRAWL_OUTAGE` with the outage start timestamp.
   c. **Switch** in-flight niches to fallback tools per the Table 2.3 Tool-to-Task Master Matrix in DATA-OPERATIONS-ARCHITECTURE.md:
      - Firecrawl /search → DataForSEO SERP API (if balance permits) or OpenSERP (free fallback)
      - Firecrawl /scrape → DataForSEO OnPage API (free) for content parsing
      - Firecrawl /crawl → Firecrawl /map + targeted /scrape of individual pages (reduces scope but keeps moving)
   d. **Continue** niches on non-Firecrawl steps (Phase 1 market sizing via EUROSTAT/OECD, Phase 2.6 company registry via OpenRegistry MCP, Phase 2.7 news scan via GDELT) — these tools are not affected.
   e. **Document** which tools are compensating for Firecrawl in `_program/TOOL_ERROR_LOG.yaml`.

   **If NOT confirmed outage (rate-limiting suspected):**
   a. **Reduce** concurrency: pause 2 of 4 active niches immediately. Leave 2 niches running.
   b. **Implement** exponential backoff: wait 2 minutes before retrying any failed request.
   c. After 2 minutes: retry 1 niche. If it succeeds, add back the second paused niche after 2 more minutes.
   d. If the first retry also fails, wait 5 minutes, then retry. Max 3 retry rounds before treating as outage.

   **If account issue (payment/suspension):**
   a. **Halt** all pipeline operations. Do not resume until account is restored.
   b. Contact Firecrawl support via dashboard. Do NOT proceed on fallback tools — Firecrawl is primary for 12 of 17 data types. Running on fallbacks alone would produce inconsistent data.
   c. Log as P1: `error_code: "FIRECRAWL_ACCOUNT_ISSUE"`.

3. **RESUME** Firecrawl-dependent steps after recovery:
   - Wait until status page shows green for 5+ minutes, OR
   - Verify with a manual test call: `firecrawl search "test sanity check 2026" --limit 1`. If this returns valid results, Firecrawl is operational.
   - Re-enable paused niches one at a time, 2-minute stagger between each.
   - Update `_program/PIPELINE_CHECKPOINTS.yaml`: remove the `DEFERRED` annotation, update status to the original phase, update `last_updated`.

4. **LOG** the incident in `_program/TOOL_ERROR_LOG.yaml`:
   ```yaml
   - tool: "firecrawl"
     error_code: "FIRECRAWL_OUTAGE"  # or "FIRECRAWL_RATE_LIMIT" or "FIRECRAWL_ACCOUNT_ISSUE"
     niche_id: "ALL"  # or specific if single niche
     timestamp: "<YYYY-MM-DDTHH:MM:SSZ>"
     context: "outage_start: <timestamp>, recovery_end: <timestamp>, duration_minutes: <X>, affected_niches: [N-XXX, N-YYY]"
     resolution: "fallback_tools_used: [DataForSEO SERP, OpenSERP], firecrawl_credits_lost_from_retries: <count>"
   ```

**Prevention:**
- Pipeline never runs >4 concurrent niches (soft limit) to stay well under Firecrawl's 50-concurrent limit.
- Every Firecrawl call has a 10-second connect timeout and 30-second read timeout (per §2.4). No call hangs indefinitely.
- A `retry_count` and `max_retries` field in each checkpoint entry prevents infinite retry loops. Default max_retries: 3.
- Weekly Firecrawl account balance check. Top-up before balance drops below 20,000 credits.
- Fallback tools kept warm: Phase 0 verifies at least 3 free fallback tools are operational (per §4.0.5 gate).

---

## Scenario 4: DataForSEO Stale / Exhausted Balance

**Severity:** P1 (balance exhausted) / P2 (balance low — <$5)

**Detection:**
- DataForSEO API returns HTTP 402 (Payment Required) on any endpoint.
- DataForSEO dashboard shows remaining balance <$5.
- `_program/CREDIT_BUDGET.yaml` DataForSEO remaining field is below threshold.
- `_program/TOOL_ERROR_LOG.yaml` shows `error_code: "DATAFORSEO_BALANCE_EXHAUSTED"` entries.

**Recovery Procedure:**

1. **CHECK** exact remaining balance. Open DataForSEO dashboard. Note the precise figure.

2. **ACT** based on balance level:

   **If balance exhausted ($0.00):**
   a. **Convert** ALL remaining niches to STANDARD-only depth immediately. No niche may proceed past Phase 1 without DataForSEO.
   b. **Migrate** DataForSEO-dependent operations to free fallbacks:
      - DataForSEO SERP API → Firecrawl /search (2 credits/search — acceptable for reduced scope)
      - DataForSEO Keywords API → Set `keyword_volume` to `SOURCE_UNAVAILABLE: BALANCE_EXHAUSTED` for all remaining niches. Do not attempt free keyword volume tools — none provide reliable B2B keyword data at the needed scale.
      - DataForSEO Labs (competitor profiling) → Firecrawl /search with competitor queries. Less structured but sufficient for STANDARD depth.
      - DataForSEO Domain Analytics (technographics) → Set `technographic_profile` to `SOURCE_UNAVAILABLE: BALANCE_EXHAUSTED`. Accept the gap.
      - DataForSEO Backlinks API → Open PageRank API (free, 4.3M domains/day — less granular but provides domain authority scores).
      - DataForSEO OnPage API (free) → This endpoint remains free even with $0 balance. Continue using it.
   c. **Document** the accepted gaps in `_program/LEDGER.yaml` for each affected niche. Add a note: `dataforseo_gap: "Phase <X> Step <Y>: BALANCE_EXHAUSTED — used fallback <tool_name> or accepted gap"`.
   d. **Recalculate** pipeline completion expectations. Without DataForSEO, DEEP depth is impossible and FORENSIC depth is blocked. Update the pipeline milestone timeline accordingly.

   **If balance low but not exhausted ($0.01-$4.99):**
   a. **Reserve** remaining balance exclusively for Phase 2 Step 2.5 (SERP/keyword analysis — highest value per dollar at $0.0006/keyword).
   b. **Drop** Phase 2 Step 2.4 (technographics via DataForSEO Domain Analytics at $1.21/1K companies). Use free alternatives:
      - BuiltWith free API (2,000 lookups/day) for core tech detection
      - Manual homepage review for tech stack clues
   c. **Drop** DataForSEO Labs API calls (competitor domain analysis at $0.012/task). Use Firecrawl /search fallback.
   d. **Continue** DataForSEO OnPage API (free) for content parsing.
   e. **Log** the reservation plan in `_program/CREDIT_BUDGET.yaml`:
      ```yaml
      # DATAFORSEO RESERVATION ACTIVE: <date>
      # Reserved for: N-XXX, N-YYY (SERP/keyword analysis only)
      # Dropped: technographics (N-XXX), competitor profiling (N-YYY)
      # Remaining balance at reservation: $X.XX
      ```

3. **TOP-UP** if pipeline continuity requires DEEP/FORENSIC depth. Budget for $50 DataForSEO credit top-up. Wesley makes the call based on how many DEEP niches remain and the expected value of DataForSEO-specific data for those niches versus the $50 cost.

4. **LOG** the incident in `_program/TOOL_ERROR_LOG.yaml`:
   ```yaml
   - tool: "dataforseo"
     error_code: "DATAFORSEO_BALANCE_EXHAUSTED"  # or "DATAFORSEO_BALANCE_LOW"
     niche_id: "ALL"
     timestamp: "<YYYY-MM-DDTHH:MM:SSZ>"
     context: "balance_at_exhaustion: $X.XX, niches_remaining: <count>, balance_lost_to: <cause_if_known>"
     resolution: "reserved_for_serp_only, dropped_technographics, gap_accepted_for_N niches"
   ```

**Prevention:**
- DataForSEO balance is checked before EACH phase transition (per §4.5 GATE-1→2: remaining must be >= $40).
- Per-niche DataForSEO consumption is tracked in `_program/CREDIT_BUDGET.yaml` — halt threshold at $5.00/niche.
- DataForSEO balance is included in the Phase 0 recurring delta check (every 10 niches). If balance drops faster than projected, pause for review.
- Free SERP tool (OpenSERP or Serpjet) is verified working in Phase 0 as a DataForSEO fallback — so the pipeline can continue even if exhausted.
- All DataForSEO calls use the standard queue (5-minute response) — never live/priority — to minimize per-query cost.

---

## Scenario 5: Registry / Manifest Corruption

**Severity:** P2

**Detection:**
- Agent reads `SHARED/_REGISTRY.yaml` or `_pipelines/dedup-manifest.yaml` and fails YAML parsing.
- Agent reports parse errors or schema validation failures when reading registry/manifest files.
- `_program/TOOL_ERROR_LOG.yaml` shows entries with `error_code: "YAML_PARSE_ERROR"` or `error_code: "REGISTRY_CORRUPTION"`.
- Manual inspection of the file reveals truncated keys, mismatched indentation, duplicate entries, or binary characters.

**Recovery Procedure:**

1. **CHECK** for backups in `_program/_registry_backups/` directory. If the directory does not exist, proceed to Step 3 (no backups available).

2. **RESTORE** from backup if available and recent (<24 hours old):
   a. Identify the most recent backup file. Format: `_REGISTRY_<YYYY-MM-DD>.yaml` or `dedup-manifest_<YYYY-MM-DD>.yaml`.
   b. Copy the backup over the corrupted file:
      ```bash
      cp _program/_registry_backups/_REGISTRY_<YYYY-MM-DD>.yaml SHARED/_REGISTRY.yaml
      ```
   c. **Replay** any niche completions that occurred between the backup timestamp and now. For each completed niche:
      - Re-import its shared data registrations into `_REGISTRY.yaml`
      - Re-import its deduplication entries into `dedup-manifest.yaml`
      - Use the niche's `_canvas/frontmatter-N-XXX.yaml` to extract registration data
   d. **Verify** the restored files pass YAML validation:
      ```bash
      python3 -c "import yaml; yaml.safe_load(open('SHARED/_REGISTRY.yaml'))"
      python3 -c "import yaml; yaml.safe_load(open('_pipelines/dedup-manifest.yaml'))"
      ```

3. **REGENERATE** from scratch if NO backup exists:
   a. **Regenerate `SHARED/_REGISTRY.yaml`:**
      - Scan all `N-XXX/` directories for completed competitor profiles (pattern: `*/02-competitor-intel/*-competitor-profile-*.yaml`)
      - Scan all `N-XXX/` directories for completed benchmarks (`*/03-market-sizing/*-market-sizing-*.yaml`)
      - Scan all `N-XXX/` directories for completed trigger catalogs (`*/05-signal-feasibility/*-trigger-catalog-*.yaml`)
      - Scan `SHARED/` subdirectories for any manually created shared files
      - Index all found files with: niche_id, file path, data_type, fetch_date, freshness_sla, fresh_until
      - Write the index to `SHARED/_REGISTRY.yaml`
      - **Time estimate:** ~30 minutes for 25 niches. Script the scan if feasible:
        ```bash
        find niche-program/research/N-*/02-competitor-intel -name "*-competitor-profile-*.yaml" 2>/dev/null
        ```
   b. **Rebuild `dedup-manifest.yaml`:**
      - Read `_program/LEDGER.yaml` for niche completion records (status: COMPLETE)
      - For each completed niche, extract the competitor unique names from its competitor profiles
      - Build a mapping: `competitor_name → first_profiled_by_niche`
      - Write to `_pipelines/dedup-manifest.yaml`
   c. **Pre-populate** known high-value competitors manually if any niche is still in-flight:
      - SyncGTM, Gong, Clari, RevenueGrid, etc.
      - Check completed niches for competitor names and add to dedup manifest

4. **CREATE** a fresh backup immediately after recovery:
   ```bash
   mkdir -p _program/_registry_backups
   cp SHARED/_REGISTRY.yaml _program/_registry_backups/_REGISTRY_$(date +%Y-%m-%d).yaml
   cp _pipelines/dedup-manifest.yaml _program/_registry_backups/dedup-manifest_$(date +%Y-%m-%d).yaml
   ```

5. **LOG** the incident in `_program/TOOL_ERROR_LOG.yaml`:
   ```yaml
   - tool: "pipeline_agent"  # or "manual_edit" if human-caused
     error_code: "REGISTRY_CORRUPTION"
     niche_id: "ALL"
     timestamp: "<YYYY-MM-DDTHH:MM:SSZ>"
     context: "corrupted_file: <filename>, suspected_cause: <e.g., concurrent_write_conflict / manual_edit_error / truncation>"
     resolution: "restored_from_backup / regenerated_from_scratch, time_to_resolve_minutes: <X>"
   ```

**Prevention:**
- **Automatic backup trigger:** After every 10 niche completions, the pipeline creates backups of both registry files. This is automated via a post-completion hook in the pipeline orchestrator.
- **Concurrent write protection:** `SHARED/_REGISTRY.yaml` is write-locked during niche completion. Only one agent writes to the registry at a time. The pipeline orchestrator serializes registry writes.
- **YAML validation gate:** Every write to `_REGISTRY.yaml` or `dedup-manifest.yaml` is immediately validated with `yaml.safe_load()`. If validation fails, the write is rolled back and the error is logged. No agent proceeds past this gate until validation passes.
- **Manual edit warning:** If Wesley edits registry files by hand, `_program/_registry_backups/` should be snapshotted first. Hand edits should use `--edit` with YAML-aware tools, never raw text manipulation (no sed/awk on YAML files).
- **Git-aware diffs:** Registry files are committed to git. `git diff` is the first diagnostic tool for corruption — check if a modified file shows truncated or malformed content.

---

## Post-Incident Review

For any pipeline halt event (P1 or P2), complete this review within 48 hours.

### Review Template

```yaml
# Post-Incident Review — <YYYY-MM-DD>
# File: _program/_postmortems/PIR-<YYYYMMDD>-<scenario-number>.yaml

incident:
  date: "<YYYY-MM-DD>"
  scenario: "Pipeline Stuck / Credit Runaway / Firecrawl Outage / DataForSEO Exhausted / Registry Corruption"
  severity: "P1 / P2"
  duration_minutes: <total outage time>
  niches_affected: [N-XXX, N-YYY]
  credits_lost: <Firecrawl credits wasted in incident>
  balance_impact: <DataForSEO $ impact if applicable>

root_cause:
  description: "<What went wrong. Be specific. No blame — just facts.>"
  detection_gap: "<How did we miss it until it became a problem? Or: how did the detection mechanism catch it?>"

fix:
  description: "<What specific change resolved the issue?>"
  files_changed:
    - "<path to file>"
    - "<path to file>"

prevention:
  description: "<What systemic change prevents recurrence?>"
  action_items:
    - priority: "HIGH / MEDIUM / LOW"
      item: "<Actionable item — what, who, by when>"
      status: "OPEN / DONE / DEFERRED"

lessons:
  - "<One specific lesson learned. Not 'test more.' E.g., 'Firecrawl /search pagination was unbounded — agent looped through 47 pages of results.'>"
  - "<Second lesson if applicable.>"
```

### When to File

| Severity | Deadline | Minimum Contents |
|---|---|---|
| P1 | 48 hours | Root cause, detection gap, fix, prevention action items |
| P2 | 48 hours (or next session) | Root cause, fix, one prevention action item |
| P3 | Optional | Summary only |

### Review Archive

All post-incident reviews are stored in `_program/_postmortems/` with the naming convention `PIR-<YYYYMMDD>-<NN>.yaml` (NN = sequential number within that date). A summary index is maintained at `_program/_postmortems/INDEX.yaml`.

The pipeline operator (Wesley) is responsible for filing the review. If the cause spans multiple scenarios (e.g., a credit runaway triggered by a Firecrawl outage that caused retry loops), document ALL contributing factors — the root cause analysis should reflect the chain of failure, not just the first symptom.

---

## Operational Flags

### `--force` Flag (Emergency Freshness Override)

For BLOCKED-class data staleness (JOB, HIRING, INTENT data types with hard enforcement under §6.1), the `freshness-audit` script accepts a `--force` flag to override the block:

**Usage:** `./freshness-audit N-001 --force`

**Behavior:**
- Logs a `BLOCK_CLASS_OVERRIDE` waiver event to `PIPELINE_CHECKPOINTS.yaml`
- The canvas is allowed to proceed despite BLOCK-class staleness
- The override is documented in the audit trail for retrospective review

**Restrictions:**
- `--force` ONLY overrides BLOCK-class hard enforcement (Rule 1 in verdict assembly). It does NOT override claim-weighted staleness (Rule 2 — the Eye Security bug fix). A single stale source supplying >20% of claims ALWAYS blocks the canvas.
- `--force` must be logged as a waiver event. Use only for emergency cases where data freshness is less critical than pipeline progress.
- All `--force` waivers are reviewed at the next 5-niche checkpoint.

### Stale Lock Cleanup (Concurrency Lock)

Concurrency lock files (`_program/_CONCURRENCY_LOCK.yaml` entries) older than 5 minutes may be broken by any agent. Procedure:
1. Any agent encountering a lock entry with `started_at` >5 minutes ago may remove it.
2. Before breaking the lock, verify the owning agent's heartbeat in `PIPELINE_CHECKPOINTS.yaml`. If the agent is still active (heartbeat <2 minutes old), do NOT break — the lock is legitimate.
3. After breaking the lock, log a warning to `TOOL_ERROR_LOG.yaml` with `error_code: "STALE_LOCK_BROKEN"`.
4. The broken lock's owner will detect the missing lock on next checkpoint write and acquire a fresh one.

---

## Security Contact & Incident Response

**Security Contact:** Wesley (phone primary, Slack secondary) — P1/P2 severity coverage.

### Incident Response: Credential Leak

If a credential leak is detected (API key, password, token exposed in transcript, git history, or tool output):

1. **REVOKE** the affected keys immediately at the provider dashboard (Firecrawl, DataForSEO, etc.)
2. **ROTATE ALL** credentials in `~/.claude/settings.json` env block
3. **CHECK** git history for leaked values:
   ```bash
   git log -p | grep -i "API_KEY\|PASSWORD\|SECRET\|TOKEN\|LOGIN"
   ```
4. **CHECK** session transcripts:
   ```bash
   grep -rnl "fc-\|API_KEY\|PASSWORD\|SECRET\|TOKEN" ~/.claude/projects/
   ```
5. **NOTIFY** affected service providers (Firecrawl support, DataForSEO support) of the rotation
6. **UPDATE** CREDENTIALS.yaml: set `last_rotated` to current date, update or verify `expires` fields
7. **LOG** the incident in `_program/TOOL_ERROR_LOG.yaml` with `error_code: "CREDENTIAL_LEAK"` and resolution steps

### Incident Response: Security Vulnerability in Pipeline Tooling

If a third-party tool (Firecrawl, DataForSEO, Reddit Research MCP) reports a security vulnerability:

1. **ASSESS** impact: does the vulnerability affect stored data, credentials, or pipeline integrity?
2. If HIGH/CRITICAL impact: **PAUSE** all niches using the affected tool
3. **NOTIFY** Wesley immediately (phone) — do not wait for Slack
4. Switch affected data types to fallback tools per §2.3 Tool-to-Task Master Matrix
5. Document the vulnerability and mitigation in `_program/_postmortems/`

### Incident Response: Data Breach from Scraped Content

If scraped content stored in `.firecrawl/` is found to contain PII (personal emails, phone numbers, addresses):

1. **REMOVE** the affected `.firecrawl/` files immediately
2. Re-scrape the URLs with `--only-main-content` to strip sidebar/footer content
3. **DELETE** any structured data files in `research/N-XXX/` that referenced the PII-containing entries
4. Re-extract the structured data from the clean re-scrape
5. Document the incident and add the offending URL pattern to the PII filter list
6. Adjust the `--only-main-content` requirement or add an additional extraction filter

---

*End of RUNBOOK.md — This document is binding for all pipeline recovery procedures. Apply before escalating. If a scenario is not covered here, treat as P1 and contact Wesley immediately.*
