# Audit Prompt: 5 Operational Pipeline Scripts — 8-Lens Specification

**Target files:**
- `niche-program/research/_pipelines/lib/pipeline_ops.py` (486 lines) — Shared library
- `niche-program/research/_pipelines/preflight-check` (930 lines) — Script 1
- `niche-program/research/_pipelines/freshness-audit` (1,129 lines) — Script 2
- `niche-program/research/_pipelines/validate-schema` (653 lines) — Script 3
- `niche-program/research/_pipelines/clean-raw-fetches` (293 lines) — Script 4
- `niche-program/research/_pipelines/generate-quality-dashboard` (1,117 lines) — Script 5

**Reference specification:** `niche-program/research/_pipelines/IMPLEMENTATION-SPEC.md`
**Reference architecture:** `niche-program/DATA-OPERATIONS-ARCHITECTURE.md` v1.1
**Schemas validated against:** `niche-program/schemas/` (4 YAML schema files)
**Tracking files consumed:** `niche-program/research/_program/` (QUALITY_METRICS.yaml, FRESHNESS_VIOLATION_LOG.yaml, TOOL_ERROR_LOG.yaml, SLI_DEFINITIONS.yaml)

---

## WHAT THIS IS

We are auditing 5 production Python scripts (plus a shared library) that form the operational backbone of the ClarityRev 25-niche evaluation pipeline. These scripts were written from a detailed implementation specification. They have never been executed. Every bug, every missing edge case, every silent failure mode that survives this audit WILL manifest during live pipeline operation across 25 niches.

**Audit standard:** These scripts must survive a Google Production Readiness Review, a Stripe API Design Review, a Netflix Chaos Engineering GameDay, and an OWASP security audit — simultaneously.

---

## CONSTRAINTS

- Python 3.10+, ruamel.yaml for comment-preserving YAML operations (G-014: yaml.safe_dump destroys comments)
- All scripts import from `lib/pipeline_ops.py` — the shared library
- Structured output to stdout (JSON), human logs to stderr — per Google SRE pattern
- Standardized exit codes: 0=SUCCESS, 1=BLOCKED/FAIL, 2=WARNING, 3=INTERNAL_ERROR, 4=INVALID_INPUT
- `--dry-run` flag on all scripts — per Netflix Chaos Engineering pattern
- Atomic writes: `.tmp` → validate → `mv` — per Design Principle 7
- URL-normalized content-addressed cache (preflight-check) — strips tracking params, sorts query params
- The scripts run in the context of AI agents (Claude Code) orchestrating them — not human operators
- Total codebase: 4,608 lines across 6 files

---

## EXPERT LENSES

### Lens 1: Senior Production Engineer (Google SRE / PRR Pattern)

**Frameworks:** Production Readiness Review (PRR), Failure Mode and Effects Analysis (FMEA), Error Budget Design, SLI/SLO Architecture, Runbook-Driven Operations, Idempotency & Determinism, Resource Exhaustion Testing

**Standard:** Every function has a defined failure mode. Every external call (file I/O, YAML parse, subprocess) has explicit error handling — no bare `except:` blocks, no silently-swallowed exceptions. The scripts produce deterministic output for the same inputs. Resource exhaustion (disk full, memory pressure, file descriptor limits) is handled, not hoped away. The scripts can be safely killed at any point and re-run without data corruption. A new SRE on-call can understand what broke and why from the stderr logs alone.

**Specific questions to answer (answer ALL):**
1. **Walk through the "kill -9 at any line" scenario.** For each script: if the process is killed at a random point, does re-running it corrupt state? Does preflight-check's CACHE_MANIFEST.yaml survive a mid-write kill? Does freshness-audit's trace-map reading tolerate partial writes?
2. **What is the failure mode when `ruamel.yaml` is not installed?** Is the error message actionable? Does it tell the operator exactly what to run?
3. **Are there any bare `except:` or `except Exception:` blocks that swallow the actual error?** These are production anti-patterns — every caught exception must be logged with its type and message.
4. **What happens when `CREDIT_BUDGET.yaml` has 50 entries and the script reads it for the 51st time?** Is there a performance degradation curve? Are YAML files re-parsed on every call or cached?
5. **Is the structured JSON output always valid?** Walk through every `emit_result()` call path — can an unhandled exception produce partial/malformed JSON to stdout before the script exits?
6. **What is the memory footprint of loading a trace-map with 500 claims across 100 sources?** Does freshness-audit stream or load entirely into memory?
7. **Are file handles properly closed?** Check every `open()` call — are context managers used consistently? Are there paths where a file handle leaks (e.g., exception between open and close)?

---

### Lens 2: Principal API & Integration Engineer (Stripe API Design Pattern)

**Frameworks:** Contract-First API Design, Input Validation Completeness, Output Schema Consistency, Error Schema Standardization, Semantic Versioning for Script Interfaces, Backward Compatibility Analysis, Cross-Script Contract Coherence

**Standard:** Every script has a documented contract (input schema, output schema, exit codes, error format). The contract is the source of truth. Input validation rejects invalid data before processing begins — no "garbage in, garbage out." Output schemas are consistent across all 5 scripts — the same field name means the same thing everywhere. Error objects contain enough context for a calling agent to decide what to do next without parsing human-readable text.

**Specific questions to answer (answer ALL):**
1. **Are all CLI arguments validated before use?** For each script: check that NICHE_ID is validated against the `^N-\d{3}$|^CAL-[AB]$` pattern. Check that DATA_TYPE is validated against the controlled vocabulary. Check that file paths are resolved and existence verified.
2. **Is the JSON output schema consistent across scripts?** Compare the output of all 5 scripts — do they all include `script`, `timestamp`, `exit_code`, `exit_code_name`? Are `verdict` values consistent (e.g., does "PASS" mean the same thing in freshness-audit as in validate-schema)?
3. **Are error objects machine-actionable?** If preflight-check returns `BLOCKED_CREDITS`, does the JSON output contain enough information for the calling agent to determine: (a) what threshold was violated, (b) what the current value is, (c) what action to take?
4. **Is there input injection risk?** Can a maliciously crafted NICHE_ID (e.g., `N-001; rm -rf /`) cause path traversal, command injection, or YAML deserialization attacks? ruamel.yaml's `yaml.load()` is safe (no arbitrary code execution), but are file paths constructed safely?
5. **What happens when two scripts are called with the same NICHE_ID simultaneously?** Is there a race condition on CACHE_MANIFEST.yaml, CREDIT_BUDGET.yaml, or trace-map.yaml? Does the atomic write pattern actually prevent corruption under concurrency?
6. **Cross-script coherence:** Does the output of preflight-check contain the fields that freshness-audit expects to consume? Does validate-schema's output format match what a calling agent would check? Are there implicit dependencies between scripts that aren't documented?

---

### Lens 3: Distinguished Chaos Engineer (Netflix Resilience Pattern)

**Frameworks:** Chaos Engineering GameDay Design, Cascade Failure Modeling, Dependency Poisoning, Silent Corruption Detection, "Assume Everything Breaks" Analysis, Antifragility Assessment, Fault Injection Test Design

**Standard:** Every assumption about external state is attacked at its breaking point. The most damaging scenario is presented first. The scripts have been "played" against a GameDay where everything that CAN go wrong DOES go wrong simultaneously. The scripts' behavior under chaos is understood, not hoped for.

**Specific questions to answer (answer ALL):**
1. **What is the "everything corrupt at once" scenario?** CACHE_MANIFEST.yaml is valid YAML but points to files that don't exist. CREDIT_BUDGET.yaml has negative credit values. DEAD_HOST_REGISTRY.yaml lists `firecrawl.dev` as dead. FRESHNESS_VIOLATION_LOG.yaml is empty but valid. TOOL_ERROR_LOG.yaml has 500 entries. QUALITY_METRICS.yaml has inconsistent totals. SLI_DEFINITIONS.yaml is missing. Walk through each script in this state. Which crash? Which produce garbage output? Which continue silently with wrong results?
2. **What is the "YAML bomb" scenario?** An agent accidentally writes a 50MB trace-map.yaml or a CREDIT_BUDGET.yaml with 10,000 nested entries. Do the scripts have any size limit or depth limit on YAML parsing? Does ruamel.yaml have recursive depth protection?
3. **What is the "slow filesystem" scenario?** The scripts run on a network filesystem where `Path.exists()` takes 2 seconds. Does this break any atomicity guarantees? Does the `.tmp` → `mv` rename work correctly on NFS (where rename is NOT atomic across filesystems)?
4. **What is the "URL that breaks normalization"?** Feed `normalize_url()` a URL with: 10,000 query parameters, Unicode homograph attack domain (IDN), null bytes, newlines embedded in query params, a 64KB URL. Does the function crash, hang, or produce an incorrect normalized form?
5. **What is the "credit exhaustion attack via the scripts themselves"?** Can a buggy agent calling preflight-check in a loop with a URL that never caches (e.g., timestamped URLs) exhaust Firecrawl credits? Is there any rate-limiting or circuit-breaking on the scripts themselves?
6. **What would the most skeptical infrastructure engineer say after reading these scripts?** "These are well-structured Python scripts. But they've never been run. The YAML parsing works in unit tests but will it work on real pipeline data with comments and multi-line strings? The atomic write pattern is correct on paper but has it been tested with actual `kill -9` during the write? The URL normalization strips tracking params but what about the 50 other tracking param names used by marketing automation platforms that aren't in the strip list?"

---

### Lens 4: Lead Security Engineer (OWASP + DevSecOps Pattern)

**Frameworks:** OWASP Top 10 for Python Applications, Path Traversal Analysis, YAML Deserialization Security, Credential Handling Audit, Input Sanitization Completeness, Principle of Least Privilege, Secure File Operations

**Standard:** No path traversal. No command injection. No unsafe deserialization. File operations are constrained to the pipeline directory tree. Environment variables are read but never logged or output. Error messages do not leak filesystem paths or internal state to stdout. The scripts can be run by an unprivileged user.

**Specific questions to answer (answer ALL):**
1. **Path traversal attack:** Can a NICHE_ID of `../../../etc/passwd` or `N-001/../../../.ssh/id_rsa` escape the `niche-program/research/` directory? Check every `Path()` construction that incorporates user input.
2. **YAML deserialization:** `ruamel.yaml.YAML.load()` is safe (no `!!python/object` support by default). Verify this is the case — ruamel.yaml in safe mode does not execute arbitrary code. Is `yaml.load()` used consistently (never the unsafe `yaml.load(data, Loader=...)`)?
3. **Information leakage:** Do any error messages or log lines contain: API keys, file paths outside the project directory, environment variable values, or credential names? Check every `emit_log()` and `emit_result()` call.
4. **File permission TOCTOU:** Between `Path.exists()` check and `open()`, the file could be replaced with a symlink. This is unlikely in a single-user pipeline but document the risk. Does the atomic write pattern use `os.replace()` or `Path.rename()` — both of which follow symlinks on some platforms?
5. **Environment variable handling:** Are `DATAFORSEO_LOGIN`, `DATAFORSEO_PASSWORD`, `FIRECRAWL_API_KEY` ever printed to logs, included in JSON output, or written to disk? These MUST only be referenced by name, never by value.
6. **Regex DoS (ReDoS):** Are there any regex patterns vulnerable to catastrophic backtracking? Check: `re.match(r'^(.+?)\[(\d+)\]$'` in validate-schema, `re.split(r'\.(?![^\[]*\])'` in resolve_path — could a maliciously long field name cause exponential runtime?

---

### Lens 5: Data Quality & Correctness Engineer (MIT/Stanford Formal Methods Pattern)

**Frameworks:** Invariant Detection, Property-Based Testing Design, Boundary Value Analysis, Equivalence Class Partitioning, Determinism Verification, Round-Trip Property Checking, Differential Testing

**Standard:** Every function with a mathematical property is identified and that property is verified. Round-trip properties hold: `normalize_url(normalize_url(url)) == normalize_url(url)`. The freshness audit produces the same result when run twice on the same data. The evidence grade truth table (Appendix C) produces the same grade for the same inputs. Boundary values (0, -1, max int, empty string, empty list, None) are handled explicitly.

**Specific questions to answer (answer ALL):**
1. **Is `normalize_url()` idempotent?** Prove: `normalize_url(normalize_url("https://example.com?utm_source=foo"))` == `normalize_url("https://example.com?utm_source=foo")`. What about URLs with double-encoded params? URLs with fragments? URLs with auth credentials?
2. **Is `days_between()` correct at DST boundaries?** The function uses `.date()` which strips timezone. Does this produce correct results when comparing dates across DST transitions? What about comparing a UTC date with a non-UTC date?
3. **Is the cache-hit decision deterministic?** If preflight-check is run twice with the same NICHE_ID, DATA_TYPE, and --target-url, does it produce the same verdict both times? What if CACHE_MANIFEST.yaml is modified between runs by another process?
4. **Does the freshness-audit claim-weighted ratio correctly identify blocking sources?** If 3 different stale sources each supply 15% of claims (all below 20%), the source-count ratio might be 15% (above 10% → BLOCKED) while no single source exceeds 20%. Are BOTH gates checked correctly?
5. **Does the validate-schema custom rule for `total_reviews` use integer or float comparison?** If `total_reviews` is 25 and the sum is 25.0 (float), does the comparison work correctly?
6. **Are there off-by-one errors in date comparisons?** Check: `fresh_until` = fetch_date + 90 days. If fetch_date is 2026-04-24, fresh_until should be 2026-07-23. Is data considered stale ON fresh_until or the day AFTER fresh_until? This is the difference between `<=` and `<` in date comparisons — and it matters for a 7-day JOB SLA.

---

### Lens 6: Observability & Monitoring Engineer (Honeycomb/Datadog Pattern)

**Frameworks:** Structured Logging Design, Cardinality Explosion Prevention, Trace Context Propagation, Alert Threshold Calibration, Dashboard Design for Autonomous Systems, Log-Level Discipline, Signal-to-Noise Ratio Optimization

**Standard:** Every log line adds information, not noise. Log levels are disciplined: DEBUG for trace-level detail, INFO for state transitions, WARNING for recoverable issues, ERROR for failures requiring attention. The calling agent (Claude Code) can parse the structured JSON output to decide next actions without reading stderr. Stderr logs are for human operators. The signal-to-noise ratio is high — no "Processing..." log lines that add zero information.

**Specific questions to answer (answer ALL):**
1. **Are log levels used consistently?** Scan every `emit_log()` call — are there INFO-level logs that should be DEBUG? Are there ERROR-level logs that should be WARNING? Are there WARNING-level logs for operations that are actually normal (e.g., "CACHE_MISS — no cache entry for URL" is normal, not a warning)?
2. **Is the structured JSON output complete enough for autonomous operation?** If a Claude Code agent calls preflight-check and gets `BLOCKED_DEAD_HOST`, does the JSON contain: which host, when it was blocked, when it expires, and what the agent should do next? Or does the agent have to grep stderr?
3. **What is the cardinality of log output?** For a niche with 100 sources, freshness-audit could emit 100+ log lines. Is each line distinct and useful, or are there repeated patterns that could be aggregated?
4. **Are timestamps consistent?** Check: do all scripts use UTC? Are timestamps ISO 8601? Do any scripts use local timezone (which would break correlation across distributed agents)?
5. **Is there a correlation ID?** If 4 niches are running concurrently and all call preflight-check, can the operator trace which log lines belong to which niche? Is NICHE_ID included in every log line?

---

### Lens 7: Code Quality & Maintainability Reviewer (Google Code Review Pattern)

**Frameworks:** Google Python Style Guide, Single Responsibility Principle, DRY (Don't Repeat Yourself) Violation Detection, Cyclomatic Complexity Analysis, Testability by Dependency Injection, Documentation Completeness for On-Call Engineers

**Standard:** A new engineer can understand each script's purpose and logic within 15 minutes of reading it. Functions do one thing. Magic numbers are named constants. Type hints are present where they add clarity. The shared library (`pipeline_ops.py`) is genuinely shared — no copy-pasted code between scripts. Comments explain WHY, not WHAT (the code already says WHAT).

**Specific questions to answer (answer ALL):**
1. **Is there code duplication between scripts?** Do preflight-check and freshness-audit both implement their own YAML loading with the same error handling pattern? Does validate-schema reimplement path resolution that pipeline_ops already provides?
2. **Are there functions longer than 50 lines?** Functions exceeding 50 lines should be identified and flagged for decomposition. (This is not a hard rule — justify any that genuinely need the length.)
3. **Are magic numbers extracted as named constants?** "2000" (credit threshold), "30" (days), "0.20" (claim-weighted threshold), "0.10" (staleness threshold), "60" (seconds). Are these defined once in pipeline_ops.py and referenced by name?
4. **Is the shared library actually shared?** Check every import from pipeline_ops in each script — are there imports that are never used? Are there functions in pipeline_ops that no script imports (dead code)?
5. **Are `--help` texts accurate and complete?** Run `./preflight-check --help` (mentally) — does it show usage, arguments, options, exit codes, and examples?
6. **Is the IMPLEMENTATION-SPEC.md accurately reflected in the code?** Compare key algorithms (cache check, claim-weighted staleness, BLOCK enforcement) between the spec and the implementation. Are there deviations? If so, are they justified improvements or spec violations?

---

### Lens 8: AI Agent Usability Reviewer (Claude Code Integration Pattern)

**Frameworks:** Autonomous Agent Interface Design, Machine-Parseable Output Design, Decision-Tree Clarity for LLM Consumers, Prompt-Engineering for Tool Output, Error Recovery Guidance, Token Efficiency for Agent Context Windows, Idempotency for Agent Retry Loops

**Standard:** These scripts are called by Claude Code agents, not humans. The JSON output must be directly consumable by an LLM — it must contain enough context for the agent to decide the next action without re-reading the specification. Error messages must suggest corrective actions. The output must be token-efficient — no verbose fields that waste context window. The scripts must be safe for agents to call in retry loops.

**Specific questions to answer (answer ALL):**
1. **Can a Claude Code agent decide the next action from the JSON output alone?** If preflight-check returns `BLOCKED_CREDITS`, does the JSON contain a field like `"suggested_action": "Replenish Firecrawl credits or reduce niche depth to STANDARD"` — or does the agent need to look up the meaning of exit code 1 in documentation?
2. **Are the JSON outputs token-efficient?** Count the typical JSON output size for each script. A 2KB JSON response for a simple preflight check wastes ~500 tokens in the agent's context window. Can fields be abbreviated or omitted when they're at default values?
3. **Is there an `--agent-mode` or machine-optimized output flag?** The scripts currently mix human-readable stderr with machine-parseable stdout. Should there be a `--quiet` flag that suppresses stderr entirely for agent callers?
4. **What happens when an agent calls the script in a retry loop?** If preflight-check returns `BLOCKED_DEAD_HOST` and the agent retries 10 times, does it consume credits? Produce duplicate log entries? Corrupt the cache manifest? The scripts must be safe under agent retry storms.
5. **Are there fields in the JSON output that an agent could misinterpret?** LLMs are pattern-matchers — a field named `"status": "ok"` might be interpreted as "everything is fine" even when `exit_code: 2` (WARNING). Are there ambiguous field names?
6. **Does the output include a `suggested_next_step` or `resolution_hint` field?** Google SRE runbooks include "what to do next." These scripts are the runbook's automated interface. The calling agent needs actionable guidance.

---

## OUTPUT FORMAT

For each lens, produce:

1. **FINDINGS** — Ordered by severity (BLOCKING > CRITICAL > HIGH > MEDIUM > LOW). Each finding must reference:
   - Exact file and line number(s)
   - The specific code or pattern that is problematic
   - The failure scenario (concrete inputs/state → wrong output/crash)
   - The corrected code (where applicable)

2. **ADVERSARIAL VERDICT** — Would this lens sign off on these scripts entering production use by 25 autonomous agents? If NO, what is the MINIMUM fix set required? Be specific — "fix the error handling" is not specific; "add `try/except ValueError` around line 147 of preflight-check with an `emit_result(INTERNAL_ERROR, ...)` call" is specific.

---

## SYNTHESIS SPECIFICATION

After all 8 lenses produce findings, a synthesis agent will:

1. **De-duplicate** findings across lenses (2+ lenses flagging the same issue = CONVERGENT, highest confidence)
2. **Resolve contradictions** (Lens A says ADD X, Lens B says REMOVE X — synthesis chooses with rationale)
3. **Rank ALL concrete fixes** by impact on: (a) production safety, (b) agent usability, (c) data integrity
4. **Produce a P0 minimum fix set** — the changes required before these scripts can be called by a single niche agent
5. **Produce a P1 fix set** — changes required before 4 concurrent niches run
6. **Assign each fix to a specific file and line range**
7. **Provide corrected code** for all BLOCKING and CRITICAL findings

A fix is only "concrete" if an engineer can implement it without asking clarifying questions.
