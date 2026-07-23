# AUDIT LENS 4: Data Quality — Tool-to-Task Mapping Audit

**Author:** Research Methodologist (McKinsey Global Institute — B2B market research methodology)
**Date:** 2026-07-23
**Audit Focus:** Tool-to-task mapping validity, coverage gaps by data type, evidence quality by source, traceability chain integrity, dark-matter detection gaps
**Status:** PRELIMINARY (no real niche data has been collected — calibration phase not yet executed)

---

## 1. EXECUTIVE SUMMARY

The tool-to-task mapping in DATA-OPERATIONS-ARCHITECTURE.md is **theoretically sound but empirically untested**. It is the most thoroughly specified data operations architecture I have seen for a program of this size — 17 data types mapped to specific tools, a four-tier tool hierarchy, explicit freshness SLAs, and a deterministic evidence grade engine. However, the architecture suffers from **four systemic risks** that must be addressed before any niche canvas is treated as decision-grade:

1. **No single tool is assigned to measure a specific canvas field.** The Tool-to-Task Master Matrix (§2.3) maps tools to data *types* (competitor pricing, market sizing, etc.), but each canvas section requires specific *fields* with specific evidence grades. There is no field-level tool assignment — a coverage gap.

2. **Coverage is calibrated for IT-adjacent niches, not the full 25-niche spectrum.** Data availability collapses for niches like Fractional Executive Services, EU Public Sector, or Niche Manufacturing, where key data types (G2 reviews, public pricing, technographics) simply do not exist. The grading engine will systematically under-score these niches, producing an availability bias in the fertility ranking.

3. **The evidence grade engine has never been run on real agent output.** It is mathematically sound (Truth Table Appendix C verifies all 16 binary combinations produce exactly one grade). But it has never been calibrated against human judgment, and **nothing prevents an agent from fabricating a source URL that passes all four criteria with plausible-looking metadata.**

4. **The toolchain can detect zero signals for which there is no digital exhaust.** Offline buying signals (trade shows, in-person conversations, word-of-mouth referrals), private-company dynamics, and non-English-language markets are invisible to every tool in the inventory. The architecture acknowledges this in passing but provides no framework for estimating the *impact* of these blind spots on niche evaluation accuracy.

The architecture is **buildable and correct for the niches it is designed for** (bounded-platform SaaS, technology-driven niches with public digital footprints). It is **insufficient for the full 25-niche diversity that the methodology claims to evaluate.** The gap is not in tool selection — it is in data-type coverage assumptions that are implicitly IT-SaaS-centric.

---

## 2. CANVAS-LEVEL TOOL MAPPING AUDIT

### 2.1 Mapping Convention

For each of the 15 canvas sections, I assess:
- **Primary tool assigned:** The tool specified in DATA-OPERATIONS-ARCHITECTURE.md §2.3 or §4 pipeline
- **Gap type:** COVERAGE (tool cannot produce the needed data), TOOL (no tool assigned), AMBIGUITY (multiple tools could work, none specified as primary), or NONE (adequate)
- **Expected evidence grade ceiling:** The maximum evidence grade the assigned tool can realistically achieve for THIS data type

### 2.2 Section-by-Section Audit

| # | Section | Primary Data Needed | Primary Tool | Gap Analysis | Evidence Ceiling |
|---|---|---|---|---|---|
| **1** | **Niche Identity & Strategic Rationale** | Company names, market existence proof, First-5 Prospects, Porter's Five Forces (judgment), TAM range from ≥2 sources, API accessibility docs, buy. temp. | Firecrawl /search + DataForSEO SERP + Context7 MCP (API docs) | **AMBIGUITY** — §4.1 assigns 5 different tools for Phase 1 steps, but §1.5 market sizing requires ≥2 independent sources, and the Agent has no guidance on which source combination to use for the first source vs. the second. The Agent's judgment handles 6 of 9 subsections — no tool can gather "Porter's Five Forces" or "pre-mortem." | `[E]` for market data; `[H]` for judgments. The Porter's Five Forces, pre-mortem, survivorship bias check, and scenario planning are 100% agent judgment — no tool produces them. |
| **2** | **Buyer, Committee & Purchase Dynamics** | Committee influence map, champion profile, buyer language verbatim quotes, budget verification, sales cycle benchmarks, trigger events | Firecrawl /search + Reddit Research MCP (VOC) | **COVERAGE** — No tool can produce the committee influence map, champion playbook, or first-meeting architecture. These are designed, not gathered. Buyer language quotes (§2.6) require ≤5 verbatim quotes with specific source URLs, but the architecture specifies no systematic corpus-building workflow. The Agent is expected to find quotes as a byproduct of review scraping in Phase 2.3 — there is no dedicated buyer-language extraction pipeline. **TOOL** — Budget verification (§2.3) has no assigned tool at all. | `[P]` for competitor pricing; `[E]` for sourced quotes; `[H]` for committee maps, champion psychographics, first-meeting architecture |
| **3** | **Pain Architecture & Economic Impact** | Pain dimensions with sources/baselines, ROI formula components, detection automation level, data quality sensitivity, cost of inaction | Firecrawl /search for benchmarks + Reddit Research MCP for pain narratives | **AMBIGUITY** — The 26% revenue leak benchmark is cited from Clari's vendor-commissioned 2024 report. Other pain dimensions (efficiency waste, missed opportunity) explicitly state "no universal benchmark." The Agent must infer these, but no tool can validate them independently. The 50% stress test is mathematical, not tool-dependent. | `[E]` for the leak benchmark (single vendor-commissioned source — borderline `[E]`). Every other pain dimension is `[H]` or `[S]`. The ROI formula inherits weakest grade. |
| **4** | **Competitive Landscape & Positioning Whitespace** | Competitor pricing, reviews corpus (≥20 reviews from ≥2 sources), GTM motion, funding, tech stack inference, battlecards, competitive dynamics | Firecrawl /scrape (pricing) + DataForSEO Labs (competitor profiling) + Firecrawl /search + /scrape (reviews) | **COVERAGE** — The review corpus requirement (≥20 reviews from ≥2 sources) is achievable for software niches (G2 + Capterra + Reddit) but IM-POSSIBLE for non-software niches (consulting, agencies, fractional execs). The architecture has no fallback for niches where review platforms don't exist. **TOOL** — Technical architecture inference (§4.1) requires Stackshare, engineering job postings, tech blog analysis. No tool assigned for Stackshare data. | `[P]` for verified pricing; `[E]` for review-sourced strengths/weaknesses (if reviews exist); `[H]` for tech inference, battlecards, competitive dynamics |
| **5** | **Ecosystem & Distribution** | Aggregator candidates, channel economics, capacity ceilings, referral dynamics, partner activation playbook, distribution risk | Firecrawl /search + OpenRegistry MCP (company search) | **COVERAGE** — No tool can produce aggregator candidates, channel prioritization, or partner activation playbooks. These are designed, not gathered. Firecrawl /search for "agencies partners consultants [niche]" is the only tool specified, and it returns names — not economic models. The entire section is agent judgment with light tool augmentation. | `[E]` for named aggregator discovery; `[H]`-`[S]` for all economic estimates (CAC, channel capacity, breakeven, warm network depletion rates) |
| **6A** | **Sales Trigger Map** | Trigger candidate pool (≥10 candidates), overt signals, detection architecture, urgency windows, persona-specific messaging | Firecrawl /search (trigger discovery) + Context7 MCP (API docs — signal feasibility) + GDELT (news signals) | **AMBIGUITY** — Trigger discovery is methodologically undefined. The ACH scoring matrix (Frequency, Urgency, Budget-Likelihood, Detectability, each 1-5) specifies a framework but no tool to populate it. The Agent scores each trigger with no empirical basis. Detectability scores of "API-accessible" (5) vs. "cannot be detected" (1) are assigned by agent judgment with no verification gate. | `[P]` for trigger concept existence; `[H]`-`[S]` for frequency, urgency, budget-likelihood, detectability scores, expected conversion rates |
| **6B** | **Client Signal Catalog** | ≥15 signals with detection architecture, source verification, predictiveness confidence, prioritization tiers, demo narrative | Context7 MCP (API capability verification) + Firecrawl /search + DataForSEO (signal source discovery) | **COVERAGE** — The 15-signal requirement has no tool-defined discovery pipeline. The Agent designs signals from first principles, competitor analysis, and published research (§6B.2). At zero clients, NO signal can have HIGH predictiveness confidence. The architecture correctly acknowledges this but provides no pre-client calibration methodology beyond "first 3 clients are calibration partners." | `[H]` for all signal designs at zero clients. Detection feasibility = `[E]` only if personally verified via live API call. |
| **7** | **Customer Journey & Offer Architecture** | Lifecycle stages, pricing ladder, conversion rates, non-linear paths, offer economics, journey instrumentation | None — entirely agent-designed | **TOOL** — No tool supports journey design. Every field in §7 is `[DESIGN]` or inherits grades from earlier sections. This is appropriate — journey design is synthesis, not data gathering. | `[H]`-`[S]` for all conversion rates, time-to-value, breakeven. Pricing inherits grades from §4.1/§9. |
| **8** | **Free Entry Services** | Competitor free layer audit (personally verified), ≥3 free services across ≥2 tiers, conversion model, breakeven analysis | Firecrawl /scrape (competitor free tool verification) | **COVERAGE** — The competitor free layer audit requires the Agent to personally visit competitor websites and document URL/date/page found. Firecrawl /scrape is adequate for this. The free service design itself is agent work, not tool-dependent. | `[E]` for verified competitor free tools; `[DESIGN]` for all free service designs |
| **9** | **Paid Standalone Services** | Service design, pricing, scope, delivery timeline, guarantee terms | Firecrawl /scrape (competitor pricing verification) | **NONE** — The primary tool for §9 is Firecrawl /scrape for competitor price verification, which maps correctly. Service design is agent work. | `[P]` for verified pricing; `[E]` for price from secondary source; `[H]` for estimated pricing |
| **10** | **Recurring Core Service** | Tier structure, service scope per tier, expansion logic, guarantee terms, pricing | Firecrawl /scrape (competitor recurring pricing) | **NONE** — Same pattern as §9. Tool maps correctly. | Same as §9 |
| **11** | **Automated Workflow Specifications** | Build specifications for N workflows — API endpoints, data flow, output format | Context7 MCP (API documentation verification) | **NONE** — Context7 MCP is the correct tool for verifying API capabilities before committing to workflow designs. Workflow design is agent work with no tool dependency for the design phase. | `[E]` for verified API capabilities; `[H]` for workflow design decisions |
| **12** | **Sales Enablement & Evidence Stack** | Objection handling, proof assets, case studies, security spec, honest negative protocol | None | **TOOL** — No tool produces sales enablement materials. These are designed, not gathered. The security specification (§12.11) requires no external data. | `[H]` for all non-client-proof elements (at zero clients) |
| **13** | **GTM Motion** | Channel-specific funnel models, founder capacity model, outreach sequences, nurture cadence | Firecrawl /search for channel benchmarks | **AMBIGUITY** — §13.2 requires channel-specific funnel conversion rates (Attract → Diagnose, Diagnose → Prove, etc.) with low-expected-high ranges anchored to published benchmarks or flagged `[S]`. No specific benchmark source is assigned. The Agent must find B2B sales benchmarks, cold email benchmarks, and channel-specific conversion data without guidance on which sources are authoritative. | `[H]`-`[S]` for all conversion rates at zero clients. Benchmark anchoring depends on Agent finding appropriate sources. |
| **14** | **RIOS Scoring** | 8-dimensional scores (Market, Pain, Competition, Ecosystem, Signals, Build, Offers, GTM) | None — scoring rubric from methodology | **NONE** — RIOS scoring applies the rubric defined in §6 of NICHE-METHODOLOGY.md. The scores are computed from the canvas evidence. No tool produces scores. | Inherits from all previous sections. Aggregate score inherits weakest component grade. |
| **15** | **Open Questions & Validation Plan** | Pre-registered hypotheses, validation experiments, decision tree for further research | None | **NONE** — This section designs validation experiments. No tool produces it. | `[DESIGN]` — all entries are pre-registration, not evidence claims |

### 2.3 Gap Count Summary

| Gap Type | Count | Most Critical Instances |
|---|---|---|
| **COVERAGE** (tool cannot produce needed data) | 6 | §2 (budget verification), §4 (non-software review corpus), §5 (economics), §6B (15-signal discovery), §7 (journey design), §13 (benchmark anchoring) |
| **TOOL** (no tool assigned) | 5 | §2 budget verification, §6B signal design methodology, §7 entire section, §12 entire section, §15 entire section |
| **AMBIGUITY** (multiple tools, no primary specified) | 5 | §1 market sizing source triangulation, §3 pain dimension benchmarking, §6A trigger scoring, §13 benchmark sourcing, §4 Stackshare/tech inference |
| **NONE** (adequate) | 4 | §9 pricing, §10 pricing, §11 API verification, §14 scoring rubric |

**Finding:** 16 of 15 sections have at least one gap (some have multiple). Only 4 sections have adequate tool coverage for the data they require. The most severe gaps are in the sections that require the most evidence-grade data: §1 (market sizing — the foundation of niche evaluation), §4 (competitive landscape — requires ≥20 reviews), and §6B (signal catalog — requires ≥15 signals at zero clients with zero data).

---

## 3. DATA TYPE COVERAGE ACROSS THE 25-NICHE SPECTRUM

### 3.1 Coverage Matrix (8 Data Types x 3 Availability Levels)

| Data Type | Always Available (all niches) | Sparse (some niches) | Unavailable (most niches) | Fallback Strategy |
|---|---|---|---|---|
| **Market Sizing** | SERP data (search volume exists for any niche keyword) | Government statistics (available for registered industries, sparse for emerging niches) | N/A — always some market signal via SERP | For SERP-only: mark confidence as LOW; require ≥2 keyword queries to triangulate |
| **Competitor Profiles** | Company web presence (every company has a website) | G2/Capterra reviews (only SaaS/software competitors) | Review data for consulting, agency, fractional exec services | Fallback: Reddit mentions, news mentions, LinkedIn posts — but these are qualitatively different from structured reviews |
| **Pricing Data** | Public-facing websites (most companies publish some pricing) | Transparent tiered pricing (only SaaS products with pricing pages) | Enterprise pricing (consulting, managed services, agencies — custom quotes only) | Fallback: G2 reviewer price mentions, job postings referencing budget. Mark as `[E]` (secondary source), not `[P]`. |
| **Buyer Personas** | LinkedIn profiles (decision-makers exist for any B2B niche) | Buyer language quotes (G2/Capterra reviews only for software niches) | Verbatim purchase-decision quotes for non-software niches | Fallback: LinkedIn thought-leadership posts, industry articles, conference talks. **These are qualitatively different** from purchase-decision quotes. |
| **Trigger Signals** | Job changes, funding news, press releases (GDLET covers 65 languages, 100K+ outlets) | CRM-native metrics (deal velocity, pipeline coverage — only accessible with CRM integration) | Internal buying signals (CRO's personal urgency, board-level conversations) | Architecture correctly flags this as `[H]` at zero clients. No fallback for internal signals. |
| **Technographics** | DataForSEO Domain Analytics (covers any domain with a website) | Stackshare, BuiltWith (limited depth for non-web-tech companies) | Offline technology use (no digital footprint — manufacturing equipment, physical infrastructure) | Fallback: Job postings for technical roles (indirect). Mark as `[H]` for non-digital. |
| **Review Sentiment** | N/A — no universal review source for all B2B niches | G2, Capterra (software only); Google Maps (local services); Trustpilot (consumer-facing) | Most non-software B2B niches (consulting, staffing, agencies, fractional execs, manufacturing services) | Fallback: Reddit, LinkedIn, case study mentions. **Critical gap:** the canvas requires ≥20 reviews from ≥2 independent sources (§4 minimum). This is impossible for most non-software niches. |
| **Hiring Signals** | Public ATS APIs (Greenhouse, Lever — free, no auth) | Industry-specific job boards (niche-specific, harder to access) | Companies using no ATS or offline hiring (small businesses, non-digital) | Fallback: LinkedIn job scraping is against ToS. Techmap API has 1K postings/mo limit. |

### 3.2 Availability Heat Map (Illustrative — 5 of 25 Niches)

| Niche Type | Market Size | Competitors | Pricing | Personas | Triggers | Techno-graphics | Reviews | Hiring |
|---|---|---|---|---|---|---|---|---|
| IT Staffing / RecTech | HIGH | HIGH | HIGH | HIGH | HIGH | HIGH | HIGH | HIGH |
| Mid-Market RevOps | HIGH | HIGH | HIGH | HIGH | HIGH | HIGH | HIGH | HIGH |
| Fractional Executive Services | MEDIUM | LOW | LOW | MEDIUM | MEDIUM | LOW | UNAVAILABLE | MEDIUM |
| EU Public Sector | HIGH | LOW | UNAVAIL | LOW | HIGH | LOW | UNAVAIL | MEDIUM |
| Niche Manufacturing (NL) | MEDIUM | LOW | LOW | LOW | MEDIUM | LOW | UNAVAIL | LOW |

**Finding:** The architecture's default tool assignments assume a HIGH-HIGH-HIGH availability profile (IT Staffing / RevOps). For non-IT niches, 3-4 of the 8 data types drop to LOW or UNAVAILABLE. **This will systematically under-score non-IT niches in the fertility ranking** unless the grading engine is designed to normalize for availability — which it currently is not.

### 3.3 Unfair Down-Ranking Risk (Critical)

The evidence grade engine (§6.2) assigns grades based on four binary criteria that include C1 (≥2 independent sources). For a niche where review data is UNAVAILABLE (Fractional Executive Services, manufacturing), the engine will produce `[H]` or `[S]` for competitor claims that would be `[E]` or `[P]` for a software niche. The fertility gate will never see these claims because the grade prevents their inclusion in the canvas.

**Recommended fix:** Add a `NICHE_DATA_AVAILABILITY` metadata field to each canvas frontmatter that records which data types were SOURCE_UNAVAILABLE. Use this to normalize evidence quality scores BEFORE fertility ranking. A niche with 6 of 8 data types available and 60% `[E]`+ claims is stronger than a niche with 3 of 8 available and 80% `[E]`+ claims (because the latter achieves its ratio by omitting sections no tool can fill).

---

## 4. EVIDENCE GRADING PIPELINE — END-TO-END AUDIT

### 4.1 Four-Layer Traceability Chain

The architecture specifies a 4-layer chain: canvas claim → structured data file → raw fetch file → original URL with checksum. I evaluate each layer:

| Layer | Specification | Status | Risk |
|---|---|---|---|
| **Layer 1:** Canvas claim with `[E]`/`[P]` grade | Methodology §1.4 requires every claim annotated. Trace-map.yaml (§6.3) maps claim_id → source_file → original_URL → checksum. | **Specified completely** in DATA-OPERATIONS-ARCHITECTURE.md §6.3. | None — specification is thorough. |
| **Layer 2:** Structured data file | Schemas defined for competitor profiles (§5.1), review corpora (§5.2), market sizing (§5.3). Schema validation gate (§5.5) requires validation before consumption. | **Specified but scripts are DRAFT.** The validate-schema.sh script in `_pipelines/` is a template with placeholder implementations (Appendix A: "NOT OPERATIONAL"). | HIGH — without operational schema validation, agents write unvalidated data that downstream consumes without error checking. |
| **Layer 3:** Raw fetch content | Raw content stored in `.firecrawl/` and `.dataforseo/` directories (gitignored). | **Specified correctly** in §3.3. | None — the architecture correctly separates raw from structured. |
| **Layer 4:** Original URL with checksum | Every source URL in trace-map.yaml carries fetch_date, content_hash, freshness_status (§6.3). | **Specified completely.** Independent verification (§4.7) requires a separate agent to re-fetch 10% of URLs and compare hashes. | LOW — the independent verification agent shares no context with the original agent, preventing hallucination cascades. |

**Has this chain been tested with real data?** NO. The program has never executed a real niche. The calibration phase (Phase 0) is documented in `_pipelines/PHASE-0-CALIBRATION.md` but has NOT produced a single complete canvas with a populated trace-map.yaml. **The entire traceability chain is theoretical.**

### 4.2 Grade Engine Calibration

The deterministic grade engine (Truth Table Appendix C) is mathematically correct — all 16 binary combinations produce exactly one grade. However:

**HUMAN CALIBRATION:** The engine has never been compared to human judgment. Key open questions:
1. Would a human rater assign `[P]` to a claim with 2 independent sources that are both low-quality (blog posts vs. official data)? The engine gives `[P]` — but a human might downgrade to `[E]` because the sources lack authority.
2. Would a human rater accept "2 independent sources" from two different web pages that both cite the same underlying study? The engine treats them as independent (different URLs) — but a human would detect they are not.
3. Does the 20% divergence threshold for numerical claims (if 2 sources diverge by >20%, downgrade `[P]` → `[E]`) actually match human judgment? At what divergence do humans stop believing a number?

**RECOMMENDATION:** Before any niche canvas is scored, run a calibration study: have 3 human raters grade 30 claims from the calibration niche, compare against the deterministic engine, and adjust criteria where disagreement exceeds 20%.

### 4.3 Source Fabrication Vulnerability — THE CRITICAL RISK

**Question:** What prevents an agent from fabricating a source?

The architecture specifies:
- Independent verification (§4.7): a separate agent re-fetches 10% of URLs (minimum 5, maximum 20) and compares content hashes.
- Immutable audit log (§6.6): trace-map.yaml is committed to git. Modification requires a detectable git commit.

**The problem:** An agent can fabricate a plausible URL that returns real content.

**Attack Scenario:**
1. Agent writes claim: "Competitor X charges EUR 2,300/mo for managed service."
2. Agent invents source: `https://competitor-x.com/pricing` — a plausible URL.
3. Agent runs Firecrawl /scrape on this URL. Firecrawl returns real content from the real page.
4. Agent extracts the quoted price from the real response (even if it's not the actual price — perhaps an old cached page, a different product tier, or a misread).
5. Agent computes content_hash from the real response.
6. Agent records: `source_url: "https://competitor-x.com/pricing"`, `content_hash: sha256:...` (real).
7. The independent verifier re-fetches the same real URL, gets the same content, computes the hash, and **confirms it matches.**

**The grade engine outcome:** C1=YES (2 independent sources), C2=YES, C3=YES, C4=YES → `[P]`. The claim passes all gates with a fabricated interpretation of real data.

**Architecture responses (and their limitations):**
1. **Independent verification re-fetches the URL, not the claim.** It detects if the URL has changed content. It does NOT detect if the agent's *interpretation* of the content is fabricated. A fabricated extraction from real content is invisible to hash comparison.
2. **Git audit trail.** Detects post-hoc modification but not initial fabrication.
3. **Cross-source consistency check (§6.2):** If 2 sources produce numerical values diverging by >20%, downgrade to `[E]`. But a skilled fabricator can ensure both fabricated claims agree within 20%.

**MITIGATION (not in current architecture):** The verifier should NOT just re-fetch the URL — it should independently extract the specific claim from the fetched content and compare against the trace-map's structured data. This requires the verifier to know the exact claim text and the exact field it maps to, then independently verify that the source URL supports that specific claim. This is more expensive but is the ONLY defense against interpretation fabrication.

**Verdict:** The grade engine CAN detect source absence and source mismatch. It CANNOT detect interpretation fabrication from real content. This is a residual risk that must be accepted or mitigated with the extended verifier protocol described above.

---

## 5. DARK MATTER — UNDETECTABLE SIGNALS

### 5.1 Signal Types the Toolchain Cannot Detect

| Dark Matter Type | Why Tools Miss It | Impact on Niche Accuracy | Most Affected Niches |
|---|---|---|---|
| **Trade show / conference presence** | No public API for event attendance. Event organizers don't publish attendee lists. | **High.** A dominant competitor's trade show presence is a strong signal of market power and brand authority. Tools see no digital footprint for the strongest competitors. | All niches, but especially EU Public Sector (trade fairs are primary GTM), Niche Manufacturing, Professional Services |
| **In-person meetings / word-of-mouth** | Zero digital exhaust for verbal referrals. The most common B2B buying trigger has no tool-detectable signal. | **Very High.** The architecture's trigger system (§6A) is entirely digital. It cannot detect the #1 trigger in B2B: "my peer at another company told me about this." | All niches equally. Fractional Executive Services (trust-based, relationship-driven buying). |
| **Private company dynamics** | No Crunchbase (API free tier removed), no SEC filings (private), no G2 (if no product), no public pricing (consulting). | **Very High.** The toolchain assumes companies have a digital footprint. Private consulting firms, agencies, and fractional exec platforms do not. Their pricing, customer counts, and strengths/weaknesses are invisible. | Fractional Executive Services, Consulting, Agencies, Staffing, Manufacturing Services |
| **Non-English-language markets** | Firecrawl and DataForSEO work in all languages, but our VOC sources (G2, Reddit, Capterra) are English-centric. GDELT covers 65 languages but VOC extraction from non-English sources is not designed. | **Medium-High.** For NL-only niches, the Reddit Research MCP covers Dutch subreddits, but G2 reviews for Dutch-language products are scarce. Buyer language extraction (§2.6) will default to English quotes. | NL public sector, NL manufacturing, BE/Flemish niches, non-English SaaS |
| **Internal buying signals** | Boardroom conversations, CRO's personal urgency, quarterly budget reviews, internal power dynamics. No tool can access these. | **High.** The architecture correctly acknowledges this as `[H]` at zero clients, but the trigger system (§6A) depends entirely on external signals. Internal signals are the actual buying mechanism — external signals are proxies. | All niches equally, but especially long-cycle B2B (EU Public Sector, Enterprise) where internal dynamics dominate. |
| **Competitor product quality** | Review data only captures visible sentiment. Engineering quality, code maintainability, infrastructure reliability are invisible. | **Low-Medium.** The architecture's weakness/strength extraction from reviews is a reasonable proxy. For non-software niches, this is wholely unavailable. | Non-software niches (no review data at all). |

### 5.2 Impact Magnitude by Niche Archetype

| Archetype | Dark Matter Impact | Reason |
|---|---|---|
| Bounded-Platform (software niches) | **LOW** — most tools work well, digital footprint is rich | Review data exists, pricing is public, technographics are available |
| Vertical-Industry | **MEDIUM** — digital tools work, but industry-specific dynamics (trade shows, relationships) are invisible | Tools capture the "what" not the "how" of industry dynamics |
| Horizontal-Function | **MEDIUM-HIGH** — function-specific tools (RevOps stack) are instrumented, but decision-making is internal and relationship-driven | Trigger signals miss the actual buying mechanism |
| Trigger-Event | **HIGH** — the niche IS trigger-based, but triggers that matter most (internal urgency, board decisions) are undetectable | The toolchain can detect secondary triggers (job changes) but not primary triggers (budget cycles, competitive fear) |
| Geographic-Cluster | **HIGH** specifically for non-English/non-US clusters | Language and cultural factors limit tool coverage; Reddit/local review presence varies by geography |

---

## 6. RECOMMENDED: DATA-COVERAGE-MATRIX.md SPECIFICATION

The program needs a `DATA-COVERAGE-MATRIX.md` that shows, for each of the 25 niches, which data types are expected to be AVAILABLE, SPARSE, or UNAVAILABLE. This prevents unfair scoring by normalizing evidence quality expectations per niche.

### 6.1 Matrix Schema

```yaml
# niche-program/research/_program/DATA-COVERAGE-MATRIX.yaml
# Per-niche data availability profile — used to normalize evidence quality scores
# AVAILABLE = toolchain expected to produce data meeting freshness SLA
# SPARSE = data exists but may be thin, single-source, or hard to find
# UNAVAILABLE = data type does not exist for this niche; do not penalize absence

niche_coverage:
  N-001-b2b-saas-revops:
    market_sizing: AVAILABLE
    competitor_profiles: AVAILABLE
    competitor_pricing: AVAILABLE
    buyer_personas: AVAILABLE
    trigger_signals: AVAILABLE
    technographics: AVAILABLE
    review_sentiment: AVAILABLE
    hiring_signals: AVAILABLE
    notes: "Highest coverage — IT SaaS niche with full digital footprint"
    normalization_factor: 1.0  # Baseline — no adjustment needed

  N-010-fractional-executive:
    market_sizing: SPARSE
    competitor_profiles: SPARSE
    competitor_pricing: UNAVAILABLE
    buyer_personas: SPARSE
    trigger_signals: SPARSE
    technographics: UNAVAILABLE
    review_sentiment: UNAVAILABLE
    hiring_signals: AVAILABLE
    notes: "Private companies, no public pricing, no G2 reviews. Compete via relationships."
    normalization_factor: 0.6  # Adjust expected evidence ratio to 60% of baseline

  N-015-eu-public-sector:
    market_sizing: AVAILABLE
    competitor_profiles: SPARSE
    competitor_pricing: UNAVAILABLE
    buyer_personas: SPARSE
    trigger_signals: AVAILABLE
    technographics: SPARSE
    review_sentiment: UNAVAILABLE
    hiring_signals: AVAILABLE
    notes: "Public tenders available via TED API. Buyers are government, not commercial."
    normalization_factor: 0.55

  N-020-niche-manufacturing:
    market_sizing: AVAILABLE
    competitor_profiles: SPARSE
    competitor_pricing: UNAVAILABLE
    buyer_personas: SPARSE
    trigger_signals: SPARSE
    technographics: UNAVAILABLE
    review_sentiment: UNAVAILABLE
    hiring_signals: SPARSE
    notes: "Limited digital footprint. No standard review platforms. Manufacturing tech not detectable."
    normalization_factor: 0.4
```

### 6.2 Normalization Rule

The evidence quality metric used for fertility ranking should be:

```
Normalized_E_Q = Actual_E_Q / (Sum_of(AVAILABLE * 1.0 + SPARSE * 0.66) / 8)
```

Where `Actual_E_Q` is the percentage of claims graded `[E]` or higher, and the denominator normalizes for the number of data types available. A niche with 8/8 AVAILABLE data types has a denominator of 1.0 (no adjustment). A niche with 3 AVAILABLE, 3 SPARSE, 2 UNAVAILABLE has a denominator of `(3.0 + 3*0.66 + 2*0)/8 = 0.6225`, so its evidence quality is divided by 0.6225 — raising it to comparable levels.

**This prevents the fertility gate from penalizing niches with inherently sparse data footprints.**

### 6.3 Coverage Estimate for All 25 Niches (high-level)

The 25 niches will fall into approximately three tiers:

| Tier | Number of Niches | Typical Coverage | Examples |
|---|---|---|---|
| **Tier 1: Full Coverage** (6-8/8 types AVAILABLE) | ~5-7 niches | Bounded-Platform SaaS niches with multiple competitors, public pricing, G2 presence, rich digital footprint | IT Staffing, RevOps, Sales Engagement, Customer Success |
| **Tier 2: Partial Coverage** (4-6/8 types AVAILABLE) | ~10-12 niches | Vertical-industry niches with some public data but fewer review sources, partial pricing | Professional Services Automation, EU GovTech, MarTech |
| **Tier 3: Sparse Coverage** (1-3/8 types AVAILABLE) | ~6-8 niches | Relationship-driven, private-company niches with thin or no digital footprint | Fractional Executive, Niche Consulting, Manufacturing Services |

**Implication:** If the fertility gate is run on raw evidence quality without normalization, Tier 3 niches will be systematically ranked lowest regardless of actual commercial viability. The normalization factor is not optional — it is required for the portfolio comparison to be valid.

---

## 7. SUMMARY OF FINDINGS

### 7.1 Blocking Issues (Must Fix Before Any Niche Canvas Is Scored)

| ID | Issue | Severity | Fix |
|---|---|---|---|
| DQ-01 | **Evidence grade engine never calibrated against human judgment.** 16/16 truth-table combinations work mathematically, but alignment with human raters is unknown. | P1 | Run calibration study: 3 human raters grade 30 claims from test niche. Compare vs. engine. Adjust criteria where disagreement >20%. |
| DQ-02 | **No normalization for data availability across niches.** Non-IT niches will be systematically under-scored. | P1 | Implement DATA-COVERAGE-MATRIX.yaml and normalization factor before fertility ranking. |
| DQ-03 | **Independent verifier cannot detect interpretation fabrication.** Re-fetching a URL and comparing hashes does not verify the agent's interpretation of the content. | P1 | Extend verifier protocol: verifier must independently extract the specific claim from the fetched content and compare against the trace-map's structured data. |
| DQ-04 | **Schema validation scripts are DRAFT/NOT-OPERATIONAL.** validate-schema.sh, freshness-audit.sh, and preflight-check.sh are templates, not operational scripts. | P1 | Implement all three scripts before any niche evaluation begins. The manual processes specified as fallbacks will fail under the concurrency of 25 niches. |

### 7.2 High-Severity Gaps

| ID | Issue | Severity | Fix |
|---|---|---|---|
| DQ-05 | **≥20 reviews from ≥2 independent sources is impossible for 8-10 niches.** The review corpus requirement in §4 assumes G2/Capterra coverage that does not exist for non-software niches. | P2 | Add a review-corpus availability flag to trace-map.yaml. If a niche's review platforms don't exist, demote the requirement from "minimum" to "target" for that niche. |
| DQ-06 | **No tool assigned for buyer language extraction.** Buyer quotes (§2.6) are gathered as a byproduct of review scraping, not as a dedicated pipeline. | P2 | Add a dedicated buyer-language extraction step to Phase 2: Firecrawl /search for verbatim quotes from G2 reviews, Reddit threads, LinkedIn posts. Schema-defined output with source URL required. |
| DQ-07 | **Trigger scoring (6A.0 ACH) has no empirical basis.** Frequency, urgency, budget-likelihood, and detectability scores are agent judgment with no validation gate. | P2 | After scoring, require the Agent to produce evidence for at least 2 of 4 dimensions per trigger. Detectability must be verified by a live API call or documentation reference. |
| DQ-08 | **Stackshare/tech blog analysis has no assigned tool.** Technical architecture inference in §4.1 requires tools not in the inventory. | P2 | Add Stackshare API (if accessible) or BuiltWith/Wappalyzer for tech inference. Or flag as `[H]` with specific confidence downgrade. |

### 7.3 Medium-Severity Gaps

| ID | Issue | Severity | Fix |
|---|---|---|---|
| DQ-09 | **Budget verification (§2.3) has no tool support.** No way to verify budget availability before investing founder hours. | P3 | Accept this as inherently human-process. Budget verification is a conversation, not a tool-output. Flag in §15 validation plan. |
| DQ-10 | **Non-transparent pricing for enterprise/consulting niches.** Architecture handles public pricing well but has no fallback for custom-quote pricing models. | P3 | When public pricing is unavailable, use G2 reviewer price mentions, job-postings-referenced budget, or competitor case studies. Mark as `[E]` (secondary source), document the limitation. |
| DQ-11 | **GDELT rate limit is 1 req/5s.** Acceptable for 10-20 queries per niche but the architecture doesn't specify queuing or batch strategy. | P3 | Add rate-limit handling to GDELT queries in Phase 2.7. Bundle queries to minimize requests. |
| DQ-12 | **Reddit Research MCP for non-English subreddits.** Dutch-language subreddits exist but coverage is thinner. Buyer language extraction for NL niches will default to English. | P3 | For NL-specific niches, supplement with Dutch-language LinkedIn groups, industry forums, and CBS StatLine reports. |

---

## 8. RECOMMENDATIONS

### 8.1 Immediate Actions (Before Calibration Niche Execution)

1. **Implement the DATA-COVERAGE-MATRIX.md** (schema provided in §6.1). Populate for all 25 niches before any fertility scoring. This is the single highest-ROI action to prevent systematic bias.

2. **Run a Grade Engine Calibration Study.** Use the calibration niche canvases (once produced) to test the deterministic engine against 3 human raters on 30 claims. Expected outcome: 1-2 grade criteria adjustments (likely around source independence and the 20% divergence threshold).

3. **Build the Three Missing Scripts.** validate-schema.sh, freshness-audit.sh, and preflight-check.sh must be operational before any niche evaluation. The current template scripts are insufficient for concurrent 25-niche operation.

### 8.2 Medium-Term Actions (During First 5 Niches)

4. **Measure per-niche tool coverage empirically.** The first 5 niches will reveal which data types are systematically harder to gather than estimated. Update the coverage matrix and normalization factors based on real data.

5. **Test the extended verifier protocol.** For the first 10 canvases, run the extended independent verification (re-fetch + re-extract the specific claim) on at least 10% of claims. Compare results to the basic URL+hash verification. This will determine whether interpretation fabrication is a real threat or a theoretical one.

6. **Validate the ACH trigger scoring.** For the first 3 niches, have a human expert independently score the trigger candidates and compare to the agent's scores. If disagreement exceeds 1 point on any dimension for >30% of triggers, add a validation gate requiring tool evidence for detectability scores.

### 8.3 Program-Level Recommendations

7. **Accept dark matter as inherent.** No toolchain can detect offline signals, private-company dynamics, or internal buying processes. The architecture should explicitly flag these limitations in each canvas's §15 (Open Questions & Validation Plan) rather than treating them as gaps to be closed.

8. **Consider light qualitative research for non-SaaS niches.** For niches where 3+ data types are UNAVAILABLE, the marginal value of 5 additional Firecrawl credits is near zero on those data types. Instead, invest 30 minutes in a subject-matter-expert interview per Tier 3 niche. This provides more signal for the dark-matter data types than any tool could.

9. **Track data-type-specific SLAs per niche.** The freshness SLA table (§6.1) applies uniformly. But a 180-day freshness on reviews matters less for a niche with 0 review sources. Track SLA compliance per data type per niche, not as a program-wide metric.

---

## 9. CONCLUSION

The DATA-OPERATIONS-ARCHITECTURE.md is the most sophisticated data operations specification I have seen for an AI-driven market research program. Its key strengths are:

- **Deterministic evidence grading with verified truth-table completeness** (all 16 binary combinations produce exactly one grade)
- **Four-layer traceability from canvas claim to original URL with checksum**
- **Explicit freshness SLAs for 17 data types**
- **Independent verification protocol for hallucination detection**
- **Schema validation gates with atomic write patterns**

However, the architecture has never been executed against real niche data. Its tool assignments assume a digital-footprint-rich environment that does not exist for 10-12 of the 25 niches. The evidence grade engine will systematically under-score these niches unless the DATA-COVERAGE-MATRIX.md normalization is implemented. And even with perfect tool execution, the architecture cannot detect the most important B2B buying signals — those that occur offline, in private companies, or in internal conversations.

**Verdict:** The tool-to-task mapping is VALID for IT-SaaS-B2B niches and INVALID for the full 25-niche spectrum without the normalization framework specified in this audit. The architecture's own rigor (deterministic grading, traceability, independent verification) is a strength, but it creates a false sense of precision for data-sparse niches. Implement the normalization, calibrate the grade engine against human judgment, and accept that dark-matter data types require qualitative methods no toolchain can replace.
