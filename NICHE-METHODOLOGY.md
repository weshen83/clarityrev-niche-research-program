# Niche Methodology — Complete Specification
## ClarityRev Niche Evaluation & Commercial System Design

**Status:** BINDING — All 25 niche agents MUST follow this methodology. Deviations must be logged in the niche document's methodology section.

**Version:** 1.0
**Last updated:** 2026-07-22
**Source:** Expert panel (Strategy Consultant, GTM Architect, Research Analyst, Systems & Automation Designer, Red-Team/QA)

---

## TABLE OF CONTENTS

1. [Preamble: Principles of This Methodology](#1-preamble-principles-of-this-methodology)
2. [Part 1: The Canvas — 15 Sections](#2-part-1-the-canvas--15-sections)
3. [Part 2: The Research Protocol](#3-part-2-the-research-protocol)
4. [Part 3: Quality Gates](#4-part-3-quality-gates)
5. [Part 4: Automated Workflow Integration](#5-part-4-automated-workflow-integration)
6. [Part 5: Cross-Niche Comparability & Scoring Rubric](#6-part-5-cross-niche-comparability--scoring-rubric)
7. [Appendix A: Canvas Template (copiable)](#appendix-a-canvas-template-copiable)
8. [Appendix B: Evidence Grading Reference](#appendix-b-evidence-grading-reference)
9. [Appendix C: Common Failure Modes Cheat Sheet](#appendix-c-common-failure-modes-cheat-sheet)

---

## 1. PREAMBLE: PRINCIPLES OF THIS METHODOLOGY

### 1.1 What This Document Is

This is the **binding specification** for evaluating one B2B commercial niche and producing a complete commercial system design for ClarityRev. Every niche agent must follow it end-to-end. The output is a single markdown document — the **Niche Canvas** — that covers market definition, commercial design, automated workflow specification, and RIOS integration.

### 1.2 What the Niche Canvas Is For

Each completed Niche Canvas answers one question: *"If ClarityRev decided to serve this niche, what is the complete commercial system — free entry, paid services, recurring core, automated workflows, evidence stack, and GTM path — and how compelling is it?"*

The 25 canvases collectively enable:
- **Comparable ranking** of all niches on a common rubric
- **Portfolio-level decisions** (which 1-3 niches to enter first, in what order)
- **Build-ready specifications** for the chosen niche's workflows
- **Investor-grade narrative** of ClarityRev's total addressable opportunity

### 1.3 Key Constraints Inherited From ClarityRev Strategy

These are binding and must be checked for every niche:

| Constraint | Source | Check |
|---|---|---|
| B2B only (never B2C, never SMB, never consumer) | Context pack §5 | Gate |
| EUR 500K/yr net profit path with leverage | Context pack §5 | Gate |
| Scalable & productizable (not bespoke consulting) | Context pack §5 | Gate |
| Fits Revenue Intelligence category (intelligence-that-drives-revenue, delivered in-system) | Context pack §5 | Gate |
| Trigger x Vertical productization (trigger = repeatable build, vertical = language/premium) | Context pack §6 | Design principle |
| Aggregator distribution (who already has trusted access to these buyers) | Context pack §6 | Design principle |
| RIOS lifecycle (Attract → Diagnose → Prove → Commit → Expand → Compound) | Offer framework §B3 | Architecture |
| Direct-first, partner-assisted GTM (white-label later) | Context pack §8 | GTM constraint |
| Service-as-Software (consulting-priced, software-margin delivery via AI) | Context pack §3 | Margin model |
| Compounding benchmark moat — optional. Only where data pools naturally. Alternative moats: distribution, brand, speed, methodology, switching costs | Context pack §9 | Context-dependent. Assess per niche, not assumed. |

### 1.4 Evidence Grading System

Every factual claim in the Niche Canvas MUST be annotated with one of four grades:

| Grade | Meaning | Visual | Action |
|---|---|---|---|
| **PROVEN** | Multiple independent, verifiable sources; quantitative data; industry-standard methodology | `[P]` | Can be used as fact in investor materials |
| **EVIDENCED** | Single credible source OR multiple partial sources pointing same direction; plausible | `[E]` | Can be used in internal decisions with caveat |
| **HYPOTHESIS** | Logical inference from analogous markets; reasoned extrapolation; no direct data | `[H]` | Must be flagged for validation; cannot be used externally |
| **SPECULATIVE** | Best guess; no supporting data; analogy from very different context | `[S]` | Must be explicitly marked; cannot inform build decisions |

**Rule:** Any section with >50% SPECULATIVE content must be flagged as HIGH-UNCERTAINTY and the canvas scored at half weight.

---

## 2. PART 1: THE CANVAS — 15 SECTIONS

Each Niche Canvas has exactly 15 sections, in order. Every section must be filled. Agents must not skip sections, combine sections, or reorder them.

---

### SECTION 1: Niche Identity & Strategic Rationale

**Purpose:** Precisely define what the niche IS and IS NOT. Establish the structural driver (why now?). Gate data accessibility AND build feasibility before deeper research. Assess structural attractiveness (Porter's Five Forces) and strategic fit (Ansoff). Surface the single assumption that breaks the thesis if wrong. Prove the niche exists in the real world by naming 5 specific companies.

**Applied lenses:** Strategy Consultant (MECE boundaries, Porter's Five Forces, Ansoff Matrix, scenario planning, market sizing), Systems Designer (data accessibility gate, build effort, data volume, scaling triggers), GTM Architect (revenue model → leakage definition, buying temperature, First-5 Prospect Test, buyer accessibility), Research Analyst (source triangulation, confidence intervals, niche existence proof), Red-Team (pre-mortem, wrong-niche indicators, survivorship bias check, single-point-of-failure assumption)

**Note on evidence grading:** All claims in this section must carry an evidence grade `[P/E/H/S]`. Definitions and judgments are `[P]`. Market numbers sourced from published data are `[E]`. Inferences from adjacent niches are `[H]`. Pure guesses are `[S]`.

#### 1.1 Niche Name & Definition
- **Niche name** — crisp, recognizable (e.g., "Mid-Market Digital Marketing Agencies on HubSpot"). `[P]`.
- **One-line definition** — ≤30 words: who + what situation + what system. `[P]`.
- **Why this niche exists now** — ≤50 words on the structural driver: market trend, technology shift, regulatory change, or economic force that created this opening. Distinguishes "interesting" from "time-sensitive." `[P]`.
- **Ansoff matrix position** — is this market penetration (existing service, existing niche type), market development (existing service, new niche type), or diversification (new service, new niche type)? Different positions = different risk profiles. `[P]`.

#### 1.2 MECE Boundaries
- **IN:** Company criteria (size range, revenue range, employee count, geography), system/stack criteria (which CRM/ATS/ERP, which versions), decision-maker criteria. `[P]`.
- **OUT:** What looks similar but is NOT this niche. Name the adjacent niches explicitly and why they're excluded. `[P]`.
- **Boundary-testing edge cases:** 3 examples of companies that sit on the boundary — and which side they fall on, with reasoning. `[P]`.
- **First-5 Prospect Test (VALIDATION GATE):** Before proceeding past Section 1, name 5 specific, real companies in this niche. For each: company name, estimated decision-maker title, and why they'd qualify. If the agent cannot name 5 real companies, the niche definition is too vague — stop and refine. `[P]`.

**Most common failure mode:** **Scope creep** — defining the niche too broadly to inflate market size. MECE boundaries + First-5 Prospect Test are the antidote.

#### 1.3 Niche Economics
- **Business model** — how do companies in this niche make money? (subscription, commission, retainer, project-based, recurring service, transaction-based, hybrid). `[P]` — observable.
- **Typical revenue per customer/transaction** — with range and source. `[E]` or `[H]`.
- **Typical gross margin in this industry** — with source. `[E]` or `[H]`.
- **Key unit economics** — CAC, LTV, churn rate if available, with evidence grade. `[E]` or `[H]`.
- **This matters because:** one sentence connecting business model → what "revenue leakage" means in this niche. `[P]` — logical deduction.

#### 1.4 Data Accessibility & Build Feasibility Gate
- **Primary system(s) of record** — CRM/ATS/ERP/platform — with market share estimates. `[E]` or `[H]`.
- **API status per system:** accessible & tested / documented but untested / CSV-only / blocked (with ToS reference). `[E]` or `[H]`.
- **Integration build effort per system:** S (<3 days) / M (1-2 weeks) / L (3-6 weeks) / XL (8+ weeks or requires partnership). This determines whether the niche is buildable within the 90-day launch window. `[H]` — estimate.
- **Estimated first connector timeline:** In weeks. `[H]`.
- **Data volume estimate:** Records per typical client — low (<1K), medium (1-10K), high (10-100K), massive (>100K). Determines Snapshot runtime and infrastructure requirements. `[H]`.
- **Multi-tenant scaling trigger:** At what client count does serving this niche require architectural changes? (10 clients: single-tenant works. 50: shared infrastructure. 200: horizontal scaling.) `[H]`.
- **Quick feasibility verdict:**
  - GREEN — accessible now, build effort S or M, connector within 4 weeks
  - YELLOW — CSV fallback viable, API needs work, or build effort L/XL
  - RED — blocked without formal partnership, or build effort exceeds 90-day window
- **This gate MUST be GREEN or YELLOW to proceed.** RED = canvas halted, niche parked.

**Most common failure mode:** Proceeding with research before confirming data access AND build feasibility. Also: assuming API access without checking ToS (the Bullhorn lesson). Also: rating a system GREEN on access but ignoring XL build effort — effectively YELLOW for the first 2 months.

#### 1.5 Market Sizing & Structural Attractiveness
- **Total addressable companies** — triangulated from ≥2 sources. For each source: name, year, methodology, potential bias. Reconciled estimate with 80% confidence interval (e.g., "8,000-14,000 companies"). `[E]` or `[H]`.
- **Geographic scope** — NL-only, Benelux, DACH, EU, US, global — with justification tied to distribution access, language requirements, and founder network. `[P]`.
- **Market trajectory** — growing / stable / shrinking — with source. `[E]` or `[H]`. Growing markets forgive execution mistakes.
- **Concentration** — platform-dominant (≥60% on one system) / oligopoly (3-5 systems dominate) / fragmented (no dominant system). `[E]`. Determines integration strategy.
- **TAM at expected pricing** — total companies × average expected ACV. Ballpark with confidence interval. `[H]` at best.
- **Niche existence proof:** Is there published evidence this niche exists as a distinct market? Industry association? Trade publication? Gartner/Forrester coverage? Conference? LinkedIn group? Specialized software vendor serving it? If zero third-party recognition, the niche may be a ClarityRev construct, not a real market. `[E]` or flag gap.
- **Porter's Five Forces rapid diagnostic (1-5 per force, 1=unfavorable, 5=favorable):**
  - Supplier power (CRM/ATS vendors): [score] — [one-line justification]
  - Buyer power (fragmented or consolidated?): [score] — [one-line justification]
  - Threat of new entrants (barriers?): [score] — [one-line justification]
  - Threat of substitutes (DIY/internal is always #1): [score] — [one-line justification]
  - Competitive rivalry (intensity): [score] — [one-line justification]
  - **Structural attractiveness score:** Average of 5 forces. ≥3.5 = structurally attractive. 2.5-3.5 = moderate. <2.5 = structurally challenging — proceed with caution. `[H]` — judgment.
- **Buyer accessibility score:** How hard is it to get a meeting with the economic buyer? 1 = "founder has their phone number," 5 = "requires 6 months of relationship building and a conference introduction." `[H]`.
- **Buying temperature:** Cold (buyers unaware of problem) / Warm (aware, seeking solutions) / Hot (actively buying). Determines GTM urgency — hot niches convert on Snapshot alone; cold niches require category education. `[H]`.

**Most common failure mode:** **False precision** — citing a specific market size from one generic report. Confidence intervals are the antidote. Also: **assuming a niche is a real market** without checking for third-party recognition.

#### 1.6 RIOS Applicability Assessment
- **For each RIOS stage, mark as APPLIES / PARTIAL / SKIP:**
  - Attract (authority content, calculators, scorecards)
  - Diagnose (free data-grounded diagnostic — the "hinge")
  - Prove (paid entry — sprint, pilot, audit, scan)
  - Commit (recurring core managed service)
  - Expand (cross-sell, upsell within account)
  - Compound (moat — benchmark, data network effects, methodology)
- **Is a compounding benchmark moat relevant?** YES / NO / LATER STAGE
  - If NO: what's the alternative moat? (distribution depth, brand authority, delivery speed, proprietary methodology, workflow embedding / switching costs, network effects, vertical dominance)
  - If LATER STAGE: at what client count or data volume does it become relevant? What's the moat until then?
- **Are benchmark/data network effects realistic?** YES (data pools naturally across clients) / NO (data too fragmented, clients won't share) / WITH CONSENT (requires explicit opt-in, governance framework)
- **Rationale:** 2-3 sentences justifying each stage's applicability and the moat decision. `[P]` — strategic judgment.

**Most common failure mode:** **Defaulting to "all stages apply"** without considering niche context. Also: assuming benchmark moat without checking data pooling feasibility.

#### 1.7 Automated Opportunity Space
- **This section does NOT design workflows** — it flags the opportunity space that Section 11 will turn into specific automated workflows.
- **Manual/heavy work:** What do these companies do manually that takes hours and could be automated? (e.g., "recruiters manually scan job boards," "account managers manually check contract renewal dates"). `[P]`.
- **Valuable data sources:** What data would be valuable to aggregate for these companies? External (job postings, funding news, reviews, industry reports, competitor activity) and internal (CRM/ATS data, email/support tickets, contract databases). `[P]`.
- **LLM interface questions:** What would someone in this niche ask an LLM if it were grounded in their data? (e.g., "Which clients are at risk?", "What pricing should I quote?", "Show me dormant accounts with buying signals"). `[P]`.
- **External signals relevant to their revenue:** Job postings, funding events, leadership changes, regulatory shifts, technology adoption, expansion announcements, contract awards, review sentiment shifts — which matter for THIS niche? `[P]`. **→ These become the starting point for the full Client Signal Catalog in §6B.**
- **Buying temperature:** Cold (unaware of problem) / Warm (aware, seeking solutions) / Hot (actively buying). Determines whether Snapshot alone converts or whether category education is needed first. `[H]`.

#### 1.8 Niche Archetype
- **Select one:** Bounded-Platform / Vertical-Industry / Horizontal-Function / Trigger-Event / Geographic-Cluster
- **Rationale:** why this archetype, not another? `[P]` — judgment, must be explained.

#### 1.9 Niche Risk Assessment
- **Pre-mortem:** "It's 18 months from now. ClarityRev failed in this niche. Why?" Write the specific failure narrative. Not generic ("ran out of money") — specific to THIS niche. (e.g., "The dominant CRM platform blocked third-party AI access in Month 4. Our CSV fallback worked for Snapshots but couldn't support recurring delivery. Clients churned. We couldn't build the connector fast enough.") `[P]` — judgment.
- **Wrong-niche indicators (3-5 specific, measurable):** What early signals would indicate this niche was a bad choice? (e.g., "Zero Snapshot requests after 100 outreaches," "Every prospect says 'we already have [tool] for that,'" "Competitor launches identical service at half price within 6 months.") `[P]` — judgment, must be testable.
- **Survivorship bias check:** Are we selecting this niche because it's genuinely attractive, or because we already have a warm prospect here? "Having a warm prospect" is a distribution advantage — it does NOT make the niche structurally attractive. Separate these. State explicitly: (a) structural attractiveness (from §1.5 Five Forces), (b) distribution advantage (from warm prospects), (c) which is driving the recommendation. `[P]`.
- **Single-point-of-failure assumption:** What's the ONE assumption that, if wrong, breaks the entire niche thesis? Name it. Stress-test it: if the assumption is 50% weaker than expected, does the thesis still hold? (e.g., "Assumption: 26% leak rate applies to this niche. If actual leak rate is 13%, does the ROI math still close at EUR 2K/mo? If not, what's the minimum viable leak rate?") `[H]`.
- **Scenario planning — 3 alternative futures:** Optimistic (niche grows, platform integration becomes moat), Pessimistic (dominant CRM blocks access or builds competing feature), Disruptive (AI makes niche's core function obsolete). Which scenario is the recommendation betting on? What's the hedge? `[S]` — scenarios, must be flagged.

**Done (minimum viable):** Niche crisply bounded with IN/OUT list and 3 edge cases. First-5 Prospect Test passed (5 real companies named). Data accessibility gate GREEN or YELLOW. Build effort estimated per system. Market size triangulated from ≥2 sources with confidence interval. Niche existence proof provided. Porter's Five Forces scored. RIOS applicability assessed per stage. Pre-mortem written. Wrong-niche indicators defined. Survivorship bias checked. Single-point-of-failure assumption named and stress-tested.

**Excellent:** All of the above, plus: scenario planning with 3 futures. Structural attractiveness score ≥3.5. Buying temperature assessed. Buyer accessibility scored. First-5 Prospect Test includes warm-path assessment for each company. The pre-mortem is specific enough that a reader can visualize the failure. The single-point-of-failure assumption has a quantified stress test.

**ADVERSARIAL CHECK:** "Is this niche genuinely attractive, or does it just have a warm prospect? The survivorship bias check forces separation. If the single-point-of-failure assumption breaks at 50% — does the thesis still hold? If not, the niche is fragile. If the agent can't name 5 real companies or write a specific pre-mortem, they don't understand the niche well enough."

---

### SECTION 2: Buyer, Committee & Purchase Dynamics

**Purpose:** Map the full purchase system: who decides, who influences, how power flows, how the champion sells internally, what Bob says in the first 15 minutes, how the budget is verified, and what happens if the champion leaves. This is the sales playbook, not just a buyer persona.

**Applied lenses:** Strategy Consultant (committee influence mapping, decision-making style), GTM Architect (champion playbook, first-meeting architecture, mobilizer theory, MEDDIC, sales complexity), Research Analyst (evidence grading, buyer language sourcing with exact URLs, sales cycle benchmarks), Systems Designer (CRM data requirements, OAuth approval chain, technical evaluator spec), Red-Team (wrong champion, phantom budget, committee turnover, continuity risk)

#### 2.1 Committee Influence Map (Open With This)

Not a bullet list of roles — a power map. Before listing individual roles, assess who matters and why:

| Role | Title | Influence (1-5) | Veto Power? | Must Be Convinced By | Primary Concern | Evidence Needed |
|---|---|---|---|---|---|---|
| Economic Buyer | [title] | [1-5] | Y/N | [role] | [their KPI/concern] | [from §12] |
| Champion | [title] | [1-5] | Y/N | [role] | [what they gain/risk] | [from §12] |
| Technical Evaluator | [title] | [1-5] | Y/N | [role] | [security/integration] | [from §12] |
| End Users | [title(s)] | [1-5] | N | [role] | [workflow impact] | [from §12] |
| Blocker/Detractor | [title] | [1-5] | Y/N | [role] | [what they lose] | [from §12] |

**Committee formality assessment:** Formal (documented procurement process with defined roles) / Informal (CEO decides, others advise) / Hybrid (small company growing into formal processes). `[E]` — from company size and industry norms.

**Decision-making style:** Consensus-driven or top-down? Data-driven or relationship-driven? Fast (decide in days) or slow (decide in months)? `[H]` — inference from niche understanding. This changes HOW Bob sells: a data-driven CRO needs benchmarks and ROI; a relationship-driven CEO needs peer references and trust.

#### 2.2 The Buying Committee — Individual Roles

**Economic buyer:** Exact title. Department. Reports to whom. Their personal KPI that this service improves. Their personal risk if this goes wrong. `[E]` — from job descriptions, LinkedIn profiles, industry role benchmarks.

**Champion (§2.2a — Profile):** Exact title. What they personally gain (career advancement, easier life, look smart). What they personally risk (blame for bad vendor, wasted time, internal embarrassment). `[H]` — inference from VOC and role understanding.

**Champion (§2.2b — Internal Sales Playbook):** Not just "what story do they tell." The full sequence of internal conversations the champion runs to sell this:
- **Step 1:** Who do they talk to first? What do they show them? (Usually: their peer or direct boss. Show Snapshot output on their data.)
- **Step 2:** Who next? What evidence at this stage? (Usually: economic buyer. Show ROI projection + competitor comparison.)
- **Step 3:** Who's the hardest internal sell? What objection do they raise? How does the champion counter it?
- **Escalation trigger:** When does the champion escalate to the economic buyer? (Usually: after the Snapshot produces a number too big to ignore.)
- **The one sentence the champion says to close the internal sale:** Write it verbatim, in their words.

**Mobilizer potential:** What would turn this champion from "advocate" to "mobilizer" — someone who actively SELLS internally because solving this problem advances THEIR career? (Gartner research: mobilizers drive deals 2-3× faster than passive champions.) Specific career advancement this service offers them. `[H]`.

**Technical evaluator:** Exact title or department. What they need to see (security one-pager, SOC2, DPA, API documentation, uptime SLA). What kills the deal at this stage? `[E]` — from security review patterns common to this company size.
- **CRM data requirements for Snapshot:** Exact OAuth scopes needed (read-only: Opportunities, Contacts, Accounts — specific fields: Stage, Amount, Close Date, Last Activity Date, Owner, Contact Roles). Exact objects NOT accessed (no emails, no files, no write access).
- **Data access approval chain:** Who controls OAuth/CSV data access? (IT? Legal? Department head?) What's the typical approval timeline? This determines whether the 48-hour Snapshot promise survives contact with IT. `[H]`.
- **CSV bypass:** If OAuth is blocked, can the champion export a CSV? What's the typical friction?

**End users:** Who uses the output day-to-day? Current workflow? What would adoption require? (Nothing — in-system delivery? Training? New tool? Behavior change?) `[E]` or `[H]`.

**Blockers/detractors:** Who loses power, budget, or relevance if this is adopted? (The internal competitor.) Often overlooked, often decisive. `[H]`.

**Committee size:** Number of people typically involved. Varies by deal size? `[E]` or `[H]`.

#### 2.3 Budget & Authority

- **Budget source:** Which line item? (Sales tools, RevOps, IT, CEO discretionary, departmental). Existing budget or new allocation needed? `[E]` or `[H]`.
- **Budget cycle:** When is budget available? (Annual planning Q4, quarterly review, "when pain is acute enough"). `[H]`.
- **Purchase authority thresholds:** Max spend champion can approve solo. Max spend economic buyer can approve solo. Threshold where CFO/board required. `[H]` at best. Determines whether EUR 2K/mo is a credit-card decision or a procurement process.
- **Budget verification method:** How does ClarityRev confirm budget availability before investing >5 founder hours? Specific verification: champion states "I have discretionary budget up to EUR X," previous tool spend in this category cited with approximate amount, published budget cycle with upcoming date. `[H]`.
- **"Phantom budget" assessment:** Evidence the budget is real and available NOW — not "we have budget somewhere in the annual plan." Red flag indicators: "we'd need to create a new line item," "let me check with finance," "we just spent our tool budget on [competitor]." `[H]`.

#### 2.4 The Decision Journey

- **Sales complexity score:** How many meetings from first contact to signed deal? 1-3 (transactional), 4-7 (moderate), 8-15 (complex enterprise). Determines whether Bob or a commission rep handles it. `[H]`.
- **Step-by-step from trigger to signed contract** — specific to this niche, not generic. ≥5 steps. Example: "Month-end review reveals 40% coverage gap → CRO asks RevOps to investigate → champion finds ClarityRev via [channel] → free Snapshot run → champion presents results to CRO → demo scheduled → procurement reviews → legal (DPA) → signed."
- **"First meeting" architecture:** Exact flow for the first 15 minutes of the first conversation with the champion. Not a script — a designed sequence: (1) Open with THEIR pain in THEIR language (from §2.6) → (2) Show industry benchmark establishing scale → (3) Offer Snapshot as zero-risk proof → (4) Schedule follow-up within 48 hours. `[H]` — design.
- **Timeline per step** — days or weeks. `[E]` or `[H]`.
- **Sales cycle benchmark:** Cite a published B2B sales cycle benchmark for this company size and deal range (e.g., HubSpot Sales Benchmarks, RAIN Group, CSO Insights, Gartner). If no benchmark exists for this niche, cite the closest available and flag the extrapolation `[H]`.
- **Who must say YES at each gate?** Where can a single NO kill the deal?

#### 2.5 The Buyer's Current State

- **Current solution:** What do they do TODAY? (Spreadsheet? Manual ops review? Internal hire? Another tool? Do nothing?) This is the REAL competitor. `[E]` or `[H]`.
- **Cost of current solution:** In time (hrs/week), money (tools, headcount), and missed opportunity (unrecovered revenue). `[H]` — estimate, be conservative.
- **Why they haven't fixed it yet:** (Didn't know scale? No budget? Tried another tool — failed? No internal owner? Too busy?) `[H]`.
- **The "no decision" scenario:** What if they do nothing for 12 months? Describe specifically: how much revenue keeps leaking, their personal consequence (missed bonus? board embarrassment? replaced?). Most common B2B outcome — must be addressed. `[H]`.
- **Champion continuity risk:** If the champion leaves mid-sale (avg CRO tenure: 21 months — from trigger research), who becomes the internal advocate? What's the fallback plan? Does ClarityRev have a relationship with a secondary contact? `[H]`.

#### 2.6 Proof Requirements

- **What does the economic buyer need to say yes?** (ROI case study from similar company? reference call? free pilot results on their own data? industry benchmark? security certification?) `[H]`.
- **Minimum viable proof for the champion:** (Often less — one Snapshot output may be enough for them to go to bat.) `[H]`.
- **Before/after gap:** How big must the gap between "what the diagnostic reveals" and "what they thought" be to trigger purchase? `[H]`.

#### 2.7 Buyer Psychographics

- **Primary fear:** What keeps them up at night? `[H]` — inference, flag as such.
- **Primary aspiration:** What makes them look like a hero? `[H]`.
- **Identity:** Operator? Strategist? Builder? Protector? Shapes how they buy. `[H]`.
- **Language they use:** 3-5 verbatim quotes from THIS niche's actual buyers. Specify exact sources: "G2 reviews for [top 3 competitor products from §4]. Reddit r/[named subreddits]. LinkedIn posts containing [pain keywords from §3]." For each quote: source URL, date, reviewer role, exact text. If no niche-specific quotes exist, flag this gap explicitly — do NOT substitute generic B2B VOC. `[E]` if sourced, `[H]` if extrapolated from adjacent niches.

#### 2.8 Trigger Events

- **What external events CAUSE this purchase?** Not "what makes them aware" — what makes them ACT. (Lost a key client, missed quarterly target, new CRO hired, CRM migration, competitor won a deal, board demanded visibility.) `[E]` or `[H]`.
- **Trigger frequency:** Per company per year. `[H]`.
- **Trigger detectability:** HIGH / MEDIUM / LOW — with specific signals ClarityRev can monitor. `[H]` until tested.
- **Urgency decay:** How long from trigger to "window closes"? (Missed quarter = 2-4 weeks. New CRO = 90 days. CRM migration = 30-120 days.) `[H]`.

**Done (minimum viable):** Committee influence map completed with ≥5 roles. Champion profile filled. Champion's internal sales playbook written with ≥3 steps. "First meeting" architecture designed. Budget verification method specified. Decision journey has ≥5 steps with time estimates. Current solution identified. Verbatim buyer language sourced with exact URLs or gap flagged. Trigger events with detectability ratings.

**Excellent:** Mobilizer potential assessed. Sales complexity score stated and benchmarked. Champion continuity risk with fallback plan. "Phantom budget" red flags listed. Data access approval chain mapped with typical timeline. CRM data requirements specified at field level. Buyer language quotes are traceable to exact G2 review URLs.

**ADVERSARIAL CHECK:** "Did we describe a real buyer or a generic B2B buyer with the niche name swapped in? If you covered the niche name, would this section work unchanged for any of the other 24 niches? If yes — it's not specific enough. Also: if the champion leaves tomorrow, does Bob have a second contact? If the budget turns out to be phantom, at what hour-mark do we know?"

---

### SECTION 3: Pain Architecture & Economic Impact

**Purpose:** Map the full pain landscape. Show how pains interconnect. Connect every pain to a specific offer, a specific committee member, and a specific diagnostic output. Build the ROI proof structure with weakest-link evidence grading. Stress-test at 50%. Arm Bob with a pain story, not just a statistic.

**Applied lenses:** Strategy Consultant (pain interconnection map, pain as competitive weapon, MECE), GTM Architect (pain-to-offer mapping, pain story for sales, pain urgency by persona, dual ROI framing), Research Analyst (source attribution per pain, adjacent-niche benchmarking, weakest-link confidence grading), Systems Designer (detection automation level, data quality sensitivity, pain threshold → workflow trigger), Red-Team (50% stress test, honest negative protocol, competitive pain narrative, pain fatigue risk)

#### 3.1 Pain Dimensions with Interconnection Map

**Pain Dimension Table:**

| Pain Dimension | Who Owns It | Urgency by Persona | Measurable From | Entry or Expansion | Source/Benchmark | Pain-to-Offer Map |
|---|---|---|---|---|---|---|
| **Revenue Leakage** — revenue lost through process gaps (dead pipeline, churn, missed renewals, dormant accounts, redeployment failure) | CRO / VP Sales (acute crisis), CFO (chronic drain) | CRO: "I need this fixed by end of quarter." CFO: "Show me the EUR impact over 12 months." | CRM/ATS data | Typically entry | 26% leak rate `[E]` — Clari Revenue Leak Report 2024 (Vanson Bourne survey, N=420 sales leaders, methodology: self-reported pipeline data). Source type: vendor-commissioned research — potential positive bias toward leak detection solutions. URL: clarityrev.io/references/clari-revenue-leak-2024. If no niche-specific data: cite adjacent niche with extrapolation flag `[H]`. | Snapshot → Recovery Sprint → Managed Recovery (§8-10) |
| **Efficiency Waste** — hours wasted on manual work AI could automate (reporting, data entry, spreadsheet reconciliation, prospect research) | VP RevOps (daily frustration), Ops Director (budget pressure) | RevOps: "I spend 10 hrs/week on this." Ops Dir: "That's EUR X in salary doing manual work." | Timesheet, CRM activity logs | Entry or standalone | No universal benchmark. Source requirement: cite industry productivity studies OR flag gap `[H]`. | Time Audit → Automation Sprint (§8-9) |
| **Missed Opportunity** — revenue NOT captured (buying signals ignored, expansion accounts not flagged, cross-sell not attempted) | CRO (strategic loss), CEO (growth gap) | CRO: "We're leaving deals on the table." CEO: "Competitors are capturing this." | CRM + external signals | Expansion (after leakage plugged) | No universal benchmark. Inference from competitor case studies `[H]`. | Opportunity Scanner → Pipeline Intelligence (§9-10) |
| **Risk Exposure** — compliance gaps, data quality risks, contract risks, regulatory exposure | CFO (liability), Legal/Compliance (audit fear) | CFO: "What's our exposure?" Legal: "We need this documented." | CRM audit, contract database | Entry if triggered by audit/incident | GDPR fines: avg EUR 2.8M (2024) `[E]`. Industry-specific fines if applicable. | Compliance Audit → Risk Monitoring (§8-9) |
| **Competitive Erosion** — losing deals to better-informed competitors | CRO (competitive fear), VP Sales (win-rate pressure) | CRO: "Why are we losing?" VP Sales: "They knew something we didn't." | Win/loss data, competitor intelligence | Expansion | No universal benchmark. Win/loss analysis pattern `[H]`. | Competitive Brief → Battlecards (§9) |

Not all apply to every niche. Flag which apply. At minimum: Revenue Leakage + Efficiency Waste must be assessed.

**Pain Interconnection Map:** How do these pains interact? Which pain, when fixed, reveals or unlocks another? Example: "Fixing Revenue Leakage → surfaces that 40% of leaks were caused by Efficiency Waste (no one following up because they were doing manual reporting). Fixing Efficiency Waste → reveals Missed Opportunity was 2× larger than estimated because clean data enables accurate signal detection." This determines offer sequencing in §7. `[H]` — judgment.

**Pain as Competitive Weapon:** Cross-reference each pain against competitor capabilities from §4. Which pains can competitors detect? Which can they act on? "Competitors can detect Pain #1 (leakage) but deliver it as a dashboard, not recovery. Pain #2 (efficiency waste) is invisible to their tools — ClarityRev's managed service is the only option. That's our wedge." `[H]`.

#### 3.2 Primary Pain: The Entry Wedge

- **Which pain dimension is the entry point?** (Gets the first "yes.") Why this pain, not another?
- **Competitive pain narrative:** What pain do the top 3 competitors lead with? (UserGems: "job changes are the #1 revenue signal." Clari: "forecast accuracy wins board confidence.") What pain are they silent on? Where's ClarityRev's opening? `[E]` from competitor homepages.
- **Quantified pain per company:**
  - Median EUR/year lost `[H]` — industry benchmark or conservative estimate
  - Range (25th-75th percentile) by company size within niche
  - Calculation method (explicit formula, explicit assumptions)
  - **50% stress test:** If the key pain number is 50% lower than estimated, does the business case still close? Show the math. "EUR 400K → EUR 200K leak. EUR 120K → EUR 60K recovered. At EUR 24K/yr cost, ROI drops from 5× to 2.5× — still positive but less compelling." If ROI goes below 1.5×, the niche is fragile. `[H]`. **Important limitation:** A 50% haircut on an `[S]`-grade number produces another `[S]`-grade number — the stress test does NOT upgrade evidence quality. It only tests whether the thesis SURVIVES if the estimate is wrong, not whether the estimate is RIGHT. The stress test is a robustness check, not validation. The evidence grade tells you how much to trust the number; the stress test tells you what happens if you shouldn't have.
- **Pain visibility:** How aware is the typical company? (Blissfully unaware / Suspects something / Can estimate roughly / Can measure exactly). `[E]` or `[H]`.
- **Pain trend:** Getting worse, stable, or improving? Why? Source. `[E]` if sourced.
- **Benchmark context:** "This niche leaks X% vs. Y% industry median." The "2.3× median" hook. `[H]` until own benchmark data exists.
- **Pain fatigue risk:** Buyers have heard "you're leaking revenue" from multiple vendors. What makes ClarityRev's framing feel FRESH? The novelty is in the PROOF mechanism (their own data, 48 hours, one number, zero risk), not the pain itself. Acknowledge this.

#### 3.3 ROI Proof Structure

The specific math a buyer uses to justify purchase. The one-slide business case.

- **The formula — every component graded individually:**

| Component | Value | Evidence Grade | Source |
|---|---|---|---|
| Annual leakage (EUR) | [X] | `[E]` or `[H]` | [source] |
| Recoverable % | [Y%] | `[H]` or `[S]` | [basis] |
| Recoverable EUR | [X × Y%] | **Inherits weakest grade** | — |
| ClarityRev annual cost (EUR) | [Z] | `[P]` | Pricing from §9-10 |
| Net recovery (EUR) | [X×Y% − Z] | **Inherits weakest grade** | — |
| Payback (months) | [Z / monthly margin] | **Inherits weakest grade** | — |

**Rule:** The final ROI claim inherits the WEAKEST evidence grade among its components. A `[S]` recoverability rate makes the entire ROI claim `[S]` regardless of how well-sourced the leakage number is.

- **Conservative case:** Worst reasonable numbers — still positive?
- **Best case:** Best reasonable numbers — aspirational but defensible.
- **Pain story for sales (two versions):**
  - **Champion version (tactical, 60 seconds):** "Last month we ran a Snapshot for a [niche] company your size. Their [champion title] thought they were missing 5% of pipeline. The Snapshot found [X]% leakage across [N] stalled deals. They recovered EUR [Y] in [N] days. Want to see YOUR number?" `[H]` — designed, not validated.
  - **Economic buyer version (strategic, 60 seconds):** "This service pays for itself in [N] months. After that, every EUR recovered is pure margin improvement. One [niche] company recovered EUR [Y] in the first quarter. Their CFO reports the ROI at their board meetings." `[H]`.

#### 3.4 Pain ↔ Diagnostic Mapping

- **How does the free Snapshot detect this pain from the buyer's own data?** Specific CRM/ATS fields, calculation, output.
- **Detection automation level per pain:** AUTO-DETECTABLE (algorithm finds it from CRM fields in <5 min) / SEMI-AUTOMATED (algorithm surfaces candidates, human confirms in <1 hr) / MANUAL (requires separate analysis, not in 48-hour Snapshot). Pains marked MANUAL cannot be the entry offer — they break the 48-hour promise. `[H]` until tested.
- **Data quality sensitivity per pain:** HIGH (requires clean CRM data — estimate degrades significantly with dirty data) / MEDIUM (tolerant of moderate messiness) / LOW (works on dirty data — actually improves as it finds the mess). Rate each. `[H]`.
- **The "one number" the diagnostic produces:** "You have EUR X in recoverable [pain type] across Y accounts."
- **The before/after urgency gap:** Buyer thought EUR 50K leak. Diagnostic shows EUR 400K. That gap IS the sales engine.
- **Pain threshold → workflow trigger:** "Leakage >15% of revenue → auto-generate Recovery Sprint proposal with pre-filled scope and pricing." "Leakage <5% → auto-generate 'pipeline health' report — builds trust, no hard sell. Reference §12.9 honest negative protocol." `[H]` — design.

#### 3.5 Cost of Inaction

- **12-month cost:** EUR amount + personal consequence. `[H]`.
- **24-month cost:** Compounding. `[H]`.
- **36-month cost:** "In 3 years, your competitor who fixed this has captured that revenue." `[H]`.
- **Personal consequence for economic buyer:** Missed bonus? Board embarrassment? Replaced? `[H]`.
- **"Honest negative" reference:** If the Snapshot finds minimal pain (<5% leakage), follow the protocol from §12.9: tell them honestly, build trust, nurture for when the pain becomes acute. This is not a failure — it's a long-term trust investment.

#### 3.6 Current Spending Baseline

- **What do they spend today?** Tools, headcount, agencies, incumbents. `[E]` or `[H]`.
- **Displacement opportunity:** Can ClarityRev replace an existing spend? (e.g., "EUR 1.5K/mo tool + 10 hrs/week analyst at EUR 50/hr = EUR 3.5K/mo. ClarityRev at EUR 2K/mo displaces both.") `[H]`.
- **Budget existence:** Yes — named / Maybe — discretionary pool / No — must create. `[H]`.

**Done (minimum viable):** ≥2 pain dimensions assessed with source/baseline. Pain interconnection map. Primary pain with 50% stress test. ROI formula with per-component evidence grades (weakest-link rule applied). Detection automation level per pain. Data quality sensitivity per pain. Pain story (both versions). Cost of inaction. Displacement analysis.

**Excellent:** Competitive pain narrative mapped. Pain fatigue acknowledged and countered. Pain threshold → workflow trigger specified. Adjacent-niche benchmarks cited where niche-specific data is absent. The 50% stress test shows ROI >1.5× even at half the estimated pain. The pain story includes specific numbers a buyer could verify.

**ADVERSARIAL CHECK:** "If the key pain number is 50% lower — does the case still close? The 50% stress test forces this. If the ROI at half-pain is below 1.5×, the niche depends on worst-case pain being typical — a fragile thesis. Also: every component of the ROI formula must be graded. If recoverability is `[S]`, the entire ROI claim is `[S]` — and Bob should know that before he quotes it to a CFO."

---

### SECTION 4: Competitive Landscape & Positioning Whitespace

**Purpose:** Map every alternative the buyer considers. Identify the positioning whitespace ClarityRev can own. Produce battlecards Bob uses on calls. Model what competitors will say about us — and how we counter. Diagnose WHY the whitespace is empty (opportunity or graveyard). Assess structural dynamics: is this winner-take-most or fragmented?

**Applied lenses:** Strategy Consultant (Porter's Five Forces, Blue Ocean Strategy Canvas, competitive dynamics over time, Rumelt diagnosis, "why hasn't anyone done this?"), GTM Architect (battlecards, displacement strategy matrix, competitor's likely attack), Research Analyst (pricing source verification, review corpus standards, freshness dating), Systems Designer (delivery model classification, marginal cost, switching cost, technical architecture inference), Red-Team (competitive intelligence limitations, reverse analysis, winner-take-most assessment, staleness dating)

#### 4.1 Direct Competitors

**Intelligence freshness banner:** "Competitive data collected: [date range]. Re-verify within 90 days: pricing, positioning headline, GTM motion."

For each direct competitor (minimum 3; if fewer explain why):

- **Name, URL, funding/backing** — how well-resourced? `[P]`
- **Pricing** — exact, with source verification: URL fetched, date fetched, exact text snippet confirming the price. If pricing is not publicly available, state "not publicly available" and cite closest signal (G2 reviewer mention, job posting referencing budget, case study citing cost). `[P]` if verified, `[E]` if from secondary source, `[H]` if estimated.
- **Delivery model:** SOFTWARE (self-serve, near-zero marginal cost) / MANAGED (human-delivered, high marginal cost) / HYBRID. `[E]`. Determines price war risk: a software competitor can drop price to near-zero. A managed competitor has a cost floor. ClarityRev's AI-delivered model should have lower marginal cost than human-delivered competitors.
- **GTM motion:** Self-serve/PLG, sales-led, partner-led, marketplace. `[E]`
- **Estimated customer count / market presence:** With estimation method stated (LinkedIn employee count, G2 review volume, press mentions, conference presence). `[H]` at best.
- **Positioning/headline** — verbatim from homepage. `[P]`
- **Rumelt diagnosis:** Stated guiding policy? Coherent action? Gap between stated strategy and execution? `[H]` — inference.
- **Strengths** — specific, verifiable from reviews. Review corpus requirement: minimum 20 reviews from ≥2 sources (G2, Capterra, Reddit), date range stated, aggregation method described. `[E]`.
- **Weaknesses** — specific, verifiable from reviews, NOT straw-man. Same review corpus standard. `[E]`.
- **Why buyers choose them:** From review data. `[E]`
- **Why buyers leave them:** From review data, switching reasons. `[E]`
- **Vulnerability:** Struggling? (layoffs, stagnant product, rebranding, funding gap, poor reviews). `[E]` or `[H]`.
- **Technical architecture inference:** From public signals (engineering job postings, Stackshare, BuiltWith, tech blog). API-first? Multi-tenant? Cloud provider? `[H]` — inference, flag.
- **Switching cost if prospect already uses them:** LOW / MEDIUM / HIGH. Specifically what they'd need to change (data export? API rebuild? workflow reconfiguration? staff retraining?). `[H]`.
- **Displacement strategy:** Rip-and-replace / augment-and-expand ("keep their tool, add our intelligence layer") / coexist-and-prove ("run the Snapshot, see what their tool misses"). Choose one with rationale. `[H]`.

**BATTLECARD (per competitor):** What Bob SAYS when a prospect mentions this competitor. Exact structure: (1) acknowledge the competitor's genuine strength, (2) insert our differentiation, (3) state the specific buyer consequence. Verbatim. ≤100 words.

**COMPETITOR'S LIKELY ATTACK ON CLARITYREV:** What will this competitor tell prospects about US? "Untested startup, zero clients, no references, bootstrapped, no SOC2, no enterprise track record, built by 3 people." Specific to what THIS competitor would emphasize. `[H]`.

**OUR COUNTER:** Bob's response to that attack. Verbatim. ≤100 words. Must be truthful — don't deny what's true ("we are new"), reframe it ("which is why the Snapshot is free — you verify on YOUR data, not our track record"). `[H]`.

#### 4.2 Adjacent & Substitute Competitors

- **Adjacent substitutes:** Tools solving different problems but competing for same budget/attention. `[H]`.
- **Internal/DIY alternative:** How the buyer solves this TODAY without buying anything. Spreadsheets, manual processes, "hire someone." This is ALWAYS the market-share leader. Describe the specific workflow. `[E]` or `[H]`.
- **The "do nothing" option:** What if they continue current approach? Quantify EUR + personal consequence. `[H]`.

#### 4.3 Competitive Positioning Map

- **Strategy Canvas (Blue Ocean):** Plot ClarityRev against incumbents on factors that matter TO THIS NICHE. Not generic — niche-specific. `[H]` — judgment.
- **Positioning whitespace:** What can ClarityRev say that NO competitor can truthfully say? Verify by checking competitor websites. `[E]` — falsifiable.
- **Competitor headlines vs. ClarityRev headline:** Verbatim side-by-side. Show the gap visually. `[P]` for competitors, `[H]` for ClarityRev.

#### 4.4 Competitive Dynamics

- **"Why hasn't anyone done this yet?"** — OPENS THIS SUBSECTION. If ClarityRev's positioning whitespace is real and valuable, why hasn't an incumbent filled it? Three honest possibilities: (a) they tried and failed — the graveyard scenario (what did they miss?), (b) the economics don't work at their cost structure but work at ours (why?), (c) genuine blind spot (rare — require extraordinary evidence). The agent must diagnose which, with evidence. `[H]` — judgment, must be argued.
- **Competitive dynamics over time (last 3 years):** Who entered this niche? Who exited? Who pivoted? Who was acquired? A niche attracting entrants is validating. A niche losing competitors is warning. A niche with stable incumbents is entrenched. `[E]` from Crunchbase, press, industry reports.
- **Winner-take-most assessment:** Is this niche structurally prone to consolidation (first mover captures 60%+, #2 gets 20%, rest fight for scraps) or fragmentation (5+ players can profitably coexist)? If winner-take-most, ClarityRev's zero-client position is a structural disadvantage regardless of product quality. `[H]` — judgment.
- **Competitive response modeling (if ClarityRev enters):** What would incumbents do? Ignore (niche too small) / Add features (how fast?) / Drop prices (how low? — see delivery model from §4.1) / Partner/acquire / Marketing counter-position. `[S]` — scenario, must be flagged.
- **Response timeline:** Enterprise incumbents: 12-18 months. Agile startups: 3-6 months. DIY: never. `[S]`.
- **Barriers to copying ClarityRev:** Integration complexity? Business model conflict (platform vs. managed service)? Niche too small for them? Our AI engine? Multi-source signal pipeline? Compounding data? `[H]`.
- **Reverse analysis (ClarityRev through competitor lens):** The #1 competitor analyzes ClarityRev. What's their battlecard against us? Exact language: "ClarityRev: [our weaknesses as they'd frame them]." This forces honesty. `[H]`.

#### 4.5 Minimum Competitive Bar

- **What's the minimum ClarityRev must deliver to be "good enough"?** The 2-3 capabilities that matter most. Not "best at everything." `[H]`.
- **Where can ClarityRev be "worse" and still win?** (e.g., "Doesn't need mobile app — buyer works at desk." "Doesn't need 50 integrations — just the dominant CRM.") `[H]`.

#### 4.6 Feature Comparison Matrix

Structured table. Rows = capabilities that matter in this niche. Columns = competitors + ClarityRev. Mark: YES / PARTIAL / NO / UNKNOWN. `[E]` from website + product research.

#### 4.7 Competitive Intelligence Limitations

What we CANNOT know from external research: product roadmaps, enterprise contract terms, actual churn rates, unit economics, upcoming features, partnership pipeline, win/loss rates, customer satisfaction beyond public reviews. This is not a weakness of the analysis — it's inherent to external competitive research. Listing limitations prevents overconfidence.

**Done (minimum viable):** ≥3 direct competitors with verified pricing, strengths/weaknesses from ≥20 reviews, battlecards, and likely attacks with counters. "Why hasn't anyone done this yet?" diagnosed. DIY alternative analyzed with specific workflow. Positioning whitespace identified and verified. Feature matrix ≥80% complete. Competitive intelligence limitations stated.

**Excellent:** Winner-take-most assessment. Reverse analysis completed (what the #1 competitor says about us). Delivery model + marginal cost classified per competitor. Switching costs assessed. Displacement strategy chosen per competitor. Competitive dynamics plotted over 3 years. Battlecards are verbatim and usable on a call today. Pricing sources verified within 30 days with exact text snippets.

**ADVERSARIAL CHECK:** "Did we describe real competitors or straw men? If a competitor read their battlecard, would they say 'fair' or 'that's not what we do'? Are the weaknesses VERIFIABLE from reviews, or invented to make us look good? If the whitespace is real — why hasn't anyone filled it? If you can't answer that with evidence, the whitespace might be a graveyard."

---

### SECTION 5: Ecosystem & Distribution

**Purpose:** Map the channels through which ClarityRev reaches buyers. Prioritize by speed-to-first-customer. Design aggregator activation playbooks. Model channel capacity ceilings so the GTM plan doesn't assume infinite volume. Build distribution as a moat. Surface the risks: partner indifference, network depletion, channel conflict.

**Applied lenses:** Strategy Consultant (distribution as moat, channel capacity constraints, concentration risk), GTM Architect (aggregator theory, channel activation playbooks, partner qualification, experiment design), Research Analyst (benchmark-anchored channel economics, partner comparables, performance benchmarks), Systems Designer (partner tech requirements, attribution tracking, distribution automation), Red-Team (distribution pre-mortem, aggregator indifference rate, channel conflict policy, warm network depletion curve)

#### 5.1 Aggregator Candidates (5 Classes)

For each class, identify named candidates. Rate each on: **Transaction proximity** (1=awareness only, 5=they sign the contract), Access (Warm/Warmable/Cold — named person, not category), Incentive alignment (does the aggregator WANT their buyers to have this?), Urgency (act now vs. long-term).

1. **Service providers:** Agencies, fractional execs, systems integrators, consultants serving this niche
2. **Capital allocators:** VCs, PE firms, accelerators funding these companies
3. **Platforms/marketplaces:** CRM/ATS app marketplaces, industry directories, platform ecosystems
4. **Adjacent vendors:** Non-competing vendors serving the same buyer — co-sell or referral
5. **Trusted humans:** Influential individuals, peer groups, industry communities, Slack/WhatsApp groups

Rank aggregators by transaction proximity. The one "closest to the signature" is the highest priority.

**Distribution as moat (§1.6 connection):** If ClarityRev captures the top aggregators in this niche before competitors, that IS defensibility. "Locking up the top 3 RevOps agencies as exclusive ClarityRev partners means a competitor entering in 12 months has zero warm distribution in this niche. They'll have to build from cold." `[H]` — strategic judgment.

#### 5.2 Channel Economics & Capacity

- **CAC by channel** — estimated hours/cost per paying client. Anchor every estimate: source a published benchmark or flag `[S]`. Warm referral: 5-10 hrs. Cold outbound: 40-80 hrs (reply rate 0.5-3%, source: HubSpot Sales Benchmarks 2024 — "Cold Email Response Rate Benchmarks by Industry," hubspot.com/sales/email-open-rates-benchmarks). Marketplace: near-zero marginal CAC but unpredictable volume. Partner: 20-30% commission (comparable: HubSpot Solutions Partner 20%, Salesforce AppExchange 15-25%). `[H]` or `[S]`.
- **Speed-to-first-customer by channel:** Warm referral: 14-30 days. Cold outbound: 60-90 days. Marketplace: 30-90 days (listing review + inbound lag). Content/authority: 6-12 months. `[H]`.
- **Channel capacity ceiling (per channel):** How many clients can this channel realistically produce before saturation? Warm network: ~50-100 contacts, depletes over 3-6 months. Partners: 2-4 active referring partners at steady state, each producing 1-3 clients/year. Cold outbound: diminishing returns after ~2,000 contacts in a defined geography. Marketplace: search volume-limited. Content: slow burn, no ceiling. `[H]` — estimate, flag.
- **Channel performance benchmarks (per channel):** What metrics indicate working vs failing? Cold outbound: Snapshot request rate >0.5% = working, <0.2% = failing. Warm referral: >20% of contacts request Snapshot = working, <5% = message or targeting wrong. Partner: >1 referral per active partner per quarter = working. `[H]` — until validated.
- **Distribution experiment design (per primary channel):** "Test: contact 10 [aggregators/prospects]. Timeline: 30 days. Success metric: [X]. If ≥threshold → double down. If <threshold → investigate message/targeting or abandon channel." Prevents running channels indefinitely without evaluation. `[H]` — design.

#### 5.3 Channel Prioritization

- **Which channel FIRST?** Not "all of them." The one with best speed-to-CAC ratio given zero references. Justify with numbers from §5.2.
- **Second channel:** What activates after first 3-5 clients? (Referrals? Marketplace? Partners?) Trigger: "When Channel 1 reaches 50% of its capacity ceiling, activate Channel 2."
- **Sequence roadmap:** Months 1-3, 4-6, 7-12. Per phase: channel mix, expected volume, expected CAC.

#### 5.4 Referral Dynamics

- **Do buyers in this niche talk to each other?** Conferences? Associations? Peer groups? Communities? `[E]` or `[H]`.
- **Referral velocity:** How fast does word-of-mouth spread? (Days: tight community. Months: fragmented. Never: isolated.)
- **Referral trigger:** What would make a client refer? (Specific EUR saved? Before/after case study? Benchmark showing peer is leaking more?)
- **Warm network depletion curve:** The warm network is a one-time asset, not a recurring channel. Estimate: Month 1 produces X referrals, Month 2 produces 0.7X, Month 3 produces 0.4X. At what month does the warm network effectively run dry? What channel replaces it? `[S]` — the 0.7X/0.4X decay rates have no empirical basis; they are estimates based on general networking patterns. Validate with actual referral data from first 3 months; if Month 2 actual is <0.3X, accelerate pivot to cold outbound.

#### 5.5 Partner Economics & Activation

- **Commission/referral fee that motivates aggregators:** `[H]`. Cite comparables: HubSpot Solutions Partner (20% first-year), Salesforce AppExchange (15-25%), agency white-label (20-40%).
- **Unit economics for partner:** "Agency refers client at EUR 2K/mo → earns EUR 400/mo (20%). At 5 clients = EUR 2K/mo recurring to the partner." `[H]`.
- **Partner qualification criteria:** What makes a partner worth Bob's time? Serves the right buyer (from §1.2), has active client relationships (can name 5 clients they'd offer the Snapshot to), has incentive to sell (commission is meaningful to them), has no competing solution, can close within 30 days. Prevents wasting hours on non-referring partners. `[H]`.
- **First partner activation playbook (per aggregator class):** Specific sequence: "Step 1: identify 5 [aggregator type] in [founder]'s network. Step 2: offer white-label Snapshot as their client lead-gen tool. Step 3: co-sell first client within 30 days (Bob supports the pitch). Step 4: document results. Step 5: use as proof to activate aggregator 6-10." Not a list — a playbook Bob executes. `[H]` — design.
- **Partner tech requirements:** What does partner need technically? (Co-branded Snapshot landing page? Unique referral tracking link? CRM integration? Training session on the Snapshot engine?) Time to activate: X days. `[H]`.
- **Attribution tracking method:** How does ClarityRev know Partner A sent Client X? (Unique Snapshot referral link per partner? Referral code entered on signup? CRM source field? Manual tracking in HubSpot?) Specified BEFORE first partner agreement to prevent commission disputes. `[P]` — design decision.
- **Partner activation rate (honest):** "If we recruit 10 partners, 2-3 will actually refer a client within 6 months." The aggregator indifference problem: partners are enthusiastic in the meeting, then never send a referral because ClarityRev is 2% of their revenue. True activation rate is low. Plan accordingly. `[H]`.

#### 5.6 Direct-First Playbook

- **Specific 30-day outreach plan:** How many contacts, through which channel, with what message, in what sequence? Reference §13 for full GTM motion. `[H]`.
- **Contact list availability:** Can we build a target list? From where? (Apollo, LinkedIn Sales Nav, industry directory?) `[E]`.
- **Competitor distribution saturation:** How do incumbents reach buyers? Which channels are saturated? Which are open?

#### 5.7 Distribution Risk Assessment

- **Distribution pre-mortem:** "We executed the GTM plan perfectly. 90 days in, zero clients. What went wrong?" Specific to THIS niche's distribution channels. `[P]` — judgment.
- **Channel conflict policy:** ClarityRev sells direct AND through partners. What's the rule when both touch the same prospect? "Partners own the relationship for clients they introduce. Direct targets prospects partners haven't engaged. If a prospect comes through both within 30 days, partner gets credit. If direct was already in active conversation, direct keeps it." Written BEFORE the first partner agreement. `[P]` — policy decision.
- **Aggregator indifference rate:** Honest estimate of TRUE partner activation. "If we sign 10 partners, expect 2-3 to refer within 6 months, 2-3 to refer within 12 months, 4-5 to never refer. This is normal. Plan partner recruitment volume accordingly." `[H]`.
- **Distribution concentration risk:** If >60% of pipeline comes from one channel, what's the trigger to diversify? (e.g., "When warm network produces <2 Snapshot requests/month for 2 consecutive months, activate cold outbound.") `[H]`.

**Done (minimum viable):** ≥2 aggregators per class (≥4 total), each with named candidate and warm access assessment. ≥1 marketplace path mapped. Channel prioritization with speed-to-CAC rationale. Channel capacity ceilings estimated. Partner qualification criteria defined. First partner activation playbook written. Attribution tracking method specified. Channel conflict policy stated.

**Excellent:** Distribution framed as moat with §1.6 connection. All channel estimates benchmark-anchored or flagged `[S]`. Channel experiment designs with success metrics and decision triggers. Warm network depletion curve modeled. Aggregator indifference rate honestly estimated. Distribution pre-mortem written. Distribution concentration risk with diversification triggers.

**ADVERSARIAL CHECK:** "Is 'warm referral' a real channel or wishful thinking? Is there an actual named person the founders can contact, or just a category they hope exists? If the warm network runs dry at Month 4 and partners haven't activated yet (the most likely scenario), what happens in Months 5-6? If the answer is 'we'll figure it out,' the distribution plan is fragile."

---

### §6.0 Unified Signal Architecture (Read Before §6A or §6B)

**Purpose:** Establish the structural relationship between the two signal sections before either is designed. §6A and §6B share detection infrastructure, enrichment pipelines, and data sources — they are one unified signal system serving two different commercial purposes.

**§6A (Sales Trigger Map):** Defines the triggers ClarityRev monitors to time Bob's OUTBOUND sales motion. These triggers determine WHEN Bob reaches out to PROSPECTS and WHAT he says. Purpose: pipeline generation.

**§6B (Client Signal Catalog):** Defines the signals ClarityRev's engine continuously monitors FOR paying CLIENTS as their recurring service. Purpose: recurring revenue delivery.

**Structural relationship:**
- §6A Tier 1 triggers ⊂ §6B Buying Intent Signals (filtered to prospect accounts, routed to Bob)
- §6B signal catalog ⊃ §6A trigger list (broader set, continuously monitored, routed to client's CRM)
- When a §6A-triggered prospect converts to a paying client, the signals that proved value during the Snapshot become the baseline recurring service. Additional signals from §6B are activated as the client expands.
- Pain chain: §3 pain dimensions → §6A triggers (which pains create buying urgency) → §6B signals (which pains does the recurring service monitor)

**Shared infrastructure:** Detection pipelines, enrichment, deduplication logic, data sources. §11 workflows consume signals from both sections in a unified format.

#### §6.0.1 Unified Signal Data Contract

Every signal detected by ClarityRev — whether routed to Bob's outreach (§6A) or to a client's recurring service (§6B) — conforms to this schema. §11 workflows consume signals in this format programmatically.

```yaml
signal_event:
  signal_id: "string"            # from §6B.2 catalog, format: {category}_{descriptor}_{version}
  signal_category: "enum"        # from §6B.1 taxonomy: account_health | buying_intent | pipeline_deal | market_intelligence | operational_efficiency | talent_resource
  company_id: "string"           # CRM/ATS account ID (client's system)
  company_name: "string"         # Human-readable company name
  detection_timestamp: "ISO8601" # When ClarityRev detected this signal
  confidence_score: 0.0-1.0      # Detection confidence — how sure are we this signal was detected correctly? (see §6B.2 detection method)
  predictiveness_confidence: 0.0-1.0  # Predictiveness confidence — how sure are we this signal predicts the revenue outcome? Mapped from §6B.2 H/M/L: HIGH→0.8+, MEDIUM→0.5-0.8, LOW→<0.5 (see §6B.8)
  eur_impact_estimate: 0         # Where calculable; null if not quantified
  source_data: {}                # Raw detection data (API response, scraped content)
  recommended_action: "string"   # From §6B.2 signal definition
  urgency: "enum"                # CRITICAL | HIGH | MODERATE | LOW
  tier: 1|2|3                    # From §6B.3 prioritization
  routing: "bob" | "client_crm" | "both"
  dedup_key: "string"            # {company_id}:{signal_id}:{window_id} for batching
  signal_version: "string"       # From §6B.2 versioning policy
```

**Routing logic:**
- `routing: "bob"` — Signal is a prospect company trigger (§6A Tier 1-2). Delivered to Bob's outreach queue.
- `routing: "client_crm"` — Signal is for a paying client's monitored accounts (§6B). Delivered to client's CRM.
- `routing: "both"` — Signal is both (e.g., a client's competitor shows buying signals — relevant to both the client's market intelligence AND potentially a prospect for ClarityRev). Delivered to both destinations with appropriate context.

**Signal ID naming convention:** `{category}_{descriptor}_v{major}.{minor}`. Example: `buying_intent_new_cro_v1.0`, `account_health_client_dark_v2.1`.

---

### SECTION 6A: Sales Trigger Map (Bob's Outreach Timing)

**Purpose:** Identify the specific, detectable events at prospect companies that create buying urgency. These triggers determine WHEN Bob reaches out and WHAT he says — they are the timing engine of the sales motion. These triggers are a subset of the broader signal catalog in §6B, filtered for prospect accounts and routed to Bob's outreach queue per §6.0.1.

**Applied lenses:** Strategy Consultant (trigger cascade chains, competitive detection lead time, commercial impact scoring), GTM Architect (outreach timing within urgency window, trigger-based messaging per persona, signal quality tiering), Research Analyst (frequency sourcing, false positive estimation method, detection recall), Systems Designer (detection architecture spec, batching/dedup logic, latency SLAs), Red-Team ("signal doesn't fire" scenario, dependency risk, gaming risk)

#### 6A.0 Trigger Candidate Pool & ACH Selection

Before selecting the top 5 triggers, the agent must consider ≥10 candidate triggers using Analysis of Competing Hypotheses (ACH). Each candidate is scored on four dimensions. Top 5 are selected for §6A.1. Bottom 5+ are documented with rejection rationale — this prevents black-box trigger selection and makes the agent's reasoning auditable.

| Candidate Trigger | Frequency (1-5) | Urgency (1-5) | Budget-Likelihood (1-5) | Detectability (1-5) | Composite | Selected? | Rejection Rationale |
|---|---|---|---|---|---|---|---|
| [Trigger 1] | [1-5] | [1-5] | [1-5] | [1-5] | [sum or avg] | YES/NO | [If NO: why not?] |
| ... | | | | | | | |

**Scoring anchors:**
- Frequency 1 = "once per decade per company," 5 = "multiple times per year per company"
- Urgency 1 = "nice to fix someday," 5 = "must fix this quarter or lose job/bonus"
- Budget-Likelihood 1 = "no budget exists for this," 5 = "dedicated budget line item, approval authority clear"
- Detectability 1 = "cannot be detected from external sources," 5 = "API-accessible, real-time, low false positive"

**Rule:** If the agent cannot identify ≥10 candidate triggers, the niche may be too narrow or poorly understood — flag this in §15.

#### 6A.1 Primary Triggers

Top 5 triggers ranked by **frequency × urgency × budget-likelihood.** For each trigger, every field that makes a factual claim must carry an evidence grade `[P/E/H/S]`. Design decisions (e.g., outreach timing) are marked `[DESIGN]`.

For each trigger:

- **Trigger name** — (e.g., "New CRO/VP Sales hired," "Missed quarterly revenue target," "Post-funding growth mandate"). `[P]` — the trigger concept exists.
- **Which pain dimension from §3 does this trigger surface?** — Direct traceability. "Pain #1: Revenue Leakage — missed quarter → pipeline gaps exposed." `[P]` — logical connection.
- **Who feels it first** — (title from §2.1). `[E]` if sourced from job descriptions/interviews, `[H]` if inferred from role.
- **Trigger frequency:** How often per company per year? Range, not point estimate. Source the claim or flag `[H]`. Confidence: HIGH/MEDIUM/LOW. `[E]` or `[H]`.
- **Trigger cascade:** What other triggers does this commonly cascade into? (e.g., "New CRO → often triggers CRM migration within 6 months. Missed quarter → board demands new tools → budget released.") Cascade chains create sustained multi-quarter urgency and are more valuable than isolated triggers. `[H]`.
- **SPICED mapping** (Situation → Pain → Impact → Critical Event → Decision — a B2B sales qualification framework from Winning by Design):
  - Situation: What event happened? (the trigger itself)
  - Pain: What problem does this create for the buyer? (from §3, in buyer language from §2.6)
  - Impact: What's the EUR consequence of not solving it? (from §3.3 ROI proof structure)
  - Critical Event: By when must it be solved? (urgency window, below)
  - Decision: Who decides and what do they need to see? (from §2.1 committee map + §12.2 evidence mapping)
- **Observable signal(s)** — specific, detectable data points that indicate this trigger fired. How ClarityRev detects it. `[E]` if source verified accessible, `[H]` if assumed.
- **Detection recall:** What % of actual trigger events do we capture? Estimation method: analogous signal / expert judgment / A/B test / unknown. `[H]` or `[S]`.
- **False positive rate** — with estimation method (analogous / expert / test / unknown). How often does this signal fire without a real buying opportunity? `[H]` or `[S]`.
- **Signal freshness:** How quickly does the signal go stale? (Job change: outreach within 2-4 weeks. Funding: within 1-3 months. Missed quarter: within 7-14 days.) `[H]`.
- **Competitive detection:** Do competitors already detect this signal? If yes — what's ClarityRev's differentiation? If no — why hasn't anyone built it? Is there a first-mover detection window (how long before competitors also detect)? `[H]`.
- **Urgency window:** Days to act before the opportunity resolves or the buyer moves on. `[H]`.
- **Outreach timing:** Exactly when does Bob reach out WITHIN the urgency window? Not "immediately" — most triggers have an optimal moment. "T1 (New CRO): Day 14-21 of their tenure — after team assessment, before tool commitment." "T2 (Missed quarter): Within 48 hours of earnings/board meeting — pain is acute for 7-14 days." `[DESIGN]`.
- **Messaging per persona:** What Bob says to the economic buyer vs champion for THIS trigger. Different committee members feel the trigger differently. "T2 (Missed quarter): Economic buyer = 'Board wants answers. Here's a number in 48 hours.' Champion = 'Your CRO needs a win. Here's one without asking for headcount.'" `[DESIGN]`.
- **Expected conversion:** When this trigger fires and Bob reaches out within the urgency window, what % result in a Snapshot request? Estimate with range. `[S]` until ≥20 data points exist. This feeds the funnel model in §13.2.

#### 6A.2 Trigger Calendar

- **Map triggers to months/quarters:** When do they concentrate? (Q1: new budgets, new CROs. Q2: pipeline reviews. Q3: pre-Q4 panic. Q4: budget flush, next-year planning.) `[H]`.
- **Seasonal buying patterns:** Are there months where purchase likelihood is 2-3× higher? `[E]` from B2B buying cycle research.
- **Trigger stacking:** When do multiple triggers fire simultaneously? These are the highest-urgency moments and the best outbound windows.

#### 6A.3 Signal Quality Tiering (Bob's Response per Tier)

| Tier | Definition | Examples (Niche-Specific — Agent Must Populate from §6.1) | Bob's Outreach (Action) | Bob's Opening Line (Verbatim, ≤30 words) | Bob's Capacity-Aware Response (When Overloaded) | Expected Volume |
|---|---|---|---|---|---|---|
| **TIER 1** | Directly indicates budget + authority | From §6.1 primary trigger list | Immediate personal outreach within 48 hours. Custom message referencing the specific trigger. | Agent must write: verbatim first sentence Bob says, referencing THIS trigger specifically. | When ≤3 active Tier-1: personal outreach to all. When >3: triage by (1) warm-path prospects first, (2) largest estimated ACV, (3) shortest urgency window. Excess Tier-1 receive automated personalized video/Snapshot offer within 48 hrs + personal follow-up within 5 days. | Low (2-5/month) |
| **TIER 2** | Indicates pain but not confirmed budget | From §6.1 primary trigger list | Personal outreach when Tier-1 volume ≤2/week. Semi-automated (personalized first line + templated Snapshot offer) when Tier-1 volume >2/week. | Agent must write: verbatim first sentence Bob says, referencing THIS trigger specifically. | When Tier-1 + Tier-2 combined >8/week: Tier-2 shifts to fully automated nurture. Personal outreach only to warm-path Tier-2. | Medium (5-15/month) |
| **TIER 3** | Indicates opportunity but not urgency | From §6.1 primary trigger list | Automated nurture sequence. Personal outreach only when Tier-1 + Tier-2 combined volume <5/week. | N/A — automated. Template must still be niche-specific. | Always automated. Bob reviews monthly for any that should have been Tier-2. | High (15-50+/month) |

**Bob's capacity constraint (binding):** Bob is ONE person at 40 hrs/week. The trigger system must account for volume spikes. If >3 Tier-1 triggers fire in a 48-hour window, Bob physically cannot execute "immediate personal outreach" to all. The capacity-aware column above specifies the triage logic. Without this, the system designs for average volume and breaks on variance — the first week 5 triggers fire simultaneously, the system fails. `[DESIGN]`.

**Triage tiebreaker (when multiple Tier-1 triggers compete for Bob's time):** (1) Warm-path (founder has personal connection to the prospect) beats cold, (2) Largest estimated ACV (from §1.5), (3) Shortest urgency window (from §6A.1). `[DESIGN]`.

#### 6A.4 Trigger → Workflow Mapping

For each trigger, which automated workflow fires? Direct traceability from trigger to automated output. Connects §6 (sales timing) to §11 (automated workflows).

- Example: "T1: New CRO hired → Workflow: Competitive Landscape Brief auto-generated for their new company → delivered to champion within 72 hrs of LinkedIn job change detection."

#### 6A.5 Signal-to-Revenue Validation (→ §15)

Every number in the signal-to-revenue chain (detection → outreach → Snapshot → paid → recurring → EUR recovered) is `[S]` at zero clients. Presenting these numbers as analysis would be false precision. Instead, the agent must pre-register validation hypotheses in §15 (Open Questions & Validation Plan).

**Required §15 entry for this section:** "Hypothesis: Tier-1 trigger outreach yields ≥X% Snapshot request rate. Method: Track 50 sequential trigger-based outreaches. Success threshold: ≥Y%. If below threshold after 50, redesign trigger messaging or abandon trigger." The agent sets X and Y based on niche context, with rationale.

**Reference:** See §13.2 (Full Funnel Model) for the overall conversion ranges, which aggregate across all trigger types. The §15 validation experiments test individual trigger performance.

#### 6A.6 Signal Sources & Detection Architecture

- **Where do signals appear?** CRM data, ATS data, job changes, company news, funding announcements, leadership changes, conference talks, quarterly reports, social media, review sites. Map each trigger to source(s).
- **Detection architecture per signal:** Specific API endpoint/method/query/filter. Not "CRM metric" — the exact technical specification Wesley can implement. Example: "API GET /deals?filter=last_activity_date_before:{30_days_ago}&stage not_in:[closed_won, closed_lost]." `[H]` until built.
- **Detection feasibility per signal:** BUILT / BUILDABLE / NEEDS PARTNER / NOT FEASIBLE.
- **Latency SLA per signal:** Must detect within X hours/days of occurrence. Determines architecture choice (polling vs webhook vs streaming). Job change: ≤48 hrs. Funding: ≤1 week. CRM metric: daily batch. `[H]`.
- **Deduplication logic:** How are multiple signals from the same company batched into a single trigger event? "Company posts 5 job openings in one week → one 'hiring surge' trigger event, not 5 separate alerts." Without dedup, Bob gets flooded and ignores alerts. `[H]` — design.

#### 6A.7 Signal Risk Assessment

- **"Signal doesn't fire" scenario:** What if the top 3 triggers DON'T fire for 3 months in this niche? What's the fallback GTM motion? (Always-running cold outbound? Content marketing? Partner referrals?) If the entire sales motion depends on triggers, a quiet quarter is a zero-revenue quarter. `[H]`.
- **"Signals fire systematically wrong" scenario:** What if the triggers fire but are systematically misleading — wrong persona (Director-level triggers firing for VP+ companies where only C-suite controls budget), wrong timing (triggers fire but urgency window is actually 3× longer than estimated), wrong implication (trigger fires but no buying process exists — e.g., "company posted jobs" but they're backfill, not growth)? If Bob burns 40 hours on 10 false-trigger outreaches with zero Snapshots, how long until he stops trusting the trigger system? Answer: ~2 weeks. The system is only as credible as Bob's last 10 outreaches. Mitigation: track per-trigger conversion rate from Day 1. Any trigger falling below 50% of expected conversion for 10 consecutive outreaches is paused and re-examined. `[H]` — scenario.
- **Signal dependency risk per trigger:** Primary detection source. Backup detection source. If both go dark (API restriction, platform change), the trigger is undetectable — flag it. Example: "T1 (New CRO): Primary = LinkedIn job change API. Backup = company press release monitoring. If both dark → manual Google Alert fallback." `[H]`.
- **Signal gaming risk:** If a competitor learns ClarityRev targets based on this signal, could they flood it with noise, pre-emptively contact those companies, or block the signal source? Any signal with public visibility can be gamed. `[H]`.

**Done (minimum viable):** §6A.0 ACH table completed with ≥10 candidate triggers scored and bottom 5 rejection rationale. 5 triggers in §6A.1 with: evidence grades on all factual claims, SPICED mapping, pain dimension traceability (§3), trigger frequency with confidence level, cascade chains, outreach timing to the day-range, persona-specific messaging, and expected conversion estimate. §6A.3 tier table populated with niche-specific examples, Bob's verbatim opening lines, and capacity-aware responses. §6A.6 detection architecture specified with per-signal API endpoints, latency SLAs, and dedup logic. §6A.7 signal risk assessment completed including "signals fire systematically wrong" scenario with mitigation.

**Excellent:** Trigger cascade chains mapped for all 5 triggers. Competitive detection lead time assessed per trigger. Outreach timing specified to the day-range. Trigger-based messaging per persona with verbatim opening lines. Detection recall estimated per trigger. Latency SLAs specified per signal source. Deduplication logic designed with explicit windows. "Signal doesn't fire" and "signals fire systematically wrong" scenarios with fallback GTM and per-trigger conversion tracking. Bob's capacity constraint modeled with triage tiebreakers. At least one trigger cascade chain spans 3+ triggers and 6+ months.

**ADVERSARIAL CHECK (extended):** "Can these signals actually be detected? Or are we listing signals we WISH we could detect? Check: does the API exist, is the data accessible, and does the signal have acceptable false positive rates? If the top 3 triggers all depend on LinkedIn and LinkedIn restricts access, does the GTM motion survive? If triggers don't fire for a quarter, what's Plan B? If triggers fire but are systematically WRONG (wrong persona, wrong timing, wrong implication), at what point does Bob stop trusting the system? Is Bob's capacity constraint modeled — can he actually execute the Tier 1 response when 5 triggers fire simultaneously?"

---

### SECTION 6B: Client Signal Catalog (What the Engine Monitors FOR Clients)

**Purpose:** Define the complete catalog of signals ClarityRev's engine monitors FOR clients in this niche. This is the beating heart of the recurring service — what clients pay for month after month. Each signal is a specific, detectable data point that indicates a revenue-relevant event. This section feeds §8 (free Snapshot scope), §9 (paid service deliverables), §10 (recurring monitoring), and §11 (workflow build specs).

**Applied lenses:** Strategy Consultant (MECE signal taxonomy, signal→moat connection, competitive signal gap analysis), GTM Architect (signal→value communication — what Bob shows in demos, "so what" per signal), Research Analyst (source feasibility grading, false positive rates, detection recall), Systems Designer (detection architecture, polling frequency, data format, dedup logic), Red-Team (signal overload risk, source dependency, signal freshness decay, "signal fails" fallback)

#### 6B.1 Signal Taxonomy (MECE)

Organize signals into categories — not a flat list. The taxonomy makes the catalog comprehensible to both clients (demos) and builders (§11).

| Signal Category | What It Detects | JTBD Framing ("When [situation], I need to [action] so that [outcome]") | Example Signals in This Niche (Agent Must Populate) | Commercial Meaning |
|---|---|---|---|---|---|
| **Account Health Signals** | Changes in existing client relationships that indicate churn risk or expansion opportunity | "When a client I thought was healthy starts going dark, I need to know immediately so that I can intervene before they churn and I walk into a board meeting surprised." | Contract renewal approaching without activity, client contact going dark, support ticket spike, NPS drop, usage decline | "This client is at risk — act now" or "This client is ready for expansion" |
| **Buying Intent Signals** | External events indicating a company is in-market for the niche's services | "When a company in my market shows signs they're about to buy, I need to know before my competitor does so that I'm the first conversation, not the third." | Funding round, leadership change, job postings for relevant roles, office expansion, new project announced, regulatory change | "This company is showing buying signals — reach out now" |
| **Pipeline/Deal Signals** | Changes in active opportunities that indicate stall, risk, or acceleration | "When a deal I'm counting on for my quarter is stuck and I don't know it, I need the system to flag it so that I don't discover it at forecast review when it's too late to save." | Deal stuck in stage >30 days, missing decision-maker contact, competitor mentioned in notes, pricing objection logged | "This deal needs intervention — here's the specific action" |
| **Market Intelligence Signals** | Competitive and market changes affecting the client's positioning | "When my competitors move and I don't know about it, I need timely intelligence so that my board sees me as informed, not blindsided." | Competitor launched new service, competitor changed pricing, new entrant in client's market, industry regulation change | "The market shifted — adjust your positioning" |
| **Operational Efficiency Signals** | Internal process gaps causing revenue leakage | "When our own processes are leaking revenue and nobody's tracking it, I need the system to find the gaps so that I can fix them without hiring a dedicated RevOps person." | Duplicate records, missing fields, unowned accounts, expired proposals without follow-up, benched resources | "Your operations are leaking — here's where" |
| **Talent/Resource Signals** | People-related events affecting revenue capacity | "When a key revenue-generating person leaves or capacity shifts, I need to rebalance immediately so that accounts don't fall through the cracks during the transition." | Key salesperson departed, new hire ready for accounts, recruiter capacity vs. req load, bench depth | "Your team capacity changed — rebalance" |

Not all categories apply to every niche. Flag which apply and which don't. Minimum: Account Health + Buying Intent must be assessed.

#### 6B.2 Full Signal Catalog

For each signal in the catalog (≥15 signals recommended for a viable recurring service). Every field that makes a factual claim must carry an evidence grade `[P/E/H/S]`. Design decisions are marked `[DESIGN]`.

- **Signal name** — client-facing name (not technical). "Client Going Dark" not "activity_log.last_contact_date > 30 days." `[P]`.
- **Signal ID** — machine-readable: `{category}_{descriptor}_v{major}.{minor}`. Example: `account_health_client_dark_v1.0`. `[P]`.
- **Signal version:** v{major}.{minor}. Versioning policy: MAJOR increment (v1 → v2) when detection algorithm changes materially (different source, different logic). MINOR increment (v1.0 → v1.1) for threshold tuning, confidence calibration, copy changes. Historical data retains the version under which it was detected. Re-computation on algorithm change: YES (re-process historical data through new algorithm) / NO (old data retains old version tag). Default YES for Tier 1 signals, NO for Tier 3. `[DESIGN]`.
- **Signal category** — from §6B.1 taxonomy. `[P]`.
- **Data source(s)** — where this signal is detected. For each source, state ALL of: (a) exact API endpoint/URL/method, (b) date last verified accessible, (c) verification method (live API call, documentation review, third-party confirmation). Sources not personally verified by the agent must be marked `[H]`. Example: "LinkedIn Sales Navigator API — endpoint `/people/{id}` — not personally verified (requires enterprise license); documented as accessible in LinkedIn API docs v2025.1. `[H]`." Primary source. Backup source (if primary goes dark). `[E]` if verified, `[H]` if assumed.
- **What it indicates** — the commercial meaning IN THIS NICHE'S CONTEXT. Not generic. "A staffing client's contract is ending in 30 days with no redeployment activity → EUR X at risk." `[H]` — interpretation, must be explained.
- **Which pain dimension (§3) this connects to** — direct traceability. "Pain #1: Revenue Leakage — redeployment gap." `[P]` — logical connection.
- **Predictiveness confidence:** HIGH / MEDIUM / LOW. How confident are we that detecting this signal actually predicts the revenue outcome we claim? This is DIFFERENT from detection quality — a signal can be detected with HIGH accuracy but have LOW predictiveness (we know the CRO changed, but does that actually predict a purchase?). Basis: historical data from N=X clients / expert consensus / logical inference from known buyer behavior / untested hypothesis. `[H]` — judgment about the signal-to-outcome link, not the detection quality. Rule: No signal with LOW predictiveness confidence may be Tier 1 (client-facing, action-critical). LOW-confidence signals are Tier 3 (awareness) until validated by ≥20 client data points.
- **Which service tier this feeds:**
  - FREE (§8) — surfaced in the 48-hour Snapshot?
  - PAID (§9) — surfaced in a one-time report/audit?
  - RECURRING (§10) — continuously monitored, alerted in real-time or weekly digest?
  - `[DESIGN]`.
- **Detection method:** AUTO-DETECTABLE (algorithm, no human) / SEMI-AUTOMATED (algorithm flags, human confirms) / MANUAL (requires analyst review). `[H]` until tested.
- **Recommended client action:** What should the client DO when this signal fires? Specific, actionable. "Contact [Client Name] within 48 hours. Reference the upcoming contract end date. Offer a renewal incentive per the playbook." `[DESIGN]`.
- **Urgency level for client:** CRITICAL (act within 24-48 hrs) / HIGH (act within 1 week) / MODERATE (act within 2 weeks) / LOW (awareness, no immediate action). `[H]` — design, validated by client feedback.
- **Signal freshness:** How quickly does this signal go stale? (24 hours, 1 week, 1 month?) Determines monitoring frequency. `[H]`.
- **False positive risk:** LOW / MEDIUM / HIGH. Estimation method: analogous signal / expert judgment / test data / unknown. `[H]` or `[S]`.
- **Detection recall:** What % of actual events of this type do we capture? Estimation method. `[H]` or `[S]`.
- **Signal dependency:** Primary detection source. Backup if primary fails. Flag if single-source. `[E]` if sources verified, `[H]` if assumed.

#### 6B.3 Signal Prioritization (Client-Facing)

Signals must be PRIORITIZED, not just listed. A client receiving 50 undifferentiated alerts ignores all of them. Design the prioritization logic:

- **Tier 1 (Immediate Action):** ≤5 signals that require same-day action. Delivered as [CRM/ATS] Task objects with: Subject = "[Signal Name]: [Company Name] — EUR [impact]", Due Date = [today + urgency window from §6B.2], Description = [signal context + recommended action from §6B.2], linked to [Company/Account] record. API: per §1.4 integration spec. Also pushed to client's Slack/Teams #revenue-intel channel (if configured) and email to champion. "3 deals stalled >60 days — combined EUR X at risk." Delivery method confirmed at client onboarding; fallback to email digest if CRM task API unavailable. `[DESIGN]`.
- **Tier 2 (This Week):** 5-10 signals for weekly review. Delivered as weekly digest email (Monday 7am local) + CRM dashboard panel listing all Tier 2 signals with EUR impact and recommended action. "7 accounts showing early churn signals — review in Tuesday pipeline meeting." `[DESIGN]`.
- **Tier 3 (Awareness):** All other signals. Delivered as monthly benchmark report (PDF + CRM dashboard) comparing client's signal patterns vs. niche benchmarks. "Your account health score is 72/100 vs. 78 niche median — trending down over 3 months." `[DESIGN]`.

**Signal overload prevention:** Maximum 5 Tier 1 alerts per client per week. If more fire, only the top 5 by EUR impact are surfaced. The rest are queued for Tier 2. `[H]` — design.

#### 6B.4 Signal → Recurring Value Cadence + Bowtie Funnel Mapping

Map signals to the recurring service's value delivery rhythm (§10.7). The client experiences value through signals. Additionally, map each signal category to the Bowtie Funnel stage it serves — post-sale retention and expansion are as important as pre-sale acquisition.

| Signal Category (§6B.1) | Bowtie Funnel Stage | Commercial Play | Example Client Action |
|---|---|---|---|
| Account Health | Retention | Prevent churn, detect expansion readiness | "3 accounts showing early churn signals — prioritize retention outreach this week" |
| Buying Intent | Acquisition (client's own sales) | Generate net-new pipeline for client | "5 companies in your market showing buying signals — add to outreach list" |
| Pipeline/Deal | Acquisition (deal rescue) | Recover stalled deals, accelerate pipeline | "2 deals stalled >60 days, combined EUR X at risk — intervention playbook attached" |
| Market Intelligence | Retention + Expansion | Defend against competitive threats, identify whitespace | "Competitor Y dropped pricing 15% in your segment — here's the counter-positioning" |
| Operational Efficiency | Expansion | Uncover hidden leakage → justify expanded scope | "Duplicate records causing EUR X in misrouted leads monthly — automation play available" |
| Talent/Resource | Retention + Expansion | Protect revenue capacity, identify organizational gaps | "Key account manager departed — 7 accounts at risk of going dark within 30 days" |

**Value delivery cadence:**

- **Weekly:** "This week we detected [X] Tier 1 signals requiring action, [Y] Tier 2 signals for review, and [Z] Tier 3 trend changes."
- **Monthly:** "This month's signals identified EUR [X] in recoverable revenue (Acquisition play), EUR [Y] in at-risk accounts (Retention play), and EUR [Z] in expansion opportunities (Expansion play)."
- **Quarterly:** "Your signal patterns vs. niche benchmarks: you're generating [X%] more churn signals than median. Your expansion signal rate is [Y%] below median — indicating possible upsell opportunity. Here's the action plan."

**Expansion trigger logic:** When specific signal combinations fire, they indicate readiness for an expansion offer (§10.3). Example: "3 consecutive months of Account Health signals above niche median + 2 Market Intelligence signals indicating competitive threat = expansion trigger for Competitive Battlecards add-on." Each niche's agent must define at least one expansion signal combination. `[DESIGN]`.

#### 6B.5 Competitive Signal Gap

Which of these signals do competitors detect? Which are unique to ClarityRev? From §4 competitor analysis. "Competitors detect signals 1-5 (standard). Signals 6-15 are ClarityRev-only — these are the signals that create switching costs because no other vendor provides them." `[H]`.

#### 6B.6 Competitive Signal Strategy (Blue Ocean Extension of §6B.5)

**Purpose:** Extend §6B.5 by plotting ClarityRev against the top 3 competitors on a Signal Strategy Canvas. This makes the competitive signal gap visual and strategic, not just a list.

Plot competitors on these factors (1-5 scale, 1=worst, 5=best):
- **Signal breadth:** How many distinct signal types do they monitor?
- **Signal actionability:** Do they tell you what to DO, or just show you a dashboard?
- **Signal freshness:** Detection latency — hours, days, or weeks?
- **Delivery format:** Is it in the CRM where the user works, or a separate tool?
- **Niche specificity:** Are signals generic cross-industry alerts, or tuned to THIS niche's revenue model?

| Factor | Competitor A | Competitor B | Competitor C | ClarityRev |
|---|---|---|---|---|
| Signal breadth | [1-5] | [1-5] | [1-5] | [1-5] |
| Signal actionability | [1-5] | [1-5] | [1-5] | [1-5] |
| Signal freshness | [1-5] | [1-5] | [1-5] | [1-5] |
| Delivery format | [1-5] | [1-5] | [1-5] | [1-5] |
| Niche specificity | [1-5] | [1-5] | [1-5] | [1-5] |

**Strategic control points:** Which 2-3 signals, if ClarityRev dominated detection quality, would create a position competitors can't easily replicate? These are the signals where detection quality COMPOUNDS with data volume (more clients = better false positive calibration = better signal = more clients). Not all signals are strategic control points — identify the specific ones that are. `[H]` — strategic judgment.

#### 6B.7 Demo Narrative (Signals as Sales Asset)

**Purpose:** The signal catalog IS the demo. This subsection specifies the 3-5 signals Bob shows a prospect, in what order, with expected prospect reaction and objection responses. It transforms §6B from an engineering spec into a sales asset.

**Demo sequence (agent must populate for this niche):**

1. **Open with THEIR pain in THEIR language (§2.6):** Bob's opening: "Most [niche title]s I talk to worry about [pain #1 from §3]. Here's what that looks like in your world." `[DESIGN]`.

2. **Show Signal 1 (highest EUR impact, Tier 1):** A specific, named signal from §6B.2 that directly addresses their primary pain. "If you were a client, this is what you'd see right now: [Signal Name] fired for 3 of your accounts. Here's what it means in EUR." Expected prospect reaction: [agent describes]. Bob's response to skepticism: [agent writes verbatim]. `[DESIGN]`.

3. **Show Signal 2 (surprising — they didn't know this was detectable):** "Here's one most [niche title]s don't realize is measurable: [Signal]. We detected this for a company your size and it led to EUR [X] in recovered revenue." Expected prospect reaction: [agent describes]. `[DESIGN]`.

4. **Show the prioritization logic:** "You don't get 50 alerts. You get the top 5, ranked by EUR impact, delivered where you already work — [CRM name from §1.4]." Demonstrate the Tier 1/2/3 system from §6B.3. Expected prospect reaction: relief ("I was worried this would be another noisy dashboard"). `[DESIGN]`.

5. **Close with the gap:** "How many of these signals is your current process catching? The Snapshot will tell you — in 48 hours, on your data, free." This is the bridge to the Diagnostic Moment (§12.4). Expected prospect reaction: "Can we run it?" `[DESIGN]`.

**Demo objection handling (signal-specific):**

| Objection | Response | Evidence |
|---|---|---|
| "Our CRM isn't clean enough for this" | "That's actually an advantage — the Snapshot finds the mess AND the money. If your CRM were perfect, you wouldn't need us. We work with dirty data." | §3.4 data quality sensitivity |
| "[Competitor] already monitors this" | "They show you signals. We show you the exact [accounts/deals/actions] to take tomorrow, ranked by EUR value, delivered as a CRM task. Here's the difference." | §12.3 competitor evidence comparison |
| "We tried something like this and it was noise" | "That's why we limit to 5 Tier-1 alerts per week. If you're getting noise, our signals aren't calibrated yet — and we fix that. Your first 3 months include weekly signal quality reviews." | §6B.3 overload prevention, §6B.8 calibration |

#### 6B.8 Signal Confidence Calibration

**Purpose:** Calibrate confidence that each signal actually predicts the revenue outcome it claims to predict. This is DIFFERENT from detection quality — a signal can be detected with HIGH accuracy but have LOW predictiveness. This section surfaces the most important unknown in the entire signal system.

For each Tier 1 and Tier 2 signal from §6B.2, complete:

| Signal Name | Tier | Predictiveness Confidence | Basis | Validation Method | Target Calibration Date |
|---|---|---|---|---|---|
| [Signal] | 1/2 | HIGH / MEDIUM / LOW | [historical data N=X / expert consensus / logical inference / untested hypothesis] | [How and when will this be validated?] | [Month Y] |

**Rules:**
- No signal with LOW predictiveness confidence may be Tier 1 (client-facing, action-critical). LOW-confidence signals are capped at Tier 3 (awareness) until validated by ≥20 client data points.
- MEDIUM-confidence signals may be Tier 2 but must carry a "[CONFIDENCE: MEDIUM]" tag in client-facing output until validated.
- HIGH confidence requires: historical data from ≥10 clients in this niche OR published research with N≥100 supporting the signal-to-outcome link. At zero clients, NO signal can be HIGH confidence — the maximum is MEDIUM (based on logical inference + competitor validation of similar signals).

**Calibration plan:** After 10 clients in this niche, retrospectively analyze: for each signal that fired, what % resulted in the predicted revenue outcome? Publish the calibration report to clients as a trust-building asset (§12.6). Target: <20% false positive rate on Tier 1 signals by Client 5. `[DESIGN]`.

**Zero-client honesty (apply §12.1 standard):** At zero clients, every signal's predictiveness is uncalibrated. The first 3 clients are signal calibration partners. They receive [50% discount / extended pilot / dedicated signal tuning] in exchange for weekly feedback on signal quality. This is NOT a weakness in sales — it's an honesty-strength play: "We're new. Competitors have 500 logos. We have zero. Here's what that means for you: we tune our signals to YOUR reality, not an industry average." `[DESIGN]`.

#### 6B.9 Signal → Workflow Traceability

Each signal maps to at least one automated workflow in §11. Direct traceability. "Signal: 'Deal Stalled >30 Days' → Workflow W3: Stalled Deal Recovery Brief → deliver to client's CRM within 24 hours of detection." This connects the signal catalog to the build specification.

**Done (minimum viable — FULL §6B):** §6B.1 taxonomy populated with JTBD framing per category. ≥15 signals in §6B.2 with: evidence grades on all factual claims, signal ID + version, source verification (endpoint/date/method), predictiveness confidence, service tier routing, and 13-field specification. §6B.3 prioritization tiers defined with delivery mechanisms specified per tier + overload prevention with EUR-impact sorting. §6B.4 value cadence mapped to weekly/monthly/quarterly + Bowtie Funnel stage per category + at least one expansion signal combination. §6B.5/§6B.6 competitive signal gap analyzed with Blue Ocean Strategy Canvas. §6B.7 demo narrative populated with 3-5 signals in sequence + prospect reactions + objection responses. §6B.8 signal confidence calibration table completed for all Tier 1+2 signals. §6B.9 ≥5 signals mapped to §11 workflows. §6B.10 signal health monitoring specified with per-signal metrics, alert thresholds, founder routing, and escalation path.

**Excellent (FULL §6B):** Full signal taxonomy populated with JTBD per category. Competitive signal gap analyzed with Blue Ocean Strategy Canvas. Every Tier 1 signal has a backup detection source + predictiveness confidence stated with validation method. Signal overload prevention designed with EUR-impact prioritization. Signal→workflow traceability complete for all Tier 1+2 signals. Signal→recurring value cadence mapped to weekly/monthly/quarterly with Bowtie Funnel plays. Demo narrative is verbatim-ready — Bob can use it on a call today. Signal health monitoring designed with per-signal metrics, alert thresholds, and escalation paths. Zero-client signal calibration protocol integrated with §12.1 honesty statement.

**ADVERSARIAL CHECK (extended):** "If a client asks 'what am I paying for each month?' — does this section provide the answer? Can Bob show this catalog in a demo and have the prospect say 'I need this'? If the top 5 signals all depend on one API and that API changes, does the recurring service break? If the client receives 50 undifferentiated alerts, do they ignore all of them? The prioritization design is as important as the detection design. Does every Tier 1 signal carry a predictiveness confidence rating? Is the most likely failure — client doesn't act on signals — designed for? If a competitor reads §6B.5/§6B.6, what do they learn and how fast can they copy it? Are signal health metrics specified such that Wesley knows a pipeline is broken BEFORE the client notices?"

#### 6B.10 Signal Health Monitoring

**Purpose:** Specify how ClarityRev knows the signal pipeline is healthy. Without monitoring, the recurring service can silently degrade — a broken scraper that goes unnoticed for 3 weeks means 3 weeks of client deliverables with missing signals, and the client notices before ClarityRev does.

**Per-signal metrics (monitored continuously):**

| Metric | Threshold | Alert | Who Gets Paged |
|---|---|---|---|
| Detection volume | Outside 2σ of 30-day moving average | Possible source failure — investigate within 4 hours | Wesley |
| Detection latency | Exceeds SLA for >10% of detections in 24 hours | Polling interval or API performance issue | Wesley |
| False positive rate (client-reported) | >30% of alerts marked "not useful" in monthly client survey | Signal needs recalibration | Adriaan |
| Source accessibility | Any source unreachable for >2 consecutive checks | Fallback activation required | Wesley |
| Zero-signal period | Zero signals of a specific type for >3× expected interval | Source change or detection logic broken | Wesley |
| Client action rate | <20% of Tier 1 signals actioned within urgency window for 2 consecutive months | Adoption problem — not a tech issue, a value-delivery issue | Bob (manages client conversation) |

**Alert routing by founder role (binding):**
- **Wesley:** Infrastructure failures — API down, scraper broken, rate limit hit, data pipeline errors.
- **Adriaan:** Data quality failures — false positives rising, stale data, enrichment gaps, signal calibration drift.
- **Bob:** Client-facing issues — output delayed, client reports signal quality problem, adoption dropping.

**Minimum viable monitoring by client count:**
- **0-5 clients:** Weekly manual check. Wesley reviews signal volume dashboard every Monday. Acceptable: manual monitoring at this scale.
- **5-20 clients:** Automated monitoring with Slack alerts. Must-have: volume and latency alerts. Nice-to-have: false positive tracking.
- **20+ clients:** Automated monitoring + on-call rotation + SLA reporting to clients. Monthly signal health report included in client QBR.

**Signal health dashboard (internal):** Per niche: signal volume by type (30-day trend), detection latency (p50/p95), source health (green/yellow/red per source), client-reported signal usefulness score (monthly survey, 1-5 scale).

**Failure mode escalation path:**
1. Automated alert fires → assigned founder acknowledges within SLA
2. If source is down >24 hours → activate backup source (from §6B.2 signal dependency field)
3. If no backup source exists → manual workaround (Adriaan manually checks source daily, delivers signals via email)
4. If manual workaround exceeds 1 week → escalate to founders: invest in backup source or accept reduced signal coverage for this niche
5. Client is notified if any Tier 1 signal is unavailable for >48 hours

`[DESIGN]` — monitoring thresholds are initial estimates, calibrated with live data.

**Cross-references to update:**
- §1.7: Add "→ see §6B for full signal catalog"
- §8: Free Snapshot scope references which §6B signals are included
- §9-10: Paid/recurring deliverables reference §6B signal categories
- §11: Each workflow references which §6B signal(s) it processes
- §11.13: Monitoring and Alerting — cross-reference §6B.10 for signal-specific health monitoring

---

### §6.8 Signal Strategy Pre-Mortem & Assumption Audit

**Purpose:** Surface and stress-test the assumptions the entire §6 signal system depends on. This section is the red-team checkpoint before the canvas proceeds to commercial design (§7-11). It forces honesty about what must be true for signals to create value — and what happens if it isn't.

**Applied lenses:** Red-Team (pre-mortem, assumption stress-testing, competitor exploitation), Strategy Consultant (strategic control points, source concentration risk), GTM Architect (adoption risk, value realization chain)

#### 6.8.1 The Three-Link Value Chain (and Where It Breaks)

ClarityRev's entire commercial system depends on a three-link chain. Every link must hold for the recurring service to deliver value:

1. **DETECT:** Signals are detected accurately (low false positive, high recall)
2. **ACT:** Client acts on the signal
3. **RECOVER:** Action recovers revenue

**Pre-mortem for each link:**

**Link 1 Fails (Detection Quality):** "It's Month 6. Our Tier 1 signals have a 45% false positive rate. Clients have learned to ignore alerts. Two of our first five clients cited 'signals were usually wrong' in their cancellation reason. A competitor with 3 years of calibration data publishes a benchmark showing their signals are 89% accurate. We can't match that claim. Our only defense — 'we're newer, we'll get better' — doesn't retain paying clients."

**Link 2 Fails (Client Adoption — THE MOST LIKELY FAILURE):** "It's Month 4. Client's team opened the first 10 Slack alerts enthusiastically. By Month 2, they'd stopped. By Month 4, the champion admits they've taken action on fewer than 20% of signals. The intelligence is good — the adoption is zero. Weekly digest emails go unopened. CRM tasks are 60 days overdue. The champion can't force their team to use it. They cancel not because the product is bad, but because it wasn't adopted. This is the #1 cause of death for intelligence products."

**Link 3 Fails (Revenue Recovery):** "It's Month 5. Client acted on 15 signals, contacted the accounts, ran the recommended plays. Recovery rate: 8%. The EUR numbers in our signals were based on average deal values, not this client's actual close rates. The ROI math the champion sold internally — the reason they bought — doesn't close. The CFO asks: 'We paid EUR 18K over 6 months and recovered EUR 14K. Why are we still paying?'"

**Link failure diagnosis table:**

| Link | Failure Signal | Detection Method | Owner |
|---|---|---|---|
| DETECT | Client reports >30% of alerts are "not useful" | Monthly client survey (from §6B.10) | Adriaan |
| ACT | <20% of Tier 1 signals actioned within urgency window for 2 consecutive months | CRM task completion rate | Bob |
| RECOVER | Actual recovery <50% of projected recovery after 6 months | Quarterly ROI review (§10.7) | Bob + client champion |

#### 6.8.2 Structural Assumptions (Stress-Tested at 50%)

| Assumption | Current Estimate | At 50% | Thesis Survives? | Mitigation |
|---|---|---|---|---|
| Signal detection recall (% of real events captured) | 70% (estimate) | 35% — miss 2/3 of events | FRAGILE — client sees low signal volume, questions value | Increase signal breadth (more signal types compensate for lower per-signal recall) |
| False positive rate on Tier 1 signals | 20% (target) | 40% — nearly half of alerts are noise | FRAGILE — client trust erodes within 2 months | §6B.8 calibration program; cap Tier 1 at 5 signals until FPR <20% verified |
| Client action rate (% of signals acted on) | 60% (estimate) | 30% | FRAGILE — even perfect signals don't create value if ignored | Embed signals in existing workflow (CRM tasks, not a separate dashboard); monthly adoption review with champion |
| Revenue recovery rate (of acted-on signals) | Per §3.3 recoverable % | At 50% of §3.3 estimate | Depends on niche — cross-reference §3.3 50% stress test | Under-promise on recovery rate; use conservative case from §3.3 ROI proof structure |

**Rule:** If any assumption's 50% stress test result is FRAGILE and no credible mitigation exists, the niche is not ready for build investment. Flag it in §14 (RIOS Score) and §15 (Validation Plan). `[DESIGN]`.

#### 6.8.3 Competitor Exploitation Assessment

If the #1 competitor from §4 reads §6A-6B, what do they learn and exploit?

**What they learn:**
- ClarityRev's entire signal detection strategy — every trigger type (§6A.1), every signal category (§6B.1)
- The tiering logic and prioritization method (§6B.3)
- Which signals ClarityRev considers highest-value (Tier 1 signals)
- The commercial architecture: free signals (§8) → paid signals (§9) → recurring signal monitoring (§10)
- Which signals ClarityRev thinks are competitively unique (§6B.5/6B.6)

**What they can do with this information:**
- Add ClarityRev's top 10 signals to their roadmap within 1 quarter
- Adopt our prioritization framework — it's unpatentable
- Target the signals we claim as unique and build them first
- Counter-position: "We detect 40+ signals. The new entrant does 15." (even if our 15 are higher quality, their 40 sounds better in a demo)

**ClarityRev's defense — what competitors CANNOT easily copy:**
- **Compounding calibration.** Each client makes signals more accurate. A competitor starting from zero has the same uncalibrated false-positive problem. Speed to calibration volume is the real moat.
- **Niche specificity.** Signals tuned to THIS niche's revenue model, buyer language, and CRM fields. A horizontal competitor can't match niche depth across 25 niches.
- **CRM-native delivery.** Signals delivered as Tasks in the client's CRM, not a separate dashboard. Requires per-CRM integration depth that horizontal players don't invest in.
- **Managed interpretation.** ClarityRev doesn't just detect signals — it tells the client what to DO (§6B.2 recommended client action). Pure software competitors detect; they don't interpret.

**Competitive exposure rating for this niche:** HIGH / MEDIUM / LOW. Based on: how unique are the signals? How long would it take a competitor to replicate the top 5? How strong are the defenses above? `[H]` — strategic judgment.

#### 6.8.4 Zero-Client Signal Honesty Protocol

At zero clients, ClarityRev MUST disclose to the first 3 clients (this extends §12.1 Zero-Client Honesty Statement to the signal layer):

> "Our signals are designed from first principles, competitor analysis, and published research. They have NOT been calibrated on live data in your niche. You are a signal calibration partner. In exchange for weekly feedback on signal quality (a 15-minute call every Friday for the first 90 days), you receive [50% discount / extended 90-day pilot at 50% fee / dedicated signal tuning priority]. By Client 5, we target <20% false positive rate on Tier 1 signals."

**This is an honesty-strength play, not a weakness:** "We're new. Our competitors have 500 logos and industry-average signals. We have zero clients and signals tuned to YOUR reality. You get intelligence built for your business, not a one-size-fits-all alert feed. And if a signal isn't working, we fix it — not in a quarterly roadmap review, but next week."

**Calibration partner economics:** 3 clients × 50% discount for 90 days = 1.5 months of full-revenue equivalent sacrificed. In exchange: calibrated signals, reference clients, case studies, and proof the signal system works. This is the cheapest calibration data ClarityRev will ever buy.

#### 6.8.5 Source Concentration Risk

Count Tier 1 + Tier 2 signals from §6B.2 by primary data source:

| Data Source | # of Tier 1+2 Signals | % of Total | If Source Goes Dark... |
|---|---|---|---|
| [Source, e.g., LinkedIn API] | [N] | [%] | [Which signals are lost? Can backup sources cover?] |
| [Source, e.g., CRM API] | [N] | [%] | |
| ... | | | |

**Rule:** If >50% of Tier 1+2 signals depend on a single data source (LinkedIn, Crunchbase, CRM API), flag the niche as **SOURCE-FRAGILE** and document the fallback plan. Source fragility is a §14 RIOS score downgrade factor — a niche with excellent signals that all depend on one API is riskier than a niche with good signals across 4 independent sources.

**Diversification strategy:** Within the first 6 months, reduce dependence on any single source below 50%. Methods: add backup sources per signal (§6B.2), develop proprietary data collection where economically justified, prioritize signals with multi-source detection.

#### 6.8.6 Client-Side Adoption Pre-Mortem

**The specific failure narrative (write this for each niche):**

"Month 1: Client champion excited. Team attends onboarding. First 5 Tier-1 alerts generate real action — one deal saved, EUR X recovered. Champion looks like a hero.

Month 2: Team's enthusiasm fades. Slack alerts become background noise. CRM tasks are marked 'done' without action to clear the queue. Champion is too busy to enforce adoption.

Month 3: Champion stops opening the weekly digest. ClarityRev's monthly report shows 127 signals fired, 11 actioned. Bob flags the adoption drop in the monthly review call. Champion acknowledges the problem, promises to 're-engage the team.'

Month 4: Nothing changes. Quarterly QBR shows EUR X in identified value, EUR Y actually captured. Gap is 4×. Client questions renewal. Bob offers adoption intervention — ClarityRev will send signal summaries directly to end users with their manager CC'd. Champion agrees to try it.

Month 5: Direct-to-end-user approach partially works — action rate rises from 11% to 35%. Still below the 60% target. Client renews at reduced scope. This is now a retention case, not a growth case."

**Built-in adoption defenses (must be in §10 recurring service design):**
1. **Month 1:** Weekly adoption check-in (15 min, Adriaan + client champion). Review: signals fired, signals actioned, barriers to action.
2. **Month 2:** Gamification — "Your team's signal action rate: 72%. Niche benchmark: 58%. You're in the top quartile." (Benchmark available after 5+ clients.)
3. **Month 3+:** Executive summary to economic buyer — "Your team acted on X% of signals this quarter, recovering EUR Y. Top performer: [Name]. Accounts with unactioned signals: [List]." Peer pressure + boss visibility.
4. **Continuous:** Signal quality feedback loop — end users can mark any signal as "not useful" with one click. >30% "not useful" rate triggers signal recalibration within 1 week.

**Done (minimum viable):** Three-link chain pre-mortems written. Structural assumptions table completed with 50% stress tests. Competitor exploitation assessment with defenses. Zero-client signal honesty protocol stated. Source concentration risk calculated. Client-side adoption pre-mortem written with built-in defenses.

**Excellent:** Every FRAGILE stress-test result has a specific, credible mitigation. The competitor exploitation assessment names the specific competitor and their likely response timeline. The adoption pre-mortem is niche-specific enough that someone who knows the niche would say "yes, that's exactly how it would fail here."

**ADVERSARIAL CHECK:** "Link 2 (client adoption) is the most likely failure and the least discussed in B2B SaaS strategy docs. Everyone worries about detection quality — almost nobody designs for adoption. If ClarityRev builds perfect signals that nobody acts on, the product is worthless. The adoption defenses in §6.8.6 must be as rigorous as the detection design in §6B.2. Also: if the competitor exploitation assessment makes you uncomfortable, that's the point — but if it makes you want to delete this section before a competitor reads it, the signals aren't defensible enough."

---

### SECTION 7: Customer Journey & Offer Architecture

**Purpose:** Design the complete customer journey — from first touch to long-term relationship. Reference the RIOS lifecycle but only mandate stages that Section 1.6 assessed as APPLIES. The Diagnose stage (free Snapshot) is always mandatory — it's the hinge. This section produces the conversion model, the pricing ladder, the non-linear journey map, the offer economics, the journey pre-mortem, and the technical specification for stage transitions.

**Applied lenses:** GTM Architect (lifecycle design, stage-gate conversion, pricing ladder, Bowtie Funnel), Strategy Consultant (MECE verification, competitive journey comparison, strategic control points, scenario planning), Systems Designer (data flow, journey instrumentation, automation feasibility, FMEA, founder capacity), Research Analyst (evidence grade inheritance, benchmark anchoring, confidence calibration), Red-Team (hinge assumption audit, journey pre-mortem, non-linear paths, kill metrics, minimum viable journey)

**Guiding policy (Rumelt):** The agent must state the guiding policy for THIS niche's journey. Not "move buyers through stages" — that's a goal. The guiding policy is the approach that overcomes the specific obstacle this niche presents. Example: "Because buyers in this niche are skeptical of AI claims, every stage transition is gated on THEIR data, not our assertions. The journey IS the proof." Another example: "Because this niche has long sales cycles (6-12 months), the journey front-loads value into the first 48 hours, creating an anchor that sustains engagement through the procurement process." The guiding policy must be specific to this niche, not generic. `[DESIGN]`.

---

#### 7.1 Lifecycle Stages (Per Section 1.6 Assessment)

**MECE verification gate (complete BEFORE populating the table):** The agent must answer:
1. "Do the APPLIES stages (from §1.6) form a MECE journey for THIS niche — covering every path a buyer could take from first touch to long-term relationship?" Test: can a buyer take any path that isn't covered? Is there a gap between any two stages where a buyer could fall out with no designed response?
2. "Is there overlap between any two stages — could a buyer reasonably be in two stages simultaneously?" If yes, the boundary is not crisp.
3. "Does §1.6's APPLIES/SKIP assessment still hold against §§2-6 niche realities?" A stage might be APPLIES in theory but practically blocked. Example: Compound requires data pooling, but clients in this niche never share data. Flag any stage where theory and reality diverge.
4. If a gap exists, design the bridge. If an overlap exists, sharpen the boundary.

**Strategic control points:** Which 1-2 stage transitions are the strategic control points — the transitions that, if ClarityRev dominates, create a position competitors can't replicate? For most niches, the Diagnose → Prove transition is the primary control point (proof on THEIR data, 48 hours, zero risk — competitors who ask for commitment BEFORE proof can't match this). Identify the control point(s) for this niche with rationale. `[H]` — strategic judgment.

For each RIOS stage marked APPLIES or PARTIAL in Section 1.6. Skip stages marked SKIP.

| Field | What to Capture | Evidence Grade |
|---|---|---|
| **Stage** | Attract / Diagnose / Prove / Commit / Expand / Compound (see note below on Compound) | `[P]` — stage concept |
| **Applies?** | From Section 1.6 assessment, verified per MECE gate above | `[P]` — verification |
| **JTBD (Job to Be Done)** | What job is the buyer hiring THIS stage to do? Not the functional job ("get a report") — the emotional/social job. "At Diagnose: 'Give me a number I can take to my boss that's big enough to get attention but credible enough to survive scrutiny.'" Each stage's JTBD must be niche-specific. | `[H]` — inference from buyer psychology (§2.7) |
| **Niche-specific offer name** | Result-named, not mechanism-named. "Revenue Leakage Snapshot" not "CRM Diagnostic." | `[DESIGN]` |
| **Offer shape** | One-time / Recurring / Usage-Based / Outcome-Based / Hybrid (setup + recurring) / Milestone-Based. Not limited to "Episodic or Recurring" — use the shape the niche demands. | `[DESIGN]` |
| **Target buyer** | Which committee member (from §2.1). | `[E]` from §2.1 |
| **One-number outcome** | Quantified EUR number. Inherits evidence grade from §3.3 ROI proof structure — state the inherited grade explicitly. | Inherits weakest grade from §3.3 |
| **Price (EUR)** | Band or estimate. Must cite specific competitor from §4.1 or §9.1 with verification date. Inherits grade from that source. | Inherits from §4.1/§9.1 |
| **Time-to-Value target** | How fast does the buyer see FIRST value at this stage? Diagnose: ≤48 hrs. Prove: ≤14 days to first recovered EUR. Commit: ≤7 days to first intelligence brief. Expand: ≤30 days to first new-service output. | `[DESIGN]` — target; validated with client data |
| **Entry logic** | How does buyer enter this stage? Specific, measurable condition. Not "they're interested" — "Buyer enters Diagnose when: Snapshot request form submitted AND CRM data connected OR CSV uploaded." | `[DESIGN]` |
| **Exit logic (stage-gate criteria)** | Measurable conditions for advancing to the next stage. NOT a prompt — specific criteria. Example: "Buyer progresses from Diagnose to Prove when ALL of: (a) Snapshot identifies ≥EUR X in recoverable revenue, (b) champion schedules results review call within 7 days of Snapshot delivery, (c) champion confirms budget existence per §2.3 budget verification method." | `[DESIGN]` |
| **Escape valve** | What if buyer won't/can't progress? Nurture path? Different offer? Honest exit? Must be specific to THIS stage and THIS niche. | `[DESIGN]` |
| **Champion advocacy at this stage** | What does the champion tell their boss to sell this stage? What evidence do they show? From §2.2b champion's internal sales playbook. Example: "After Diagnose: 'We ran a free diagnostic. It found EUR X in leakage across Y accounts. The paid Sprint recovers the top 5 deals in 14 days, guaranteed. I need EUR Y approval.'" | `[DESIGN]` |
| **Founder time per buyer** | Who does what? Hours per buyer? Capacity ceiling per week? (Bob: 40 hrs/week; Adriaan: part-time; Wesley: build only, no sales.) | `[DESIGN]` — binding per §13 founder capacity |

**Compound stage — cross-cutting property, NOT a peer journey stage:** Compound is not a stage buyers experience — it's a business outcome that accumulates across stages. At EACH stage, assess: "At what client count does each new client make the next client easier/cheaper/better to serve?" For the Compound row in the table above, answer:
- What moat mechanism? (Benchmark, methodology, distribution depth, switching costs, brand?)
- At what client count does compounding begin?
- What data/assets accumulate per client that make the next client easier/cheaper/better?
- Only if §1.6 marked YES or LATER STAGE. `[H]` until data exists.

---

#### 7.1a Competitive Journey Comparison (Blue Ocean Strategy Canvas)

**Purpose:** Plot ClarityRev's customer journey against the top 3 competitors' journeys on the factors that matter most to buyers. This prevents journey design in a vacuum.

**Journey Strategy Canvas (1-5 scale, 1=worst, 5=best):**

| Factor | Competitor A | Competitor B | Competitor C | ClarityRev | What This Means for Buyers |
|---|---|---|---|---|---|
| **Time-to-first-value** | [1-5] | [1-5] | [1-5] | [1-5] | How fast do they see proof this works? |
| **Friction-to-start** | [1-5] | [1-5] | [1-5] | [1-5] | Data access, contract, procurement — how hard is it to begin? |
| **Commitment required up-front** | [1-5] | [1-5] | [1-5] | [1-5] | Do they need to sign an annual contract before seeing value? (1=annual contract required, 5=free diagnostic first) |
| **Risk-reversal strength** | [1-5] | [1-5] | [1-5] | [1-5] | What happens if it doesn't work? (1=no guarantee, 5=outcome-based pricing) |
| **Expansion velocity** | [1-5] | [1-5] | [1-5] | [1-5] | Once a client, how fast can they access additional services? |
| **Human touch required** | [1-5] | [1-5] | [1-5] | [1-5] | How many meetings/calls/reviews? (1=heavy human, 5=mostly automated) |

**Positioning implication:** Summarize ClarityRev's journey differentiation in one sentence. Example: "Competitors make buyers commit before proving value. ClarityRev proves value before asking for commitment — the Snapshot IS the proof, and it takes 48 hours on their own data." `[H]` — strategic judgment.

**Competitor free → paid mechanisms:** For each of the top 3 competitors, what's THEIR free → paid transition? Free trial? Freemium? Demo? Consultative sale? How does ClarityRev's Diagnose → Prove transition differ? `[E]` from §4.1 competitor analysis.

---

#### 7.2 The Diagnose Stage (Mandatory — The Hinge)

The free Snapshot is always required — it's the hinge of the entire commercial system. This subsection fully specifies the Snapshot. For complete service design, see §8 (Free Entry Services) which covers the full free layer including content, calculators, and aggregator-native versions.

- **Snapshot name** — result-named, niche-specific. `[DESIGN]`.
- **What data does the prospect connect?** — specific CRM/ATS fields, OAuth or CSV. From §1.4 data accessibility gate. `[E]` from §1.4.
- **What one benchmarked EUR number does it produce?** From §3.3 ROI proof structure. Inherits weakest grade from §3.3. State the inherited grade.
- **Turnaround time** — target ≤48 hours from data connection to one number. `[DESIGN]`.
- **Security/privacy narrative for this niche** — what concerns do THEY have? From §12.11 security specification. `[E]` from §12.11.
- **What prevents them from saying no to data access?** — read-only? CSV fallback? Live preview showing instant value? From §1.4 accessibility. `[E]` from §1.4.
- **Conversion hook** — what in the diagnostic output leads naturally to the Prove/paid stage? Specific: "The output shows the top 5 recoverable deals, ranked by EUR value. Each deal has a recommended next action. The natural next sentence after the number is: 'We can recover the top 3 in 14 days. EUR X. Guaranteed 3× ROI or free.'" `[DESIGN]`.

**Hinge assumption (MANDATORY — the most important field in this section):** "The Snapshot produces a number that creates buying urgency in THIS niche." This assumption must be explicitly stated and stress-tested:

| Snapshot Output Level | Buyer Reaction (Best Case) | Buyer Reaction (Worst Case) | Thesis Survives? |
|---|---|---|---|
| **Too small** (EUR <50K leakage) | "Still worth fixing — let's start the Sprint" | "Not worth the effort — we'll address this internally" | FRAGILE if >40% of Snapshots fall here |
| **Too big to believe** (EUR >500K) | "This is exactly what I suspected — let's go" | "Your algorithm must be wrong — our pipeline isn't THAT bad" | FRAGILE — requires data-backed credibility; show the specific deal list |
| **About right** (EUR 50-500K, credible, urgent) | "EUR X in leakage? We need to fix this. What's the next step?" | "Interesting. Let me check with my team and get back to you." | DEPENDS — the number alone may not be enough; the conversion hook must bridge the gap |

**Hinge assumption confidence:** HIGH / MEDIUM / LOW that the Snapshot creates buying urgency in this niche. Basis: [analogous service in adjacent niche / logical inference / untested]. If LOW, the niche is not ready for build investment — flag in §14. `[H]` — judgment; validated by first 20 Snapshots.

---

#### 7.2a Pricing Ladder Architecture

**Purpose:** Connect the prices at each stage into a designed ascension where each price feels like a natural next step. Prices are not isolated numbers — they form a ladder where each rung's value-to-price ratio justifies the step up.

**Pricing ladder diagram:**

```
Free (EUR 0)                → Value: Proof on their data. Risk: Zero. Commitment: 48 hours.
  ↓ Step-up: EUR 0 → EUR X. Justification: "You saw EUR Y in leakage. Recover the top 5 for EUR X."
Paid Entry (EUR X)          → Value: 3-5× price in recovered revenue. Risk: Guaranteed. Commitment: 14-90 days.
  ↓ Step-up: EUR X → EUR Y/mo. Justification: "The Sprint recovered EUR Z. Ongoing monitoring catches the NEXT leak before it grows."
Core Recurring (EUR Y/mo)   → Value: Ongoing intelligence + benchmark comparison. Risk: Monthly, cancel anytime.
  ↓ Step-up: EUR Y → EUR Z/mo. Justification: "You're also leaking in [adjacent area]. Add [expansion service] at EUR (Z-Y)/mo."
Premium (EUR Z/mo)          → Value: Expanded scope + additional signals + dedicated analyst.
  ↓ Step-up: EUR Z → EUR W/mo. Justification: "Enterprise-grade: multi-system, multi-geography, custom signals, SLA."
Enterprise (EUR W+/mo)      → Value: Full portfolio + white-glove + custom integrations.
```

**Maximum step-up rule:** No rung-to-rung price increase exceeds 3× the previous rung's price. A jump from EUR 0 (free) to EUR 15K (annual contract) fails this rule. A jump from EUR 0 to EUR 5K (Sprint) passes. `[DESIGN]`.

**Pricing consistency note (MANDATORY):** Pricing appears across multiple sections — §7.2a (ladder), §9.2 (paid services), §10.2 (recurring), §10.6 (tiering), §7.4 (economics). The agent MUST ensure price consistency: the price stated in the ladder (§7.2a) must match the price in the service design (§9.2, §10.2) and the economics model (§7.4). Any price mismatch >10% between sections fails the Pricing Consistency canvas-level gate (§4.2). `[DESIGN]`.

**Value-to-price ratio per rung:** Each rung must show value ≥3× price at the conservative case from §3.3. If a rung's value-to-price ratio drops below 2× at the conservative case, the pricing is too aggressive for that niche. `[H]` — design; validated by client ROI data.

**Competitor price anchoring per rung:** For each rung, cite the closest competitor equivalent from §4.1 or §9.1. Show the math: "Competitor X charges EUR A for Y. ClarityRev charges EUR B for Y + [differentiating element]." `[E]` from §4.1/§9.1.

---

#### 7.3 Customer Journey Map (Conversion Model + Non-Linear Paths)

**Purpose:** This is a CONVERSION MODEL, not just a flow diagram. Every transition has explicit conversion rates, stage-gate criteria, and confidence grades. Non-linear paths (nurture loops, skip paths, resurrection paths, churn paths) are equally important as the primary linear path — B2B buyers don't move in straight lines.

##### 7.3.1 Primary Linear Path (Happy Path)

| # | Transition | Conversion Rate (Low-Expected-High) | Benchmark Source | Confidence Grade | Stage-Gate Criteria (Measurable) | Time-to-Value Target | Champion Advocacy |
|---|---|---|---|---|---|---|---|
| 1 | **Attract → Diagnose** | [%] – [%] – [%] | [Published benchmark or `[S]`] | `[H]` or `[S]` | Prospect completes Snapshot request form AND connects CRM data OR uploads CSV | Content: immediate. Data connection: ≤48 hrs. | N/A — this is the first touch |
| 2 | **Diagnose → Prove** | [%] – [%] – [%] | [Benchmark or `[S]`] | `[H]` or `[S]` | ALL of: (a) Snapshot identifies ≥EUR X in recoverable revenue, (b) champion schedules results review within 7 days, (c) champion confirms budget per §2.3 | ≤48 hrs to one number; ≤14 days to first recovered EUR | "We ran the free diagnostic. It found EUR X. The Sprint recovers the top 5 in 14 days, guaranteed. I need EUR Y approval." |
| 3 | **Prove → Commit** | [%] – [%] – [%] | [Benchmark or `[S]`] | `[H]` or `[S]` | ALL of: (a) Sprint delivered EUR ≥3× Sprint fee in recovered/recoverable revenue, (b) client champion confirms ongoing need, (c) contract signed | ≤7 days from go-live to first intelligence brief | "In 90 days, we recovered EUR Z. At EUR Y/mo, this pays for itself. The ongoing service catches the NEXT leak before it grows." |
| 4 | **Commit → Expand** | [%] – [%] – [%] | [Benchmark or `[S]`] | `[H]` or `[S]` | ALL of: (a) client has been recurring for ≥6 months, (b) expansion signal combination from §6B.4 fires, (c) champion confirms adjacent pain exists | ≤30 days from expansion trigger to first new-service output | "We've been monitoring your [core pain] for 6 months. The data also shows EUR X in [adjacent pain]. Here's the mini-diagnostic — same format, same proof." |

**Compound probability calculation (MANDATORY):** End-to-end from Attract → Commit = [Transition 1 conversion %] × [Transition 2 conversion %] × [Transition 3 conversion %] = [X%]. At [Y] Diagnose-stage entrants per month, this produces [Z] recurring clients per month. At [EUR price] per recurring client, monthly recurring revenue from this journey = EUR [amount]. Is this viable? `[S]` until validated.

**§13.2 reconciliation (MANDATORY):** The §7.3.1 end-to-end compound probability (journey-based) MUST reconcile with the §13.2 end-to-end rates (channel-based) within ±20% tolerance. These are the SAME funnel modeled from different starting points. If §7.3.1 produces 2% end-to-end and §13.2 warm channel produces 0.5-5.3% end-to-end, the journey-based rate should fall within the channel-based range. If the models diverge by >20%: (a) the conversion rates in one model are wrong, or (b) the channel mix assumption differs from the journey assumption. Resolve and document the reconciliation. This reconciliation is checked in the Canvas-Level Gates (§4.2). `[DESIGN]`.

##### 7.3.2 Non-Linear Paths (Equally Important)

B2B buyers do not move in straight lines. The journey must accommodate:

| Path | Description | Designed Response | Re-Entry Criteria |
|---|---|---|---|
| **Nurture Loop** | Buyer completes Diagnose, sees value, but isn't ready to buy now ("check back in Q3") | 6-month nurture sequence from §13.8. Benchmark context emails. "Your EUR X leakage vs. peers." Risk-reversed re-offer at Month 6. | New trigger fires from §6A, OR buyer requests re-engagement, OR 6-month nurture cadence |
| **Skip Path** | Warm referral enters directly at Prove, bypassing Attract + Diagnose (existing client vouches for the concept) | Bob runs abbreviated Snapshot as part of Prove kickoff (not as a separate stage). Reference the referring client's results. | Referred by existing client OR aggregator partner who pre-qualified |
| **Resurrection Path** | Buyer stalled for 6-12 months. New trigger fires (new CRO, missed quarter). | Re-enter at Diagnose with fresh Snapshot on current data. Reference: "When we last looked, you had EUR X in leakage. Let's see what's changed." | New §6A trigger fires AND previous Snapshot is >6 months old |
| **Expansion Loop** | Committed client → mini-Diagnose for adjacent pain → Expand service. Not a separate sale — a built-in expansion engine. | Every 6 months, run expansion diagnostic on adjacent pain area. Present findings in QBR. "We found EUR X in [adjacent area]. Same proof, same guarantee." | Expansion signal combination from §6B.4 fires AND client has been recurring ≥6 months |
| **Churn Path** | Client cancels recurring service. | 90-day data retention. Exit interview captures reason. Win-back nurture at Month 12: "Here's what's changed since you left." If cancellation was budget-driven, offer reduced scope at lower tier. If value-driven, offer re-Snapshot to prove the problem has grown. | 12 months post-cancellation OR new trigger fires at their company |
| **Non-Converter Path** | Buyer completes Diagnose but never converts. 80-95% of entrants. | They're not failures — they're future opportunities. Keep Snapshot output. Send benchmark context quarterly. When a new trigger fires at their company, they're pre-warmed. | New trigger fires AND ≥6 months since last Snapshot |

**Referral mechanics (cross-cutting, not a stage):** Referral is possible at ANY stage — a buyer who never converts can still refer if the Snapshot experience was exceptional. Referral trigger per stage:
- After Diagnose: "Know another [niche title] who'd want to see THEIR number? The Snapshot is free for them too."
- After Prove (successful Sprint): "Your results: EUR X recovered. Would you introduce us to 2 peers? Here's a blurb you can forward."
- At Commit (6+ months, high NPS): Formal referral program — "Refer a client, get [incentive]."

Specific referral trigger: client has recovered ≥EUR X AND NPS ≥9 AND has been a client for ≥90 days → Bob asks for 2 introductions. `[DESIGN]`.

##### 7.3.3 Bowtie Funnel Overlay

The journey is not just an acquisition funnel. Map each stage to its Bowtie Funnel side:

| Journey Stage | Bowtie Funnel Side | Metric | Target |
|---|---|---|---|
| Attract | Acquisition | Content engagement → Snapshot request rate | Per §13.2 funnel model |
| Diagnose | Acquisition | Snapshot completion rate; Diagnose → Prove conversion | ≥80% completion; conversion per table above |
| Prove | Acquisition | Prove → Commit conversion; CAC payback | Conversion per table above; payback ≤6 months |
| Commit | Retention | Monthly churn rate; NPS; signal action rate | Churn <1.5%/month; NPS ≥30; action rate ≥60% |
| Expand | Expansion | Expansion revenue per client; products per client | ≥1 expansion per client by Month 12 |
| All stages | Advocacy | Referral rate (% of clients who refer) | ≥20% of clients refer within 12 months |

---

#### 7.4 Offer Economics Summary

**Purpose:** Model the unit economics at each stage. Every number carries an evidence grade. At zero clients, most numbers are `[S]` — this is honest, not a weakness.

**Evidence grade rule:** Each field inherits the weakest evidence grade among its components. Revenue numbers are `[S]` at zero clients. Cost numbers are `[S]` until first delivery.

| Stage | Revenue per Client (EUR) | Evidence Grade | Delivery Cost per Client (EUR) | Evidence Grade | Gross Margin | Breakeven (Months) |
|---|---|---|---|---|---|---|
| Diagnose (Free) | 0 | `[P]` | [Fixed amortized + variable] | `[S]` until first delivery | N/A (CAC investment) | N/A |
| Prove (Paid Entry) | [Price from §9] | Inherits from §9 | [Founder hrs × rate + compute + enrichment] | `[S]` | [%] | [CAC ÷ monthly margin] |
| Commit (Recurring) | [Monthly price × avg duration] | Inherits from §10 | [Per-client variable + amortized fixed] | `[S]` | [%] | [CAC ÷ monthly margin] |
| Expand | [Expansion price × uptake %] | `[S]` | [Incremental delivery cost] | `[S]` | [%] | N/A (existing client) |

**Cost decomposition (fixed vs. variable):**

| Cost Type | Examples | At 5 Clients (EUR/mo) | At 20 Clients (EUR/mo) | At 100 Clients (EUR/mo) |
|---|---|---|---|---|
| **Fixed (amortized)** | Workflow development, benchmark infrastructure, monitoring, dashboard hosting | [Total ÷ 5] | [Total ÷ 20] | [Total ÷ 100] |
| **Variable (per-client)** | Compute, enrichment APIs, LLM tokens, Clay credits, human review time | [Per-client × 5] | [Per-client × 20] | [Per-client × 100] |
| **Total delivery cost** | | [Fixed + Variable] | [Fixed + Variable] | [Fixed + Variable] |
| **Cost per client** | | [Total ÷ 5] | [Total ÷ 20] | [Total ÷ 100] |

**Margin trajectory:** At 5 clients, margin is typically lower (fixed costs spread over few clients). At 20 clients, margin should approach the target from §11.7 (70-85% for automated workflows). At 100 clients, margin should reflect near-full automation. If margin doesn't improve with scale, the service isn't actually automated. `[S]` until validated.

**Founder capacity allocation per stage (binding — per §13):**

| Stage | Who | Hours per Buyer | Capacity Ceiling (per Week) | Overflow Procedure |
|---|---|---|---|---|
| Diagnose (review call) | Bob | 0.5 hrs | 10 calls/week | >10: Adriaan handles overflow calls |
| Prove (close + onboard) | Bob (close) + Adriaan (onboard) | 3 hrs (Bob) + 4 hrs (Adriaan) | 3 new Sprints/week (Bob) | >3: commission rep handles discovery; Bob closes only |
| Commit (onboarding + QBR) | Adriaan (Month 1 onboarding) + Bob (monthly QBR) | 6 hrs (Adriaan, one-time) + 1 hr/mo (Bob) | 4 new clients/month (Adriaan) | >4: hire part-time onboarding specialist |
| Expand (upsell) | Bob | 2 hrs | 4 conversations/month | >4: prioritize by expansion revenue potential |

**Time-to-breakeven per client:** Total CAC (all founder hours + tool costs through Prove stage) ÷ monthly recurring margin = [N] months. Target: <6 months. `[S]` until validated.

---

#### 7.5 Journey Pre-Mortem & Assumption Audit

**Purpose:** Surface and stress-test the assumptions the entire journey depends on. This is the red-team checkpoint before the canvas proceeds to service design (§8-10).

**Applied lenses:** Red-Team (pre-mortem, hinge assumption, kill metrics, minimum viable journey), Strategy Consultant (scenario planning)

##### 7.5.1 Journey Pre-Mortem

"It's 18 months from now. ClarityRev executed the journey as designed in this niche. <5% of Snapshots convert to paid. Why?"

The agent must write the specific failure narrative for THIS niche. NOT generic ("the product was bad") — niche-specific. Consider:

- **The Snapshot didn't create urgency.** Buyers said "interesting" but didn't act. Why? The pain wasn't acute enough? The EUR number wasn't big enough? The champion didn't have authority to act on it?
- **The Prove stage didn't convert to Commit.** The Sprint delivered value but clients saw it as a one-time fix, not an ongoing need. "We recovered the top 5 deals. We're good now."
- **Competitor response neutralized the hinge.** A competitor launched an identical free diagnostic, and buyers couldn't distinguish ClarityRev's from theirs.
- **Adoption failed.** The intelligence was good. Nobody acted on it. (See §6.8.1 Link 2 pre-mortem.)
- **Buyer organization wasn't ready.** The champion loved it. Procurement killed it. Legal sat on the DPA for 6 months. The champion left the company.

The agent selects the 2-3 most likely failure modes for THIS niche and writes the specific narrative.

##### 7.5.2 Hinge Assumption Stress Test

From §7.2 hinge assumption. Restated here: **"The Snapshot produces a number that creates buying urgency in THIS niche."**

Stress-test at three output levels (agent must populate with niche-specific numbers):

| Snapshot Finding | Buyer Reaction (Optimistic) | Buyer Reaction (Pessimistic) | % of Snapshots Expected in This Band | Thesis Survives at Pessimistic? |
|---|---|---|---|---|
| <EUR X (small) | "Still worth fixing" | "Not worth the effort — we'll handle internally" | [%] | FRAGILE if >40% — too many Snapshots produce no urgency |
| EUR X-Y (credible, urgent) | "We need to fix this. What's next?" | "Interesting. Let me check with my team." | [%] | DEPENDS — the number alone may not be enough |
| >EUR Y (large — potentially unbelievable) | "This confirms what I suspected" | "Your algorithm must be wrong — our pipeline isn't THAT bad" | [%] | FRAGILE if >20% — requires data-backed credibility |

##### 7.5.3 Per-Transition Kill Metrics

What early signals indicate the JOURNEY DESIGN (not execution) is wrong for this niche? These are thresholds where the problem is structural, not something better sales execution can fix.

| Transition | Kill Metric | Threshold | Action If Tripped |
|---|---|---|---|
| Attract → Diagnose | Snapshot request rate | <0.5% after 500 outreaches | Attract content or targeting wrong. Redesign before scaling outreach. |
| Diagnose → Prove | % of Snapshots that produce urgency | <30% of Snapshots find ≥EUR X in leakage | Pain not acute enough in this niche OR Snapshot isn't detecting the right things. Revisit §3 pain quantification. |
| Diagnose → Prove | % of Snapshots that convert to paid | <5% after 50 Snapshots delivered | The Snapshot number doesn't create buying urgency. Redesign the conversion hook (§7.2) or the Prove offer (§9). |
| Prove → Commit | % of Sprints that convert to recurring | <25% after 20 Sprints | The Sprint delivers value but doesn't create ongoing need. Revisit §10 recurring value proposition. |
| Commit | Monthly churn rate | >3%/month for 3 consecutive months | The recurring service isn't delivering ongoing value. Investigate signal quality (§6B.10) or adoption (§6.8.6). |
| Any stage | Same objection from >50% of buyers | [Objection text] | The objection is structural, not situational. Address in offer design or accept the niche is blocked. |

##### 7.5.4 Minimum Viable Journey (The Skeptical Advisor's Critique)

**The critique the founders' most skeptical advisor would give:**

> "You've designed a beautiful 6-stage journey. You have zero clients. You don't know if Stage 2 works, let alone Stage 6. You're optimizing a funnel with no one in it. Design the first two stages — Diagnose and Prove — and nothing else. Prove the hinge works. Prove someone will pay. THEN design stages 3-6. You're building a cathedral when you need a door."

**Minimum viable journey sequencing:**

1. **Phase 1 (Validate the hinge):** Build and test ONLY the Diagnose → Prove transition. Run 20 Snapshots. Target: ≥X% of Snapshots create urgency; ≥Y% convert to paid Sprint. If the hinge doesn't work, nothing else matters.
2. **Phase 2 (Prove recurring value):** With 5+ paying clients from Phase 1, validate the Prove → Commit transition. Prove clients see ongoing value, not just a one-time fix.
3. **Phase 3 (Design expansion):** With 10+ recurring clients and ≥6 months of data, design the Expand stage based on actual signal patterns, not predictions.
4. **Phase 4 (Activate Compound):** At 20+ clients, assess whether compounding is real — does each new client actually make delivery cheaper/better?

This sequencing is BINDING. The full 6-stage journey is designed now for portfolio comparison purposes, but build investment follows this sequence. `[DESIGN]`.

##### 7.5.5 Journey Scenario Planning

Three alternative futures for this niche's journey. Which is the recommendation betting on? What's the hedge?

| Scenario | Description | Probability | Hedge |
|---|---|---|---|
| **Optimistic** | Aggregator partners accelerate Diagnose stage (partners offer Snapshot as client lead-gen). Conversion rates meet or exceed benchmarks. First-mover advantage in niche. | [%] | None needed — double down on partner channel. |
| **Pessimistic** | Competitor launches identical free diagnostic within 12 months. Diagnose stage commoditized. Competitive advantage shifts to Prove → Commit (managed interpretation competitors can't replicate). | [%] | Build switching costs early (benchmark data, CRM-native delivery, workflow embedding). Invest in Prove-stage differentiation, not Diagnose-stage exclusivity. |
| **Disruptive** | CRM platform builds Snapshot-like feature natively. Journey collapses at Diagnose — buyers get the diagnostic from their CRM vendor for free. | [%] | ClarityRev's advantage shifts entirely to managed interpretation + multi-source signals. The Snapshot becomes a feature, not a product. Pivot to: "The CRM shows you what's wrong. We fix it." |

`[S]` — scenarios, must be flagged.

---

#### 7.6 Journey Technical Specification

**Purpose:** Specify what must be built to operationalize this journey. A senior engineer (Wesley) should be able to implement stage transitions from this spec.

**Applied lenses:** Systems Designer (data flow, instrumentation, automation feasibility, FMEA)

##### 7.6.1 Stage Transition Data Contracts

What data passes between stages? Wesley needs this to build stage transition automation.

| Transition | Data Passed | Format | Source System | Destination System | Mechanism | Error Handling |
|---|---|---|---|---|---|---|
| Attract → Diagnose | Prospect company name, CRM type, champion email, Snapshot request timestamp | JSON | Website form / partner referral link | Snapshot engine queue | API POST to Snapshot engine | Retry 3× with exponential backoff; alert Adriaan if queued >4 hrs |
| Diagnose → Prove | Snapshot output (leakage EUR, top 5 recoverable deals, recommended Sprint scope), champion contact, budget confirmation | JSON | Snapshot engine | HubSpot Deal record + Sprint proposal generator | Webhook on Snapshot completion → create Deal → trigger proposal generation | Retry; if proposal generation fails, Adriaan manually creates from template |
| Prove → Commit | Sprint results (EUR recovered, deals saved, client feedback), signal configuration (which signals from §6B are active) | JSON | Sprint tracker | HubSpot (Deal → Closed Won) + Recurring delivery engine (signal config) | Webhook on Deal close → provision recurring service + activate signal monitoring | Retry; if provisioning fails, Adriaan manually onboards |
| Commit → Expand | Client signal history (6+ months), expansion diagnostic output, adjacent pain quantification | JSON | Recurring delivery engine | HubSpot (new Opportunity) + Expansion proposal generator | Triggered by expansion signal combination (§6B.4) → create Opportunity → generate mini-diagnostic | Retry; if mini-diagnostic fails, Bob runs manually from QBR data |

##### 7.6.2 Journey Instrumentation Spec

How does ClarityRev know a buyer is at a specific stage? What automation fires?

| Stage | CRM Stage Field | Entry Trigger | Exit Trigger (Advances Buyer) | Stall Alert (Buyer in Stage >X Days) | Notification on Entry | Notification on Stall |
|---|---|---|---|---|---|---|
| Diagnose | "Snapshot Requested" → "Data Connected" → "Results Delivered" | Snapshot request form submitted | Results delivered + champion schedules review | >7 days in "Data Connected" without results: alert Adriaan (possible data quality issue) | Bob: "New Snapshot request from [Company]" | Bob: "[Company] Snapshot results undelivered for 7 days" |
| Prove | "Sprint Proposed" → "Contract Sent" → "Sprint Active" → "Results Delivered" | Deal created in HubSpot + proposal sent | Sprint results delivered + ROI documented | >14 days in "Contract Sent": alert Bob (deal stalling) | Adriaan: "New Sprint started for [Company]" | Bob: "[Company] contract unsigned for 14 days" |
| Commit | "Onboarding" → "Active" → "At Risk" → "Churned" | Deal Closed Won | N/A (steady state) | >30 days since last signal actioned: alert Bob (adoption dropping) | Bob + Adriaan: "New recurring client: [Company]" | Bob: "[Company] signal action rate below 20% for 30 days" |
| Expand | "Expansion Proposed" → "Expansion Active" | Expansion signal combination fires | Expansion service active | N/A | Bob: "Expansion trigger fired for [Company]" | N/A |

**Stage duration SLAs:** Diagnose: ≤48 hrs from data connection to results. Prove: ≤14 days from Sprint start to first recovered EUR. Commit onboarding: ≤7 days from contract to first intelligence brief. `[DESIGN]`.

##### 7.6.3 Stage Automation Feasibility

| Stage | % Automated | Tools/APIs Powering Automation | Human Touchpoints | Automation Ceiling | Build Dependencies |
|---|---|---|---|---|---|
| Diagnose | 90% | Snapshot engine (CRM API + signal detection + LLM analysis + report generation) | Bob: 30-min results review call | 95% — call can become async (recorded video walkthrough) once process is proven | CRM integration (§1.4), Snapshot engine, report template |
| Prove | 50% | Sprint tracker (HubSpot), proposal generator, automated check-ins | Bob: close (3 hrs). Adriaan: onboard (4 hrs), weekly check-ins. | 70% — proposal + tracking automated; close + onboarding remain human | Snapshot engine, HubSpot, proposal template, guarantee tracking |
| Commit | 80% | Recurring delivery engine (signal detection + enrichment + LLM analysis + CRM-native delivery per §6B.3) | Adriaan: Month 1 onboarding (6 hrs). Bob: monthly QBR (1 hr). | 90% — onboarding can be systematized; QBR becomes quarterly | All §11 workflows for this niche, CRM integration, client dashboard |
| Expand | 40% | Mini-diagnostic engine (subset of Snapshot on adjacent pain area) | Bob: upsell conversation (2 hrs). Adriaan: expanded service setup. | 60% — diagnostic automated; upsell conversation remains human | Expansion signal combination logic (§6B.4), mini-diagnostic engine |

##### 7.6.4 FMEA — Journey Transition Failures

| Transition | Failure Mode | Effect | Detection Method | Response Procedure |
|---|---|---|---|---|
| Attract → Diagnose | Snapshot landing page broken / form submission fails | Zero Snapshots, silent revenue blockage | Monitor: Snapshot request rate drops to 0 for >48 hrs. Alert: Wesley | Fix page. If >72 hrs, Bob manually processes requests via email. |
| Data → Snapshot output | CRM API connection fails mid-Snapshot | Snapshot incomplete, buyer waits, trust erodes | Monitor: Snapshot completion rate drops. Alert: Wesley per affected Snapshot | Retry connection. If persistent, request CSV upload. Notify buyer of delay within 4 hrs. |
| Snapshot → Results delivery | Snapshot finds EUR 0 in leakage / no meaningful signals | No urgency created, buyer walks | Monitor: % of Snapshots below urgency threshold. Alert: Bob if >30% | Follow honest negative protocol (§12.9). Nurture. Investigate: data quality issue or genuinely healthy pipeline? |
| Diagnose → Prove | Buyer doesn't schedule results review after Snapshot delivered | Stalled at the hinge | Monitor: >7 days since results delivered without review scheduled. Alert: Bob | Bob sends personalized follow-up: "Your EUR X number. Want to see what recovery looks like?" If no response in 14 days → nurture sequence. |
| Prove → Commit | Sprint delivers but client sees it as one-time fix | No recurring conversion, revenue capped per client | Monitor: Sprint → Commit conversion rate. If <25% after 20 Sprints, escalate | Redesign Prove → Commit transition: during Sprint, seed recurring value ("Here's what we'd catch NEXT month"). |
| Commit | Signal action rate drops below 20% for 2 consecutive months | Client not using the service, churn imminent | Monitor: per-client signal action rate. Alert: Bob if <20% for 60 days | Adoption intervention (§6.8.6): direct-to-end-user signals, manager visibility, executive summary to economic buyer. |

---

**Done (minimum viable — FULL §7):** MECE verification gate completed. All APPLIES stages in §7.1 with: evidence grade inheritance on all fields, JTBD per stage, TTV targets, measurable stage-gate criteria, champion advocacy mapping, and founder time allocation. Competitive journey comparison (§7.1a) with Strategy Canvas. Diagnose Snapshot fully specified with hinge assumption stress-tested at 3 output levels. Pricing ladder architecture (§7.2a) with value-to-price ratios and competitor anchoring. Journey map (§7.3) with: explicit conversion rates (low-expected-high) per transition, benchmark anchoring or `[S]` flag, compound probability calculation, non-linear paths (nurture, skip, resurrection, expansion loop, churn, non-converter), Bowtie Funnel overlay, and cross-cutting referral mechanics. Offer economics (§7.4) with: per-stage revenue/cost/margin/breakeven, cost decomposition (fixed vs. variable at 5/20/100 clients), founder capacity allocation, and margin trajectory. Journey pre-mortem (§7.5) with: specific failure narrative, hinge assumption stress test, per-transition kill metrics, minimum viable journey sequencing, and scenario planning. Journey technical specification (§7.6) with: stage transition data contracts, journey instrumentation (CRM fields + triggers + stall alerts), automation feasibility per stage, and FMEA for top journey transitions.

**Excellent:** All conversion estimates are benchmark-anchored or honestly flagged `[S]`. The hinge assumption stress test includes niche-specific numbers and buyer reactions. The competitive journey comparison names specific competitors and their free→paid mechanisms. The pricing ladder shows value-to-price ratio declining monotonically (highest at free, lowest at enterprise). The non-linear paths are as detailed as the primary path. The journey pre-mortem is specific enough that someone who knows the niche would say "yes, that's exactly how it would fail." The minimum viable journey is respected — stages 4-6 are designed on paper but not funded for build until stages 1-3 are proven. The skeptic's quote is verbatim and uncomfortable. The FMEA covers the top 3 failure modes with specific detection methods and response procedures. The founder capacity allocation shows exactly when Bob runs out of hours — and what happens then.

**ADVERSARIAL CHECK (extended):** "Did we default to all 6 stages? Is the Compound mechanism realistic? Does every stage exist because THIS niche needs it, or because the template has 6 slots? The minimum viable journey forces honesty: at zero clients, only Diagnose and Prove should be built. Stages 3-6 are designed for portfolio comparison, not funded for build. Is the hinge assumption surfaced and stress-tested? If the Snapshot doesn't create urgency in THIS niche, nothing else matters — is that assumption stated, tested at 3 output levels, and assigned a confidence grade? Are non-linear paths designed, or does the journey assume buyers move in straight lines? If a buyer stalls for 12 months, do we have a designed response or do they just fall out of the CRM? Is the founder capacity constraint respected — can Bob actually execute this journey for 10 simultaneous buyers? At what buyer count does the journey break on founder time?"

**Cross-references to update:**
- §1.6: RIOS APPLIES/SKIP verified against §7 niche realities
- §2.2b: Champion's internal sales playbook → §7.1 champion advocacy column
- §3.3: ROI proof structure → §7.1 one-number outcome + §7.2 hinge assumption
- §4.1: Competitor pricing → §7.2a competitor anchoring
- §6B.4: Signal → expansion trigger → §7.3 expansion loop
- §8-10: Free/Paid/Recurring service design → §7.1 offer names + pricing

---

### SECTION 8: Free Entry Services (Attract + Diagnose)

**Purpose:** Design the complete free layer. The free layer is not a collection of giveaways — it is a designed entry system with a specific strategic job, MECE coverage of entry paths, and modeled economics. Every free service must be traceable to a specific pain (§3), use buyer language (§2.6), work within data accessibility constraints (§1.4), surface specific signals from §6B, and have an explicit competitive decision: Match, Differentiate, or Skip.

**Applied lenses:** GTM Architect (free-to-paid ascension, conversion model, sales usage), Systems Designer (build spec, health monitoring, scaling limits, versioning), Strategy Consultant (strategic job, MECE coverage, competitive positioning, cost model), Research Analyst (evidence grades, competitor source verification, demand validation), Red-Team (free anchoring risk, pre-mortem, breakeven analysis)

**Design principles (binding):**
1. **The free layer has one strategic job for this niche.** State it before designing: (a) Attract Volume — wide funnel, many Snapshots, optimize for quantity; (b) Pre-Qualify — filter out non-buyers, only qualified prospects reach paid stage; (c) Educate the Market — category creation, buyers don't know they have this problem; (d) Demonstrate Superiority — prove ClarityRev is better than competitors before asking for money. The strategic job determines which free services to build, how they're distributed, and what "success" looks like. `[DESIGN]`.
2. **"Differentiate on everything" is a trap.** If a competitor's free tool is excellent, Match it and add ONE differentiating element (faster turnaround, niche-specific language, deeper insight). Don't reinvent what already works.
3. **Free services are an investment, not a cost center.** Every free service has a delivery cost. The free layer must have a modeled breakeven conversion rate. If actual conversion falls below breakeven for 6 months, the free service is redesigned or retired.
4. **"Free" creates a psychological anchor.** Buyers who receive value for free may resist paying for the next step. Every free service must include a conversion hook that makes the paid step feel like a natural extension, not a bait-and-switch.

---

#### 8.1 Competitor Free Layer Audit (Do This First)

Structured table mapping what the top 3 competitors offer for free. This informs — but does not dictate — ClarityRev's free layer.

**Source verification requirement:** For each competitor's free tool listed, the agent must personally verify by visiting the competitor's website. Record: URL visited, date of visit, and the specific page/section where the free tool is described. Competitor free tools NOT personally verified must be marked `[H]`. `[E]` if personally verified within 30 days.

| Competitor | Free Tool / Trial / Asset | How It Works | Strengths | Gaps / Weaknesses | ClarityRev Decision | Strategic Intent |
|---|---|---|---|---|---|---|
| Comp A | [Name + type] | [Mechanism] | [What's good] | [What's missing] | Match / Differentiate / Skip | WHY this decision? "Match and add niche-specific benchmark because..." / "Differentiate on turnaround because..." / "Skip because cost-to-match exceeds strategic value..." |
| Comp B | ... | ... | ... | ... | ... | ... |
| Comp C | ... | ... | ... | ... | ... | ... |

**Decision logic:**
- **Match:** The competitor's free tool is exactly what buyers need and there's no meaningful way to improve it. Match the capability but add one differentiating element. Document the element.
- **Differentiate:** The competitor's free tool has a clear gap ClarityRev can exploit. Build something genuinely different. Document the gap.
- **Skip:** The competitor's free tool serves a need ClarityRev doesn't need to address in the free layer, or the cost to match isn't justified. Document the rationale.

---

#### 8.1a Competitive Free-Layer Strategy Canvas

**Purpose:** Plot ClarityRev's free layer against competitors on the factors that matter for free-to-paid conversion. Prevents free-layer design in a vacuum.

| Factor (1-5, 1=worst, 5=best) | Competitor A | Competitor B | Competitor C | ClarityRev | Strategic Implication |
|---|---|---|---|---|---|
| **Speed-to-value** — how fast does the free tool produce a meaningful output? | [1-5] | [1-5] | [1-5] | [1-5] | |
| **Depth of insight** — how specific and actionable is the free output? | [1-5] | [1-5] | [1-5] | [1-5] | |
| **Data friction** — how hard is it to get started? (1=requires IT involvement, 5=no data required) | [1-5] | [1-5] | [1-5] | [1-5] | |
| **Niche relevance** — does it speak THIS niche's language, or is it generic? | [1-5] | [1-5] | [1-5] | [1-5] | |
| **Conversion hook strength** — how naturally does the free output lead to the paid offer? | [1-5] | [1-5] | [1-5] | [1-5] | |

**Positioning implication:** One sentence. "Competitors' free tools tell you WHAT. ClarityRev's free tools tell you WHAT and exactly WHAT TO DO NEXT — and the 'what to do next' IS the paid service."

---

#### 8.2 Free Service Design (≥3 Services)

**Free service tiering — required before designing individual services.** Free services form a commitment gradient. Not all prospects are ready for a data-connected diagnostic. Design services at multiple commitment levels:

| Tier | Commitment Level | Data Required? | Example | Best For | Expected Volume |
|---|---|---|---|---|---|
| **TIER 1: Zero-Friction** | None — instant value, no data | No data required | Industry benchmark report, "State of [Niche] 2026" PDF, ROI calculator with sliders | Top-of-funnel, LinkedIn ads, cold outreach lead magnet | Highest (100-500/month) |
| **TIER 2: Low-Friction** | Email + minimal inputs | 3-5 self-reported metrics | Online scorecard ("Rate your pipeline health in 2 minutes"), self-assessment | Mid-funnel, website visitors, event follow-up | Medium (20-100/month) |
| **TIER 3: Data-Connected** | CRM/ATS data connection (OAuth or CSV) | Full data access required | The Snapshot — ClarityRev's hinge diagnostic | Bottom-of-funnel, warm prospects, partner-referred | Lowest (5-20/month) |

**Rule:** Every niche must have at least one service at each tier. The Snapshot (Tier 3) is mandatory per §7.2. Tier 1 and Tier 2 services feed Tier 3. `[DESIGN]`.

**Coverage verification (MECE):** After designing all free services, verify: "Do these services collectively cover every free entry path for this niche? Is there a buyer persona from §2 who has NO natural free entry point? Is there overlap where two services serve the same buyer in the same way?" If a gap exists, design the bridge. If overlap exists, consolidate or differentiate.

For each free service, complete all fields. Every field that makes a factual claim must carry or state its inherited evidence grade. Design decisions are marked `[DESIGN]`.

- **Service name** — must use buyer language from §2.6. No generic names. `[DESIGN]`.
- **Free service tier** — Tier 1 (Zero-Friction), Tier 2 (Low-Friction), or Tier 3 (Data-Connected). `[DESIGN]`.
- **Which pain from §3 does this expose?** Direct traceability. State the inherited evidence grade from §3. Inherits weakest grade from §3.
- **Which signals from §6B does this free service surface?** Direct traceability to the Client Signal Catalog. State which specific signal IDs from §6B.2 are included. `[E]` from §6B.
- **Competitive decision:** Match, Differentiate, or Skip vs. each competitor's equivalent (from §8.1 table). Include the strategic intent from §8.1. `[DESIGN]`.
- **What does it produce?** Specific output. One number, one insight, one list, one benchmark. Not "valuable insights" — a specific, named deliverable. `[DESIGN]`.
- **Data required** — from §1.4. Must work within GREEN/YELLOW constraints. State the inherited evidence grade from §1.4. For Tier 3: specify exact CRM/ATS fields, OAuth scopes, or CSV columns required. Inherits weakest grade from §1.4.
- **Turnaround** — target ≤48 hours for anything requiring data access. For Tier 1: instant. For Tier 2: ≤5 minutes. `[DESIGN]`.
- **How does it fit into the buyer's current workflow?** From §2.4 — don't make them change behavior. Delivered where they already work (email, CRM, LinkedIn). `[DESIGN]`.
- **Conversion hook to paid** — specifically which paid service from §9, and exactly what in the output triggers the transition. Not "they see value and buy." Specific: "The Snapshot output shows the top 5 recoverable deals, ranked by EUR. The report footer says: 'Recover the top 3 in 14 days. EUR X. Guaranteed 3× ROI or free. [Link to schedule Sprint kickoff].'" `[DESIGN]`.
- **Bob's Usage (verbatim):** Exactly how Bob introduces this free service in a conversation. When does he offer it? What does he say? What does he do after? "On a call with a [champion title] who mentions [pain from §3]: Bob says '[verbatim, ≤50 words].' Bob sends the link during the call. Bob follows up within 48 hours of them completing it." `[DESIGN]`.
- **Objection handling (top 2):** The most common objections to THIS free service and Bob's verbatim response.
  - Objection 1: "[Most common pushback]." Bob's response: "[verbatim, ≤50 words]."
  - Objection 2: "[Second most common pushback]." Bob's response: "[verbatim, ≤50 words]." `[DESIGN]`.
- **MEDDIC qualification:** Which MEDDIC elements does this free service help qualify? Metrics (quantifies the pain) / Economic Buyer (identifies who cares) / Decision Criteria (shows what matters) / Pain (identifies champion) / Champion (gives champion internal ammunition) / Competition (shows ClarityRev's differentiation). Map each. `[DESIGN]`.
- **Conversion model (per service):**
  - Expected conversion rate to paid: [X%] (low [Y%] – high [Z%]). `[S]` until 20+ data points.
  - Average time-to-conversion: [N] days from free service completion to paid Sprint start. `[S]`.
  - Most common stall point: [Where do prospects get stuck?]. `[H]`.
  - Confidence in this conversion estimate: HIGH / MEDIUM / LOW. `[H]` or `[S]`.
- **Delivery cost per unit:** Compute, API credits, LLM tokens, enrichment, human review time. Estimate with range. `[S]` until first 20 deliveries.
- **Build specification:**
  - Tools/APIs powering this service: [List specific tools, APIs, data sources].
  - Build effort: S (<1 day) / M (2-5 days) / L (1-2 weeks) / XL (3+ weeks).
  - Dependencies: [What must be built first? CRM integration? Signal pipeline? §11 workflows?].
  - Cost per run (EUR): [Estimate with range].
- **Demand validation:** What evidence exists that buyers in this niche would use this free service? Search volume for related terms? Competitor free tool adoption (G2 reviews mentioning it)? Analogous free tool success in adjacent niche? Or is this purely a hypothesis? `[E]` if evidence exists, `[H]` if inferred, `[S]` if pure guess.
- **Niche-name-swap test** — if you swapped the niche name, would this service work unchanged for any of the other 24 niches? If yes, it's not specific enough. Redesign. `[DESIGN]`.

---

#### 8.3 Free Layer Distribution

Distribution is specified per service, not as a generic list. For each free service:

- **Primary distribution channel:** Where does the buyer encounter this free service? (Website tool page, LinkedIn ad → landing page, partner's client portal, cold outreach link, event/conference, aggregator-forward).
- **SEO/SEM strategy:** Target keywords for this free service. Search volume if available. `[E]` if search volume data exists, `[S]` otherwise.
- **Aggregator-native version:** Can a partner white-label or forward this free service? What's the co-branded version? "Agency partners offer the '[Agency Name] Pipeline Health Scorecard' — ClarityRev-white-labeled, partner-branded. Prospect enters data, receives partner-branded output. ClarityRev branding appears in the footer: 'Powered by ClarityRev.'" `[DESIGN]`.
- **Distribution cost per channel:** Estimated cost per free-service completion by channel. LinkedIn ads: EUR X/CPC × conversion rate = EUR Y/completion. Partner-forwarded: near-zero marginal cost. `[S]` until validated.
- **Channel experiment design:** "Test: distribute [free service] via [channel] for 30 days. Target: ≥[N] completions at ≤EUR [X]/completion. If ≥threshold → scale channel. If <threshold → investigate or abandon channel." `[DESIGN]`.

---

#### 8.4 Free-to-Paid Conversion Design

- **Per-service conversion model:** See §8.2 per-service conversion fields. The aggregate free-to-paid conversion rate is the weighted average across all free services. Calculate it.
- **What happens when a prospect completes a free service?** Specific sequence per tier:
  - Tier 1 (Zero-Friction): Thank-you page → "Want to see YOUR number? The Snapshot is free, takes 48 hours." → nurture sequence if no Snapshot request within 14 days.
  - Tier 2 (Low-Friction): Personalized results page → "This is based on your self-assessment. The Snapshot uses your ACTUAL CRM data — same format, real numbers. Free. 48 hours." → Bob or automated follow-up within 48 hours.
  - Tier 3 (Data-Connected): Results delivered → Bob's call within 48 hours → "Here's your number. Want to see what recovery looks like?" If no Sprint within 14 days → nurture sequence from §13.8.
- **Nurture for non-converters (per tier):**
  - Tier 1 non-converters: "You downloaded the [niche] benchmark. Here's how [Company A] used it to find EUR X in leakage." → Tier 2 offer.
  - Tier 2 non-converters: "Your scorecard showed [result]. Companies with similar scores typically find EUR X in leakage. Free Snapshot?" → Tier 3 offer.
  - Tier 3 non-converters: §13.8 nurture sequence. "Your EUR X gap" → benchmark context → case proof → risk-reversed re-offer at Month 6.
- **Free-to-paid conversion time:** Track time from free service completion → paid Sprint start. Median, p25, p75. If median exceeds 30 days, the conversion hook or nurture sequence needs redesign.

---

#### 8.5 Free Layer Pre-Mortem & Economics

**Purpose:** Surface the risks and economics of giving away services for free. The free layer is an investment — it must have a modeled breakeven and kill switches if it doesn't perform.

##### 8.5.1 Free Layer Pre-Mortem

"It's 12 months from now. 500 Snapshots completed across all free services. Fewer than 2% converted to paid. What went wrong?"

The agent writes the specific failure narrative for THIS niche. Consider:
- **The free tools attracted the wrong buyers.** Tier 1 content (benchmark reports) was downloaded by students, journalists, and competitors — not buyers. No qualification gate.
- **The Snapshot produced accurate numbers that didn't create urgency.** Buyers said "interesting, thanks" and never responded to follow-up. The number alone wasn't enough.
- **Competitors copied the free tools.** Within 6 months, 2 of 3 competitors launched identical free diagnostics. Buyers couldn't distinguish. The free layer became table stakes.
- **The free → paid price jump was too steep.** Buyers who received EUR 400K in leakage findings for free balked at EUR 5K for the fix. "You found it for free — why does fixing it cost money?"
- **The nurture sequence failed.** Non-converters received automated emails that went to spam or were ignored. No human follow-up. 80% of non-converters never heard from ClarityRev again after the automated sequence ended.

##### 8.5.2 Free Anchoring Risk

**The problem:** The Snapshot finds EUR X in leakage for free. The Sprint costs EUR Y to recover it. Some buyers will think: "You found this for free. Why should I pay for the fix?" This is not irrational — it's a predictable psychological response to freemium models.

**Risk assessment for this niche:** HIGH / MEDIUM / LOW. Based on: buyer price sensitivity (§3.6), competitor free→paid models (§8.1), and whether the niche has experience with free diagnostics (more experience = higher anchoring risk).

**Mitigations:**
1. **Set the expectation early.** The Snapshot landing page says: "The diagnosis is free. The recovery is guaranteed. You only pay if we recover revenue." This frames free as "diagnosis" and paid as "treatment" — a natural sequence, not a bait-and-switch.
2. **Show the paid step during the free step.** The Snapshot output includes a preview of what the Sprint delivers. Not "buy now" — "Here's what recovery looks like. Ready when you are."
3. **The guarantee is the bridge.** "The Sprint costs EUR X. If it doesn't recover ≥3× EUR X, it's free." This makes the paid step risk-reversed, neutralizing the "why pay?" objection.
4. **Never apologize for charging.** Bob never says "I know it was free before, but..." He says: "The diagnosis found the problem. Now let's fix it. Here's what that looks like."

##### 8.5.3 Free Layer Breakeven Analysis

The free layer costs money to operate. It must convert enough prospects to cover its costs.

| Metric | Tier 1 (Zero-Friction) | Tier 2 (Low-Friction) | Tier 3 (Data-Connected) | Total |
|---|---|---|---|---|
| Monthly volume (estimated) | [N] | [N] | [N] | [N] |
| Cost per completion (EUR) | [X] | [X] | [X] | — |
| Total monthly cost (EUR) | [N × X] | [N × X] | [N × X] | [Sum] |
| Expected conversion rate to paid | [%] | [%] | [%] | — |
| Expected paid conversions/month | [N × rate] | [N × rate] | [N × rate] | [Sum] |
| Average paid Sprint value (EUR) | [X] | [X] | [X] | — |
| Monthly revenue from conversions (EUR) | [Conv × value] | [Conv × value] | [Conv × value] | [Sum] |
| **Monthly net (EUR)** | | | | **[Revenue − Cost]** |

**Breakeven conversion rate:** Total monthly cost ÷ average Sprint value = [N] paid conversions/month needed. At estimated volume of [Y] free completions/month, breakeven conversion rate = [N÷Y]%. `[S]` until validated.

**Kill switch:** If actual aggregate conversion rate is below 50% of breakeven for 6 consecutive months, the free layer design is wrong for this niche. Options: (a) redesign conversion hooks, (b) reduce free layer scope (cut cost), (c) accept that the free layer is a brand investment, not a direct conversion engine, or (d) abandon the niche.

##### 8.5.4 Competitor Exploitation of the Free Layer

If a competitor reads §8, what do they exploit?
- They copy the free Snapshot within 3-6 months → free layer commoditized
- They launch a BETTER free tool (faster turnaround, more signals) → ClarityRev's looks inferior
- They run "free tools are worthless" counter-marketing → undermines the entire free-layer strategy

**Defense:** The free tools themselves are not defensible. What IS defensible: (a) the managed interpretation layer (competitors can copy the tool, not the analyst who interprets it), (b) the niche-specific language and benchmarks (horizontal competitors won't invest in per-niche depth), (c) the CRM-native delivery (competitors without CRM integration depth can't match the in-system experience).

---

#### 8.6 Free Layer Technical Operations

##### 8.6.1 Free Service Health Monitoring

| Metric | Threshold | Alert |
|---|---|---|
| Completion rate | <70% of started free services completed | Friction too high — simplify data access or form fields |
| Time-to-delivery (Tier 3) | >48 hrs for >10% of Snapshots in 24-hr period | Engine bottleneck or data quality issue |
| Error rate | >5% of free services fail with error | API or enrichment failure |
| Prospect satisfaction | <3.5/5 average rating on post-Snapshot survey | Quality or relevance problem with output |

##### 8.6.2 Multi-Tenant Scaling

| Metric | At 10 Simultaneous Snapshots | At 50 Simultaneous Snapshots | At 200 Simultaneous Snapshots |
|---|---|---|---|
| Queuing mechanism | First-in-first-out, no queue visible to user | FIFO with estimated wait time shown to user | Priority queue (Tier 3 prospects first, then Tier 2, then Tier 1) |
| Infrastructure requirement | Single server | Load-balanced, auto-scaling | Dedicated per-niche processing pipeline |
| Scaling trigger | N/A (baseline) | When average queue time >1 hr for 3 consecutive days → scale up | When >100 simultaneous → horizontal scaling |

##### 8.6.3 Free-Tier Data Retention & Privacy

Extends §12.11 security specification for free-tier specifically:
- **Data retention:** Free Snapshot data retained for 90 days (not 7 days as in §12.11 — extended to allow nurture sequence). After 90 days without conversion: auto-deleted. Prospect can request immediate deletion at any time.
- **Data usage:** Free-tier data used ONLY for the specific free service the prospect requested. NOT used for benchmark aggregation without explicit opt-in. NOT used to enrich other prospects' data.
- **Re-Snapshot:** If prospect requests a second Snapshot >90 days after the first, it's treated as a new free service with fresh data connection.
- **Conversion:** If prospect converts to paid, their data transitions to the paid retention policy from §12.11.

##### 8.6.4 Free Service Versioning

- **Versioning policy:** Free services follow the same MAJOR.MINOR versioning as signals (§6B.2). MAJOR increment on output format or algorithm change. MINOR increment on copy, UI, or threshold tuning.
- **Historical results:** When a free service algorithm updates, previously delivered free results do NOT retroactively update. The prospect's original output stands. If the prospect requests a re-Snapshot, the new version runs.
- **Prospect notification:** When a new MAJOR version of a free service ships, prospects who completed the previous version within the last 30 days receive: "We've improved our [free service name]. Your original findings are still valid. Want to see what the new version finds? [Link]."

---

**Done (minimum viable — FULL §8):** Free layer strategic job stated. Competitor free layer audit (§8.1) with ≥3 competitors, source-verified (URL + date), Match/Differentiate/Skip decisions with strategic intent per competitor tool. Competitive free-layer Strategy Canvas (§8.1a). ≥3 free services designed (§8.2) across ≥2 tiers, each with: evidence grades on all fields (inherited or `[DESIGN]`), pain traceability (§3), signal traceability (§6B), competitive decision, specific output, data requirements, turnaround, workflow fit, conversion hook, Bob's Usage (verbatim), top 2 objection responses (verbatim), MEDDIC mapping, conversion model (rate + time + stall point + confidence), delivery cost, build spec (tools/APIs/effort/dependencies/cost per run), demand validation evidence, and niche-name-swap test. Distribution specified per service (§8.3) with channel, SEO/SEM, aggregator-native version, distribution cost, and channel experiment design. Free-to-paid conversion design (§8.4) with per-tier post-completion sequence and nurture for non-converters. Free layer pre-mortem (§8.5.1), free anchoring risk assessment with niche-specific mitigations (§8.5.2), breakeven analysis with kill switch (§8.5.3), competitor exploitation assessment with defenses (§8.5.4). Technical operations (§8.6): health monitoring, multi-tenant scaling, free-tier data retention/privacy, service versioning.

**Excellent:** Every free service passes the niche-name-swap test. The free layer includes an aggregator-native version for at least one service. At least one free service is a deliberate Match of a competitor's offering (proving the audit informed decisions). The free anchoring risk is assessed honestly for this niche — not downplayed. The breakeven conversion rate is calculated and the kill switch is specific. The pre-mortem names a specific failure scenario unique to this niche. Bob's Usage fields are verbatim — a rep could read them on a call today. The build spec per service is complete enough that Wesley could estimate sprint scope from it.

**ADVERSARIAL CHECK (extended):** "Is the free layer's strategic job stated and does it drive every design decision? If the strategic job is 'attract volume' but all free services require CRM data connection (high friction), the strategy and the design are misaligned. Are there free services at every commitment tier — can a skeptical buyer start with zero data commitment? Is the free anchoring risk honestly assessed — or is it assumed that buyers will naturally progress to paid? If 500 Snapshots produce 5 paid conversions, at what month do we kill the free service? Is that kill switch specified? What prevents a competitor from copying the free Snapshot in 3 months? If the answer is 'nothing,' what's the defensibility beyond the free layer?"

**Cross-references to update:**
- §1.4: Data accessibility constraints for free services
- §2.6: Buyer language used for free service naming
- §3: Pain → free service traceability
- §6B: Signals surfaced in free services
- §7.2: Diagnose stage (the Snapshot — mandatory free service)
- §9: Paid services that free services convert to
- §12.11: Security specification → §8.6.3 free-tier extension
- §13.8: Nurture sequence for non-converters

---

### SECTION 9: Paid Standalone Services (Prove)

**Purpose:** Design the first paid transaction(s). These are the "yes" that matters most — the first time a buyer pays ClarityRev money. Every paid service must be: low-commitment (under the champion's purchase authority threshold), fast-to-value (first result in days, not months), risk-reversed (guarantee data-underwritten by the free Snapshot), AND niche-specific (fails the niche-name-swap test). The competitive decision per service is explicit: Match, Differentiate, or Skip.

**Applied lenses:** GTM Architect (first "yes" design, conversion model, risk reversal, purchase psychology, sales usage), Systems Designer (build spec, delivery automation, guarantee tracking, health monitoring), Strategy Consultant (portfolio architecture, competitive positioning, pricing strategy, portfolio economics), Research Analyst (evidence grades, competitor source verification, confidence calibration), Red-Team (pre-mortem, guarantee exposure model, price sensitivity, minimum viable portfolio)

**Design principles (binding):**
1. **The first "yes" is the hardest.** The paid service must feel like a natural, psychologically easy next step after the free Snapshot. Not "now buy our service" — "here's what recovering those top 5 deals looks like. Ready when you are."
2. **Price under the champion's solo approval threshold** (from §2.3 purchase authority). If the champion needs their boss's sign-off, the first "yes" becomes a procurement process — and most first "yeses" die in procurement.
3. **The guarantee is underwritten by the free diagnostic.** ClarityRev only offers the paid service when the Snapshot data supports it. If the Snapshot finds <EUR X in leakage, the paid service is not offered — honest negative protocol (§12.9).
4. **The paid portfolio has a defined architecture.** Is it a ladder (ascending price/commitment), a menu (pick what you need), or a sequence (Service A must precede Service B)? The architecture determines how services relate and how Bob sells them.
5. **Use implementation-agnostic language.** Refer to "automated workflows" not vendor-specific tool names. The workflow specification (§11) is about what gets built, not which LLM provider powers it.

---

#### 9.1 Competitor Paid Service Audit (Do This First)

Structured table mapping what the top 3 competitors offer as paid standalone/entry services.

**Source verification requirement:** For each competitor's paid service, the agent must personally verify pricing by visiting the competitor's website. Record: URL visited, date of visit, exact text snippet confirming the price. If pricing is not publicly available, state "not publicly available" and cite closest signal (G2 reviewer mention, case study, job posting). Services NOT personally verified must be marked `[H]`. `[E]` if personally verified within 30 days.

| Competitor | Paid Entry Service | Price (EUR) | Source Verified? | Strengths | Gaps / Weaknesses | ClarityRev Decision | Strategic Intent |
|---|---|---|---|---|---|---|---|
| Comp A | [Name + type] | [EUR] | [URL + date or `[H]`] | [What's good] | [What's missing] | Match / Differentiate / Skip | WHY? |
| Comp B | ... | ... | ... | ... | ... | ... | ... |
| Comp C | ... | ... | ... | ... | ... | ... | ... |

**Decision logic (same as §8.1):**
- **Match:** The competitor's paid service is exactly what buyers need and well-executed. Match the capability but add one differentiating element.
- **Differentiate:** The competitor's paid service has a clear gap ClarityRev can exploit. Build something genuinely different.
- **Skip:** The competitor's paid service serves a need ClarityRev doesn't need to address, or the cost to match isn't justified.

---

#### 9.1a Competitive Paid-Layer Strategy Canvas

**Purpose:** Plot ClarityRev's paid entry services against competitors on the factors that matter for the first "yes."

| Factor (1-5, 1=worst, 5=best) | Competitor A | Competitor B | Competitor C | ClarityRev |
|---|---|---|---|---|
| **Speed-to-first-value** — days from payment to visible result? | | | | |
| **Commitment required** — annual contract or one-time project? (1=annual, 5=one-time) | | | | |
| **Risk-reversal strength** — what happens if it doesn't work? (1=no guarantee, 5= outcome-based pricing) | | | | |
| **Price relative to value** — value-to-price ratio perceived by buyer | | | | |
| **Niche specificity** — generic cross-industry or tailored to THIS niche? | | | | |
| **Path to recurring** — how naturally does it lead to ongoing commitment? | | | | |

---

#### 9.2 Paid Service Portfolio (≥3 Services)

**Paid portfolio architecture (state before designing services):** Is this portfolio a:
- **Ladder:** Services ascend in price/commitment. Buyer typically buys Service 1 → Service 2 → Service 3. Sequential.
- **Menu:** Services are independent. Buyer selects what they need. The Snapshot output recommends the right service.
- **Sequence:** Service A is prerequisite for Service B. Must complete A before B is offered.

State the architecture and rationale for this niche. `[DESIGN]`.

**Portfolio economics summary (complete after designing all services):**

| Service | Expected Volume (per month) | Avg Price (EUR) | Expected Monthly Revenue (EUR) | Gross Margin | Portfolio Role |
|---|---|---|---|---|---|
| [Service 1] | [N] | [X] | [N×X] | [%] | Volume leader / Margin leader / Gateway to recurring |
| [Service 2] | [N] | [X] | [N×X] | [%] | |
| [Service 3] | [N] | [X] | [N×X] | [%] | |
| **Total** | | | **[Sum]** | **[Blended]** | |

For each paid standalone service, complete all fields. Every field that makes a factual claim must carry or state its inherited evidence grade. Design decisions are marked `[DESIGN]`.

- **Service name** — buyer language from §2.6. Result-named. `[DESIGN]`.
- **Service type** — from §9.3 patterns OR a new type defined for this niche. `[DESIGN]`.
- **Portfolio role** — Volume leader / Margin leader / Gateway to recurring / Premium differentiator. `[DESIGN]`.
- **Which pain from §3 does this solve?** Direct traceability. State the inherited evidence grade from §3. Inherits weakest grade from §3.
- **Which signals from §6B does this paid service surface/analyze?** Direct traceability. List specific signal IDs from §6B.2. `[E]` from §6B.
- **Competitive decision:** Match, Differentiate, or Skip vs. each competitor's equivalent (from §9.1). Include strategic intent. `[DESIGN]`.
- **Price (EUR):** Band, with competitor anchoring from §4.1 and §9.1. Show the math: "Competitor X charges EUR Y for Z. We deliver [more/different] for EUR W." `[E]` from §4.1/§9.1.
- **Strategic pricing rationale:** Is ClarityRev pricing at a PREMIUM (better service, higher value), PARITY (matching market), or DISCOUNT (buying market share, entering new niche)? State rationale with competitive context. `[DESIGN]`.
- **Scope** — exactly what the buyer gets. Deliverables (named, specific), timeline (start to finish), touchpoints (meetings, calls, reviews), output format (where and how delivered). Not "we analyze their pipeline" — "We produce: (1) Ranked list of top 10 recoverable deals with EUR value, stall reason, and recommended action. (2) One-page executive summary for the economic buyer. (3) 60-minute results presentation with the champion. Delivered within 14 days." `[DESIGN]`.
- **Time-to-value** — first visible result by when. Target in days. `[DESIGN]`.
- **Risk reversal** — specific guarantee mechanism. "If the [service] doesn't identify ≥EUR [3× fee] in recoverable revenue within the scope period, the service is free." Must cite the data underwriter: the free Snapshot from §8 that showed the opportunity existed. `[DESIGN]`.
- **Guarantee financial exposure:** If [X%] of clients invoke the guarantee, max liability = [N clients × X% × service fee]. At estimated volume of [Y] services/year, worst-case exposure = EUR [Z]. Is ClarityRev capitalized for this? `[S]` until validated.
- **Evidence needed before selling** — what proof must exist? (Case studies? Benchmark? Methodology doc? Reference call?) Be specific about what exists NOW vs. what must be built. Cross-reference §12 evidence stack. `[E]` if evidence exists, `[H]` if planned.
- **Purchase psychology — the first "yes":** What makes THIS paid service the psychologically easiest first "yes" for this niche's buyer? The free Snapshot already proved the problem exists. The paid service is the fix. What specific element reduces the psychological barrier? "The guarantee means the buyer risks nothing." "The price is below their solo approval threshold — no boss sign-off needed." "The 14-day timeline means they see results before their next pipeline review." `[H]` — inference from buyer psychology (§2.7).
- **Price sensitivity threshold:** At what price does the buyer balk? "Above EUR X, the champion needs CFO approval (§2.3 purchase authority). Above EUR Y, it triggers a procurement process. The sweet spot is EUR Z — below the champion's threshold, above the 'too cheap to be credible' floor." `[H]` — inference.
- **Delivery method** — exactly how and where the output is delivered. "CRM-native: results posted as Tasks and Notes in the client's [CRM name] per §1.4 integration spec. Plus: 60-minute video call to walk through findings. Plus: one-page PDF executive summary for the economic buyer." `[DESIGN]`.
- **Delivery automation level:** What % is automated vs. human-delivered? Which specific tools/APIs/LLM calls produce the output? What's the human touchpoint? `[DESIGN]`.
- **Build specification:**
  - Automated workflows powering this service: Which §11 workflows? What tools/APIs? `[E]` if §11 workflows exist.
  - Build effort: S (<1 day) / M (2-5 days) / L (1-2 weeks) / XL (3+ weeks).
  - Dependencies: What must exist before this can be built? (CRM integration from §1.4, Snapshot engine, §11 workflows, benchmark data?)
  - Cost per delivery (EUR): Compute, API credits, LLM tokens, enrichment, human review time. Estimate with range. `[S]` until first 5 deliveries.
- **Bob's Usage (verbatim):** Exactly how Bob introduces this paid service after the Snapshot results are delivered. "When the Snapshot finds EUR X in leakage: Bob says '[verbatim offer, ≤75 words].' Bob shows the one-page Sprint preview. Bob asks: 'Want to start Monday?'" `[DESIGN]`.
- **Objection handling (top 3):** The most common objections to THIS paid service and Bob's verbatim response.
  - Objection 1: "[Most common pushback]." Bob's response: "[verbatim, ≤50 words]."
  - Objection 2: "[Second]." Bob's response: "[verbatim, ≤50 words]."
  - Objection 3: "[Third]." Bob's response: "[verbatim, ≤50 words]." `[DESIGN]`.
- **MEDDIC qualification mapping:** Which MEDDIC elements does this paid service address? Metrics / Economic Buyer / Decision Criteria / Decision Process / Pain / Champion / Competition. Map each. `[DESIGN]`.
- **Sales cycle:** Expected meetings from proposal to signed contract: [N]. Typical duration: [N] days (range: [X-Y]). Who must say YES at each gate? (From §2.1 committee map.) `[H]` until validated.
- **Conversion model:**
  - Free (§8) → This paid service: [X%] conversion rate (low [Y%] – high [Z%]). `[S]` until 20+ data points.
  - This paid service → Recurring (§10): [X%] conversion rate. `[S]`.
  - Most common stall point: [Where do buyers get stuck?]. `[H]`.
- **Client data handling (paid tier):** Paid services process client data more deeply than free services. What additional data is accessed? Where is it stored? What's the retention policy? Cross-reference §12.11 and §8.6.3. `[DESIGN]`.
- **Niche-name-swap test** — if you swapped the niche name, would this service work unchanged for any of the other 24 niches? If yes, redesign. `[DESIGN]`.

---

#### 9.3 Service Type Patterns (Suggestive, Not Exhaustive)

These are common patterns — inspiration, not a menu. The niche may demand something not listed here. The form follows the pain, the data, and the buyer's workflow.

| Pattern | Best For | Example | Risk | Margin Profile | Founder Time per Delivery |
|---|---|---|---|---|---|
| **Sprint** — episodic, fixed-duration, outcome-focused | Acute pain with fast ROI proof | "14-Day Dead Pipeline Resurrection Sprint" | Overpromising on timeline | High (automated analysis + human review) | Medium (3-5 hrs) |
| **Report/Brief** — one-time deliverable, research-backed | Awareness-stage buyers, competitive niches | "Competitive Landscape Brief for [Niche]" | Perceived as "just a PDF" | Very High (fully automatable) | Low (1-2 hrs review) |
| **Pilot** — reduced-scope recurring, time-limited | Recurring services where "ongoing" is too big a first yes | "3-Month Pipeline Intelligence Pilot at 50% fee" | Difficulty converting to full price | Medium (setup cost amortized over pilot) | Medium-High (onboarding + weekly check-ins) |
| **Audit/Scan** — fixed-scope, data-grounded diagnosis | Data-heavy niches where diagnostic creates urgency | "Revenue Leakage Scan — 2 weeks, one number" | Findings don't create urgency | High (automated + human interpretation) | Medium (2-4 hrs) |
| **Workshop** — live, collaborative, low data friction | Relationship-driven niches, low-trust entry | "Half-Day Pipeline Discovery Workshop" | Doesn't scale; high founder time | Low (mostly human-delivered) | Very High (8-16 hrs) |
| **Lead/Account List** — enriched deliverable, immediately actionable | Pipeline-driven niches | "50 Qualified Accounts with Buying Signals" | Perceived as a data product, not intelligence | Very High (fully automatable) | Low (<1 hr review) |
| **Embedded Tool** — custom AI asset on client's site | High-trust, tech-savvy buyers | "ROI Calculator grounded in client's market data" | Build cost; maintenance expectation | High (automated once built) | High initial build, Low ongoing |
| **Other** | Whatever this niche needs | Defined by the niche, not this list | — | — | — |

**Rule:** If the niche demands a service type not listed here, define it with the same fields (Best For, Example, Risk, Margin Profile, Founder Time). The list is a starting point, not a boundary.

---

#### 9.4 Pricing Justification

For each paid service (aggregate into one pricing rationale or break out per service):

- **Strategic pricing position:** PREMIUM / PARITY / DISCOUNT. Justify with competitive context. "We price at PARITY with Competitor X's [service] but deliver [differentiating element]. We price at PREMIUM to the market median because [unique value]. We price at DISCOUNT to [specific strategic reason — buying market share, entering new niche, etc.]." `[DESIGN]`.
- **Competitor price anchoring** — from §4.1 and §9.1. Show the math per service: "Competitor X charges EUR Y for Z. We deliver Z + [differentiating element] for EUR W." `[E]` from §4.1/§9.1.
- **ROI justification** — from §3.3. "Client pays EUR X. Recovers EUR Y within [timeframe]. Net: EUR (Y-X). Payback: [N] months." The recoverable EUR number inherits its evidence grade from §3.3. State it.
- **Purchase authority fit** — from §2.3. Is this price below the champion's solo approval threshold? If no: "This price requires [role] approval per §2.3. Budget verification method: [from §2.3]. Expected additional sales cycle time: +[N] weeks."
- **Displacement comparison** — from §3.6. "Client currently spends EUR X on [tools/headcount/agencies] addressing this pain partially. ClarityRev replaces [specific spend] at EUR Y — a [saving/investment] of EUR Z."

---

#### 9.5 Paid Service Pre-Mortem & Risk Assessment

##### 9.5.1 Paid Service Pre-Mortem

"It's 12 months from now. 50 prospects completed the free Snapshot. 8 converted to a paid service. Of those 8, 3 invoked the guarantee. 2 converted to recurring. What went wrong?"

The agent writes the specific failure narrative for THIS niche. Consider:
- **The free → paid price jump was too steep.** Buyers who received EUR 400K in leakage findings for free balked at the EUR 5K Sprint. "You found it for free — why does fixing it cost money?"
- **The guarantee was invoked too often.** The Snapshot overestimated recoverable revenue. Actual recovery was 40% of projected. Clients didn't renew.
- **The paid service was perceived as a one-time fix.** Clients recovered the top deals and said "we're good." No path to recurring was visible.
- **Competitors undercut pricing.** A competitor launched a similar service at 60% of ClarityRev's price. Buyers cited "we found a cheaper option."
- **The sales cycle was longer than expected.** What was modeled as 2 meetings became 6. Champion turnover mid-cycle killed 3 deals.

##### 9.5.2 Guarantee Financial Exposure Model

The guarantee is ClarityRev's core risk-reversal mechanism. It must be modeled for worst-case exposure.

| Guarantee Parameter | Value | Basis |
|---|---|---|
| Guarantee terms | "If the [service] doesn't identify ≥EUR [3× fee] in recoverable revenue, the service is free." | `[DESIGN]` |
| Average service fee (EUR) | [X] | From §9.2 |
| Expected monthly volume | [N] services/month | From §9.2 portfolio economics |
| Worst-case invocation rate | [Y%] | Estimate: 20-40% in early months before calibration; declining to <10% after 20+ deliveries |
| Max monthly exposure (EUR) | [N × Y% × X] | Worst-case: [EUR amount] |
| Annualized max exposure (EUR) | [Monthly × 12] | [EUR amount] |
| ClarityRev cash buffer required | [Annualized max exposure] | Must be reserved or insurable |

**Guarantee invocation triggers:** What specific, measurable condition triggers the guarantee? "Client must provide written notice within 30 days of service completion. ClarityRev reviews against the scope defined in the service agreement. If the service did not identify ≥EUR [3× fee] in recoverable revenue as defined in the scope, the guarantee applies."

**Guarantee tracking system:** How does ClarityRev track guarantee eligibility and prevent disputes?
- Each paid service delivery includes a "Guarantee Scope Statement" — specific, measurable criteria for what counts as "recoverable revenue identified."
- Client signs acceptance of the scope before service begins.
- Upon delivery, ClarityRev provides a "Guarantee Outcome Statement" — "We identified EUR X in recoverable revenue across Y accounts. This meets/exceeds the 3× guarantee threshold."
- If client disputes, Adriaan reviews within 5 business days. Final determination within 10 business days.

##### 9.5.3 Minimum Viable Paid Portfolio (Skeptical Advisor's Critique)

**The critique:** "You've designed 3 paid services. You have zero clients. You don't know which one anyone will actually pay for. Build ONE — the one closest to the Snapshot output. The Sprint. Prove someone writes a check. THEN build the other two."

**Minimum viable paid portfolio sequence:**
1. **Build first:** The service closest to the Snapshot output. Typically the Sprint or Audit — directly addresses the pain the Snapshot quantified. This is the "hinge paid service."
2. **Validate:** 10 paid deliveries. Target: ≥60% client satisfaction (would recommend), <20% guarantee invocation rate, ≥30% conversion to recurring inquiry (even if recurring product isn't built yet).
3. **Build second:** Only after the first service is validated. The second service addresses either: (a) a different pain surfaced by the Snapshot, or (b) a different buyer persona from §2.1.
4. **Build third:** Only after ≥5 clients have expressed interest in it OR competitive pressure demands it.

This sequencing is BINDING for build investment. All three services are designed now for portfolio comparison, but build follows this sequence. `[DESIGN]`.

##### 9.5.4 Competitor Undercutting Scenario

**Scenario:** A competitor launches an identical paid service at 50% of ClarityRev's price. What happens?

**Likelihood in this niche:** HIGH / MEDIUM / LOW. Based on: competitor delivery model (§4.1 — software competitors can drop price further than managed competitors), competitor funding (§4.1 — well-funded competitors can sustain losses longer), and niche price sensitivity.

**ClarityRev's defense:**
1. **The guarantee is the differentiator.** A cheaper competitor with no guarantee is a riskier purchase. "They charge 50% less. We guarantee 3× ROI or it's free. Which is actually cheaper if it doesn't work?"
2. **Niche specificity.** A horizontal competitor dropping price can't match niche-specific language, benchmarks, and CRM-native delivery. Buyers pay for relevance.
3. **The Snapshot is the proof.** "Before you switch, let's run a fresh Snapshot. If our service is working, the number will show it. If it's not, we'll fix it or you don't pay."

---

#### 9.6 Paid Service Technical Operations

##### 9.6.1 Paid Service Health Monitoring

| Metric | Threshold | Alert |
|---|---|---|
| Delivery on-time rate | <90% of services delivered within promised timeline | Workflow bottleneck or scope creep |
| Client satisfaction | <3.5/5 average post-service rating | Quality or expectation-setting problem |
| Guarantee invocation rate | >25% of services invoke guarantee | Snapshot overestimating recoverable revenue — recalibrate |
| Margin per service | <50% gross margin for 3 consecutive months | Underpriced or over-delivering scope |
| Paid → recurring conversion | <25% after 20 paid deliveries | Paid service not leading naturally to ongoing need |

##### 9.6.2 Paid Service Versioning

- Same MAJOR.MINOR policy as free services (§8.6.4) and signals (§6B.2).
- **Client notification on update:** When a paid service methodology improves, past clients receive: "We've improved our [service name] methodology. The update is available if you'd like a re-assessment. [Link]."
- **Guarantee continuity:** If a client purchased under v1.x and v2.0 launches mid-engagement, the client receives v2.0 at no additional cost. Guarantee terms are based on v2.0 scope.

---

**Done (minimum viable — FULL §9):** Paid portfolio architecture stated (ladder/menu/sequence). Competitor paid audit (§9.1) with ≥3 competitors, source-verified (URL + date), Match/Differentiate/Skip with strategic intent. Competitive paid-layer Strategy Canvas (§9.1a). ≥3 paid services designed (§9.2) with portfolio economics summary, each with: evidence grades on all fields, service type, portfolio role, pain traceability (§3), signal traceability (§6B), competitive decision, price with competitor anchoring + strategic pricing rationale (premium/parity/discount), detailed scope, time-to-value target, risk reversal with guarantee financial exposure, evidence needed, purchase psychology, price sensitivity threshold, delivery method + automation level, build spec (workflows/APIs/effort/dependencies/cost per delivery), Bob's Usage (verbatim), top 3 objection responses (verbatim), MEDDIC mapping, sales cycle (meetings + duration + approvers), conversion model (free→paid rate + paid→recurring rate + stall points), client data handling, and niche-name-swap test. Pricing justification (§9.4) with strategic pricing position, competitor anchoring, ROI justification, purchase authority fit, and displacement comparison. Paid service pre-mortem (§9.5.1), guarantee financial exposure model (§9.5.2), minimum viable paid portfolio sequence (§9.5.3), competitor undercutting scenario (§9.5.4). Technical operations (§9.6): health monitoring + service versioning.

**Excellent:** Every paid service passes the niche-name-swap test. At least one service is a deliberate Match (proving competitor audit informed design). The guarantee exposure is calculated and within ClarityRev's risk tolerance. The minimum viable portfolio sequence is respected — the hinge paid service is designated for first build. Bob's Usage fields are verbatim — a rep could present the service on a call today. Objection responses cite specific evidence from §12. Price sensitivity is assessed against actual purchase authority thresholds from §2.3. The competitor undercutting scenario is specific (names the competitor most likely to do this).

**ADVERSARIAL CHECK (extended):** "If we ran sections 8-9 for 3 niches simultaneously, would all 3 produce genuinely different free tools and paid services? Or the same Snapshot/Sprint/Audit with the niche name changed? Are there deliberate Match decisions where competitors got it right, or is everything 'differentiated' for the sake of it? Is the single most dangerous assumption surfaced: that buyers will pay for the fix after getting the diagnosis for free? Is the guarantee exposure modeled — what if 40% of clients invoke it in the first 6 months? Can ClarityRev survive that? Is the minimum viable portfolio respected, or are we building 3 paid services at zero clients? What would the founders' most skeptical advisor say?"

**Cross-references to update:**
- §2.3: Purchase authority thresholds → §9.2 price sensitivity + §9.4 purchase authority fit
- §3.3: ROI proof structure → §9.4 ROI justification
- §3.6: Displacement analysis → §9.4 displacement comparison
- §4.1: Competitor pricing → §9.1 audit + §9.4 competitor anchoring
- §6B: Client Signal Catalog → §9.2 signal traceability
- §8: Free services → §9.2 conversion path from free
- §10: Recurring services → §9.2 conversion path to recurring
- §11: Automated workflows → §9.2 build spec
- §12.9: Guarantee design → §9.2 risk reversal + §9.5.2 exposure model

---

### SECTION 10: Core Recurring Services (Commit + Expand)

**Purpose:** Design the recurring revenue engine — the services clients pay for month after month. This is ClarityRev's MRR foundation. Reference §1.6 RIOS applicability — if Commit is marked SKIP, this section is minimal (state why recurring doesn't apply to this niche). If APPLIES, this section designs the complete recurring commercial system: the core service, expansion paths, tiering, value cadence, retention defenses, and the moat that strengthens with each client.

**Applied lenses:** GTM Architect (recurring economics, LTV, conversion model, objection handling, client experience), Strategy Consultant (portfolio strategy, competitive positioning, moat trajectory, retention economics), Systems Designer (delivery automation, client provisioning, multi-tenant isolation, health monitoring), Research Analyst (evidence grades, competitor source verification, churn benchmarks), Red-Team (pre-mortem, churn stress test, minimum viable recurring, competitor poaching)

**Design principles (binding):**
1. **The recurring service is NOT "the same thing but monthly."** It must deliver NEW value every month that the client couldn't get from a one-time engagement. The paid Sprint (§9) showed them what was broken. The recurring service shows them what's breaking NOW — and will break next month.
2. **Retention is the product.** A recurring service with 3%/month churn loses 31% of clients annually. Every element of the recurring design — value cadence, signal delivery, QBRs, benchmark comparisons — exists to make cancellation feel more expensive than continuation.
3. **Expansion is designed, not discovered.** The signals that trigger expansion conversations are specified in §6B.4. The expansion path is part of the recurring architecture, not an afterthought.
4. **Validate one-time before building recurring.** At zero clients, the paid Sprint (§9) must be validated first. The recurring service is designed now for portfolio comparison, but build investment follows the minimum viable sequence from §9.5.3.

---

#### 10.1 Competitor Recurring Service Audit (Do This First)

Same pattern as §8.1 and §9.1. Map what competitors offer as ongoing/recurring services.

**Source verification requirement:** For each competitor's recurring service, the agent must personally verify pricing and scope by visiting the competitor's website. Record: URL visited, date of visit, exact text snippet confirming the price and what's included. Services NOT personally verified must be marked `[H]`. `[E]` if personally verified within 30 days.

| Competitor | Recurring Service | Price/mo (EUR) | Source Verified? | Strengths | Gaps / Weaknesses | ClarityRev Decision | Strategic Intent |
|---|---|---|---|---|---|---|---|
| Comp A | [Name] | [EUR] | [URL + date or `[H]`] | [What's good] | [What's missing] | Match / Differentiate / Skip | WHY? |
| Comp B | ... | ... | ... | ... | ... | ... | ... |
| Comp C | ... | ... | ... | ... | ... | ... | ... |

**Decision logic — same as §8.1 and §9.1.** Match with one differentiating element. Differentiate on a clear competitor gap. Skip if cost-to-match exceeds strategic value.

---

#### 10.1a Competitive Recurring Strategy Canvas

**Purpose:** Plot ClarityRev's recurring services against competitors on the factors that drive retention and expansion.

| Factor (1-5, 1=worst, 5=best) | Competitor A | Competitor B | Competitor C | ClarityRev |
|---|---|---|---|---|
| **Signal breadth** — how many signal types are continuously monitored? | | | | |
| **Actionability** — do they tell the client what to DO, or just show a dashboard? | | | | |
| **Delivery format** — CRM-native tasks or separate tool? | | | | |
| **Benchmark access** — can clients compare themselves to peers? | | | | |
| **Expansion velocity** — how naturally does the service expand to cover more? | | | | |
| **Switching cost** — how hard is it to leave? (data export, workflow reconfiguration, retraining) | | | | |

---

#### 10.2 Core Recurring Service Design

**Recurring portfolio strategy (state before designing):** Is this niche best served by:
- **Single Core Service:** One recurring service with tiered pricing (Core/Premium/Enterprise). Clients expand within the same service. Best for focused niches.
- **Core + Modules:** Base recurring service + optional add-on modules (expansion services). Best for diverse niches where different clients need different things.
- **Platform:** Multiple recurring services sharing infrastructure, benchmarks, and signal detection. Best for broad niches with multiple buyer personas.

State the strategy and rationale for this niche. `[DESIGN]`.

For each core recurring service, complete all fields. Every field that makes a factual claim must carry or state its inherited evidence grade. Design decisions are marked `[DESIGN]`.

- **Service name** — buyer language from §2.6. Result-named, ongoing. Not "[Niche] Monitoring" — "[Niche] Revenue Intelligence" or equivalent. `[DESIGN]`.
- **RIOS stage:** Commit (if APPLIES per §1.6) or SKIP. State rationale if SKIP. `[P]` from §1.6.
- **Which pain from §3 does this address?** Direct traceability. State the inherited evidence grade from §3. Inherits weakest grade from §3. "Pain #1: Revenue Leakage — continuous monitoring catches new leaks before they grow." `[P]` — logical connection.
- **Strategic rationale for recurring vs. one-time:** Why does THIS niche need ongoing intelligence rather than a one-time fix? "Because [niche-specific reason — e.g., 'recruitment needs change weekly as new requisitions open and close'], the value is in CONTINUOUS detection, not a one-time audit." `[H]` — strategic judgment.
- **Competitive decision:** Match, Differentiate, or Skip vs. each competitor. Include strategic intent from §10.1. `[DESIGN]`.
- **Monthly price (EUR):** Band. What determines position in the band? (Company size? Number of monitored accounts/signals? Usage volume? Users? Outcome magnitude?) Anchored to competitor pricing from §10.1 and §4.1. `[E]` from §10.1/§4.1.
- **Annual contract value (EUR):** Estimate. Monthly × 12, minus any annual discount. `[S]` until validated.
- **What's included:** Specific, scoped. Signal monitoring: which signals from §6B (list signal IDs). Output delivery: what, where, how often (from §6B.3 and §10.7). Human touch: meetings, reports, QBRs — frequency and duration. Response SLA: how fast ClarityRev responds to client questions. Minimum commitment: 1 month / 3 months / 12 months. `[DESIGN]`.
- **What's NOT included:** Explicit boundaries. "The following are NOT included in the core recurring fee: [list — e.g., additional CRM integrations beyond the primary system, custom signal development, dedicated analyst, on-site visits]. These are available as expansion services (§10.3) or Enterprise tier (§10.6)." `[DESIGN]`.
- **Relationship to paid standalone services (§9):** How does this differ from what they already bought in the Sprint/paid service? "The Sprint found and recovered the top 5 stalled deals. The recurring service continuously monitors ALL deals, detects new stalls before they grow, and adds market intelligence signals the Sprint didn't cover. If the Sprint was the emergency room, this is the annual physical — every month." `[DESIGN]`.
- **LTV model:**
  - Average monthly revenue per client: EUR [X]. `[S]` until validated.
  - Expected average client lifetime: [N] months. Basis: [industry churn benchmark or `[S]`].
  - LTV: EUR [X × N]. `[S]`.
  - CAC (from §9 paid service + onboarding cost): EUR [Y]. `[S]`.
  - LTV/CAC ratio: [X×N ÷ Y]. Target: >3×. `[S]`.
- **Paid → Recurring conversion model:**
  - Expected conversion rate from paid Sprint (§9) to recurring: [X%] (low [Y%] – high [Z%]). `[S]` until 20+ data points.
  - Most common stall point: [Where do paid clients hesitate to commit to recurring?]. `[H]`.
  - Time from Sprint completion to recurring start: [N] days (target: seamless — Sprint ends Friday, recurring starts Monday).
- **Onboarding process:** Steps, timeline, who does what. "Day 0: Contract signed → Adriaan initiates client provisioning (§10.8.1). Day 1: Welcome sequence triggered. Day 2: Signal configuration confirmed (which signals from §6B are active). Day 3: First signal baseline established. Day 5: Client champion receives 'Your First Week in Signals' summary. Day 7: First weekly digest delivered." `[DESIGN]`.
- **Onboarding automation:** What's automated vs. manual? "Provisioning: automated (CRM connection verified, signal config deployed, client dashboard provisioned). Kickoff call: manual (Adriaan, 60 min). First-week check-in: manual (Adriaan, 30 min). Weekly digest: automated." `[DESIGN]`.
- **Churn prevention:** What would cause cancellation in THIS niche specifically? What's built in to prevent it? NOT generic "great customer service" — niche-specific. "For staffing agencies: if the client stops hiring (hiring freeze), signal volume drops to near-zero. The recurring service looks inactive. Built-in defense: during hiring lulls, the service automatically shifts to 'Market Watch' mode — monitoring competitor activity and talent market shifts, so the client still receives value even when not actively hiring." `[H]` — design, validated by retention data.
- **Bob's Usage (verbatim):** How Bob presents the recurring commitment after the Sprint succeeds. "Bob: 'The Sprint recovered EUR X in 14 days. Here's what happens next: those same deals, and every new deal, get monitored continuously. New stalls get caught in days, not months. Here's what that looks like. [Shows sample weekly digest.] The Sprint was the fix. This is the prevention. EUR Y/month. Cancel anytime.'" `[DESIGN]`.
- **Objection handling (top 3 for recurring):**
  - Objection 1: "We don't need this every month — we fixed the problem." Bob: "The Sprint fixed what was ALREADY broken. The recurring service catches what's breaking NOW. Last month alone we detected [X] new signals for clients your size. Here's what one looked like. [Shows anonymized example.]"
  - Objection 2: "It's too expensive annually." Bob: "The Sprint recovered EUR X in 14 days. At EUR Y/month, the annual cost is EUR Z. If we catch ONE deal per quarter that would have stalled — just one — the service pays for itself 3× over. And if it doesn't, you cancel. No annual contract."
  - Objection 3: "We'll try it internally — we can set up our own alerts." Bob: "You can. Here's what that looks like: [shows comparison — internal setup: 10 hrs/week, misses 60% of signals, no benchmark context. ClarityRev: automated, 20+ signal sources, niche benchmark context.] The Snapshot showed you what you were missing. Don't go back to missing it." `[DESIGN]`.
- **Niche-name-swap test** — same as §8/§9. `[DESIGN]`.

---

#### 10.3 Expansion Architecture (Expand Stage)

Only if Expand marked APPLIES in §1.6. If SKIP, state why and skip to §10.4.

- **≥2 expansion paths:**
  - **Cross-sell:** Different trigger/pain, same buyer. "Client started with Revenue Leakage monitoring. Expansion: add Competitive Intelligence module (§9 service type: Report/Brief, recurring cadence). Mini-diagnostic: competitive landscape scan on client's top 3 competitors." Each cross-sell path has its own mini-diagnostic based on a free-tier Snapshot of the adjacent pain area.
  - **Upsell:** More scope/volume within same trigger. "More pipelines monitored, more CRM systems connected, more geographies, more users, more signal sources." Each upsell threshold is tied to an objective metric (not "sales convinces them").
- **Expansion trigger (specific, from §6B.4):** What exact signal combination or data threshold indicates readiness? "3 consecutive months of Account Health signals above niche median + 2 Market Intelligence signals indicating competitive threat → expansion trigger for Competitive Battlecards add-on. OR: client's monitored account count grows >20% in 6 months → upsell trigger for additional account tier." `[H]` — design.
- **Expansion conversion math:**
  - Expected % of recurring clients who take expansion offer 1 by Month 12: [X%]. `[S]`.
  - Expected % who take expansion offer 2 by Month 18: [Y%]. `[S]`.
  - Expected expansion revenue per expanded client: EUR [Z]/month additional. `[S]`.
- **Expansion pricing:** Add-on pricing (per-module fee) vs. bundle (Core + Expansion at discount) vs. platform fee (all-inclusive at higher tier). Which model for this niche? `[DESIGN]`.

---

#### 10.4 Moat Connection (From §1.6)

- **What moat mechanism applies?** (Benchmark, methodology, distribution depth, switching costs, brand?) `[DESIGN]`.
- **How does each recurring client strengthen the moat?** Specific, quantified — not "data gets better." "Each client contributes [N] accounts to the niche benchmark. Each client's signal calibration data reduces false positive rate by an estimated [X%]. Each client's churn/recovery patterns train the prediction model." `[H]` until quantified with real data.
- **Moat trajectory quantified:**

| Client Count | Benchmark Sample Size | Est. Signal Accuracy (FPR) | Switching Cost per Client | Defensibility Level |
|---|---|---|---|---|
| 5 | [N companies in benchmark] | ~30% FPR (uncalibrated) | Low — minimal data accumulated | FRAGILE — competitor can replicate |
| 20 | [N] | ~15% FPR | Medium — 6+ months of historical intelligence | MODERATE — benchmark has value |
| 50 | [N] | ~8% FPR | High — years of historical data, niche benchmark is reference-standard | STRONG — benchmark is a published asset |
| 100+ | [N] | ~5% FPR | Very High — leaving means losing niche benchmark access + years of intelligence history | DOMINANT — benchmark IS the industry standard |

- **At what client count does the moat become defensible?** Per §1.6 assessment. For most niches: 20-30 clients (benchmark becomes statistically meaningful; switching costs become material). `[H]` — estimate.

---

#### 10.5 Land-and-Expand Revenue Trajectory

- **24-month expected revenue curve per client:** Show expected MRR at each milestone.

| Milestone | Month | MRR (EUR) | What Changed |
|---|---|---|---|
| Entry (Sprint, one-time) | 0 | 0 (one-time fee: EUR X) | Sprint completed |
| Core Recurring Start | 1 | [X] | Recurring service begins |
| First Expansion Trigger | 6 | [X] | Signal combination fires (§10.3) |
| Expansion 1 Active | 7 | [X + Y] | First expansion service added |
| Expansion 2 Active | 14 | [X + Y + Z] | Second expansion service added |
| Full Portfolio | 24 | [X + Y + Z] | All applicable services active |

- **Step-up triggers at each stage:** What objective signal triggers each price increase? Not "Bob convinces them" — "Client's monitored account count exceeds tier threshold" or "Expansion signal combination from §6B.4 fires."
- **Expected expansion velocity:** What % of clients reach each milestone? `[S]` until validated.

---

#### 10.6 Service Tiering Driver

- **What determines Core vs. Premium vs. Enterprise pricing?** For THIS niche, the tiering driver is: [Company size / Number of monitored accounts / Number of signal sources / Usage volume / Number of users / Outcome magnitude / Service-level mix]. Select the primary driver with rationale. `[DESIGN]`.
- **Tier boundaries:** Specific, objective thresholds.

| Tier | Monthly Price (EUR) | Threshold | What Changes at This Tier |
|---|---|---|---|
| **Core** | [EUR 3K] | Up to [X] monitored accounts / [Y] signals | Standard signal catalog (§6B.2 Tier 1+2), weekly digest, monthly QBR |
| **Premium** | [EUR 5K] | [X+1] to [Z] accounts / additional signal sources | All Tier 1-3 signals, bi-weekly digest, dedicated analyst check-in, benchmark comparisons, expansion diagnostics |
| **Enterprise** | [EUR 8K+] | [Z+] accounts / multi-system / multi-geography | Custom signals, white-glove onboarding, dedicated analyst, quarterly on-site QBR, SLA with penalties |

- **Anchor:** Where do competitors draw their tier lines? From §10.1 audit. Show competitor tier boundaries alongside ClarityRev's. `[E]` from §10.1.

---

#### 10.7 Value Delivery Cadence

Not "monthly reports" — a specific rhythm showing the client experiences NEW value at every interval. The client must be able to answer "what did I get this month that I didn't have last month?"

- **Week 1 (Onboarding):** "Here's your starting state." Baseline report: current leakage rate, signal volume baseline, initial top 5 opportunities identified. Delivered as CRM dashboard + 60-min kickoff call with Adriaan. Client sees: "I didn't know I had EUR X in stalled deals."
- **Week 2:** First signal alert fired. "A buying signal was detected for Account X — here's the context and recommended action." Delivered as CRM task + Slack/Teams alert. Client sees: "This caught something I would have missed."
- **Month 1:** First monthly intelligence brief. "This month: X opportunities identified (EUR Y), Z risks flagged (EUR W at stake), N recoveries actioned." Delivered as PDF + CRM dashboard update. Client sees: "There's a pattern here — we consistently miss [type of signal]."
- **Month 3:** First benchmark comparison. "Your leakage rate: X% vs. niche median: Y%. Your signal action rate: Z% vs. top quartile: W%." Client sees: "We're above median on leakage but below on action rate — we detect but don't act."
- **Quarter 1:** ROI review. "You paid EUR X. We identified EUR Y in recoverable revenue. You actioned Z signals, recovering EUR W. Net ROI: (W−X)/X = N×." Delivered as QBR presentation. Client sees: "This paid for itself N times over."
- **Quarter 2+:** Expansion diagnostic. "We also found EUR X in [adjacent pain area]. Here's a mini-diagnostic — same format as your first Snapshot." Client sees: "There's more value we're not capturing."

**Client monthly experience (the "what am I paying for?" answer):** "Each month you receive: (1) Weekly digest every Monday — top 5 signals requiring action this week, ranked by EUR impact. (2) Real-time CRM tasks when a Tier 1 signal fires — subject line tells you what to do and why. (3) Monthly intelligence brief — patterns, trends, and benchmark comparisons. (4) Quarterly business review — ROI, adoption metrics, and expansion opportunities. All delivered in your CRM where you already work. No new tool to learn."

---

#### 10.8 Onboarding-to-Recurring Conversion

- **Is conversion automatic or sales-led?** "Your [Sprint/Pilot] converts to monthly at EUR X unless you cancel" (automatic) vs. separate sales conversation at pilot-end (sales-led). Choose with rationale for this niche. `[DESIGN]`.
- **If automatic:** What's the expected opt-out rate? What prevents "bill shock"? "Client receives reminder 14 days and 7 days before conversion. Conversion invoice references the specific Sprint results that justify the recurring commitment. 'Based on your Sprint results — EUR X recovered in 14 days — your recurring service begins [date] at EUR Y/month.'"
- **If sales-led:** What's the conversation? When (day 75 of 90-day pilot)? What evidence is presented? "Bob presents: Sprint results summary, projected recurring value based on Sprint signal patterns, ROI projection for 12 months of recurring, and client references (when available)."
- **Conversion rate assumption:** `[S]` — flag. Benchmark: B2B pilot-to-recurring conversion typically 30-60% (source: various SaaS benchmarks). State whether this niche is expected to be above or below that range and why.

---

#### 10.8.1 Client Provisioning Automation

When a client signs a recurring contract, what gets provisioned automatically?

| Provisioning Step | Automated? | Tool/API | Human Checkpoint | SLA |
|---|---|---|---|---|
| CRM connection verified | Yes — validates OAuth token still active | CRM API (§1.4) | Adriaan confirms if token expired | Day 0 |
| Signal configuration deployed | Yes — provisions client-specific signal catalog from §6B.2 | Recurring delivery engine | Adriaan reviews signal list for client context | Day 1 |
| Client dashboard provisioned | Yes — creates client tenant with data isolation | Supabase / hosting platform | None | Day 1 |
| First baseline Snapshot run | Yes — runs full signal sweep | Snapshot engine | Adriaan reviews for anomalies | Day 2 |
| Weekly digest template configured | Yes — brand, contacts, CRM fields | Email + CRM integration | Adriaan sends test digest | Day 3 |
| Welcome sequence triggered | Yes — email sequence + CRM tasks | HubSpot | Bob reviews first client comms | Day 1 |

---

#### 10.9 Competitive Retention Defense

- **If a competitor offers the same recurring service for 30% less:** What's the retention argument? "They charge 30% less. We guarantee value or you don't pay. Their cheaper price with no guarantee is riskier — you pay regardless of results. With us, if we don't deliver, you don't pay. That's actually the cheaper option." `[DESIGN]`.
- **Specific switching costs for THIS niche:**
  - Benchmark data they'd lose: [N] months of personalized benchmark context. Starting over with a new provider means 6-12 months before benchmark comparisons are meaningful.
  - Workflow embedding: ClarityRev delivers as CRM Tasks. Removing ClarityRev = sales team loses their daily action queue.
  - Integration depth: Custom CRM connector built for this client's specific fields and workflow.
  - Historical intelligence: [N] months of signal history, recovery patterns, and trend data — not exportable.
  - Relationship: Bob + Adriaan know their business. A new provider starts from zero.
- **"Cheaper to stay" math:** "Switching would cost: [N] weeks of re-onboarding (EUR X in lost productivity), [N] months before benchmark comparisons are meaningful (EUR Y in lost insight), re-integration with your CRM (EUR Z in IT time). Total switching cost: EUR [X+Y+Z]. Staying costs: EUR [monthly fee × 12]. You'd need the competitor to be [X%] cheaper just to break even on the switch — before accounting for the risk that their service isn't as good." `[H]` — estimate.

---

#### 10.10 "Why Cancel?" Pre-Mortem

Top 3 reasons a client cancels this recurring service. For each: the built-in defense AND the early warning signal.

| # | Cancellation Reason | Early Warning Signal | Built-in Defense |
|---|---|---|---|
| 1 | **Value decay** — "I forgot why we're paying for this" | Signal action rate drops below 30% for 2 consecutive months. Weekly digest open rate drops below 20%. | Monthly ROI dashboard showing cumulative value delivered since Day 1. QBR with before/after metrics. "Since you started, we've identified EUR X and you've recovered EUR Y." If action rate drops → adoption intervention (§6.8.6). |
| 2 | **Budget cut** — "We're cutting all non-essential spend" | Client mentions "budget review" in QBR. Procurement asks for "vendor justification" document. | Documented savings that make cancellation MORE expensive than keeping it. "You'll lose EUR X in recovered revenue to save EUR Y in subscription. Here's the net loss calculation." Position ClarityRev as revenue-generating, not cost-center. |
| 3 | **Competitor poach** — "Someone offered the same thing cheaper" | Client asks about contract terms, data export, or mentions competitor by name. | Data portability friction + benchmark loss + integration depth. "Before you switch, let's run a fresh Snapshot. If we're delivering value, the number will show it. If we're not, we'll fix it or you don't pay this month." |

**Churn rate benchmarks:** Industry average B2B SaaS monthly churn: 1.5-3% `[E]` — KeyBanc SaaS Survey 2025 (N=~150 private SaaS companies, self-reported churn data). Lower bound (1.5%) represents companies with >$10M ARR and dedicated CS; upper bound (3%) represents companies <$5M ARR without dedicated CS. Report: "KeyBanc 2025 Private SaaS Company Survey." Target for ClarityRev: <1.5%/month. At 1.5% monthly churn, annual retention = 83%. At 3%, annual retention = 69%. The difference is 14% of revenue annually — churn prevention is the highest-leverage activity in recurring revenue.

---

#### 10.11 Recurring Service Pre-Mortem & Churn Stress Test

##### 10.11.1 Recurring Service Pre-Mortem

"It's 18 months from now. 30 clients signed for recurring. Today, 14 remain. Monthly churn averaged 3.8%. What went wrong?"

The agent writes the specific failure narrative for THIS niche. Consider:
- **The value proposition didn't sustain.** Months 1-3: clients engaged. By Month 6: signals became background noise. "We already know our pipeline has gaps. Tell us something new." The recurring service didn't evolve.
- **The champion left.** Average CRO tenure: 21 months (§2.5 champion continuity risk). When the champion who bought the service left, the new champion saw it as "the previous person's tool" and canceled.
- **Competitor launched a bundled offering.** A competitor included signal monitoring in their existing platform at no additional cost. "Why pay ClarityRev EUR 3K/month when our CRM now does this for free?"
- **Clients didn't expand.** Without expansion, the recurring service felt static. Clients who stayed at the Core tier for 12+ months eventually questioned the value and churned. Expansion isn't just revenue growth — it's a retention mechanism.

##### 10.11.2 Churn Rate Stress Test

| Churn Scenario | Monthly Churn Rate | Annual Retention | Clients Remaining After 24 Months (from 30 starting) | Monthly Revenue Impact |
|---|---|---|---|---|
| **Optimistic** | 1.0% | 89% | 24 | Revenue grows through expansion |
| **Target** | 1.5% | 83% | 20 | Revenue stable; expansion offsets churn |
| **Industry Average** | 2.5% | 74% | 16 | Revenue declining unless expansion > churn |
| **Pessimistic** | 4.0% | 61% | 11 | Revenue in steep decline; service unviable without redesign |

**Churn kill switch:** If monthly churn exceeds 3% for 3 consecutive months AND client interviews confirm it's a value problem (not budget cycles), the recurring service design is wrong for this niche. Options: (a) redesign value cadence (§10.7), (b) pivot to quarterly/annual engagement instead of monthly, (c) accept that this niche only supports one-time paid services.

##### 10.11.3 Minimum Viable Recurring (Skeptical Advisor's Critique)

**The critique:** "You've designed a beautiful recurring service with tiers, expansion paths, benchmark moats, and QBR cadences. You have zero recurring clients. You haven't proven anyone will pay ONCE, let alone MONTHLY. The Sprint (§9) comes first. Get 10 paid Sprint clients. Track how many ask 'what happens after the Sprint?' If >30% ask that question unprompted, the demand for recurring is real. THEN build it."

**Minimum viable recurring sequence:**
1. **Validate the Sprint first** (§9.5.3). 10 paid deliveries. Target: ≥30% of Sprint clients express interest in ongoing monitoring.
2. **Build the core recurring service** only after Step 1 validates demand. Start with Core tier only. No Premium, no Enterprise, no expansion modules.
3. **Add expansion** after 10 recurring clients have been active for 6+ months and expansion signals (§6B.4) are firing.
4. **Add tiers** after 20 recurring clients — enough data to know where the natural tier boundaries are.

This sequencing is BINDING for build investment. The full recurring architecture is designed now for portfolio comparison, but build follows this sequence. `[DESIGN]`.

---

#### 10.12 Recurring Service Technical Operations

##### 10.12.1 Recurring Delivery Automation

For the core recurring service, what runs automatically and on what schedule?

| Delivery Component | Cadence | Automated? | Tools/APIs | Human Checkpoint | SLA |
|---|---|---|---|---|---|
| Signal detection sweep | Continuous | Yes | Signal detection engine (§6B sources) | None | ≤1 hr from source publication to detection |
| Signal prioritization + routing | Continuous | Yes | Prioritization engine (§6B.3) | None | ≤15 min from detection to CRM task |
| Weekly digest | Every Monday 7am local | Yes | Digest generation engine → email + CRM dashboard | Adriaan spot-checks 1 digest/week | Delivered by 9am Monday |
| Monthly intelligence brief | 1st of month | 80% automated | Brief generation engine (LLM synthesis + charts) | Adriaan reviews for narrative quality (30 min) | Delivered by 3rd business day |
| Quarterly Business Review | End of quarter | 50% automated | Data pull + slide generation automated | Bob reviews + customizes per client (60 min) | Scheduled within 2 weeks of quarter-end |
| Benchmark update | Monthly | Yes | Benchmark engine (anonymized aggregation across clients) | Adriaan validates for anomalies | Updated by 5th of month |

##### 10.12.2 Multi-Tenant Data Isolation

Per §11.12 and extending §8.6.3 for recurring tier:
- **Shared across clients:** Benchmark data (anonymized), signal taxonomies, prompt libraries, enrichment templates, workflow code, RAG infrastructure.
- **Per-client (strictly isolated):** CRM/ATS data, specific outputs, client-specific signals, historical intelligence, user accounts, client RAG interface (grounded in THEIR data only).
- **Data isolation enforcement:** Client A's CRM data never appears in Client B's outputs, dashboard, or benchmark in identifiable form. Anonymized benchmark data is the only cross-client flow. Per-client database schemas or row-level security enforced at the application layer.

##### 10.12.3 Recurring Service Health Monitoring

| Metric | Threshold | Alert |
|---|---|---|
| Client churn rate | >2%/month for 2 consecutive months | Bob + Adriaan — investigate value delivery |
| Signal volume per client | <50% of client's 3-month average for 2 consecutive weeks | Adriaan — data source issue or client business change |
| Weekly digest open rate | <30% for 3 consecutive weeks | Bob — client disengagement; check in |
| CRM task completion rate | <30% of Tier 1 tasks completed within urgency window | Bob — adoption intervention |
| Delivery SLA compliance | <95% of scheduled deliveries on time | Wesley — engine or pipeline issue |
| Client NPS | <30 for 2 consecutive quarters | Bob + Adriaan — relationship review |
| Expansion signal firing rate | 0 expansion signals for client active >9 months | Bob — proactive expansion conversation; may indicate client not growing |

---

**Done (minimum viable — FULL §10):** Recurring portfolio strategy stated. Competitor recurring audit (§10.1) with ≥3 competitors, source-verified, Match/Differentiate/Skip with strategic intent. Competitive recurring Strategy Canvas (§10.1a). Core recurring service designed (§10.2) with: evidence grades on all fields, strategic rationale for recurring, competitive decision, price with tiering driver + competitor anchoring, detailed scope (included/excluded), relationship to paid services (§9), LTV model, paid→recurring conversion model, onboarding process + automation, churn prevention (niche-specific), Bob's Usage (verbatim), top 3 objection responses (verbatim), niche-name-swap test. Expansion architecture (§10.3) with ≥2 paths, specific expansion triggers from §6B.4, expansion conversion math, and pricing model. Moat connection (§10.4) with quantified trajectory at 5/20/50/100 clients. Land-and-expand revenue trajectory (§10.5) with 24-month milestones + step-up triggers. Service tiering driver (§10.6) with objective boundaries + competitor anchoring. Value delivery cadence (§10.7) with 6 timeline checkpoints + client monthly experience description. Onboarding-to-recurring conversion (§10.8) with automatic vs. sales-led decision + conversion rate benchmark. Client provisioning automation (§10.8.1) with per-step automation + SLAs. Competitive retention defense (§10.9) with switching cost math. "Why Cancel?" pre-mortem (§10.10) with early warning signals + churn benchmarks. Recurring service pre-mortem (§10.11.1). Churn stress test at 4 scenarios (§10.11.2). Minimum viable recurring sequence (§10.11.3). Technical operations (§10.12): delivery automation, multi-tenant isolation, health monitoring.

**Excellent:** Every recurring service passes the niche-name-swap test. The LTV/CAC ratio exceeds 3× even at conservative conversion rates. The moat trajectory is quantified with specific accuracy improvements at each client-count threshold. The value delivery cadence is specific enough that a client could read it and know exactly what they receive. Churn prevention is tied to niche-specific triggers, not generic "great service." The switching cost math is specific — a client could calculate their own switching cost from it. The minimum viable recurring sequence is respected — Core tier only until 10 clients validate demand.

**ADVERSARIAL CHECK (extended):** "Is the recurring service genuinely different from the paid standalone, or just 'the same thing but monthly'? If the client asks 'what am I getting new each month?' — does §10.7 provide the answer? Is the single most dangerous assumption surfaced: that clients see ongoing value sufficient to justify a monthly commitment? The Sprint proved one-time value. Why do they keep paying? Is churn modeled at multiple scenarios — what if churn is 3%/month instead of 1.5%? Does the LTV model still close at 3% monthly churn? Is the minimum viable recurring concept respected — are we building recurring before validating one-time? What would the founders' most skeptical advisor say? Is the switching cost math honest, or does it assume clients value things (benchmark access, historical data) that a price-sensitive buyer might not care about?"

**Cross-references to update:**
- §1.6: RIOS Commit/Expand APPLIES → §10.2, §10.3
- §2.3: Purchase authority → §10.2 monthly price positioned within budget
- §3.3: ROI proof structure → §10.7 ROI review
- §4.1: Competitor pricing → §10.1 audit + §10.6 tier anchoring
- §6B: Client Signal Catalog → §10.2 what's included (signal IDs)
- §6B.4: Expansion signal combinations → §10.3 expansion triggers
- §6.8.6: Adoption pre-mortem → §10.10 churn early warnings
- §9: Paid services → §10.2 relationship to paid + conversion model

---

### SECTION 11: Automated Workflow Specifications

**Purpose:** Design automated workflows from first principles, grounded in what THIS niche specifically needs. Workflows are not selected from a predefined catalog — they are reverse-engineered from the heavy/boring work identified in §1.7, the pains in §3, the signals in §6, and the services designed in §8-10. This section must produce specifications that a senior engineer (Wesley) can build from without asking clarifying questions.

**Applied lenses:** Systems & Automation Designer (buildability, tool/API architecture, error handling, testing, performance, rollback), GTM Architect (workflow → commercial service mapping, sales enablement, demo-ability), Strategy Consultant (build-vs-buy, strategic prioritization, tool rationale), Research Analyst (evidence grades, tool availability verification), Red-Team (pre-mortem, tool/API risk, cost spiral, LLM quality drift)

**Evidence grading for this section (binding):**
- Tool exists and can perform the specified function: `[P]` — must cite documentation URL or test result
- Pattern demonstrated in a similar context: `[E]` — must cite the prior implementation
- This specific tool combination is new: `[H]` — must explain why it should work
- Relies on unproven technology or assumption: `[S]` — must flag for validation
- Design decision (not a factual claim): `[DESIGN]`

Every field in §11.2 and every claim in §11.1-11.14 must carry or inherit an evidence grade.

**Design principles (binding):**
1. **Workflows are designed from niche-specific first principles, not adapted from a catalog.** The agent must explain WHY each tool was chosen over alternatives. "Firecrawl over DataforSEO: Firecrawl handles JavaScript-rendered pricing pages; most competitors in this niche use React for their pricing pages." Not "Firecrawl because it's in the list."
2. **Every workflow enables a specific sales claim.** If a workflow exists but Bob can't use it in a sales conversation, it's infrastructure, not a product. Each workflow must map to a claim Bob can make: "Because we have [Workflow], we can tell you [specific insight] within [timeframe]."
3. **Build-vs-buy is an explicit decision per workflow.** Is ClarityRev building custom or leveraging existing tools? Custom = higher upfront cost, higher defensibility. Buy/existing tool = faster to market, lower defensibility. The agent must justify the decision per workflow.
4. **Every tool/API dependency is a single point of failure.** Each critical tool must have a documented fallback or contingency plan.

---

#### 11.1 First-Principles Workflow Design

For each automated workflow powering a commercial service:

**Step 1 — What's the job to be done?** Start from §1.7. What manual/heavy/boring work does this niche do that AI can automate? What questions would they ask an LLM grounded in their data? What data sources would be valuable to aggregate? What external signals matter to their revenue? Reference specific §1.7 entries. `[P]` — the job exists in this niche.

**Step 2 — What's the output?** What does the client/buyer actually receive? (PDF report, enriched CSV, real-time dashboard, embedded chat interface, CRM-native alert, automated email digest, Slack/Teams notification, custom web asset.) Must match the delivery method specified in §8-10 for the service this workflow powers. `[DESIGN]`.

**Step 3 — What tools/APIs/data sources power it?** No catalog limits. Consider ALL available: Firecrawl, DataforSEO, Clay, Apollo.io, Clearbit, Hunter.io, Crunchbase, LinkedIn (Sales Nav API / scraping), G2/Capterra (scraping), Reddit API, YouTube API, Google Trends, Google Search Console, SERP APIs, Facebook Ad Library, BuiltWith, Wappalyzer, n8n/Make, Supabase, Pinecone/pgvector, LangChain/CrewAI, custom Python scripts, CRM/ATS APIs, webhooks, RSS feeds, News APIs, podcast transcripts, SEC EDGAR, and anything else this niche requires.

**Build-vs-buy rationale (MANDATORY per workflow):** For each tool/API selected, state: BUILD (custom code), BUY (existing SaaS/API), or LEVERAGE (open-source/free tier). Justify: "BUY Clay for enrichment — existing API, proven at scale, faster than building custom enrichment pipeline. BUILD the signal taxonomy logic — it's niche-specific IP and our defensibility depends on it." `[DESIGN]`.

**Why this tool and not the alternative? (MANDATORY):** For each tool selected, name the most obvious alternative and explain why it wasn't chosen. "Firecrawl over DataforSEO for competitor pricing scraping: Firecrawl handles JavaScript-rendered pages; 2 of 3 competitors in this niche use React for their pricing pages. DataforSEO is better for SERP analysis but can't execute JS." This proves the choice was deliberate, not from a template. `[E]` if verified, `[H]` if reasoned.

**Step 4 — What does the LLM/agent do?** Specify the LLM role(s). Not "the LLM analyzes data" — specific tasks:
- **Command execution:** The LLM triggers actions in the workflow (e.g., "LLM detects churn signal → triggers Clay enrichment → triggers CRM task creation")
- **Synthesis/analysis:** The LLM processes raw data into structured insights (e.g., "LLM clusters 500 G2 reviews into 8 pain themes with verbatim quotes")
- **Chat/interface:** The LLM powers a RAG chat grounded in client data (e.g., "Ask anything about your market — competitor positioning, buyer objections, pricing benchmarks")
- **Generation:** The LLM produces deliverables (e.g., "LLM drafts 10 website headlines backed by VoC data with traceability to specific quotes")
- **Multiple roles:** Many workflows combine several of the above

**Step 5 — What's the trigger and cadence?** Event-triggered (signal detected), on-demand (client requests), scheduled (daily/weekly/monthly), or continuous (real-time monitoring).

**Step 6 — Where does human review add value?** Not "review everything." Specific checkpoints where human judgment matters: final output quality check, strategic recommendation validation, edge case handling, client-specific customization. For each checkpoint, state: who reviews, what they check, estimated time per review, and what happens if they reject the output.

**Step 7 — Sales enablement (MANDATORY):** What specific claim does this workflow enable Bob to make in a sales conversation? "Because we have [Workflow Name], I can tell prospects: '[verbatim claim, ≤30 words].'" Example: "Because we have the Stalled Deal Detector, I can tell prospects: 'We'll find every deal in your pipeline that's been stalled more than 30 days — with the exact reason and the next action — in 48 hours.'" `[DESIGN]`.

#### 11.2 Workflow Specification Format

For each workflow, complete all fields. Every factual claim must carry an evidence grade. Design decisions are marked `[DESIGN]`.

- **Workflow name** — descriptive, niche-specific. `[P]`.
- **Workflow ID** — machine-readable: `W{NN}_{descriptor}`. Example: `W01_stalled_deal_detector`. `[P]`.
- **Classification:** CORE (shared across niches) or NICHE-SPECIFIC (built per niche). With rationale. `[DESIGN]`.
- **Which commercial service does this power?** Traceability to §8, §9, or §10. Specify exact service name. `[P]`.
- **Which pain from §3 does this address?** Direct traceability. `[P]` — logical connection.
- **Which signals from §6 does this use?** Direct traceability. List specific signal IDs from §6B.2. `[E]` from §6B.
- **Sales enablement claim:** The verbatim claim Bob can make because this workflow exists. "Because of [Workflow], Bob says: '[verbatim, ≤30 words].'" `[DESIGN]`.
- **Input:** What data/sources feed in (specific URLs, APIs, data types). `[E]` if sources verified accessible.
- **Process:** Step-by-step tool/API chain. Format: `Tool A → Tool B → LLM processes → Tool C → output`. For each step: tool name, what it does, build-vs-buy decision, why this tool over the alternative. `[E]` if tools verified, `[H]` if assumed.
- **LLM/agent role(s):** Command execution, synthesis, chat interface, generation — specific tasks. Per §11.1 Step 4 specificity standard. `[DESIGN]`.
- **Output:** Exactly what's produced and how it's delivered. Must match the delivery method from the commercial service (§8-10). `[DESIGN]`.
- **Trigger & cadence:** What starts it, how often it runs. Per §11.1 Step 5. `[DESIGN]`.
- **Human review checkpoint:** Where, who, what they check, time per review, reject procedure. `[DESIGN]`.
- **Client-facing or internal:** CLIENT-FACING (output goes to client) or INTERNAL (feeds ClarityRev operations). `[DESIGN]`.
- **Demo-ability:** Can this workflow be demonstrated in a sales demo? LIVE (runs on real data during demo) / SIMULATED (uses pre-generated output) / NOT-DEMOABLE (backend only). If SIMULATED, explain how the demo version works. `[DESIGN]`.
- **Client-facing SLA (if applicable):** What's the committed turnaround time to the client? "Weekly digest delivered by Monday 9am." "CRM task created within 1 hour of signal detection." Must be achievable with current architecture. `[DESIGN]`.
- **Error handling:** What happens when a tool fails mid-chain? Retry? Fallback? Alert? Per failure mode. `[DESIGN]`.
- **Build effort:** S (<1 day) / M (2-5 days) / L (1-2 weeks) / XL (3+ weeks). `[H]` — estimate.
- **Dependencies:** What must exist before this workflow can be built? (CRM integration from §1.4, upstream workflows, benchmark data, API keys?) `[E]` if dependency verified, `[H]` if assumed.
- **Cost per run estimate (EUR):** API credits, LLM tokens, human review time, enrichment costs. Range: low-expected-high. `[S]` until 5+ production runs.
- **Quality criteria:** Per §11.9 standards. What does "good enough to deliver" look like for THIS specific workflow? What triggers "needs rework"? `[DESIGN]`.
- **Testing & validation:** How will this workflow be tested before client delivery? (Unit tests on tool chain? Sample output reviewed by Adriaan? A/B test against manual process? Dry run on ClarityRev's own CRM data?) `[DESIGN]`.
- **Rollback/recovery procedure:** If this workflow is updated and the new version produces worse output, how is the previous version restored? "Previous workflow version retained in git. Rollback: redeploy previous commit. Client outputs generated under old version retain version tag. Re-processing: optional, client-requested." `[DESIGN]`.

#### 11.3 LLM Interface Design (If Applicable)

If any workflow includes an LLM chat/query interface:

- **What data is the LLM grounded in?** (Client's CRM data, market research, competitor data, VoC corpus, internal docs, all of the above)
- **What can the user ask?** Example queries. Not "anything" — specific valuable use cases.
- **What can the LLM DO?** Just answer questions? Or trigger workflows? ("Find companies matching this ICP and enrich them" → triggers lead list workflow)
- **Interface:** Embedded on client site? Private dashboard? Slack/Teams bot? CRM-native panel?

#### 11.4 Workflow Architecture Diagram

A simple visual showing how workflows interconnect:

```
[Signal Detection] → [Enrichment] → [LLM Analysis] → [Output Generation] → [Delivery]
                                                         ↓
                                                  [Human Review]
                                                         ↓
                                                  [Client Delivery]
```

**Done (minimum viable):** ≥3 workflows specified with full tool/API chain, LLM role, trigger, output, and human checkpoint. Each traceable to a commercial service. At least one workflow uses tools/APIs beyond the obvious (Firecrawl, Clay, CRM API).

**Excellent:** Workflows are designed from niche-specific first principles — not adapted from any catalog. False positive handling specified. LLM roles are specific and implementable. Cost per run estimated. Error handling designed. At least one workflow combines command-execution LLM with a chat interface. The agent can explain WHY each tool was chosen over alternatives.

**ADVERSARIAL CHECK:** "Were these workflows designed for THIS niche, or adapted from a generic template? If we asked 'why Firecrawl and not DataforSEO for this step?' — is there a reasoned answer specific to the niche? If the workflow was presented to a developer, could they build it from this spec?"

#### 11.5 Core vs. Niche-Specific Classification

For each workflow, classify:

- **CORE:** Built once. Shared across all niches. Examples: G2 review scraper, DataforSEO SERP analyzer, Clay enrichment pipeline, Reddit API keyword monitor, FB Ad Library scraper, LLM synthesis engine, RAG chat infrastructure.
- **NICHE-SPECIFIC:** Built per niche. Examples: Bullhorn dormant-requisition detector, ConnectWise utilization analyzer, Applied Epic policy-lapse monitor, staffing-specific signal taxonomy, MSP churn predictor.
- **Investment implication:** CORE workflows are fixed cost (build once, amortize across 25 niches). NICHE-SPECIFIC workflows are variable cost (build per niche, justified by niche revenue potential). This distinction determines build economics and whether a niche is viable at low client counts.

#### 11.6 Workflow Dependency Graph

- **Which workflows feed into which others?** Example: Workflow A (G2 review scraper) → Workflow B (LLM pain-point clustering) → Workflow C (VoC Master Document generator).
- **Build sequence implication:** Workflows that produce output consumed by other workflows must be built first.
- **Dependency diagram** — simple visual showing upstream → downstream relationships.

#### 11.7 Workflow → Revenue Mapping

Each workflow must have clear revenue attribution:

- **Which commercial service does this workflow power?** (From §8, §9, §10.)
- **Revenue per unit:** If Workflow X powers the Competitive Brief (EUR 2K/ea), and it runs 5×/month, revenue equivalent = EUR 10K/mo.
- **Margin:** Delivery cost vs. revenue. Automated workflows with human review: ~70-85% margin. Manual-heavy workflows: ~40-60%.
- **Prioritization:** Rank workflows by revenue-per-build-hour. Build the highest-ROI workflows first.

#### 11.8 Client-Facing vs. Internal Flag

- **Client-facing:** Output goes directly to the client. Requires human review checkpoint. Quality bar: "would I present this to a board?"
- **Internal:** Output feeds ClarityRev's own analysis, sales enablement, or internal operations. Can be fully automated. Quality bar: "directionally accurate, flag material errors."
- **Flag each workflow** as CLIENT-FACING or INTERNAL. Different standards, different review processes.

#### 11.9 Output Quality Criteria

Per workflow type, define specific, measurable quality standards. Examples:

| Workflow Type | "Good Enough to Deliver" | "Needs Rework" |
|---|---|---|
| VoC Report | ≥5 verbatim quotes sourced from G2/Reddit; ≥3 pain themes clustered with ≤10% unclassified quotes; ≤10% of claims marked `[S]` | <3 quotes; quotes are generic ("users want better features"); >20% quotes unclassified; sources not cited |
| Competitive Brief | ≥3 competitors priced with source URLs; positioning claims verifiable from competitor websites; feature matrix ≥80% complete (≤20% UNKNOWN cells) | Pricing from memory/estimation; positioning claims unverifiable; feature matrix <50% complete |
| Lead List | ≥90% email validity (verified via Hunter.io or equivalent); ≥80% firmographic accuracy; ≥3 enrichment fields per record beyond name/company | <70% email validity; firmographic data unverified; single-source enrichment |

#### 11.10 Data Freshness SLA

Per data source type, define maximum age before output must be refreshed:

| Data Source | Max Age | Rationale |
|---|---|---|
| Competitor pricing (from website) | 90 days | SaaS pricing changes; annual contracts renew |
| G2/Capterra reviews | 180 days | Review velocity is slow; sentiment shifts gradual |
| Reddit/community discussions | 90 days | Fast-moving; new complaints emerge |
| CRM/ATS data (client's own) | Real-time or <24 hours | The diagnostic is only as good as the data; stale CRM data = wrong recommendations |
| Job postings (hiring signals) | 7 days | Job market moves fast; a 30-day-old job posting may already be filled |
| Funding announcements | 30 days | News cycle; still relevant for 1-3 months post-announcement |
| Company news | 14 days | News relevance decays quickly |
| Technographics (BuiltWith/Wappalyzer) | 180 days | Tech stacks change slowly |

- **Per workflow:** which data sources does it consume? What's the freshness requirement for each?
- **Staleness flag:** If workflow output is older than SLA, it must be labeled "Data as of [date] — refresh recommended."

#### 11.11 Workflow Composability

- **How do workflows chain?** Example: Competitive Brief (W2) → Positioning Recommendation (W3) → Website Copy Engine (W5). Output of W2 is input to W3. Output of W3 is input to W5.
- **Compound value:** Chained workflows produce outputs more valuable than the sum of individual workflows. The Competitive Brief alone = EUR 2K. The Brief + Positioning + Website Copy as a chain = EUR 7.5K (the Sprint). The chain IS the product.
- **Design for chains:** Each workflow output should be structured to serve as input to the next workflow in the chain.

#### 11.12 Multi-Tenant Architecture

For serving multiple clients in the same niche:

- **Shared across clients:** Benchmark data, prompt libraries, enrichment templates, signal taxonomies, industry knowledge base, RAG infrastructure, workflow automation code.
- **Per-client:** CRM/ATS data, specific outputs, client RAG interface (grounded in THEIR data), client-specific configurations, historical intelligence, user accounts.
- **Data isolation:** Per-client data must be strictly separated. Client A's CRM data never appears in Client B's outputs. Anonymized benchmark data is the only cross-client data flow.

#### 11.13 Monitoring and Alerting

- **Success detection:** How do we know a scheduled workflow ran successfully? (Output file generated? Notification sent? Client acknowledged?)
- **Failure detection:** What alerts fire when a workflow fails mid-chain? (API error? Timeout? Empty output? LLM refusal? Rate limit?)
- **Alert routing:** Who gets paged? (Wesley for engine failures; Adriaan for data/enrichment failures; Bob if client-facing output is delayed.)
- **Response procedure:** What happens when a workflow fails? (Automatic retry? Manual restart? Skip and flag? Escalate to human delivery?)
- **Minimum viable monitoring:** At zero clients, monitoring can be manual (Wesley checks). At 5+ clients, monitoring must be automated.

#### 11.14 Workflow Failure Modes

Per workflow, identify the most likely errors and what catches them before client delivery:

| Failure Mode | Example | Detection Method | Prevention |
|---|---|---|---|
| **False positive signal** | LLM flags a company as "hiring aggressively" based on a single job posting for an unrelated role | Volume threshold (≥3 job postings in relevant category) | Signal calibration during workflow design |
| **Hallucinated data** | LLM fabricates a competitor's pricing because it wasn't in the scraped data | Source citation required for every factual claim; `source_url` field must be populated | Prompt engineering: "If you cannot find the exact pricing on the page, state 'pricing not found' — do not estimate" |
| **Stale data** | Workflow uses competitor pricing from 6 months ago; competitor has since raised prices 30% | Data freshness check against SLA (§11.10); output stamped with "data as of [date]" | Scheduled re-scraping at SLA intervals |
| **Broken API connection** | Clay enrichment fails mid-chain because API key expired or rate limit hit | Retry with exponential backoff; alert if failure persists >3 attempts | API key rotation; rate limit monitoring; fallback data sources |
| **Empty/partial output** | G2 scraper returns 0 reviews because G2 changed their page structure | Output validation: "Expected ≥50 reviews, got 0 — flag for manual review" | Periodic scraper maintenance; Firecrawl Monitor on target page structure |

#### 11.15 Workflow Pre-Mortem & Tool/API Risk Assessment

##### 11.15.1 Workflow Pre-Mortem

"It's 18 months from now. 3 core workflows were built. 2 of them produce unreliable output. 1 has been abandoned because the key API was deprecated. Clients are receiving inconsistent deliverables. What went wrong?"

The agent writes the specific failure narrative for THIS niche's workflows. Consider:
- **API deprecation.** A critical tool (LinkedIn API, Crunchbase, Clay) changed pricing, restricted access, or was deprecated. The workflow that depended on it broke with no fallback.
- **LLM quality drift.** The LLM model that powered synthesis workflows was updated by the provider. Output quality degraded on niche-specific tasks. No monitoring detected it for 3 months.
- **Cost spiral.** Per-run costs were 3× estimates because prompt complexity grew, enrichment volume exceeded assumptions, and API pricing increased. Workflows that were profitable at 50 runs/month lost money at 200.
- **Scope creep.** "Just add one more signal source" became routine. Workflows accumulated technical debt. Build effort for changes grew from S to XL. No refactoring triggers existed.
- **False positive accumulation.** Without calibration feedback loops, signal false positive rates drifted upward. Clients received more noise, less signal. Trust eroded.

##### 11.15.2 Tool/API Dependency Risk Matrix

For every tool/API used across all workflows, assess:

| Tool/API | Workflows Dependent | Criticality (1-5) | Deprecation Risk | Fallback | Migration Cost |
|---|---|---|---|---|---|
| [Tool] | [W01, W03, W05] | [1-5] | LOW/MEDIUM/HIGH | [What replaces it?] | [Est. days to migrate] |

**Criticality scale:** 1 = "nice-to-have, workflow runs without it" → 5 = "workflow completely broken without it, no workaround exists."

**Deprecation risk assessment:** Based on: vendor stability (startup vs. enterprise), API versioning history, pricing change frequency, ToS restrictions relevant to ClarityRev's use case. `[H]` — judgment.

**Rule:** Any tool rated 4-5 criticality with HIGH deprecation risk must have a funded fallback plan before the workflow enters production. `[DESIGN]`.

##### 11.15.3 LLM Quality Drift Monitoring

LLM outputs degrade silently — the model still produces text, but quality drops. Detection requires active monitoring.

| Metric | Method | Threshold | Alert |
|---|---|---|---|
| Output structure compliance | Validate output against expected schema (JSON schema validation) | >5% of outputs fail schema validation in 24 hours | Wesley — prompt or model change |
| Factual hallucination rate | Spot-check 5% of outputs weekly: are source citations real? | >10% of spot-checked outputs contain unverifiable claims | Adriaan — prompt engineering review |
| Client "not useful" rate | Per §6B.10 client feedback | >30% of outputs marked "not useful" | Adriaan — workflow recalibration |
| Output length/token drift | Monitor output token count vs. 30-day baseline | >2σ deviation for 3 consecutive days | Wesley — possible prompt or model behavior change |

##### 11.15.4 Cost Spiral Scenario

**Scenario:** LLM API costs increase 3×. Enrichment API costs increase 2×. Monthly workflow costs go from EUR X to EUR 3-5X. What happens?

**Impact by client count:**

| Client Count | Current Monthly Workflow Cost (EUR) | After 3× LLM + 2× Enrichment | Margin Impact | Action |
|---|---|---|---|---|
| 5 | [X] | [3-5X] | [%] | Absorb — absolute cost is low; revisit at 20 clients |
| 20 | [X] | [3-5X] | [%] | Optimize: reduce LLM calls, batch enrichment, negotiate API pricing |
| 100 | [X] | [3-5X] | [%] | Strategic: evaluate self-hosted models, build proprietary enrichment where defensible |

**Cost optimization triggers (automated):**
- Per-run cost exceeds 120% of 30-day average → alert Wesley
- Monthly workflow cost exceeds 20% of associated service revenue → flag for margin review
- Any single API's cost grows >50% quarter-over-quarter → trigger re-evaluation of build-vs-buy

---

#### 11.16 Workflow Testing & Validation

##### 11.16.1 Per-Workflow Testing Requirements

Before any workflow output reaches a client:

| Test Type | What It Verifies | Method | Pass Threshold | Frequency |
|---|---|---|---|---|
| Unit test | Each tool/API in the chain works in isolation | Test API call with known input → verify expected output | 100% pass | On every deploy |
| Integration test | Full chain runs end-to-end | Run workflow on test data → verify output format + quality | 100% pass | On every deploy |
| Output quality review | Output meets §11.9 "good enough to deliver" standard | Adriaan reviews 3 sample outputs against quality criteria | 3/3 pass | First deploy + on MAJOR version change |
| Human baseline comparison | Automated output is at least as good as manual process | Compare workflow output to human-produced equivalent (Adriaan manually does the task once) | Automated ≥ human on accuracy, faster on time | First deploy |
| Client acceptance | Client confirms output is useful | First 3 client deliveries include feedback form; client rates usefulness 1-5 | Average ≥4.0 | First 3 deliveries per client |

##### 11.16.2 Dry-Run Protocol

Before a workflow is used in a paid client engagement:
1. Run workflow on ClarityRev's own CRM data (if applicable). Verify output is sensible.
2. Run workflow on a friendly test client's data (first calibration partner from §6.8.4). Verify output matches their reality.
3. Run workflow in parallel with manual process for 2 weeks. Compare results.
4. If automated output matches or exceeds manual in ≥90% of cases → promote to production.
5. If not → fix, re-test, repeat.

---

#### 11.17 Workflow Performance & Optimization

##### 11.17.1 Workflow Performance Benchmarks

| Workflow Type | Target Runtime | Max Acceptable Runtime | Cost per Run Target (EUR) | Max Cost per Run (EUR) |
|---|---|---|---|---|
| Signal detection (real-time) | <5 min | <15 min | <2 | <5 |
| Enrichment pipeline (batch) | <30 min (per 100 records) | <2 hrs | <10 | <25 |
| LLM synthesis/report | <15 min | <1 hr | <5 | <15 |
| Weekly digest generation | <10 min | <30 min | <3 | <8 |
| Benchmark computation (monthly) | <1 hr | <4 hrs | <20 | <50 |

**Runtime SLA:** If any workflow exceeds max acceptable runtime for >10% of runs in a 24-hour period → performance investigation triggered. `[DESIGN]`.

##### 11.17.2 Workflow Optimization Triggers

| Trigger | Action |
|---|---|
| Per-run cost exceeds 150% of target for 10 consecutive runs | Cost optimization review: reduce LLM calls, cache repeated enrichments, batch API requests |
| Runtime exceeds max acceptable for >20% of runs in a week | Performance optimization: parallelize where possible, upgrade API tiers, optimize prompts for speed |
| Human review time per output exceeds estimate by >50% | Process optimization: improve output quality (less rework needed) or automate the review checkpoint |
| Same manual fix applied to >30% of outputs | Automation opportunity: the human fix is pattern-repeatable → encode it in the workflow |

##### 11.17.3 Workflow Documentation Standards

Every workflow must include (stored in workflow repository, referenced from canvas):

```yaml
workflow_id: "W01_stalled_deal_detector"
version: "v1.2"
last_updated: "2026-07-22"
author: "[Agent]"
status: "DESIGNED / IN_DEVELOPMENT / TESTING / PRODUCTION / DEPRECATED"
commercial_service: "[§9 Service Name]"
build_effort: "M"
build_hours_actual: null  # populated after build
dependencies:
  - "CRM integration (§1.4) — HubSpot OAuth"
  - "Clay API key — enrichment pipeline"
  - "Signal detection engine — §6B signals 01, 03, 07"
cost_per_run_estimated: 3.50  # EUR
cost_per_run_actual: null  # populated after 20+ runs
last_performance_review: null
known_issues: []
optimization_backlog: []
```

---

**Done (minimum viable — FULL §11):** ≥3 workflows specified with full §11.1-11.17 detail. Each workflow has: evidence grades on all fields (§11.2), build-vs-buy rationale with alternative tool comparison (§11.1 Step 3), sales enablement claim (§11.1 Step 7), classification as CORE or NICHE-SPECIFIC (§11.5), dependency graph (§11.6), revenue attribution (§11.7), client-facing vs. internal flag (§11.8), quality criteria (§11.9), data freshness SLA (§11.10), composability mapping (§11.11), testing & validation spec (§11.16), rollback/recovery procedure (§11.2), demo-ability assessment (§11.2), client-facing SLA (§11.2). Tool/API dependency risk matrix (§11.15.2) with criticality + deprecation risk + fallback per tool. LLM quality drift monitoring (§11.15.3) with 4 metrics + thresholds. Cost spiral scenario modeled at 3 client-count levels (§11.15.4). Workflow performance benchmarks per type (§11.17.1) with runtime + cost targets. Documentation standards per workflow (§11.17.3).

**Excellent:** The agent can explain WHY each tool was chosen over the most obvious alternative — and the explanation is specific to this niche. Every workflow enables a specific, verbatim sales claim Bob can use. Build-vs-buy decisions are explicit and defensible. Tool/API dependencies rated 4-5 criticality have funded fallback plans. Workflow pre-mortem names specific failure modes unique to this niche's tool stack. Dry-run protocol is specified and sequenced. Performance benchmarks are realistic for this niche's data volumes. Cost optimization triggers are automated. At least one workflow chains 3+ tools in a non-obvious combination specific to this niche.

**ADVERSARIAL CHECK (extended):** "Were these workflows designed for THIS niche, or adapted from a generic template? If we asked 'why Firecrawl and not DataforSEO for this step?' — is there a reasoned answer specific to the niche? If the workflow was presented to a developer, could they build it from this spec? Does every workflow enable a specific sales claim, or are some just infrastructure? What happens when the most critical API is deprecated — is there a fallback? If LLM costs increase 3×, do the workflows still make economic sense at 20 clients? At 100? Is there automated monitoring to detect LLM quality drift, or would we only find out when a client complains?"

---

### SECTION 12: Evidence Stack & Proof Architecture

**Purpose:** Design the evidence system that de-risks the purchase for this niche's buyers. In B2B, proof > persuasion. At zero clients, the evidence stack must be honest about what doesn't exist yet AND specific about what substitutes. This section arms Bob with the specific evidence assets he deploys at each point in the sales conversation — not just a list of proof types, but a playbook for WHEN and HOW to use each one.

**Applied lenses:** Research Analyst (evidence quality, confidence calibration, counter-evidence), GTM Architect (trust architecture, MEDDIC mapping, evidence playbook, objection handling), Strategy Consultant (evidence positioning, gap prioritization, competitive trajectory), Systems Designer (evidence automation, freshness tracking), Red-Team (zero-client honesty, guarantee stress-test, pre-mortem, competitor weaponization)

**Evidence grading for this section (binding):** Every factual claim and every evidence asset must carry an evidence grade `[P/E/H/S]`. Design decisions are marked `[DESIGN]`. The overall evidence stack inherits the WEAKEST grade among its load-bearing claims.

---

#### 12.1 Zero-Client Honesty Statement (Write This First)

Before listing evidence types, explicitly state what ClarityRev CANNOT prove at this stage:

- **We have:** Industry benchmarks (26% leak rate — Clari/Vanson Bourne, N=420) `[E]`, founder credentials (Adobe enterprise sales, Clay/data ops, AI architecture) `[P]`, a working demo for the staffing niche (Gapstars) `[P]`, a free diagnostic that proves the problem on the buyer's own data `[P]`.
- **We do NOT have:** Client case studies, client references, proprietary benchmark data, named logos, third-party validation (Gartner, Forrester), SOC2 certification. `[P]` — these are verifiable absences.
- **Our evidence strategy therefore relies on:** Empirical proof (their own data via Snapshot) over social proof (logos, references). This is a deliberate choice — their numbers are more compelling than someone else's logo. `[DESIGN]`.
- **Timeline to close the gap:** First pilot results → Month 3 `[S]`. First case study → Month 4-6 `[S]`. Reference calls available → Month 6+ `[S]`. Benchmark data meaningful → 50+ diagnostics (Month 9-12) `[S]`. SOC2 → when justified by enterprise pipeline `[DESIGN]`.
- **The "no references" assumption (MANDATORY stress test):** The entire evidence strategy assumes that empirical proof (their own data) overcomes the absence of social proof (references, logos). What if it doesn't? "It's Month 6. 50 Snapshots delivered. 3 paid conversions. The #1 objection from the 47 non-converters: 'We need to see a reference before we commit.' Our response — 'Your own data is the only reference that matters' — worked on 3 buyers and failed on 47. We have no fallback evidence strategy." **Mitigation:** By Month 3, the first pilot client becomes an anonymized case study. By Month 6, the first named reference. The evidence strategy is a TRANSITION plan — empirical proof carries the load until social proof exists. If empirical proof alone isn't converting by Month 4, accelerate reference-building timeline. `[H]` — scenario.

---

#### 12.2 Evidence-to-Buyer Mapping (MEDDIC-Aligned)

Map every committee member from §2 to the specific evidence they need at each decision stage. Each cell must state the evidence asset AND its grade.

| Committee Member | Awareness Stage | Consideration Stage | Decision Stage | Retention Stage |
|---|---|---|---|---|
| Economic Buyer (§2.1) | Industry benchmark showing scale of problem `[E]` | Snapshot output on THEIR data `[P]` + ROI projection `[H]` | Guarantee terms `[DESIGN]` + reference call (when available) `[E]` | Quarterly ROI report `[P]` + benchmark comparison `[E]` |
| Champion (§2.1) | Free Snapshot one-number output `[P]` | Competitive comparison showing whitespace `[E]` | Internal business case (we help them write it) `[DESIGN]` | Monthly wins to share with their boss `[P]` |
| Technical Evaluator (§2.1) | Security one-pager `[DESIGN]` | DPA + data handling documentation `[DESIGN]` | API documentation + integration spec `[H]` | Uptime reports + compliance updates `[P]` |
| End Users (§2.1) | "What you'll get" sample output `[DESIGN]` | Live demo of in-system delivery `[P]` | Pilot results showing time saved `[P]` | Weekly intelligence digest `[P]` |
| CFO/Finance (§2.2) | Industry benchmark (cost of inaction) `[E]` | Displacement cost analysis (§3.6) `[H]` | ROI projection with conservative case `[H]` | Actual vs. projected ROI at quarter-end `[P]` |

**Evidence gap priority matrix:** Which missing evidence assets hurt most?

| Missing Evidence | Committee Member Affected | Stage Impacted | Conversion Impact (H/M/L) | Time-to-Fill | Mitigation |
|---|---|---|---|---|---|
| Client references | Economic Buyer, Champion | Decision | HIGH — #1 objection | Month 6+ | Anonymized case study at Month 3; empirical proof carries load until then |
| Named case studies | Economic Buyer, CFO | Decision | HIGH | Month 4-6 | Industry benchmarks + Snapshot output as substitute proof |
| Proprietary benchmark data | Economic Buyer, Champion | Consideration, Retention | MEDIUM | Month 9-12 | Published industry data as substitute; cite source and limitations |
| SOC2 certification | Technical Evaluator | Decision | MEDIUM (enterprise only) | Month 12+ | Security one-pager + DPA + transparent data handling docs |
| Third-party validation (Gartner) | Economic Buyer, CFO | Awareness | LOW (early stage) | Year 2+ | Founder credentials + published industry benchmarks |

---

#### 12.3 Competitor Evidence Comparison

What proof can the top 3 competitors deploy vs. what ClarityRev deploys? Weaponize the contrast:

| Evidence Type | Competitors (agent must name specific competitors from §4) | ClarityRev | Who Wins? | Grade |
|---|---|---|---|---|
| Social proof | 500+ logos, named case studies, G2 reviews | Zero at launch | Competitors | `[P]` |
| Empirical proof | "Companies like you see X% improvement" | "YOU are leaking EUR X — here's the exact list of deals" | **ClarityRev** | `[P]` |
| Methodology | Black-box AI | Transparent: "We scan these 8 leak types using your CRM data + these 20 external signal sources" | **ClarityRev** | `[P]` |
| Risk reversal | Annual contract, no guarantee | Data-underwritten guarantee: "If Snapshot doesn't show 3× ROI, Sprint is free" | **ClarityRev** | `[DESIGN]` |
| Speed to proof | 2-4 week implementation | 48 hours from data connection to one number | **ClarityRev** | `[DESIGN]` |

**The pitch:** "They have logos. We have YOUR numbers. Which would you rather make a decision on?" `[DESIGN]`.

**Competitive evidence trajectory (24-month projection):**

| Evidence Type | ClarityRev Today | ClarityRev Month 6 | ClarityRev Month 12 | ClarityRev Month 24 | Competitors Today |
|---|---|---|---|---|---|
| Social proof | None | 1-2 named case studies | 5+ case studies, reference calls | 20+ case studies, G2 presence | 500+ logos |
| Empirical proof | Snapshot on their data | + Sprint recovery data | + 6-month recurring outcome data | + multi-year benchmark data | Generic improvement claims |
| Benchmark data | None (published substitutes) | 50+ diagnostics aggregated | Published niche benchmark report | Industry-reference benchmark | May have benchmarks (varies by competitor) |
| Security certs | None | DPA + security docs | SOC2 Type I in progress | SOC2 Type II | SOC2 / ISO 27001 |

**The trajectory IS the strategy:** ClarityRev doesn't try to match competitors on social proof. It builds a different evidence category — empirical, data-grounded, niche-specific — where competitors can't follow without changing their product architecture. By Month 24, ClarityRev has BOTH empirical proof (where it leads) AND social proof (where it has closed the gap). `[DESIGN]`.

---

#### 12.4 The Diagnostic Moment

Design the specific experience when the prospect sees their number for the first time. This is the emotional peak of the sales process — not just "proof" but a designed conversion event:

- **The setup:** Prospect uploads CRM data or grants read-only OAuth. ClarityRev processes for 48 hours. Prospect receives email: "Your Revenue Leakage Snapshot is ready." `[DESIGN]`.
- **The opening:** One-page report. Top line: "You are leaking EUR [X]/yr through [top 3 leak sources]." Below: ranked list of top 5 recoverable deals, each with EUR value, reason stalled, and recommended next action. `[DESIGN]`.
- **The gap:** Prospect thought they were leaking EUR 50K. Report shows EUR 400K. The EUR 350K gap is the emotional engine. `[H]` — example; actual gap is niche-specific.
- **The next step:** "We can recover the top 3 deals in 14 days. EUR 5K. Guaranteed 3× ROI or free." This is not a separate sales call — it's the natural next sentence after the number. `[DESIGN]`.
- **Design principle:** The Snapshot output IS the sales deck. No separate pitch. No follow-up meeting required. The number does the selling. `[DESIGN]`.

**Bob's evidence playbook (WHEN to use WHICH evidence):**

| Conversation Stage | Evidence Asset Bob Deploys | What Bob Says (Verbatim) |
|---|---|---|
| **First contact** (cold email/LinkedIn) | Industry benchmark + Snapshot offer | "[Niche] companies lose EUR X/yr to revenue leakage. We built a free diagnostic that finds YOUR number in 48 hours. Want to see it?" |
| **Snapshot results call** (the Diagnostic Moment) | Snapshot output + top 5 recoverable deals | "You're leaking EUR X/yr. Here are the top 5 deals you can recover, ranked by EUR. The gap between what you thought and what we found is EUR Y." |
| **Sprint proposal** (Prove stage) | Sprint scope + guarantee terms + ROI projection | "We recover the top 3 deals in 14 days. EUR 5K. If we don't find 3× that in recoverable revenue, it's free. Your own data underwrites this." |
| **Objection: "I need references"** | Anonymized case study (Month 3+) OR pivot to empirical proof | "Fair. We're new. Here's what a [niche] company your size found. [Show anonymized results.] But honestly — your own Snapshot number is more relevant to YOU than any reference. Here's your number. Let's talk about what it means." |
| **Recurring proposal** (Commit stage) | Sprint results + projected recurring value + retention metrics | "The Sprint recovered EUR X. Ongoing monitoring would have caught 3 of those deals months earlier. At EUR Y/month, it pays for itself if we catch ONE deal per quarter." |
| **QBR** (Retention stage) | ROI dashboard + benchmark comparison + expansion diagnostic | "You paid EUR X. We identified EUR Y, you recovered EUR Z. Your leakage rate is [X%] vs. [Y%] niche median. We also found EUR W in [adjacent area]." |

---

#### 12.5 Proof-on-Their-Data

What can ClarityRev prove using the prospect's OWN data (via the free Snapshot)? Extended from §7.2:

- **What specific CRM/ATS fields are analyzed?** (Opportunities, Deals, Contacts, Activities, Quotes, Contracts) `[DESIGN]`.
- **What leak types are detected?** (Expired quotes, stalled deals, orphaned renewals, unowned leads, departed champions, missed reactivation, incomplete handovers, unacted signals — from §3 pain dimensions) `[DESIGN]`.
- **How is the EUR figure calculated?** (Deal value × historical win rate × recovery probability — explicit formula) `[DESIGN]`.
- **What does the output look like?** (Describe the one-page report format) `[DESIGN]`.
- **Evidence grade:** `[P]` — this is their data. The calculation method is `[H]` until validated by actual recoveries.

---

#### 12.6 Segment Benchmarks

- **Existing benchmarks:** What published data exists for this niche's pain? (Source, year, N-size, potential bias.) `[P]` or `[E]`.
- **ClarityRev-built benchmarks:** If §1.6 moat is YES or LATER STAGE — what benchmarks will ClarityRev build from diagnostics? Timeline to meaningful sample size. `[S]` until data exists.
- **If §1.6 moat is LATER STAGE or NO:** Benchmarks won't exist at launch. Substitutes: published industry data, competitor case studies (cited as "according to UserGems..."), conservative estimates from adjacent niches, academic research. `[E]` if substitutes sourced, `[H]` if inferred.
- **Counter-evidence (systematic, not one example):** For each core claim, identify the strongest counter-evidence and address it:

| Core Claim | Strongest Counter-Evidence | Our Response | Honest? |
|---|---|---|---|
| "26% revenue leakage" | Well-managed orgs with dedicated RevOps see 8-12% leakage (Source: [name, year]) | True. Our target buyer (companies WITHOUT dedicated RevOps) maps to the higher figure. For buyers WITH RevOps, we adjust the benchmark accordingly. | Yes — we don't claim 26% applies universally |
| "48-hour diagnostic" | Data quality issues can delay analysis | True. 48 hours assumes CRM data is accessible and moderately clean. Our Snapshot agreement states: "48 hours from successful data connection." If data requires cleaning, timeline extends. | Yes — we set realistic expectations |
| "[Niche-specific claim]" | [Counter-evidence] | [Response] | |

- **Source attribution standard:** Every benchmark claim: source name, source type (primary research, vendor content, media, user-generated), publication year, potential bias, URL. `[P]` — this is a documentation standard.

---

#### 12.7 Reference-Building Plan (Not "Reference Cases" Yet)

At zero clients, this is a BUILDING plan, not a USING plan:

- **Month 1-2: No references.** Sales rely entirely on the free Snapshot as proof-on-their-data. `[P]`.
- **Month 3: First pilot client completes.** Request permission to publish anonymized results (e.g., "EUR 100-200K in recoverable pipeline identified for a [niche] company"). `[S]` — timeline.
- **Month 4-6: First named case study.** Format: client profile (anonymized or named with permission), before state (leakage found), intervention (Sprint delivered), after state (revenue recovered), client quote, specific EUR numbers. `[S]`.
- **Month 7-12: 3-5 case studies across sub-segments.** `[S]`.
- **Reference call protocol:** What clients agree to. How often they can be called (max 1×/quarter). Incentive for participating (discount? benchmark access? featured in report?). `[DESIGN]`.

---

#### 12.8 Methodology Validation

What makes ClarityRev's methodology credible? Specific, named practices — not "proprietary AI":

- **Anchored methodology:** "Our leakage detection follows the revenue attribution framework used by Clari in their Revenue Leak Report (Vanson Bourne, N=420)." `[E]`.
- **Transparent process:** "We scan 8 specific leak types using defined CRM fields. The algorithm is documented. Here's exactly what we look for." `[DESIGN]`.
- **Founder credibility:** "Wesley built AI pipelines for [X]; Bob spent 2 decades in enterprise sales at Adobe seeing these leaks firsthand; Adriaan ran data ops at scale." `[P]`.
- **Third-party data sources:** "We cross-reference your CRM data with 20+ signal sources including Crunchbase, LinkedIn, job boards, and news APIs." `[E]` if sources verified.
- **What we are NOT:** "We don't use a black-box AI. Every recommendation traces to a specific signal or data point. You can verify every claim we make." `[DESIGN]`.

---

#### 12.9 Guarantee Design

- **Guarantee mechanism:** What specifically is guaranteed? "If the Snapshot doesn't identify EUR [3× Sprint fee] in recoverable pipeline value, the Sprint is free." `[DESIGN]`.
- **Data underwriter:** The free Snapshot. We see their data before quoting. We only offer the Sprint when the data supports it. `[P]` — process.
- **Attribution boundaries:** What counts as "recovered by ClarityRev"? (Only deals that were specifically identified in the Snapshot/Sprint output and actioned within 90 days.) What does NOT count? (Deals the sales team was already working. Deals that closed for unrelated reasons.) `[DESIGN]`.
- **Financial exposure calculation:** "If 20% of clients invoke the guarantee in Year 1, max liability = [N clients × 20% × Sprint fee]. At 10 clients and EUR 5K Sprint = max EUR 10K exposure." Must be calculated per niche. `[S]` until validated.
- **Contractual liability cap:** "ClarityRev's maximum liability under this guarantee is limited to the fees paid for the specific engagement. No consequential damages." `[DESIGN]`.
- **"Honest negative" protocol:** If the Snapshot finds minimal leakage (e.g., <EUR 50K in a EUR 10M company), ClarityRev tells them honestly: "Your pipeline is healthier than most. Here's what's still worth watching." No forced sale. This builds more long-term trust than forcing a Sprint on a weak finding. `[DESIGN]`.

---

#### 12.10 Case Study Plan

For when references exist (per §12.7 timeline):

- **Structure:** Client profile → Problem (pre-Snapshot state) → Discovery (Snapshot findings) → Intervention (Sprint/Recurring) → Results (EUR recovered, time to value) → Client quote. `[DESIGN]`.
- **Minimum viable case:** "We saved 2 deals worth EUR 45K." Small but real. `[DESIGN]`.
- **Ideal case:** "We identified EUR 412K in recoverable pipeline and recovered EUR 187K within 90 days." `[DESIGN]`.
- **Formats:** One-page PDF, slide deck version, video testimonial (when available), G2 review (when appropriate). `[DESIGN]`.

---

#### 12.11 Security/Privacy Specification (Not Narrative)

Structured specification, not a paragraph:

- **Data access method:** Read-only OAuth (HubSpot, Salesforce), CSV upload (universal fallback), Bullhorn REST API (requires partner agreement per §1.4). `[E]` from §1.4.
- **Data processed:** Specifically — Opportunities, Deals, Contacts, Accounts, Activities, Quotes, Contracts. NOT: emails, call recordings, documents, candidate data (staffing), patient data (healthcare). `[DESIGN]`.
- **Data storage:** EU-only (AWS Frankfurt / equivalent). Encrypted at rest (AES-256) and in transit (TLS 1.3). `[DESIGN]`.
- **Data retention:** Free Snapshot: 90 days then auto-deleted (extended per §8.6.3). Paid engagement: duration of engagement + 90 days. Client can request immediate deletion. `[DESIGN]`.
- **Data deletion:** Automated purge. Confirmation provided. `[DESIGN]`.
- **Sub-processors:** Named specifically — OpenAI API (analysis), Clay (enrichment), Supabase (database), [hosting provider]. No data used for model training by any sub-processor. `[DESIGN]`.
- **Certifications:** None at launch. SOC2 Type II planned when enterprise pipeline justifies (est. Month 12+). `[P]` — honest about current state.
- **DPA:** Standard DPA provided. Based on Cognism template (GDPR-compliant, processor role). `[DESIGN]`.
- **Breach notification:** Within 72 hours per GDPR Art. 33. `[P]` — regulatory requirement.

---

#### 12.12 Evidence Freshness & Automation

- **Auto-generated evidence:** Snapshot output (always fresh — runs on current data), benchmark comparisons (refresh with each new diagnostic), ROI dashboards (real-time). `[DESIGN]`.
- **Manually created evidence:** Case studies (annual refresh), methodology documentation (quarterly review), security documentation (annual review + on-change). `[DESIGN]`.
- **Staleness detection:** Each evidence asset stamped with "last updated" date. Assets >90 days old flagged for review. Assets >180 days old automatically labeled "Data as of [date] — may not reflect current state." `[DESIGN]`.

**Evidence automation pipeline:** How are evidence assets generated, stored, and kept fresh?

| Evidence Asset | Generation Method | Storage | Refresh Trigger | Owner |
|---|---|---|---|---|
| Snapshot output | Automated — Snapshot engine | Client-specific, CRM-delivered | On-demand (each new Snapshot) | Wesley (engine) |
| ROI dashboards | Automated — recurring delivery engine | Client dashboard | Real-time (continuously updated) | Wesley (engine) |
| Benchmark reports | Automated — anonymized aggregation across clients | Shared (anonymized), per-client (personalized) | Monthly | Adriaan (review) |
| Case studies | Manual — Adriaan writes, client approves | Website, sales collateral, G2 | Annual refresh or on new major result | Adriaan |
| Methodology docs | Manual — Adriaan + Wesley | Website, security package | Quarterly review | Adriaan |
| Security documentation | Manual — Wesley | Website, security package | Annual review + on-change | Wesley |

---

#### 12.13 Evidence Pre-Mortem & Risk Assessment

##### 12.13.1 Evidence Pre-Mortem

"It's 12 months from now. We executed the evidence strategy as designed. Buyers still don't trust us. Why?"

The agent writes the specific failure narrative for THIS niche. Consider:
- **"Your own data" wasn't enough.** Buyers acknowledged the Snapshot findings but still wanted to see references before committing budget. "We love the diagnostic. Who else has used this?" → "We're new — you'd be among the first." → Silence. The empirical proof strategy failed to overcome the social proof gap.
- **Competitors weaponized our zero-client status.** "ClarityRev? They're 3 founders with no clients. Here's our Gartner Magic Quadrant position and 500 referenceable customers." Buyers chose the safe option.
- **The guarantee wasn't trusted.** "3× ROI or free" sounded too good to be true. Buyers assumed there was fine print that would let ClarityRev weasel out of it.
- **The first case study was too small to matter.** "They saved EUR 45K across 2 deals? Our problems are bigger than that." The minimum viable case wasn't compelling to THIS niche's buyers.

##### 12.13.2 Competitor Weaponization Scenario

**Scenario:** A well-funded competitor reads §12 and launches a campaign targeting ClarityRev's zero-client status.

**Their attack:** "Would you trust your revenue data to a company with zero clients? Zero references? Zero security certifications? We have 500+ logos, SOC2 Type II, and a Gartner Magic Quadrant position. Our free trial takes 2 weeks. Theirs takes 48 hours. Speed isn't safety."

**ClarityRev's counter (Bob's response, verbatim):** "They have 500 logos. We have zero. Here's why that matters: every one of those 500 clients gets the same generic report. We have zero clients, which means YOUR business becomes OUR reference architecture. Our signals get tuned to YOUR reality. And you don't have to trust us — you verify on YOUR data, for free, in 48 hours. If we don't find anything, you've lost nothing. If we do, you decide what to do with the number. No commitment. No fine print."

##### 12.13.3 Confidence Calibration on Evidence Stack

**Overall evidence stack confidence for this niche:** HIGH / MEDIUM / LOW.

| Confidence Level | Criteria | When |
|---|---|---|
| HIGH | ≥3 named case studies, published benchmark report, reference calls available, guarantee validated by ≥20 deliveries | 20+ clients, 12+ months |
| MEDIUM | 1-2 case studies, 50+ diagnostics aggregated, guarantee <20% invocation rate | 5-20 clients, 6-12 months |
| LOW | Zero clients, no case studies, no proprietary benchmarks, unvalidated guarantee | 0-5 clients, 0-6 months |

At zero clients, the evidence stack confidence is LOW — and that's honest. The strategy is a transition plan from LOW to HIGH, with empirical proof carrying the load until social proof exists. `[P]` — this is the current state.

---

**Done (minimum viable — FULL §12):** Zero-client honesty statement with "no references" assumption stress-tested. Evidence-to-buyer mapping with grades per cell. Evidence gap priority matrix — which missing evidence hurts most and how it's mitigated. Competitor evidence comparison with named competitors + 24-month trajectory projection. Diagnostic Moment designed as a specific experience. Bob's evidence playbook — which evidence at which conversation point, verbatim. Proof-on-their-data mechanism specified with formula. Segment benchmarks with systematic counter-evidence table. Reference-building plan with monthly milestones. Methodology validation with anchored sources. Guarantee designed with attribution boundaries, financial exposure, and honest negative protocol. Case study plan with minimum viable and ideal formats. Security specification structured. Evidence freshness + automation pipeline. Evidence pre-mortem (§12.13.1). Competitor weaponization scenario with Bob's verbatim counter (§12.13.2). Confidence calibration on overall evidence stack (§12.13.3).

**Excellent:** The competitor evidence comparison names specific competitors (not "Competitors (e.g., UserGems, Clari)") and their specific evidence assets. The 24-month evidence trajectory shows a credible path from LOW to HIGH confidence. The counter-evidence table addresses the strongest critique of every core claim — not just one example. Bob's evidence playbook is verbatim and usable on a call today. The "no references" assumption is stress-tested with a specific failure scenario and mitigation. The competitor weaponization scenario includes Bob's exact response.

**ADVERSARIAL CHECK (extended):** "If a buyer reads this section, would they trust ClarityRev MORE or LESS? The zero-client honesty statement is counterintuitively trust-building — most vendors hide their weaknesses. ClarityRev naming them explicitly is a credibility signal. If the competitor evidence comparison makes ClarityRev look weak on social proof, strengthen the empirical proof column until the contrast is undeniable. Is the 'no references' assumption stress-tested — what if empirical proof alone doesn't convert? At what month do we know the evidence strategy isn't working? What's the most damaging thing a competitor could say about our evidence stack, and do we have a verbatim response?"

**Cross-references to update:**
- §2: Committee member evidence needs → §12.2
- §3.3: ROI proof structure → §12.4 Diagnostic Moment gap
- §4: Competitor evidence assets → §12.3 comparison
- §7.2: Diagnose stage → §12.4 Diagnostic Moment, §12.5 Proof-on-Their-Data
- §8.6.3: Free-tier data retention → §12.11

---

### SECTION 13: GTM & Sales Motion

**Purpose:** Design the practical go-to-market motion for this niche. How does ClarityRev get from zero to paying clients? This section must respect founder capacity constraints, include kill switches for channels and niches that don't work, and produce a week-by-week execution plan that Bob and Adriaan can follow without further clarification.

**Applied lenses:** Strategy Consultant (resource allocation, channel ROI, competitive response), GTM Architect (full funnel model, message architecture, objection handling, MEDDIC qualification, time-budget), Research Analyst (benchmark-anchored conversion rates, evidence grades, confidence calibration), Systems Designer (GTM tool stack, automation, handoff, pipeline capacity), Red-Team (kill switches, founder resilience, pre-mortem, competitive response, "wrong niche" detection)

**Evidence grading for this section (binding):** Every factual claim and every conversion metric must carry an evidence grade `[P/E/H/S]`. Design decisions are marked `[DESIGN]`. At zero clients, all conversion rates are `[S]` — this is honest, not a weakness.

**Founder GTM capacity (binding):**
- **Bob:** Full-time for next 4 months. Primary sales closer. Can prospect, run demos, close deals, manage partner relationships. 40 hrs/week available for GTM. `[P]`.
- **Adriaan:** 30 hrs/week until revenue justifies full-time (then quits job). Selling + implementation + client technical onboarding + data operations. Can prospect, enrich data, run Clay pipelines, handle technical questions during sales process and onboarding. Also handles: Diagnose overflow calls, Sprint onboarding (4 hrs/client), Month 1 recurring onboarding (6 hrs/client), signal quality review, case study generation, validation activities. `[P]`.
- **Wesley:** Building and implementation ONLY. Does NOT do sales. 40 hrs/week on engine, workflows, website, technical delivery. May participate in technical demos if needed but does not prospect or close. `[P]`.
- **Sales hires:** Commission-only sales people can be added early to accelerate growth. Top sales people hired on salary + commission when revenue justifies (est. EUR 30K+ MRR). `[DESIGN]`.

**Bob time-budget (actual hours, not just percentages):** The binding constraint is hours, not allocation percentages. This table translates the channel allocation into actual weekly hours.

| Channel | Month 1-3 (% / hrs) | Month 4-6 (% / hrs) | Month 7-12 (% / hrs) | Primary Activity |
|---|---|---|---|---|
| Warm network (Bob + Adriaan) | 70% / 28 hrs Bob + Adriaan part-time | 40% / 16 hrs | 20% / 8 hrs | Personal outreach, Snapshot calls, follow-ups |
| Cold outbound (Bob + Adriaan) | 20% / 8 hrs | 35% / 14 hrs | 30% / 12 hrs | Prospect list review, personalized outreach, A/B testing |
| Partners/aggregators (Bob) | 10% / 4 hrs | 20% / 8 hrs | 30% / 12 hrs | Partner recruitment, activation, co-selling |
| Marketplace/inbound | 0% / 0 hrs | 5% / 2 hrs | 20% / 8 hrs | Content, SEO, website optimization |
| **Total Bob hours/week** | **40 hrs** | **40 hrs** | **40 hrs** | |

**Bob pipeline capacity model:** Bob can effectively manage a maximum active pipeline of [N] deals simultaneously (estimate: 15-20 deals across all stages). Beyond this, deal quality and follow-up consistency degrade. Track: active deals in HubSpot, deals per stage, time since last activity per deal. If >20 active deals for >2 consecutive weeks → activate commission reps or de-prioritize lowest-probability deals. `[DESIGN]`.

---

#### 13.1 Channel Investment Allocation

Not just "which channel" — how much founder time goes to each channel at each phase. The binding constraint is Bob's 40 hrs/week + Adriaan's part-time hours.

| Channel | Month 1-3 (%) | Month 4-6 (%) | Month 7-12 (%) | Rationale |
|---|---|---|---|---|
| Warm network (Bob + Adriaan) | 70% | 40% | 20% | Fastest path to first revenue. Depletes over time. `[DESIGN]`. |
| Cold outbound (Bob + Adriaan) | 20% | 35% | 30% | Ramps as messaging is proven and warm network depletes. `[DESIGN]`. |
| Partners/aggregators (Bob) | 10% | 20% | 30% | Requires case studies to activate. Grows as proof accumulates. `[DESIGN]`. |
| Marketplace/inbound | 0% | 5% | 20% | Requires website, content, SEO. Longest to activate. `[DESIGN]`. |

**Expected ROI per channel per founder-hour:** Warm referral: 1 paid client / 15-30 hrs `[H]`. Cold outbound: 1 paid client / 150-250 hrs `[H]`. Partners: 1 paid client / 5-10 hrs (but 20-30% commission) `[H]`. Marketplace: unpredictable volume, near-zero marginal CAC `[S]`.

**Per-channel experiment design (MANDATORY):** Before committing significant founder hours to any channel beyond initial allocation, run a 30-day experiment.

| Channel | Experiment | Metric | Success Threshold | Fail Threshold | Action on Fail |
|---|---|---|---|---|---|
| Warm network | Contact 20 warm prospects with Snapshot offer | Snapshot request rate | ≥20% request rate | <10% | Message or targeting wrong. Pivot. If still <10% on retry, warm network not viable for this niche. |
| Cold outbound | 200 cold outreaches (2 A/B message variants) | Snapshot request rate | ≥2% | <0.5% | Niche may not be cold-reachable. Shift hours to partner channel. |
| Partners | Recruit 5 partners, support their first 3 client conversations each | Referrals generated within 90 days | ≥1 referral per partner | 0 referrals from all 5 | Partner incentive insufficient. Interview partners. Redesign or abandon channel. |

`[DESIGN]` — experiment designs.

**Commission sales acceleration:** Add 2-3 commission-only sales reps in Month 2-3, targeting the niche's buyer titles. 20-30% commission on first-year revenue. No base salary — reduces cash burn risk. Reps use the free Snapshot as their primary outreach tool. ClarityRev provides: prospect lists (Adriaan-built via Clay), Snapshot engine, sales scripts, objection handling playbook. `[DESIGN]`.

**Commission rep onboarding script (verbatim):** "Your job: get [niche title]s to run the free Snapshot. You don't sell — the Snapshot sells. When they see their number, they'll want to know what recovery looks like. That's when Bob takes over. You get 25% of first-year revenue for every client you source. Here's your prospect list, here's the Snapshot link, here's exactly what to say. [Hands them the outreach messages from §13.3.] Any questions?" `[DESIGN]`.

---

#### 13.2 Full Funnel Model (Ranges, Not Point Estimates)

Each conversion metric is ranged and anchored to B2B benchmarks where available. `[S]` until validated.

| Stage | Cold Outbound | Warm Referral | Partner-Introduced | Benchmark Source | Confidence |
|---|---|---|---|---|---|
| Prospects contacted | 100% | 100% | 100% | — `[P]` | — |
| Snapshot requested | 0.5-3% | 15-35% | 30-50% | Cold: industry avg 1-5% reply rate `[E]` — HubSpot 2024, Lavender 2025. Warm: B2B referral benchmarks 20-50% `[E]` — Heinz Marketing "B2B Referral Marketing Benchmarks" 2024 (N=200+ B2B companies). | LOW — unvalidated for this niche |
| CRM data connected | 45-65% of requesters | 50-70% | 60-80% | OAuth friction estimate; partner vouching reduces drop-off `[H]` — no published benchmark for CRM data connection friction exists; estimate based on B2B SaaS onboarding benchmarks. | LOW |
| Paid entry converted | 15-25% of connected | 20-30% | 25-35% | B2B demo-to-close benchmarks `[E]` — Bridge Group "SaaS AE Benchmarks" 2024; InsightSquared "B2B Sales Conversion Rates" 2025. Range reflects cross-industry variance. | LOW |
| Recurring converted | 30-45% of paid | 35-50% | 40-55% | B2B expansion/upsell benchmarks `[E]` — Gainsight "Customer Success Benchmark Report" 2024; Vitally "B2B Expansion Rate Benchmarks" 2025. | LOW |
| **End-to-end: prospect → recurring** | **0.01-0.22%** | **0.5-5.3%** | **3-14%** | Compound probability `[S]`. | LOW |

**Confidence calibration:** All conversion rates are LOW confidence at zero clients. Confidence upgrades to MEDIUM after 50+ data points per channel. Upgrades to HIGH after 200+ data points. Until then, the funnel model is a planning tool, not a forecast. `[P]` — honest about uncertainty.

**Deal economics:**
- Average deal cycle (first contact → signed): Warm: 14-30 days `[H]`. Cold: 45-90 days `[H]`. Partner: 21-45 days `[H]`.
- Average Sprint deal size: EUR 5-10K `[DESIGN]`.
- Average recurring deal size: EUR 2-5K/mo `[DESIGN]`.
- CAC (founder time monetized at internal cost): Warm: EUR 1.5-3.5K `[S]`. Cold: EUR 17-30K `[S]`. Partner: EUR 0.5-1.5K (+ 20-30% commission) `[S]`.

**Funnel stress test at 50% conversion rates:** If every conversion rate is 50% of the expected value:
- Warm referral end-to-end: 0.25-2.65% (vs. 0.5-5.3% expected)
- At 100 warm outreaches/month: 0.25-2.65 recurring clients/month
- Is this still viable for the niche? `[S]` — scenario.

---

#### 13.3 Outreach Message Architecture

Not "send LinkedIn messages." The specific words, per channel, per buyer persona. Must use buyer language from §2.6 and connect to a specific pain from §3.

For each primary outreach channel × buyer persona combination, specify:

- **Channel:** LinkedIn InMail / cold email / phone / event / referral introduction
- **Buyer persona:** From §2.1 (economic buyer, champion)
- **First-touch message:** Verbatim. ≤150 words. Opens with THEIR pain (from §3). Offers the Snapshot as the proof mechanism. No pitch — diagnostic first.
- **Follow-up message (if no response, Day 5):** Different angle. Different pain dimension. Same offer.
- **Snapshot offer message:** What they receive when they say yes. Links to Snapshot landing page or calendar.
- **Post-Snapshot message:** "Your results are ready. Here's your one number. Want to see what recovery looks like?"

**Coverage requirement:** The agent must complete at minimum: (a) LinkedIn InMail → Champion, (b) Cold Email → Champion, (c) Cold Email → Economic Buyer, (d) Referral Introduction → Champion. Additional combinations as niche-appropriate.

**Example format for one channel-persona combination (the agent must complete for ALL required combinations):**

```
Channel: LinkedIn InMail
Persona: VP Sales at mid-market digital agency
First touch: "Hi [Name] — most agency pipeline reports miss 20-30% of 
recoverable deals hiding in stalled stages and expired proposals. We built 
a free diagnostic that finds them in 48 hours — one number on YOUR HubSpot 
data. No pitch, just the number. Want to see it?"

Follow-up (Day 5): "Hi [Name] — quick follow-up. Last week I mentioned 
the free pipeline diagnostic. Most [niche title]s who run it find EUR X-K 
in deals their CRM reports missed. Takes 48 hours, zero cost, read-only 
access. Worth 5 minutes to see your number?"

Snapshot offer: "Great — here's the link: [URL]. It takes 5 minutes to 
connect your [CRM]. You'll have your number within 48 hours. I'll follow 
up as soon as it's ready."

Post-Snapshot: "Your Snapshot is ready. You're leaking EUR X/yr through 
[top leak sources]. Here are your top 5 recoverable deals. Want to walk 
through what recovery looks like?"
```

`[DESIGN]` — all messages; must be tailored to niche-specific buyer language from §2.6.

---

#### 13.4 Objection Handling Playbook

Top 5 niche-specific objections. For each: the exact response, the supporting evidence from §12, and when to walk away.

| # | Objection | Response | Evidence | Walk-Away Signal | Grade |
|---|---|---|---|---|---|
| 1 | "We already have a CRM/tool that does this" | "That tool shows you what's IN your pipeline. We find what's HIDDEN — deals that stalled, expired, or were never followed up. Here's a Snapshot from a similar [niche] company that found EUR X their [tool name] missed." | Competitor feature comparison (§4.6), Snapshot output example | Prospect can name specific reports they run that cover ALL 8 leak types | `[DESIGN]` |
| 2 | "Too expensive" | "The Snapshot is free and takes 48 hours. If it doesn't find at least EUR [3× Sprint fee] in recoverable revenue, you don't pay for the Sprint. If it does, the ROI is at least 3×." | ROI proof structure (§3.3), guarantee terms (§12.9) | Prospect's pipeline is genuinely too small for the math to work — honest negative protocol | `[DESIGN]` |
| 3 | "We don't have budget for this" | "The Snapshot is free. If it finds significant leakage, we can discuss what budget cycle works. Most clients fund this from recovered revenue — the Sprint pays for itself before the invoice is due." | Displacement cost analysis (§3.6), CAC payback period | Prospect is in a procurement freeze with no end date | `[DESIGN]` |
| 4 | "We need to see references first" | "Fair. We're new. That's why the Snapshot is free — you verify on YOUR data, not someone else's. If we had 500 logos and you were client 501, you'd still want to see YOUR number. Here's how the Snapshot works." | Zero-client honesty statement (§12.1), Diagnostic Moment design (§12.4) | Prospect insists on references AND won't run the free Snapshot — respect it, nurture | `[DESIGN]` |
| 5 | "[Competitor] already pitches us this" | "They show you signals. We show you the exact deals to call tomorrow, ranked by EUR value, with the specific next step. Here's the difference." | Competitor evidence comparison (§12.3) | Prospect is under contract with competitor and can't switch | `[DESIGN]` |

---

#### 13.5 Sales Qualification Criteria (MEDDIC)

**Qualified (pursue):**
- Right CRM/ATS (from §1.4 — GREEN or YELLOW accessibility) `[E]` from §1.4.
- Right company size (from §1.2 boundaries) `[E]` from §1.2.
- Right trigger active (from §6A.1 — at least one trigger fired within its urgency window) `[H]` from §6A.
- Economic buyer accessible (from §2.1 — can Bob or Adriaan get a meeting within 14 days?) `[H]`.
- Budget existence plausible (from §3.6 — discretionary pool or named line item) `[H]`.

**Disqualified (deprioritize or nurture):**
- Wrong CRM/ATS (RED accessibility in §1.4)
- Company too small (<minimum boundary from §1.2)
- No active trigger (all §6A.1 triggers cold)
- Economic buyer inaccessible (gatekeeper blocks, no warm path)
- Active procurement freeze or known budget cut

**Qualification checklist:** Before any founder spends >1 hour on a prospect, verify ≥3 of 5 qualified criteria. Prevents founder time waste on uncloseable deals. `[DESIGN]`.

---

#### 13.6 GTM Tool Stack & Handoff

**Operational backbone:**
- **Prospect list building:** Clay (Apollo enrichment + ICP filtering + signal detection) → exported to CRM. Build effort: M (2-5 days to configure for this niche). `[DESIGN]`.
- **CRM:** HubSpot Sales Hub (deal pipeline, task management, email sequences, meeting scheduler). Build effort: S (setup; ongoing configuration). `[DESIGN]`.
- **Outreach:** LinkedIn (manual, personalized), email sequences (automated via HubSpot), phone (manual). `[DESIGN]`.
- **Snapshot delivery tracking:** Internal dashboard showing: who requested, who connected data, who received report, who converted. Adriaan manages this. Build effort: M (custom dashboard or HubSpot dashboard). `[DESIGN]`.
- **Contract/onboarding:** DocuSign or similar for contracts. Automated onboarding checklist triggered on deal-close in HubSpot. `[DESIGN]`.

**GTM-to-delivery handoff:** Deal marked "Closed Won" in HubSpot → triggers onboarding workflow → Adriaan notified → CRM data access requested → Snapshot re-run on full dataset → first Sprint output scheduled → client welcome sequence initiated. No dropped handoffs. `[DESIGN]`.

**GTM automation:** Auto-enrichment of prospect lists (Clay, weekly), signal-based prospect alerts ("company just posted 3 new job openings → add to outreach list"), follow-up email sequences (automated), meeting reminders (automated), deal stage tracking (HubSpot). What stays manual: first conversation, Snapshot walkthrough, closing. `[DESIGN]`.

---

#### 13.7 GTM Kill Switches & Early Warnings

**Channel kill switches (abandon channel, not niche):**

| Channel | Metric | Trigger | Action | Grade |
|---|---|---|---|---|
| Warm network | Snapshot requests | <5 requests after 50 outreaches | Warm network depleted or message not resonating. Pivot message. If still <5 on retry, shift 80% of hours to cold outbound. | `[DESIGN]` |
| Cold outbound | Snapshot requests | <1% request rate after 500 outreaches | Message or targeting wrong. A/B test message. If still <1% after 2 A/B tests, this niche may not be cold-reachable. Increase partner investment. | `[DESIGN]` |
| Partners | Referrals generated | 0 referrals after 90 days of partner conversations | Partner incentive insufficient or partners not activated. Interview 3 partners. Redesign incentive or abandon channel. | `[DESIGN]` |

**Niche kill switch (abandon niche entirely):**

| Metric | Early-Warning Precursor (Act BEFORE Kill Trigger Fires) | Kill Trigger | Action | Grade |
|---|---|---|---|---|
| Conversion rate | <8% Snapshot-to-paid after 10 Snapshots delivered | <5% Snapshot-to-paid after 20 Snapshots delivered | Early warning: investigate hinge — is the Snapshot producing urgency? Are the right prospects being targeted? Interview 3 non-converters before Snapshot #15. If still below 8% at 15 → escalate to founders. Kill: below 5% at 20 → pivot offer or pivot niche. | `[DESIGN]` |
| Revenue | No paid Sprint proposals sent after 45 days of active GTM | EUR 0 revenue after 90 days of active GTM | Early warning at Day 45: if no proposals sent, the pipeline is empty — investigate outreach messaging OR targeting before the 90-day clock runs out. Kill: EUR 0 at Day 90 AND no proposals in pipeline → redesign or pivot. | `[DESIGN]` |
| Pattern objection | Same objection from 2 of first 5 prospects | Same objection from >50% of prospects | Early warning: if 2 of first 5 prospects raise the same objection, investigate immediately. Do NOT wait for >50% sample size — that wastes hours on deals already structurally blocked. Address in offer design before outreach #6. Kill: >50% AND investigation confirmed structural → niche blocked. | `[DESIGN]` |
| Snapshot quality | >40% of Snapshots find <EUR 50K in leakage after 10 Snapshots | >60% of Snapshots find <EUR 50K after 20 Snapshots | Early warning: pain not acute enough in this niche, OR targeting wrong company size. Revisit §3 pain quantification. Kill: confirmed insufficient pain → niche not viable. | `[DESIGN]` |

**Founder resilience:** Bob at 40 hrs/week for 4 months = 640 hours of GTM capacity. If these hours burn without results, the company enters a cash crisis. Track cumulative Bob-hours vs. cumulative revenue. If the ratio exceeds 100:1 (100 hrs per EUR 1K MRR), escalate. Early warning at 50:1 ratio. `[DESIGN]`.

**Competitive response anticipation:** If ClarityRev starts winning, competitors will: (a) launch free diagnostics within 3-6 months `[H]`, (b) cut prices by 15-30% `[H]`, (c) target ClarityRev's prospects with FUD ("untested startup, no references") immediately `[P]`. Pre-emption: build switching costs early (benchmark data, workflow embedding, integration depth), document every client win with attributable EUR figures, build partner relationships that competitors can't easily replicate. `[DESIGN]`.

**Competitive GTM response timeline:**

| Time After ClarityRev Entry | Likely Competitor Response | ClarityRev Counter |
|---|---|---|
| 0-3 months | Ignore — too small to notice | Build quietly. Document early wins. |
| 3-6 months | Launch free diagnostic copycat | Already have 50+ Snapshots of calibration data. Their copycat is uncalibrated. Weaponize: "We've done 50 of these. They've done zero." |
| 6-12 months | FUD campaign: "untested startup" | Counter with growing case studies + guarantee. "Untested? Our clients' recovered EUR speaks for itself." |
| 12-18 months | Price cuts on competing services | Compete on niche specificity + switching costs, not price. |

`[H]` — competitive scenario modeling.

---

#### 13.8 Nurture Sequence

For prospects who complete the Snapshot but don't convert to paid within 14 days:

- **Day 1:** Snapshot results delivered. "Here's your number. Want to see what recovery looks like?" `[DESIGN]`.
- **Day 5:** "Quick follow-up — any questions on your Snapshot results?" `[DESIGN]`.
- **Day 10:** Industry benchmark comparison. "Your EUR X leakage is Y% above the median for [niche] companies your size." `[DESIGN]`.
- **Day 21:** Case context. "A [niche] company we worked with found EUR Z in a similar situation. They recovered EUR W in 30 days." `[DESIGN]`.
- **Day 35:** Risk-reversed offer. "Still interested? The Sprint is EUR X, guaranteed 3× ROI or free. We only offer it when the data supports it — and your data does." `[DESIGN]`.
- **Day 60:** Break-up. "We showed you EUR X in leakage 60 days ago. If it's not a priority now, we'll check back in 6 months. No hard feelings. The Snapshot is yours to keep." `[DESIGN]`.

---

#### 13.9 GTM Pre-Mortem & First-90-Days Plan

##### 13.9.1 GTM Pre-Mortem

"It's 90 days from now. We executed the GTM plan as designed. Zero revenue. Bob has burned 480 hours. What went wrong?"

The agent writes the specific failure narrative for THIS niche. Consider:
- **The warm network wasn't as warm as assumed.** "Warm" contacts were LinkedIn connections who hadn't spoken to Bob in 3 years. Response rate: 3%, not 20%.
- **Messaging didn't resonate.** The pain language from §2.6 was wrong for this niche. Buyers use different words. The Snapshot offer landed as "another sales tool" not "free diagnostic."
- **The Snapshot was too hard to complete.** Data connection friction was higher than expected. 60% of requesters never connected their CRM. OAuth was blocked by IT. CSV upload was "too much work."
- **Bob spread himself too thin.** 40 hrs/week sounds like a lot. Between prospecting, calls, follow-ups, partner meetings, and internal coordination, actual selling time was <15 hrs/week.
- **The first 5 "yeses" were from companies too small to matter.** They qualified on paper (right CRM, right size) but their pipeline was too small for the EUR math to create urgency.

##### 13.9.2 First-90-Days Week-by-Week Execution Calendar

| Week | Bob's Focus (Hours) | Adriaan's Focus (30 hrs/week) | Key Milestone | Kill Switch Check |
|---|---|---|---|---|
| 1-2 | Warm outreach to top 20 contacts (20 hrs). Set up HubSpot + sequences (8 hrs). Internal Snapshot dry-run (4 hrs). Partner identification (4 hrs). Pipeline/admin overhead (4 hrs). | Build first prospect list in Clay (15 hrs). Configure enrichment pipeline (10 hrs). Internal coordination (5 hrs). | First 20 outreaches sent. HubSpot operational. | — |
| 3-4 | Follow-ups Week 1-2 (10 hrs). New warm outreach batch 2 (14 hrs). First cold outreach test — 50 contacts (6 hrs). Partner conversations (6 hrs). Pipeline/admin overhead (4 hrs). | Refine prospect list based on first responses (10 hrs). Prepare Snapshot demo for partners (10 hrs). Support cold outreach targeting (5 hrs). Internal coordination (5 hrs). | First Snapshot requests received. | Warm: <3 Snapshot requests from first 20 contacts → message pivot |
| 5-6 | Snapshot results calls (10 hrs). Warm outreach batch 3 (10 hrs). Cold outreach batch 2 — A/B test (8 hrs). Partner follow-ups (8 hrs). Pipeline/admin overhead (4 hrs). | Support Snapshot calls — technical Q&A (10 hrs). Track Snapshot → conversion pipeline (5 hrs). Enrichment for cold outreach lists (10 hrs). Internal coordination (5 hrs). | First Sprint proposals sent. | Cold: <1% Snapshot request rate from first 50 → targeting pivot |
| 7-8 | Close first Sprints (15 hrs). Warm + cold outreach (14 hrs). Partner co-sell first attempts (7 hrs). Pipeline/admin overhead (4 hrs). | Onboard first Sprint clients (12 hrs). Snapshot re-runs for new prospects (8 hrs). Enrichment + list building (5 hrs). Internal coordination (5 hrs). | First revenue (Sprint fee). | Still EUR 0 revenue → escalate; not yet kill |
| 9-10 | Sprint delivery oversight (5 hrs). Outreach continues (20 hrs). First recurring conversations (10 hrs). Partner channel review (1 hr). Pipeline/admin overhead (4 hrs). | Deliver Sprints — weekly check-ins (12 hrs). Document results for case studies (8 hrs). Enrichment + ongoing data ops (5 hrs). Internal coordination (5 hrs). | First Sprint results delivered. | <5% Snapshot-to-paid → investigate hinge |
| 11-12 | Close first recurring deals (15 hrs). Outreach + partner management (21 hrs). Pipeline/admin overhead (4 hrs). | Onboard recurring clients (15 hrs). Begin case study drafts (5 hrs). Data ops + enrichment (5 hrs). Internal coordination (5 hrs). | 90-day review. | <EUR 5K total revenue → serious pivot |

**Note on Week 1-2 warm allocation:** Weeks 1-2 allocate 20 hrs to warm outreach (50% of 40 hrs) — below the 70% monthly target — due to one-time setup (HubSpot, Snapshot dry-run). Weeks 3-12 compensate: warm outreach averages 18-20 hrs/week for the remaining weeks. The monthly weighted average across all 12 weeks meets the 70%/20%/10% allocation from §13.1. Setup hours decline to near-zero by Week 3. `[DESIGN]`.

**Pipeline/admin overhead (4 hrs/week):** Managing 15-20 active deals requires ~2 hrs of pipeline review + 2 hrs of admin/email/internal coordination. This is non-negotiable overhead. Without this line item, the 40 hrs/week allocation is aspirational fiction. `[DESIGN]`.

##### 13.9.3 Content & SEO Roadmap (Marketplace/Inbound Channel)

For the marketplace/inbound channel (activates Month 4+):

| Content Asset | Target Keyword | Format | Publish Month | Purpose |
|---|---|---|---|---|
| "[Niche] Revenue Leakage: The Complete Guide" | [niche] revenue leakage, [niche] pipeline health | Long-form guide (3,000+ words) | Month 3 | Top-of-funnel, SEO anchor |
| "[Niche] Pipeline Health Calculator" | [niche] pipeline health score | Interactive tool (free, no data required — Tier 1 per §8.2) | Month 4 | Lead magnet, email capture |
| "How [Company A] Found EUR X in Hidden Revenue" | [niche] case study revenue recovery | Case study page | Month 5 | Social proof, mid-funnel |
| "5 Signals Every [Niche Title] Is Missing" | [niche] buying signals, [niche] revenue signals | Blog post + LinkedIn carousel | Month 4, then monthly | Social media, top-of-funnel |

`[DESIGN]`.

---

**Done (minimum viable — FULL §13):** Evidence grades on all claims. Bob time-budget in actual hours/week (not just %). Bob pipeline capacity model with max active deals. Channel allocation table with rationale. Per-channel ROI estimates with grades. Per-channel experiment designs with success/fail thresholds. Full funnel model with ranges, benchmark sources, and confidence calibration per rate. Funnel stress test at 50% conversion rates. Deal economics with grades. Outreach message architecture: completed for ≥4 channel-persona combinations (LinkedIn→Champion, Email→Champion, Email→Economic Buyer, Referral→Champion) — all verbatim. Top 5 objections with verbatim responses, evidence citations, and walk-away signals. MEDDIC qualification criteria with evidence grades. GTM tool stack with build/configure effort per tool. GTM-to-delivery handoff spec. Channel + niche kill switches with specific metrics and triggers. Founder resilience tracking (Bob-hours vs. revenue). Competitive GTM response timeline (4 phases). Nurture sequence (6 touches, Day 1-60). GTM pre-mortem with niche-specific failure narrative (§13.9.1). First-90-days week-by-week execution calendar (§13.9.2). Content/SEO roadmap (§13.9.3).

**Excellent:** All required channel-persona combinations have verbatim messages. Objection responses cite specific evidence sections. Funnel model ranges are anchored to published B2B benchmarks with sources and dates. Confidence calibration is explicit — LOW confidence at zero clients, upgrade path defined. The 90-day calendar is specific enough that Bob could execute it without asking "what do I do this week?" The GTM pre-mortem names specific, niche-relevant failure modes. The competitive response timeline names likely competitor actions and ClarityRev's counter at each phase. Commission rep onboarding script is verbatim.

**ADVERSARIAL CHECK (extended):** "If the founders execute this GTM plan perfectly for 90 days and generate zero revenue — at what day do they know it's not working? What's the specific metric and trigger? If the answer is 'we'll figure it out,' the kill switches aren't specific enough. Every founder-hour of GTM is borrowed against runway. Is Bob's time-budget realistic — does 40 hrs/week actually break down into the activities listed, or is there hidden overhead (internal meetings, email, admin) that consumes 30% before any selling happens? If the warm network produces 3 Snapshot requests instead of the expected 20, at what week does the plan pivot? Is that pivot specified?"

---

#### 13.10 Sales Playbook Extract (MANDATORY per Canvas)

**Purpose:** Each completed canvas must produce a one-page "Sales Extract" that consolidates Bob's daily operational information. Bob should not need to navigate 15 sections to find what to do today. This extract is the bridge between strategy document and daily execution.

**The Sales Extract consolidates from across the canvas:**

| Section | What to Extract | Format |
|---|---|---|
| §6A.3 | Today's active triggers (Tier 1 with urgency windows) | Prioritized list: Company, trigger, urgency, opening line |
| §6A.3 | This week's Tier 2 triggers | Batched list for daily review |
| §8.2 | Free service offering — Bob's verbatim introduction | Copy-paste ready script |
| §9.2 | Paid service offering — Bob's verbatim pitch + top objections | Copy-paste ready script with responses |
| §10.2 | Recurring service — Bob's verbatim transition pitch | Copy-paste ready script |
| §12.4 | Evidence playbook — which evidence at which conversation stage | Quick-reference table |
| §13.3 | Outreach messages — all channel-persona combinations | Copy-paste ready, ordered by priority |
| §13.4 | Objection handling — all 5 objections with responses | Quick-reference table |
| §13.9.2 | This week's calendar allocation | Monday morning view |

**Format:** One-page PDF or CRM dashboard panel. Updated weekly. Stored in HubSpot as a pinned note on Bob's dashboard. `[DESIGN]`.

**Sales CRM fields (in addition to §7.6.2 journey tracking):**

| CRM Field | Purpose | Values |
|---|---|---|
| `Deal_Trigger_Type` | Which §6A trigger initiated this deal | Dropdown from §6A.1 trigger list |
| `Urgency_Window_Expiry` | Date beyond which trigger is stale | Date — auto-calculated from trigger detection date + urgency window |
| `MEDDIC_Metrics_Confirmed` | Has EUR pain been quantified? | Yes/No |
| `MEDDIC_Economic_Buyer_Identified` | Named + accessible? | Yes/No |
| `MEDDIC_Decision_Criteria_Confirmed` | Do we know what they need to decide? | Yes/No |
| `MEDDIC_Champion_Coached` | Has champion been given internal sales playbook? | Yes/No |
| `Budget_Verification_Status` | Per §2.3 method | Unverified / Champion stated / Documented |
| `Referral_Ask_Due` | Should Bob ask for referral at next contact? | Yes/No — auto-flagged at §7.3.2 referral trigger points |

**Cross-references to update:**
- §1.2: Company boundaries → §13.5 qualification criteria
- §1.4: CRM accessibility → §13.5 qualification
- §2.6: Buyer language → §13.3 outreach messages
- §3.3: ROI proof → §13.4 objection handling
- §5: Ecosystem & distribution → §13.1 partner channel
- §6A: Trigger map → §13.5 qualification
- §12: Evidence stack → §13.4 objection evidence citations

---

### SECTION 14: RIOS Score & Diagnosis

**Purpose:** Score this niche's commercial system against the RIOS value equation and the gate criteria. Identify the weakest link. This is the synthesis section — every score must be traceable to specific insights from prior sections. The scoring must survive adversarial scrutiny: if a dimension is scored 4-5, the agent must explain why, with evidence. If no dimension scores ≤2, the agent must re-examine for inflation.

**Applied lenses:** Strategy Consultant (scoring, prioritization, calibration, sensitivity), Research Analyst (evidence grade inheritance, confidence calibration), Red-Team (anti-inflation, adversarial honesty, score reconciliation)

**Evidence grading (binding):** This section synthesizes all previous sections. Each RIOS dimension score inherits the WEAKEST evidence grade among the claims from prior sections that support that dimension. The overall RIOS score inherits the weakest grade among all dimensions. If Quantified Outcome is supported by `[H]` evidence, the RIOS score cannot exceed `[H]` confidence regardless of the numerical score.

**Score calibration anchors (binding — use these, not intuition):**

| Score | Meaning (All Dimensions) | Requires |
|---|---|---|
| **1** | Critical weakness — would block purchase or delivery | Specific evidence of the weakness from prior sections |
| **2** | Significant weakness — addressable but real | Named gap with proposed fix |
| **3** | Adequate — meets baseline, not differentiated | Industry-norm comparison |
| **4** | Strong — differentiated from competitors | Competitor comparison evidence from §4, §8.1, §9.1, §10.1 |
| **5** | Exceptional — best-in-class, structural advantage | Requires extraordinary evidence: competitor benchmarking OR unique capability no competitor has |

**Score inflation detection (MANDATORY):** After scoring all 8 dimensions:
1. Identify the lowest score. If no dimension scores ≤2, the agent MUST re-examine each dimension and either: (a) downgrade at least one dimension to ≤2 with specific justification, or (b) explain in a "Score Reconciliation Note" why this niche genuinely has no significant weaknesses — which is rare and requires evidence.
2. Count dimensions scored 5. If >2 dimensions score 5, the agent MUST re-examine: 5s require extraordinary evidence. Downgrade or provide the evidence.
3. If every dimension's evidence grade is `[H]` or `[S]`, the overall RIOS confidence is LOW regardless of numerical score. A numerically high score on low-confidence evidence is a RED FLAG — flag it in the verdict.

---

#### Part A: Gate Check (pass/fail)

Reference §1.6 RIOS applicability. Skip scoring for any stage marked SKIP in §1.6.

| Gate | Result | Evidence Grade | Math / Justification |
|---|---|---|---|
| EUR 500K net profit path with leverage? | PASS/FAIL | `[S]` at zero clients | **Show the explicit math:** At [N] clients × EUR [X] avg monthly revenue × 12 months = EUR [Y] annual revenue. At [Z]% gross margin = EUR [Y×Z%] gross profit. Target: EUR 715-910K revenue → EUR 500K net profit. Clients needed at breakeven: [N]. Time to reach breakeven: [N] months at [X] new clients/month. Is this achievable within 24 months? |
| Scalable & productizable? | PASS/FAIL | From §10.12.1, §11.17 | Can this be delivered without bespoke work per client? What % is automated vs. manual? Reference §11.17 automation feasibility. |
| In-bounds (B2B, not consumer/SMB)? | PASS/FAIL | `[P]` from §1.2 | Verify against §1.2 MECE boundaries. |
| Fits Revenue Intelligence category? | PASS/FAIL | `[P]` from §1.1, §6B | Is this intelligence-that-drives-revenue, delivered in-system? Reference §6B signal catalog as evidence. |

**EUR 500K gate — explicit revenue math template (MANDATORY):**

```
ASSUMPTIONS:
- Target clients at steady state: [N]
- Avg monthly revenue per client: EUR [X] (from §10.2 core recurring + §10.3 expansion)
- Annual revenue per client: EUR [X × 12]
- Blended gross margin: [Y%] (from §7.4, §10.2)
- Annual gross profit per client: EUR [X × 12 × Y%]
- Total annual gross profit at [N] clients: EUR [N × X × 12 × Y%]
- Target: EUR 500K net profit → need EUR [500K / Y%] gross profit → [N] clients
- Time to reach [N] clients at [Z] new clients/month (from §13.2 funnel model): [N÷Z] months
- IS THIS ACHIEVABLE WITHIN 24 MONTHS? YES / NO / BORDERLINE
```

`[S]` until validated with actual client economics. All inputs sourced from prior sections.

---

#### Part B: RIOS Value Equation Score

Rate each dimension 1-5 using the calibration anchors above. Every score must cross-reference the specific prior section(s) that provide the evidence.

| Dimension | Score (1-5) | Evidence Grade | Cross-Reference (Source Sections) | Justification (Not "4" but "4 because...") |
|---|---|---|---|---|
| **Quantified Outcome** | | Inherits from §3.3 | §3.3 (ROI proof), §7.2 (hinge assumption) | How specific and visceral is the EUR number? Is it niche-specific or generic? Is it stress-tested at 50%? |
| **Proven Likelihood** | | Inherits from §12 | §12 (evidence stack), §12.13.3 (confidence calibration) | How strong is the evidence stack? At zero clients: maximum score = 2 (evidence confidence is LOW per §12.13.3). |
| **Strategic Fit** | | `[P]` — logical | §2.1 (committee), §2.3 (budget), §1.6 (RIOS) | Does this ladder to a board-level KPI for THIS niche's buyers? Name the specific KPI. |
| **Time-to-Value** | | From §7.1, §7.3.1 | §7.1 (TTV targets), §7.3.1 (conversion model), §8.2 (turnaround) | How fast is first value? Diagnose ≤48 hrs? Prove ≤14 days? Cite the TTV from §7.1. |
| **Organizational Friction** | | From §1.4, §2.4, §12.11 | §1.4 (data accessibility gate), §2.4 (data access approval chain), §12.11 (security) | Data access ease? Security concerns? Adoption barriers? Reference the data accessibility gate verdict from §1.4. |
| **Perceived Risk** | | From §9.2, §12.9 | §9.2 (risk reversal), §12.9 (guarantee), §12.3 (competitor evidence comparison) | How well is purchase risk reversed? Is the guarantee data-underwritten? Is it credible? |
| **Distributability** | | From §5, §13.1 | §5 (ecosystem & distribution), §13.1 (channel allocation) | Can an aggregator carry this? How many warm aggregator paths exist? Reference specific aggregators from §5. |
| **Compounding** | | From §1.6, §10.4 | §1.6 (RIOS moat assessment), §10.4 (moat trajectory) | How much does each client feed the moat? At what client count does compounding begin? Reference §10.4 trajectory. |

**RIOS Score Calculation:**

```
Perceived Value = (Quantified Outcome × Proven Likelihood × Strategic Fit) 
                / (Time-to-Value × Org Friction × Perceived Risk)
               = ([A] × [B] × [C]) / ([D] × [E] × [F])
               = [X] / [Y]
               = [PV]

RIOS Score = Perceived Value × Distributability × Compounding
           = [PV] × [G] × [H]
           = [RIOS]

Evidence Grade: [Weakest grade among A-H]
```

---

#### Part C: Lowest-Term Diagnosis

Identify the single lowest-scoring RIOS dimension. Propose a specific fix. This is the binding action item before this niche could be launched.

- **Lowest-scoring dimension:** [Name] — Score: [X]/5.
- **Why it's the lowest:** [Specific reason traceable to prior sections — not "because evidence is weak" but "because §12.13.3 shows zero-client evidence confidence is LOW, and the first case study isn't available until Month 4-6 per §12.7."]
- **Proposed fix:** [Specific, actionable, with owner and timeline]. NOT "improve evidence stack." Instead: "Commission an industry benchmark report using published data from [sources], publish Month 2. Recruit 2 design partners for paid Sprint by Month 3 to generate case study material by Month 4. Owner: Bob (recruiting) + Adriaan (benchmark report)."
- **Fix confidence:** HIGH / MEDIUM / LOW that this fix will raise the score by ≥1 point within 6 months. `[H]` — judgment.

---

#### Part D: Overall Niche Verdict

| Verdict | Meaning | When to Use |
|---|---|---|
| **LAUNCH PENDING** | Gates passed, RIOS score >3.0, lowest term has a credible fix with HIGH fix confidence | Niche is ready for build investment |
| **VALIDATE FIRST** | Gates passed, but RIOS score <3.0 OR low-confidence evidence OR fix confidence LOW | Needs primary research (minimum 5 buyer conversations) before build |
| **CONDITIONAL** | One gate at risk but salvageable with specific changes | Flag the condition; proceed if condition is acceptable |
| **NO-GO** | Gates not passed or RIOS score <1.5 | Do not invest further; document why |

**Verdict for this niche:** [LAUNCH PENDING / VALIDATE FIRST / CONDITIONAL / NO-GO]

**Verdict confidence:** HIGH / MEDIUM / LOW. How sure is the agent of this verdict? Based on: evidence grades across all dimensions, score inflation check passed, lowest-term fix credibility. At zero clients with predominantly `[H]` and `[S]` evidence, verdict confidence is typically MEDIUM at best. `[P]` — honest about current state.

---

#### Part E: Sensitivity Analysis

Which dimension, if scored one point lower, would change the verdict? Which dimension, if scored one point higher, would upgrade the verdict?

| Dimension | Current Score | If −1: New RIOS Score | If +1: New RIOS Score | Verdict Impact |
|---|---|---|---|---|
| [Lowest dimension] | [X] | [Recalculate] | [Recalculate] | If −1: [worsens verdict?]. If +1: [verdict unchanged?] |
| [Second-lowest] | [X] | [Recalculate] | [Recalculate] | |

**Most sensitive dimension:** [Name] — a one-point change in this dimension has the largest impact on the RIOS score. This is where validation effort has the highest ROI.

---

#### Part F: Competitive RIOS Comparison (Optional, Excellent)

Score the #1 competitor from §4 on the same 8 dimensions. This calibrates ClarityRev's scores against a real benchmark.

| Dimension | ClarityRev Score | Competitor [Name] Score | Delta | Notes |
|---|---|---|---|---|
| Quantified Outcome | | | | |
| ... (all 8 dimensions) | | | | |

**Competitor's RIOS Score:** [X]. **ClarityRev's RIOS Score:** [Y]. **Delta:** [+/−Z]. Interpretation: ClarityRev's advantage comes from [dimensions where ClarityRev leads]. ClarityRev's disadvantage is [dimensions where competitor leads].

This comparison is `[H]` at best — competitor scoring is from external observation, not internal data.

---

#### Part G: RIOS Score Trajectory (12-Month Projection)

| Time | RIOS Score | Evidence Confidence | What Changes |
|---|---|---|---|
| **Today (0 clients)** | [X] | LOW (per §12.13.3) | Desk research, zero-client evidence stack |
| **Month 6 (5-10 clients)** | [X+Δ] | MEDIUM | First case studies, calibrated signals, validated conversion rates |
| **Month 12 (15-25 clients)** | [X+2Δ] | HIGH | Published benchmark, reference calls, proven guarantee record |

`[S]` — projection; actual trajectory depends on execution.

---

#### Part H: Score Reconciliation Note

**Required if any dimension scores 5 OR if no dimension scores ≤2.**

"If any dimension scores 5, explain: what extraordinary evidence supports a best-in-class rating? Which competitor(s) were benchmarked? If no dimension scores ≤2, explain: what makes this niche genuinely free of significant weaknesses? Or is inflation more likely — re-examine each dimension."

**Reconciliation for this niche:** [Agent completes.]

---

**Done (minimum viable — FULL §14):** All 4 gates checked with pass/fail + evidence grades + explicit EUR 500K math template. All 8 RIOS dimensions scored 1-5 using calibration anchors with: evidence grade inheritance, cross-reference traceability to source sections, and specific justification (not just "4" but "4 because..."). Score inflation detection completed: lowest score identified, 5-count verified, evidence-grade coherence checked. RIOS formula calculated with evidence grade inheritance. Lowest-term diagnosis with specific fix (owner + timeline) + fix confidence. Verdict stated with confidence grade. Sensitivity analysis: which dimension swing changes verdict? Score reconciliation note if applicable.

**Excellent:** Competitive RIOS comparison vs. #1 competitor (§F). RIOS score trajectory with 12-month projection (§G). Every score of 4+ cites specific competitor comparison evidence from §4, §8.1, §9.1, or §10.1. The EUR 500K math is explicit with sourced inputs from prior sections. The sensitivity analysis identifies the highest-ROI validation target. The score reconciliation note is honest — if inflation is suspected, it's flagged rather than buried.

**ADVERSARIAL CHECK (extended):** "Is the lowest score ≤2? If not, re-examine — something is probably over-scored. Are there >2 dimensions scored 5? If yes, extraordinary evidence is required. Does every score of 4+ cite a specific competitor comparison? If not, the score is uncalibrated. Is the EUR 500K gate math explicit — or is it hand-waved? At the evidence grades this canvas has (mostly `[H]` and `[S]`), is the verdict confidence honestly LOW/MEDIUM? If the verdict is LAUNCH PENDING on LOW-confidence evidence, that's a contradiction — flag it. What's the single most sensitive dimension — where would a one-point change alter the verdict? That's where validation effort should focus."

**Cross-references to update:**
- §1.4: Data accessibility → Organizational Friction score
- §1.6: RIOS applicability, moat → Strategic Fit, Compounding scores
- §3.3: ROI proof → Quantified Outcome score
- §4: Competitor landscape → Competitive RIOS comparison
- §5: Ecosystem → Distributability score
- §7.1: TTV targets → Time-to-Value score
- §9.2, §12.9: Guarantee → Perceived Risk score
- §10.4: Moat trajectory → Compounding score
- §12: Evidence stack → Proven Likelihood score
- §13.2: Funnel model → EUR 500K gate math

---

### SECTION 15: Open Questions & Validation Plan

**Purpose:** Honestly flag what is unknown and specify exactly how to resolve each unknown. This is the honesty section — it prevents "unknown unknowns" from killing the niche later and forces the agent to confront what they don't know. Every niche canvas should have at least 5 open questions. If it doesn't, the agent didn't research deeply enough.

**Applied lenses:** Research Analyst (confidence calibration, unknown unknowns, evidence inventory), Strategy Consultant (decision framework under uncertainty, prioritization), Red-Team (most dangerous unknown, pre-mortem, what's being hidden), GTM Architect (validation ownership, timeline)

**Evidence grading for this section:** This section is about what IS unknown — which is factual and `[P]`. Prioritization is `[P]` (agent's judgment, must be explained). Validation method feasibility is `[H]` until attempted.

---

#### 15.1 Consolidated Evidence Grade Inventory

Before listing open questions, tally every `[P]`, `[E]`, `[H]`, and `[S]` claim across the entire canvas. This inventory is the honest foundation for the validation plan.

| Evidence Grade | Count | % of Total | Interpretation |
|---|---|---|---|
| `[P]` (Proven) | [N] | [%] | Verifiable facts, design decisions, logical deductions |
| `[E]` (Evidenced) | [N] | [%] | Single-source or multi-source claims with verification |
| `[H]` (Hypothesis) | [N] | [%] | Reasoned inferences — validation needed before build |
| `[S]` (Speculative) | [N] | [%] | Guesses — MUST be validated before decisions depend on them |
| **Total** | **[N]** | **100%** | |

**Canvas evidence health check:**
- If >50% of claims are `[H]` or `[S]`: canvas is HIGH-UNCERTAINTY. Verdict should be VALIDATE FIRST, not LAUNCH PENDING.
- If >70% of claims are `[H]` or `[S]`: canvas is VERY-HIGH-UNCERTAINTY. Even VALIDATE FIRST may be premature — consider whether the niche is researchable with available sources.
- If >20% of claims are `[S]`: canvas has significant speculation. Build decisions based on this canvas carry high risk.
- If <10% of claims are `[P]`: the canvas lacks a factual foundation. More primary research needed.
- **Important:** Also monitor the `[H]` threshold. The 50% rule on `[S]` alone creates a perverse incentive to pad with `[H]` claims to dilute the `[S]` ratio. The combined `[H]+[S]` percentage is the honest measure.

**What counts as "one claim"?** For counting purposes: each independently verifiable factual assertion is one claim. A table cell containing "EUR 400K [E] — source: Clari 2024, adjusted for niche" contains ONE evidence-graded claim (the EUR figure). The source citation and adjustment note are part of the claim's support, not separate claims. Design decisions marked `[DESIGN]` are excluded from the count. Strategic judgments marked `[P]` (pre-mortems, wrong-niche indicators) count as `[P]` claims. When in doubt, be conservative — it's better to undercount than overcount. `[P]` — this is a counting methodology.

**Critical unknowns — claims marked `[S]` that are load-bearing:** Not all `[S]` claims are equal. Identify the `[S]` claims that, if wrong, would break the niche thesis. These are the highest-priority validation targets.

| Load-Bearing `[S]` Claim | Source Section | If Wrong, What Breaks? | Validation Priority |
|---|---|---|---|
| [Claim] | [§X.Y] | [e.g., "If conversion rate is actually 1% not 5%, the funnel economics don't close"] | Critical |
| ... | | | |

---

#### 15.2 Top 5 Open Questions (Prioritized by Decision-Impact / Cost-to-Answer Ratio)

Rank questions by: "How much does the decision depend on this?" ÷ "What does it cost to find out?" Highest ratio = highest priority.

| # | Question | Source Section | Decision It Impacts | Why Unknown | Resolution Method | Owner | Cost (Time + EUR) | Priority | Decision-Impact / Cost Ratio |
|---|---|---|---|---|---|---|---|---|---|
| 1 | [What exactly is unknown?] | [§X.Y] | [What decision depends on knowing this?] | [Why couldn't this be answered during canvas research?] | [Buyer conversation / Expert interview / Competitive demo / Data analysis / Web search / Experiment] | Bob / Adriaan / Wesley | [N days + EUR X] | Critical | [High/Medium/Low] |
| 2 | ... | | | | | | | Important | |
| 3 | ... | | | | | | | Important | |
| 4 | ... | | | | | | | Nice-to-know | |
| 5 | ... | | | | | | | Nice-to-know | |

**Validation owner capacity (binding):**
- **Bob:** Can run buyer conversations, attend expert interviews, validate messaging. 40 hrs/week but primary focus is selling. Max 5 hrs/week on validation activities.
- **Adriaan:** Can run data analysis, competitive demos, enrichment validation. 30 hrs/week total; max 10 hrs/week on validation activities (remainder consumed by onboarding + data ops + overflow calls per §7.4).
- **Wesley:** Can validate technical feasibility, API access, build effort. Does NOT do buyer conversations. 40 hrs/week on building; validation is secondary.

**Rule:** Each open question must have an assigned owner. No question is owned by "the team."

---

#### 15.3 Most Dangerous Unknown

**The single most dangerous unknown in this canvas:** [State it explicitly.] This is the unknown that, if resolved negatively, would change the niche verdict from LAUNCH PENDING or VALIDATE FIRST to NO-GO.

**Unknown pre-mortem:** "It's 6 months from now. We resolved the top 5 open questions. The answers were worse than expected on [most dangerous unknown]. Specifically: [what we learned]. As a result: [what happens to the niche thesis]. The niche is now NO-GO. What did we miss in the initial canvas that should have warned us?"

**Early warning indicators:** What signals in the first 90 days would indicate this unknown is resolving negatively? "If [metric] is below [threshold] within 90 days, the most dangerous unknown is trending negative. Escalate to founders."

---

#### 15.4 Validation Experiment Design

For the single most important unknown (typically #1 from §15.2), design a falsifiable validation experiment:

- **Hypothesis:** [Falsifiable statement — can be proven wrong.] "H1: [Niche title]s will request the free Snapshot at ≥Y% rate when reached via [channel] with [message]."
- **Method:** Exactly what to do. Step-by-step. "1. Bob identifies 20 [niche title]s in his warm network. 2. Bob sends [verbatim outreach message from §13.3]. 3. Track: messages sent, responses, Snapshot requests, Snapshot completions. 4. After 20 outreaches OR 30 days (whichever comes first), evaluate."
- **Success criteria:** What confirms the hypothesis? "≥Y% Snapshot request rate (≥[N] of 20)."
- **Fail criteria:** What falsifies the hypothesis? "<Y% Snapshot request rate (<[N] of 20)."
- **Minimum viable sample:** [N] data points. Rationale: "[N] is the minimum to distinguish a real signal from random noise at 80% confidence."
- **Maximum cost acceptable:** [N] hours of founder time + EUR [X] in tools/ads.
- **Decision on outcome:**
  - If SUCCESS → [Action: proceed to next validation, increase investment in this channel, etc.]
  - If FAIL → [Action: redesign hypothesis, pivot channel, or escalate to downgrade trigger.]

---

#### 15.5 Validation Timeline

Sequence the validation activities to maximize learning per week while respecting founder capacity.

| Month | Validation Activities | Owner | Hours Required | Key Decision at Month-End |
|---|---|---|---|---|
| **Month 1** | [Activity 1], [Activity 2] | Bob / Adriaan | [N] hrs | Go/No-Go on [decision] |
| **Month 2** | [Activity 3], [Activity 4] | | | |
| **Month 3** | [Activity 5] — most dangerous unknown resolved | | | Update niche verdict based on findings |
| **Month 4-6** | Remaining validation, first client outcomes | | | Full validation complete; verdict finalized |

---

#### 15.6 Decision Triggers

What evidence would change the recommendation for this niche? Triggers must be specific, measurable, and time-bound.

- **Upgrade trigger (VALIDATE FIRST → LAUNCH PENDING):** What would make this niche MORE attractive? "Conversion rate ≥Y% after 20 Snapshot deliveries." "First 3 paid Sprints deliver ≥3× ROI within 90 days." "Partner channel produces ≥2 qualified referrals within 90 days of activation."
- **Downgrade trigger (LAUNCH PENDING → VALIDATE FIRST, or VALIDATE FIRST → CONDITIONAL):** What would make this niche LESS attractive? "Conversion rate <Y% after 20 Snapshots." "Guarantee invocation rate >30%." "Primary CRM platform announces competing feature."
- **Kill trigger (→ NO-GO):** What would make us abandon this niche? "Zero paying clients after 6 months of active outreach (per §13.7 niche kill switch)." "Two competitors launch identical managed services within 6 months." "Primary CRM platform changes ToS to prohibit third-party AI access." "Most dangerous unknown (§15.3) resolves negatively AND the thesis cannot be salvaged."

- **Trigger for revisiting (time-based):** "Re-evaluate this niche canvas in [N] months. By then, [what should have changed? — e.g., 'benchmark data reaches 50 companies,' '2 case studies published,' '10 paying clients']."
- **Trigger for canvas refresh:** "If this canvas is >90 days old AND no validation activities have been completed, refresh the canvas before making any build decisions. Competitive data, pricing, and market conditions change."

---

#### 15.7 Decision-Tree for Verdict Changes

```
Current verdict: [LAUNCH PENDING / VALIDATE FIRST / CONDITIONAL]

IF validation experiment (§15.4) returns SUCCESS:
  → Resolve that question. Move to next-highest-priority unknown.
  → If all Critical unknowns resolved favorably → UPGRADE verdict.

IF validation experiment returns FAIL:
  → Is the failure addressable? 
    → YES: Redesign hypothesis, retest within 60 days.
    → NO: Does this failure break the niche thesis?
      → YES → DOWNGRADE or KILL.
      → NO → Accept the limitation, update canvas, proceed.

IF most dangerous unknown resolves negatively:
  → KILL or DOWNGRADE (per §15.6 kill/downgrade triggers).

IF no validation activities completed within 90 days:
  → Canvas is stale. Downgrade verdict to VALIDATE FIRST.
  → Reason: LOW-confidence evidence with no validation progress does not support build investment.
```

`[DESIGN]` — decision framework.

---

#### 15.8 Required Signal Validation Entries (from §6.5)

Every niche canvas MUST include these two signal validation hypotheses:

1. **Trigger conversion hypothesis:** "Tier-1 trigger outreach yields ≥X% Snapshot request rate in this niche. Method: Track 50 sequential trigger-based outreaches (Bob logs per-trigger outcome in HubSpot). Success threshold: ≥Y% Snapshot request rate. If below threshold after 50 outreaches, redesign trigger messaging or de-prioritize that trigger. Target: validate within 90 days of first outreach." The agent sets X and Y per niche with rationale. `[S]` until validated.

2. **Signal predictiveness hypothesis:** "Tier 1 signals predict revenue outcomes with ≥Z% accuracy in this niche. Method: After 10 clients, retrospectively analyze: for each Tier 1 signal that fired, what % resulted in the predicted revenue outcome within the urgency window? Success threshold: ≥Z% accuracy (false positive rate <(100-Z)%). If below threshold, recalibrate signal per §6B.8 or downgrade to Tier 2/3. Target: first calibration report at 10 clients." `[S]` until validated.

Additionally, every `[S]` and critical `[H]` claim from §6A and §6B must appear in the §15.2 open questions list with resolution method, owner, and priority.

---

**Done (minimum viable — FULL §15):** Consolidated evidence grade inventory (§15.1) with counts + % per grade + health check (HIGH-UNCERTAINTY flag if >50% `[H]`/`[S]`). load-bearing `[S]` claims identified with source sections + breakage consequences. Top 5 open questions (§15.2) prioritized by decision-impact/cost-to-answer ratio, each with: source section, decision impacted, resolution method, assigned owner, cost, and priority. Most dangerous unknown (§15.3) stated + unknown pre-mortem + early warning indicators. Validation experiment design (§15.4) with falsifiable hypothesis, step-by-step method, success/fail criteria, minimum sample, max cost, and decision on outcome. Validation timeline (§15.5) with monthly activities, owners, hours, and month-end decisions. Decision triggers (§15.6): upgrade, downgrade, kill, revisit, canvas refresh — all specific and measurable. Decision-tree for verdict changes (§15.7). Required signal validation entries (§15.8).

**Excellent:** The evidence inventory is an honest count — not estimated. The decision-impact/cost ratio is calculated, not intuited. The most dangerous unknown is specific enough that a founder reading it would say "yes, if that's wrong, we shouldn't do this." The validation experiment is falsifiable — it can be proven wrong, not just "we'll know more." The validation timeline respects founder capacity. The decision-tree covers all branches (success, addressable fail, non-addressable fail, staleness). Every open question has a named owner — not "the team."

**ADVERSARIAL CHECK (extended):** "Are there at least 5 open questions? If fewer, the agent didn't research deeply enough. Is the evidence inventory an honest count — or does it undercount `[H]`/`[S]` to make the canvas look more evidenced than it is? Is the most dangerous unknown genuinely load-bearing — if resolved negatively, does the verdict actually change? Or is it a safe unknown that leaves the thesis intact either way? Are validation activities assigned to specific people with specific hours, or is everything 'Bob will figure it out'? Bob has 40 hrs/week for selling — how many of those hours are allocated to validation? If the answer is zero, the validation plan is aspirational, not operational. If the canvas is >90 days old with no validation progress, does the verdict automatically downgrade? If not, we're making build decisions on stale assumptions."

**Cross-references to update:**
- §6.5: Signal-to-revenue validation → §15.8 required entries
- §6A/§6B: All `[S]` and critical `[H]` claims → §15.2 open questions
- §13.7: GTM kill switches → §15.6 decision triggers (aligned)
- §14: Niche verdict → §15.7 decision-tree for verdict changes

---

## 3. PART 2: THE RESEARCH PROTOCOL

> **Data Operations Architecture (BINDING):** All research data gathering, storage, and sharing follows the Data Operations Architecture at `niche-program/DATA-OPERATIONS-ARCHITECTURE.md`. This specification provides exact tools, commands, schemas, storage paths, credit budgets, freshness SLAs, and cross-agent sharing patterns. The Research Protocol below specifies WHAT to research; the Data Operations Architecture specifies HOW to execute the research. Niche agents MUST consult both documents. See also: `niche-program/references/` for tool reference docs, `niche-program/discovery/` for data source catalogs, and `niche-program/lenses/` for the 6-lens architecture designs that produced the Data Operations Architecture.
>
> **Phase 0 Prerequisite (BINDING):** Before any niche research begins, the Phase 0 Tool Calibration protocol (DATA-OPERATIONS-ARCHITECTURE.md §4.0) MUST complete successfully. This verifies Firecrawl, DataForSEO, authenticated sessions, and fallback tools. No niche evaluation begins until Phase 0 passes. If a non-primary tool fails calibration, Wesley may waive it. Primary tool failures (Firecrawl, DataForSEO) cannot be waived — the pipeline is blocked until resolved.

### 3.1 Research Sequence

Execute in this order. Do not skip steps. Do not reorder. Each phase references the corresponding pipeline phase in DATA-OPERATIONS-ARCHITECTURE.md §4.

**Phase 1: Niche Bounding (Pipeline §4.1 — ~17 credits, ~$0.002, ~3 min)**

1. Identify the niche (Section 1). Write the MECE IN/OUT list.
2. Run 5 broad Firecrawl /search queries to confirm niche existence as a category worth investigating:
   - `"[niche] market size 2026"` — returns relevance excerpts (94.7% SimpleQA accuracy)
   - `"[niche] industry trends 2026"`
   - `"[niche] challenges revenue growth"`
   - `"[niche] software tools platform"`
   - `"[niche] companies list top"`
   - Cost: 10 credits (5 searches × 2 credits). Use the new relevance model — /search alone is sufficient; do NOT follow up with /scrape unless excerpts are clearly insufficient.
3. Run First-5 Prospect Test: Firecrawl /search for "[niche] companies [country]" + OpenRegistry MCP for company registry verification. Cost: ~7 credits.
4. Run broad market sizing: EUROSTAT + OECD + CBS StatLine APIs. All free, no auth. Cost: $0.
5. Run competitor count estimate: DataForSEO Labs SERP Competitors for "[niche] software". Cost: ~$0.002.
6. Run data accessibility gate: Context7 MCP — query CRM/ATS API docs to verify signal feasibility. Cost: $0.

**Gate:** If Phase 1 fails to confirm niche existence (fewer than 50 searchable companies, zero analyst coverage, or data accessibility RED), flag as HIGH-UNCERTAINTY. **Auto-proceed to STANDARD depth** (Phase 1 only — fertility scoring). Do NOT proceed to DEEP depth without explicit approval. The pipeline does NOT block — a partial canvas is better than a blocked pipeline. See DATA-OPERATIONS-ARCHITECTURE.md §4.5 for credit gate GATE-1→2 before Phase 2.

**Phase 2: Deep Research (Pipeline §4.2 — ~100 credits, ~$0.04, 5-8 min)**

**Gate:** Runs only if Phase 1 credit gate (GATE-1→2) passes. Firecrawl remaining ≥ 5,000 credits.

7. **Buyer & committee** (Section 2): Firecrawl /search for target titles' job descriptions. Search: `"[title] responsibilities KPIs [industry]"`, `"[title] challenges pipeline management"`. Read job descriptions for KPI language and pain points. Use public ATS job board APIs (Greenhouse, Lever) for role data. Do NOT scrape LinkedIn (ToS violation).
8. **Pain & economics** (Section 3): Firecrawl /search for industry benchmarks on the specific leak type in this niche. Search: `"[industry] [leak type] benchmark 2025 2026"`, `"[industry] revenue lost to [leak type]"`, `"[industry] average churn rate"`. Cross-reference with EUROSTAT/OECD for macro validation.
9. **Competitive landscape** (Section 4): Firecrawl /search for competitors → /map (discover pricing URLs, 1 credit) → /scrape competitor homepages and pricing pages. Then Firecrawl /search for "X reviews G2" → /scrape review pages (minimum 10 reviews per competitor from public pages — do NOT create accounts to bypass login walls). Use Firecrawl /interact only for pages genuinely behind JS-rendered walls that /scrape cannot reach; test /scrape with --wait-for first. Cost: ~40-55 credits.
10. **Ecosystem & distribution** (Section 5): Firecrawl /search for aggregators, marketplaces, communities. Search: `"[niche] software marketplace"`, `"[niche] agency partners"`, `"[niche] community"`, `"[system name] app marketplace"`. Use Firecrawl /map before /crawl for directory pages.
11. **Signals & triggers** (Section 6): Firecrawl /search for trigger events. Search: `"[niche] common challenges"`, `"[niche] CFO concerns 2026"`, `"[niche] board metrics"`. GDELT Project API for news/intent signals (last 90 days, free). Public ATS APIs for hiring signals. Context7 MCP for API capability verification.
12. **Technographics** (DataForSEO Domain Analytics): Batch 5 competitors, $0.01. See pipeline Step 2.4.
13. **SERP/keyword analysis** (DataForSEO Keywords API): Batch 50 keywords per competitor, single batched request, $0.03. See pipeline Step 2.5.
14. **Buyer language** (Reddit Research MCP + Firecrawl /search for review quotes): Use Reddit Research MCP as PRIMARY for Reddit data (official API, no auth, ToS-compliant). Firecrawl /search for public Reddit pages as fallback. Do NOT create throw-away Reddit accounts. Do NOT use Firecrawl /interact for authenticated Reddit scraping.

**Data quality gate (BINDING):** After Phase 2, verify: (a) ≥3 competitors with pricing anchors (KT-3 gate), (b) ≥20 reviews across ≥3 competitors, (c) ≥2 independent market sizing sources. If any gate fails, flag as INSUFFICIENT_DATA. The deterministic evidence grade engine (DATA-OPERATIONS-ARCHITECTURE.md §6.2) assigns grades — agents do NOT self-grade claims.

**Phase 3: Commercial Design (Pipeline §4.3 — ~15 credits, ~3 min)**

15. Based on research from Phases 1-2, design the commercial system (Sections 7-11). This is a DESIGN task, not a research task. The research is input; the design is output.
16. Validate design assumptions: Firecrawl /scrape for pricing benchmarks (re-verify competitor pricing completeness and schema validity). Context7 MCP for signal feasibility verification. Cost: ~15 credits.

**Phase 4: Scoring & QA (Pipeline §4.4 — ~0 credits, ~2 min + 5-8 min canvas authoring)**

17. Score the niche (Section 14) using the RIOS scoring rubric.
18. Generate evidence traceability map (DATA-OPERATIONS-ARCHITECTURE.md §6.3) — every [E]/[P] claim linked to source file, URL, and content hash.
19. Run freshness audit — verify all source data within SLA (DATA-OPERATIONS-ARCHITECTURE.md §6.4).
20. Identify open questions (Section 15).
21. Self-audit against quality gates (Part 3).
22. Cross-reference verification: canvas-level gates for completeness, coherence, conversion reconciliation, pricing consistency, minimum viable sequencing.

### 3.2 Research Tool Strategy

This section replaces the generic "web search operators" from earlier methodology versions. Firecrawl /search with the new relevance model (94.7% SimpleQA accuracy, 10x fewer tokens) is the PRIMARY discovery tool. Google-style search operators (site:, filetype:, intitle:) do NOT apply to Firecrawl — use natural-language queries instead.

**Firecrawl /search patterns (use these, not Google operators):**

| Research Goal | Firecrawl Query Pattern | Notes |
|---|---|---|
| Find competitors | `"[niche] software platforms tools 2026"` | Relevance excerpts surface competitor names + positioning |
| Market sizing | `"[niche] market size report 2025 2026"` | Analyst reports often in top results |
| Review extraction | `"[competitor] reviews G2 Capterra"` | Follow with /scrape on review URLs from excerpts |
| Buyer language | `"[buyer title] challenges [topic] 2026"` | Natural language, no site: operator needed |
| Pricing discovery | `"[competitor] pricing plans cost"` | Firecrawl /map to discover pricing URLs before /scrape |
| Trigger events | `"[niche] industry challenges trends 2026"` | Broad discovery queries — relevance model filters noise |
| Funding data | `"[company] funding round 2025 2026"` | Financial Hub MCP (SEC EDGAR) + Firecrawl /search as backup |
| News/intent | `"[niche] announced expansion hiring 2026"` | GDELT Project API for systematic coverage (free) |

**DataForSEO patterns:**

| Research Goal | DataForSEO API | Batch Strategy |
|---|---|---|
| Keyword volume | Keywords API | Batch up to 1,000 keywords per request — same cost as 1 |
| Competitor domain analysis | Labs API — Domain Competitors | One call per competitor domain |
| SERP analysis | SERP API — Standard queue | Use standard queue (5 min), not live (<60s). All niche research is batch. |
| Technographics | Domain Analytics — Technologies | Batch up to 5 domains per call |

**When a search returns no relevant results:**
1. Try a narrower query (remove a modifier — use more specific niche terminology)
2. Try a broader query (add an adjacent concept — switch from niche term to problem term)
3. Try a different tool: switch from Firecrawl /search to DataForSEO SERP API for SEO-indexed results, or Context7 MCP for structured docs
4. Only after 3 attempts across ≥2 tools, mark as `[S]` and record the attempted searches + tools in the canvas notes

**Cache-idempotent rule:** Before any credit-consuming operation, check if fresh data already exists per DATA-OPERATIONS-ARCHITECTURE.md §1.3 item 2. The preflight check script (Appendix A) handles this. No data is fetched twice within its freshness SLA.

**Credit optimization (always apply):**
- Firecrawl /search before /scrape — excerpts are often sufficient
- Firecrawl /map before /crawl — 1 credit saves ~80% of crawl credits
- DataForSEO batch requests — always batch; same cost for 1 or 1,000 keywords
- Firecrawl /monitor for recurring checks — 1 credit/check vs. repeated /scrape
- Paid-first: Firecrawl + DataForSEO are PRIMARY. Free tools only when demonstrably better (see DATA-OPERATIONS-ARCHITECTURE.md §2.2 decision tree)

### 3.3 Cross-Reference Requirements

Every claim should be cross-referenced where possible. The deterministic evidence grade engine (DATA-OPERATIONS-ARCHITECTURE.md §6.2) enforces this mechanically:

- **Market size:** Cross-reference top-down (total industry spend × niche %) with bottom-up (company count × avg spend). If they differ by more than 2×, investigate and flag the discrepancy.
- **Competitor pricing:** Verify pricing claims against 2+ sources (website, G2, review site, third-party article). For `[P]` grade: requires 2+ INDEPENDENT sources with DIFFERENT root domains owned by DIFFERENT entities. G2 + Capterra (same parent: G2.com, Inc.) = NOT independent.
- **Pain quantification:** Cross-reference industry benchmarks with government statistics (EUROSTAT, OECD, CBS StatLine) and published surveys.
- **Trigger events:** Cross-reference with ClarityRev's existing trigger research (niche-program/research/SHARED/triggers/) and the cross-niche dedup manifest.
- **Signal feasibility:** Verify every planned signal against Context7 MCP (official API docs) — confirm the API endpoint exists and returns the data type needed BEFORE designing the signal workflow.

**Cross-source consistency for `[P]` claims:** When two independent sources produce numerical values (pricing, market size, churn rate), compare them. If they diverge by >20%, the claim is downgraded from `[P]` to `[E]` with annotation: "Sources diverge: Source A says X, Source B says Y (Δ = Z%)."

### 3.4 When to Flag Unknowns

Flagging is now deterministic — the Grade Assignment Engine (DATA-OPERATIONS-ARCHITECTURE.md §6.2) computes grades from four binary criteria. The agent does NOT self-assign evidence grades.

| Situation | Action |
|---|---|
| No data found after 3 search attempts across ≥2 tools | Mark claim as `[S]`, log all attempted searches + tools in trace-map |
| Data from one source only | Grade `[E]` (C1=NO, C2=YES). Cite the source. |
| Data from one source but source is authoritative (government statistics, official registry) | Grade `[E]`, cite the source, note "SINGLE_SOURCE_AUTHORITATIVE" |
| Data from 2+ independent sources (different root domains, different parent entities) | Grade `[P]` (C1=YES, C2=YES). Verify cross-source consistency (≤20% divergence for numerical claims). |
| Data from 2+ sources but NOT independent (same parent entity, e.g., G2 + Capterra) | Grade `[E]` — flag as "MULTI_SOURCE_SAME_PARENT" |
| Data exists but freshness SLA expired | Grade `[H]` (demoted — C3=NO). Re-fetch attempted. If re-fetch succeeds, restore original grade. |
| Source URLs undocumented or traceability broken | Grade `[S]` (C4=NO) — claim cannot be verified by a third party |
| Tool unavailable for data type (SOURCE_UNAVAILABLE) | Mark as `SOURCE_UNAVAILABLE` with tool name + timestamp. Do NOT substitute a qualitatively different data type. |

### 3.5 Using ClarityRev's Existing Research

Before starting any new niche, check existing ClarityRev research for overlaps. The canonical research data lives under `niche-program/research/`.

1. **Check `niche-program/research/SHARED/competitors/`** — Cross-niche competitor profiles. If a competitor serves this niche, the profile provides: pricing, positioning, weaknesses, strengths, GTM motion, target buyer. Consume from SHARED (FREE — no credit cost) if FRESH.
2. **Check `niche-program/research/SHARED/benchmarks/`** — B2B benchmarks (churn rates, conversion rates, CAC ranges) accumulated as niches are evaluated. The benchmark database grows with each niche.
3. **Check `niche-program/research/SHARED/triggers/`** — Cross-niche trigger registry. Trigger events and signal patterns discovered in earlier niches.
4. **Check `niche-program/research/SHARED/_REGISTRY.yaml`** — Master index of all shared data. Query for data tagged with this niche's category or overlapping competitors BEFORE fetching any new data.
5. **Check `research/phase-3/` competitor audits** — 37 competitors audited in Phase 3. These are pre-niche-program artifacts. They provide deep qualitative competitor data but were not produced under the niche methodology. Treat as `[H]` grade — useful context, not binding evidence.
6. **Check `research/phase-2/` VOC corpus** — VOC interviews and language patterns. Treat as `[H]` grade — secondary research, pre-dates the niche methodology.

**Integration rule:** When integrating existing research, cite the source document AND the specific file path. All evidence from pre-niche-program sources is `[H]` grade maximum — it is secondary research, not primary data gathered under this methodology. Regrade through the deterministic evidence grade engine (DATA-OPERATIONS-ARCHITECTURE.md §6.2).

**Cross-niche deduplication:** The `_pipelines/dedup-manifest.yaml` tracks which niche first profiled each cross-niche entity. If a competitor or benchmark was already profiled by an earlier niche, consume the existing profile rather than re-fetching. This prevents duplicate credit spend across niches. See DATA-OPERATIONS-ARCHITECTURE.md §7.3.

---

## 4. PART 3: QUALITY GATES

### 4.1 Section-Level Gates

Each section must pass its gates before the canvas moves to scoring.

#### Section 1: Niche Identity & Definition
- **BLOCKING:** IN/OUT list present. Market size estimated with at least `[E]` grade.
- **MAJOR:** Niche archetype selected with reasoning. Geographic scope justified.
- **NICE:** Market size triangulated from 3+ sources.
- **ADVERSARIAL CHECK:** Can I name a company that is IN this niche? Can I name one that is OUT? If either answer is no, the boundaries are too vague.

#### Section 2: Buyer & Committee Mapping
- **BLOCKING:** All 5 roles named with titles and KPI ownership. Decision process has 3+ steps. 3+ trigger events.
- **MAJOR:** Champion's internal pitch written out. Purchase authority thresholds estimated.
- **NICE:** Trigger events ranked by frequency. Decision timeline validated.
- **ADVERSARIAL CHECK:** Would the named economic buyer recognize themself in this description? If the description fits any VP at any company, it's too generic.

#### Section 3: Pain & Economics
- **BLOCKING:** Primary revenue leakage type identified. EUR quantified pain per company (with method). Pain visibility assessed.
- **MAJOR:** Budget existence determined. Current spending on solution category known.
- **NICE:** Pain quantified at multiple tiers. Range (not just median) provided.
- **ADVERSARIAL CHECK:** Is the EUR number visceral enough that a buyer would say "that's me"? If it reads like a consultant's estimate, it needs more specificity.

#### Section 4: Competitive Landscape
- **BLOCKING:** 3+ direct competitors with pricing. Internal/DIY alternative analyzed. White space identified.
- **MAJOR:** Strategy Canvas or equivalent visual. Adjacent substitutes listed. Pricing landscape summarized (min/median/max).
- **NICE:** Competitive response modeled. Porter's Five Forces for the niche.
- **ADVERSARIAL CHECK:** Is the DIY alternative HONESTLY analyzed, or dismissed? Most B2B buyers solve problems with spreadsheets; if the canvas doesn't explain why they'd leave spreadsheets, it's incomplete.

#### Section 5: Ecosystem & Distribution
- **BLOCKING:** 4+ aggregator candidates across 2+ classes. Warm access assessed for each. At least 1 marketplace/platform path.
- **MAJOR:** Aggregators ranked by proximity to transaction. Incentive alignment modeled for top 2.
- **NICE:** Direct-first reachability estimated per channel. Partner incentive structure designed.
- **ADVERSARIAL CHECK:** Can a founder personally get an intro to the #1 aggregator candidate? If no, and the strategy depends on it, the strategy has a hole.

#### Section 6: Trigger & Signal Map (§6A + §6B + §6.0 + §6.8)

**§6.0 Unified Signal Architecture:**
- **BLOCKING:** Unified signal data contract present. §6A/§6B relationship explicitly stated. Routing logic specified (bob / client_crm / both).
- **MAJOR:** Signal ID naming convention followed across both sections.

**§6A Sales Trigger Map:**
- **BLOCKING:** §6A.0 ACH table with ≥10 candidate triggers scored, bottom 5 rejection rationale. 5 triggers identified with: evidence grades on all factual claims, SPICED mapping, pain dimension traceability (§3), who feels them, detectable signal, outreach timing to day-range. Detection feasibility assessed per signal. Bob's capacity constraint modeled in §6A.3 with triage tiebreakers.
- **MAJOR:** Trigger cascade chains mapped. §6A.3 tier table with niche-specific examples, verbatim opening lines, and capacity-aware responses. Dedup logic with explicit windows. "Signal doesn't fire" AND "signals fire systematically wrong" scenarios covered.
- **NICE:** Calendar of trigger events across year. False positive rate estimated per trigger. Detection recall estimated. Competitive detection lead time assessed per trigger.
- **ADVERSARIAL CHECK:** Are these triggers the BUYER cares about, or is this ClarityRev's buying signal that isn't the buyer's problem? Can Bob physically execute the Tier 1 response when 5 triggers fire simultaneously? If triggers fire but are systematically WRONG, at what point does Bob stop trusting the system?

**§6B Client Signal Catalog:**
- **BLOCKING:** §6B.1 taxonomy populated with JTBD framing per category. ≥15 signals in §6B.2 with: evidence grades on factual claims, signal ID + version, source verification (endpoint/date/method), predictiveness confidence, 13-field specification. §6B.3 tiers defined with delivery mechanisms + overload prevention. §6B.7 demo narrative with 3-5 signals in sequence + expected prospect reactions. §6B.8 calibration table for all Tier 1+2 signals. §6B.10 signal health monitoring with per-signal metrics + alert routing + escalation path.
- **MAJOR:** §6B.5/§6B.6 competitive signal gap with Blue Ocean Strategy Canvas. §6B.4 Bowtie Funnel mapping per category + at least one expansion signal combination. Every Tier 1 signal has backup detection source. §6B.9 ≥5 signals mapped to §11 workflows.
- **NICE:** Zero-client signal calibration protocol integrated with §12.1. Source concentration risk calculated. Signal freshness decay modeled per signal. Demo objection handling specified per common objection.
- **ADVERSARIAL CHECK:** Does every Tier 1 signal carry a predictiveness confidence rating? Is Link 2 (client adoption) designed for — the most likely failure mode? If a competitor reads §6B.5/§6B.6, what do they learn and how fast can they copy it? Are signal health metrics specified such that Wesley knows a pipeline is broken BEFORE the client notices?

**§6.8 Signal Strategy Pre-Mortem:**
- **BLOCKING:** Three-link chain pre-mortems written (Detect/Act/Recover). Structural assumptions table with 50% stress tests. Competitor exploitation assessment with defenses. Zero-client signal honesty protocol.
- **MAJOR:** Source concentration risk calculated with diversification strategy. Client-side adoption pre-mortem written with built-in defenses.
- **NICE:** Every FRAGILE stress-test result has specific, credible mitigation. Competitor exploitation names specific competitor + response timeline.
- **ADVERSARIAL CHECK:** Link 2 (client adoption) is the most likely failure — are the adoption defenses as rigorous as the detection design? If the competitor exploitation assessment makes you want to delete this section before a competitor reads it, the signals aren't defensible enough.

#### Section 7: Customer Journey & Offer Architecture

- **BLOCKING:** MECE verification gate completed (§7.1 preamble). All APPLIES stages in §7.1 with: evidence grade inheritance on all fields, JTBD per stage, TTV targets, measurable stage-gate criteria (not prompts — specific conditions), champion advocacy mapping, and founder time allocation. Diagnose Snapshot fully specified (§7.2) with hinge assumption stress-tested at 3 Snapshot output levels (too small, credible, too big). Journey map (§7.3) with: explicit conversion rates (low-expected-high) per transition, benchmark anchoring or `[S]` flag, compound probability calculation, non-linear paths (≥5: nurture loop, skip path, resurrection path, expansion loop, churn path, non-converter path). §7.2a pricing ladder with value-to-price ratios and competitor anchoring. §7.4 offer economics with per-stage revenue/cost/margin/breakeven, cost decomposition (fixed vs. variable at 3 scale points), and founder capacity allocation. §7.5 journey pre-mortem with specific failure narrative + per-transition kill metrics + minimum viable journey sequencing. §7.6 journey technical specification with: stage transition data contracts, journey instrumentation (CRM fields + triggers + stall alerts), automation feasibility per stage, and FMEA for top 6 transitions.
- **MAJOR:** Competitive journey comparison (§7.1a) with Strategy Canvas vs. top 3 competitors. Bowtie Funnel overlay mapping each stage to Acquisition/Retention/Expansion/Advocacy with metrics. Non-converter path designed (not just happy path). Referral mechanics specified per stage. Strategic control point identified with rationale.
- **NICE:** Scenario planning for journey disruption (§7.5.5). Competitor free→paid mechanism comparison. Pricing ladder shows value-to-price ratio declining monotonically. Stage duration SLAs specified. Margin trajectory modeled at 5/20/100 clients. Rumelt guiding policy specific to this niche.
- **ADVERSARIAL CHECK:** Are all 6 stages genuinely different for this niche, or is this the generic RIOS framework copy-pasted? The test: could I tell which niche this lifecycle belongs to without reading the niche name at the top? If the answer is no, redo §7.1 with niche-specific offer names, JTBD, and stage-gate criteria. Is the hinge assumption surfaced AND stress-tested at 3 output levels? If the Snapshot doesn't create urgency in THIS niche, nothing else matters — is that assumption assigned a confidence grade? Are non-linear paths designed, or does the journey assume buyers move in straight lines? If a buyer stalls for 12 months, do we have a designed response? Can Bob actually execute this journey for 10 simultaneous buyers — is founder capacity respected? At what buyer count does the journey break?

#### Section 8: Free Entry Services

- **BLOCKING:** Free layer strategic job stated (attract volume / pre-qualify / educate market / demonstrate superiority). Competitor free layer audit (§8.1) with ≥3 competitors, source-verified (URL + date), Match/Differentiate/Skip with strategic intent. Competitive free-layer Strategy Canvas (§8.1a) completed. ≥3 free services designed across ≥2 tiers (§8.2), each with: evidence grades on all fields, pain traceability (§3), signal traceability (§6B), competitive decision, specific output, data requirements, turnaround, conversion hook, Bob's Usage (verbatim), top 2 objection responses (verbatim), MEDDIC mapping, conversion model (rate + time + stall point), delivery cost, build spec (tools/APIs/effort/dependencies/cost per run), and niche-name-swap test. The Snapshot (Tier 3 data-connected) is mandatory. Free-to-paid conversion design (§8.4) with per-tier post-completion sequence and nurture for non-converters. Free layer pre-mortem (§8.5.1) with specific failure narrative. Free anchoring risk assessed with niche-specific mitigations (§8.5.2). Breakeven analysis (§8.5.3) with kill switch at 50% of breakeven for 6 months. Free-tier data retention & privacy spec (§8.6.3).
- **MAJOR:** Distribution specified per service (§8.3) with channel, aggregator-native version, distribution cost, and channel experiment design. Free service health monitoring with metrics and thresholds (§8.6.1). Multi-tenant scaling modeled at 10/50/200 simultaneous users (§8.6.2). Free service versioning policy (§8.6.4). Competitor exploitation assessment with defenses (§8.5.4). Demand validation per free service.
- **NICE:** SEO/SEM strategy with search volume data. At least one free service is a deliberate Match (proving competitor audit informed design). Bob's Usage fields are verbatim-ready for a call today. Build spec per service complete enough for sprint estimation.
- **ADVERSARIAL CHECK:** Would a busy executive in this niche actually spend 5 minutes to get this free number? If the answer requires them to care about ClarityRev before seeing value, the friction is too high. Is the free anchoring risk honestly assessed — "you found it for free, why pay for the fix?" — or hand-waved? If 500 Snapshots produce 5 paid conversions, at what month do we kill the free service? Is that kill switch specified? What prevents a competitor from copying the free Snapshot in 3 months?

#### Section 9: Paid Entry Services

- **BLOCKING:** Paid portfolio architecture stated (ladder/menu/sequence). Competitor paid audit (§9.1) with ≥3 competitors, source-verified (URL + date), Match/Differentiate/Skip with strategic intent. Competitive paid-layer Strategy Canvas (§9.1a). ≥3 paid services designed (§9.2) with portfolio economics summary, each with: evidence grades on all fields, service type + portfolio role, pain traceability (§3), signal traceability (§6B), competitive decision, price with competitor anchoring + strategic pricing rationale, detailed scope, time-to-value, risk reversal with guarantee financial exposure, evidence needed, purchase psychology + price sensitivity, delivery method + automation level, build spec (workflows/APIs/effort/dependencies/cost), Bob's Usage (verbatim), top 3 objection responses (verbatim), MEDDIC mapping, sales cycle, conversion model (free→paid + paid→recurring rates), client data handling, and niche-name-swap test. Pricing justification (§9.4) with strategic pricing position, competitor anchoring, ROI justification, purchase authority fit, and displacement comparison. Paid service pre-mortem (§9.5.1). Guarantee financial exposure model (§9.5.2) with worst-case monthly and annualized exposure. Minimum viable paid portfolio sequence (§9.5.3). Competitor undercutting scenario with defenses (§9.5.4).
- **MAJOR:** Paid service health monitoring with metrics and thresholds (§9.6.1). Paid service versioning policy (§9.6.2). Portfolio-level revenue mix and margin by service. Every paid service's price lands under the champion's solo approval threshold per §2.3.
- **NICE:** Guarantee invocation triggers and tracking system specified. Client satisfaction monitoring. Service margin trajectory modeled. At least one service is a deliberate Match. Bob's Usage fields are verbatim-ready for a call today.
- **ADVERSARIAL CHECK:** Is the risk reversal real, or is it just words? "Satisfaction guaranteed" doesn't reverse risk in B2B. "We don't get paid unless we recover EUR X" does — but can ClarityRev afford it? The guarantee exposure model (§9.5.2) forces this math. Is the single most dangerous assumption surfaced: that buyers will pay for the fix after getting the diagnosis for free? Is the minimum viable portfolio respected — are we building ONE paid service first? If the competitor undercutting scenario happens at 50% of our price, do we have a defense beyond "our quality is better"?

#### Section 10: Core Recurring Services

- **BLOCKING:** Recurring portfolio strategy stated. Competitor recurring audit (§10.1) with ≥3 competitors, source-verified, Match/Differentiate/Skip with strategic intent. Competitive recurring Strategy Canvas (§10.1a). Core recurring service designed (§10.2) with: evidence grades on all fields, strategic rationale for recurring vs. one-time, competitive decision, price with tiering driver + competitor anchoring, detailed scope (included/excluded), relationship to paid services (§9), LTV model (LTV/CAC >3×), paid→recurring conversion model, onboarding process + automation (§10.8.1), churn prevention (niche-specific, not generic), Bob's Usage (verbatim), top 3 objection responses (verbatim), niche-name-swap test. Expansion architecture (§10.3) with ≥2 paths, specific expansion triggers from §6B.4, expansion conversion math. Moat connection (§10.4) with quantified trajectory at 5/20/50/100 clients. Value delivery cadence (§10.7) with 6 timeline checkpoints + client monthly experience. "Why Cancel?" pre-mortem (§10.10) with early warning signals per reason. Churn stress test at 4 scenarios (§10.11.2). Minimum viable recurring sequence (§10.11.3). Recurring service health monitoring (§10.12.3) with 7 metrics + thresholds + alerts.
- **MAJOR:** Competitive retention defense (§10.9) with switching cost math. Onboarding-to-recurring conversion mechanism chosen with rationale. Service tiering driver (§10.6) with objective boundaries + competitor anchoring. Land-and-expand revenue trajectory (§10.5) with 24-month milestones + step-up triggers. Delivery automation spec (§10.12.1) per recurring component. Multi-tenant data isolation (§10.12.2).
- **NICE:** Moat quantified with accuracy improvements at each client-count threshold. Churn preventive measures tied to early warning signals. Client provisioning fully automated where possible. LTV/CAC >5× at target churn rate. At least one expansion path traces to a specific §6B.4 signal combination. Client monthly experience description reads like a product marketing page.
- **ADVERSARIAL CHECK:** Why wouldn't the buyer cancel after 3 months? If the churn prevention answer is "they love it," that's not a mechanism. What specific observed behavior indicates at-risk accounts? Is the recurring service genuinely different from the paid standalone, or just "the same thing but monthly"? If churn hits 3%/month, does the LTV model still close? Is the minimum viable recurring concept respected — are we building recurring before validating one-time? What would the founders' most skeptical advisor say?

#### Section 11: Automated Workflow Specifications

- **BLOCKING:** ≥3 workflows specified with full §11.2 detail (26 fields). Each workflow has: evidence grades on all fields, build-vs-buy rationale with alternative tool comparison (§11.1 Step 3), sales enablement claim (§11.1 Step 7), CORE/NICHE-SPECIFIC classification (§11.5), dependency graph (§11.6), revenue attribution (§11.7), client-facing vs. internal flag (§11.8), quality criteria (§11.9), data freshness SLA (§11.10), composability mapping (§11.11), testing & validation spec (§11.16), rollback/recovery procedure (§11.2), demo-ability assessment (§11.2), client-facing SLA (§11.2). Tool/API dependency risk matrix (§11.15.2) with criticality + deprecation risk + fallback per critical tool. LLM quality drift monitoring (§11.15.3) with 4 metrics + thresholds. Cost spiral scenario modeled at 3 client-count levels (§11.15.4). Workflow performance benchmarks per type (§11.17.1). Documentation standards per workflow (§11.17.3).
- **MAJOR:** LLM role specified at implementable level per §11.1 Step 4. Error handling described per failure mode. Cost per run estimated with range. Dry-run protocol sequenced. Workflow pre-mortem written (§11.15.1). Cost optimization triggers automated (§11.17.2). Workflow performance SLA with runtime + cost targets.
- **NICE:** Every workflow's tool choices justified against the most obvious alternative. At least one workflow chains 3+ tools in a non-obvious combination. Fake-positive analysis per signal-consuming workflow. Workflow cost modeled under 3× LLM cost scenario. Rollback procedure tested.
- **ADVERSARIAL CHECK:** Can a developer build this from the description without asking the agent clarifying questions? If not, the spec is too vague. If we asked 'why Firecrawl and not DataforSEO for this step?' — is there a reasoned answer specific to the niche? Does every workflow enable a specific sales claim, or are some just infrastructure? What happens when the most critical API is deprecated — is there a fallback? If LLM costs increase 3×, do the workflows still make economic sense?

#### Section 12: Evidence Stack & Proof Architecture

- **BLOCKING:** Zero-client honesty statement (§12.1) with evidence-graded assets + "no references" assumption stress-tested with mitigation. Evidence-to-buyer mapping (§12.2) with grades per cell. Evidence gap priority matrix — top 5 missing evidence assets ranked by conversion impact with mitigation per gap. Competitor evidence comparison (§12.3) with named competitors + 24-month evidence trajectory. Diagnostic Moment designed (§12.4). Bob's evidence playbook (§12.4) — which evidence at which conversation point, verbatim (6 stages). Proof-on-their-data mechanism (§12.5) with explicit formula. Segment benchmarks (§12.6) with systematic counter-evidence table (core claim → strongest counter → our response → honest?). Guarantee designed (§12.9) with attribution boundaries + financial exposure calculation per niche + honest negative protocol. Security specification (§12.11) structured with grades. Evidence automation pipeline (§12.12) per asset type.
- **MAJOR:** Evidence pre-mortem (§12.13.1). Competitor weaponization scenario with Bob's verbatim counter (§12.13.2). Confidence calibration on overall evidence stack (§12.13.3). Reference-building plan with monthly milestones (§12.7). Methodology validation with anchored, sourced practices (§12.8). Case study plan with minimum viable and ideal formats (§12.10).
- **NICE:** Every benchmark claim has full source attribution (name, type, year, bias, URL). Counter-evidence is systematic, not a single example. The 24-month evidence trajectory shows credible path from LOW to HIGH confidence. Bob's evidence playbook is verbatim-ready for a call today.
- **ADVERSARIAL CHECK:** Is the guarantee SAFE for ClarityRev? What's the worst-case scenario if the guarantee pays out? Can ClarityRev survive it? Is the "no references" assumption stress-tested — what if empirical proof alone doesn't convert? At what month do we know the evidence strategy isn't working? What's the most damaging thing a competitor could say about our evidence stack, and do we have a verbatim response?

#### Section 13: GTM & Sales Motion

- **BLOCKING:** Evidence grades on all claims. Bob time-budget in actual hours/week (not just %). Bob pipeline capacity model with max active deals. Channel allocation with rationale + per-channel ROI estimates. Per-channel experiment designs with success/fail thresholds. Full funnel model with ranges, benchmark sources, and confidence calibration per rate. Funnel stress test at 50% conversion rates. Outreach messages for ≥4 channel-persona combinations (all verbatim). Top 5 objections with verbatim responses, evidence citations, and walk-away signals. MEDDIC qualification criteria. GTM tool stack with build effort per tool. Channel + niche kill switches with specific metrics + triggers. Founder resilience tracking (Bob-hours vs. revenue). Competitive GTM response timeline (4 phases). Nurture sequence (6 touches, Day 1-60). GTM pre-mortem (§13.9.1). First-90-days week-by-week execution calendar (§13.9.2).
- **MAJOR:** Commission sales acceleration plan with rep onboarding script. Content/SEO roadmap (§13.9.3). Deal economics with grades. GTM-to-delivery handoff spec. Partner activation playbook per aggregator type. Confidence calibration explicitly LOW at zero clients with upgrade path defined.
- **NICE:** All channel-persona combinations have unique verbatim messages (not templated). Competitive response timeline names likely competitor actions at each phase. The 90-day calendar specifies Bob's focus by week with hour allocations and kill switch checkpoints. Funnel math stress-tested at conservative, expected, and optimistic conversion rates.
- **ADVERSARIAL CHECK:** Run the funnel math: 1000 contacts → X responses → Y snapshots → Z paid deals. At X=200, Y=20, Z=4, is the niche still worth targeting? If the math only works at optimistic conversion rates, flag it. If the founders execute this GTM plan perfectly for 90 days and generate zero revenue — at what day do they know? Is Bob's time-budget realistic — or is 30% consumed by admin before any selling happens? Is the pivot specified for each channel if the experiment fails?

#### Section 14: RIOS Score & Diagnosis

- **BLOCKING:** All 4 gates checked with pass/fail + evidence grades + explicit EUR 500K math with sourced inputs. All 8 RIOS dimensions scored 1-5 using calibration anchors with: evidence grade inheritance (weakest-link rule), cross-reference traceability to source sections, specific justification per dimension. Score inflation detection completed: lowest score identified (must be ≤2 or reconciliation note required), 5-count verified (≤2 dimensions at 5 or reconciliation note required), evidence-grade coherence checked. RIOS formula calculated with inherited evidence grade. Lowest-term diagnosis with specific fix (owner + timeline) + fix confidence (HIGH/MEDIUM/LOW). Verdict stated with confidence grade. Score reconciliation note if applicable.
- **MAJOR:** Sensitivity analysis — which dimension swing changes verdict? Competitive RIOS comparison vs. #1 competitor. RIOS score trajectory (today → Month 6 → Month 12). Verdict confidence explicitly stated.
- **NICE:** Every score of 4+ cites specific competitor comparison evidence. The EUR 500K math uses actual inputs from §10.2, §10.3, and §13.2. Score reconciliation note is honest — inflation flagged if suspected. Competitive comparison names the specific #1 competitor and their approximate scores.
- **ADVERSARIAL CHECK:** What's the lowest score? If nothing is below 2, re-examine honestly — inflation is likely. Are there >2 dimensions scored 5? Extraordinary evidence required. Does every score of 4+ cite a specific competitor comparison? Is the EUR 500K gate math explicit or hand-waved? At the evidence grades this canvas has (mostly `[H]`/`[S]`), is the verdict confidence honestly LOW/MEDIUM? LAUNCH PENDING on LOW-confidence evidence is a contradiction — flag it.

#### Section 15: Open Questions & Validation Plan

- **BLOCKING:** Consolidated evidence grade inventory (§15.1) with counts + % per grade + health check (HIGH-UNCERTAINTY flag if >50% `[H]`/`[S]`). Load-bearing `[S]` claims identified with source sections + breakage consequences. Top 5 open questions (§15.2) prioritized by decision-impact/cost-to-answer ratio, each with: source section, decision impacted, resolution method, assigned owner (Bob/Adriaan/Wesley), cost estimate, and priority. Most dangerous unknown (§15.3) stated with unknown pre-mortem + early warning indicators. Validation experiment (§15.4) with falsifiable hypothesis, step-by-step method, success/fail criteria, minimum sample, max cost, and decision on outcome. Decision triggers (§15.6): upgrade, downgrade, kill, revisit, and canvas refresh — all specific, measurable, and time-bound. Decision-tree for verdict changes (§15.7). Required signal validation entries (§15.8).
- **MAJOR:** Validation timeline (§15.5) with monthly activities, owners, hours required, and month-end decisions. Validation owner capacity respected (Bob max 5 hrs/week, Adriaan max 8 hrs/week). Every open question has a named owner. Upgrade/downgrade/kill triggers are specific and measurable.
- **NICE:** Decision-impact/cost ratio is calculated per question, not estimated. The most dangerous unknown is genuinely load-bearing — founders would agree "if this is wrong, we shouldn't do this." The validation experiment can be proven wrong (falsifiable). Canvas refresh trigger ≤90 days. The decision-tree covers all branches.
- **ADVERSARIAL CHECK:** Are there fewer than 5 open questions? If yes, the agent probably didn't research deeply enough. Every niche has major unknowns at this stage — the canvas should reflect that honestly. Is the most dangerous unknown genuinely load-bearing — if it resolves negatively, does the verdict change? Are validation activities assigned to specific people with specific hours, or is everything "Bob will figure it out"? If the canvas is >90 days old with no validation progress, does the verdict automatically downgrade?

### 4.2 Canvas-Level Gates

| Gate | What | Verdict |
|---|---|---|
| **Completeness** | All 15 sections present, all fields filled | PASS/FAIL — FAIL if any section is missing |
| **Evidence Integrity** | No ungraded claims. >50% of claims at `[E]` or higher | PASS/FAIL — FAIL if majority of claims are `[H]` or `[S]` without flagging |
| **Coherence** | Sections link logically: pain → trigger → snapshot → paid entry → recurring. No contradictions. | PASS/FAIL — FAIL if a section contradicts another without explanation |
| **Falsifiability** | The canvas could be proven wrong by evidence | PASS/FAIL — FAIL if every claim is unfalsifiable (too vague to test) |
| **MECE Boundaries** | Niche boundaries are mutually exclusive and collectively exhaustive | PASS/FAIL — FAIL if boundaries overlap with another assessed niche |
| **Decision-Readiness** | A founder could decide "enter" or "skip" this niche based on the canvas | PASS/FAIL — FAIL if after reading the canvas the answer is still "it depends" without a clear path to resolve |
| **Minimum Viable Sequencing** | Canvas respects build sequencing: Diagnose→Prove validated before Commit designed; one paid service validated before second/third built; Sprint validated before recurring built | PASS/FAIL — FAIL if canvas has LAUNCH PENDING verdict but §9.5.3 hinge paid service is not designated for first build, or if §10.11.3 minimum viable recurring is not respected |
| **Conversion Model Reconciliation** | §7.3.1 journey transition rates compound to match §13.2 channel-specific end-to-end rates within ±20% tolerance | PASS/FAIL — FAIL if the two models produce end-to-end rates that diverge by >20% without explanation |
| **Pricing Consistency** | Price stated in §7.2a (pricing ladder) matches price in §9.2 (paid service), §10.2 (recurring service), and §7.4 (offer economics) | PASS/FAIL — FAIL if any price mismatch >10% without explanation |

### 4.3 Agent Self-Audit Checklist (run before submitting)

1. [ ] All 15 sections are present and filled (§6 includes: §6.0, §6A, §6B, §6.8 — all four parts)
2. [ ] Every quantified claim has an evidence grade `[P/E/H/S]`
3. [ ] Niche boundaries are MECE
4. [ ] §6A.0 ACH table with ≥10 candidate triggers and rejection rationale
5. [ ] §6A.3 Bob's capacity constraint modeled with triage tiebreakers
6. [ ] §6B.8 signal confidence calibration completed for all Tier 1+2 signals
7. [ ] §6B.7 demo narrative with 3-5 signals in sequence
8. [ ] §6.8 three-link chain pre-mortems written (Detect/Act/Recover)
9. [ ] §6.8 structural assumptions stress-tested at 50%
10. [ ] §6.8 competitor exploitation assessment completed
11. [ ] All APPLIES lifecycle stages populated with: MECE verification, evidence grade inheritance, JTBD, TTV targets, measurable stage-gate criteria, champion advocacy, founder time
12. [ ] §7.2 hinge assumption stated + stress-tested at 3 Snapshot output levels with confidence grade
13. [ ] §7.2a pricing ladder with value-to-price ratios and competitor anchoring
14. [ ] §7.3 conversion model: explicit rates (low-expected-high) per transition, compound probability, non-linear paths (≥5)
15. [ ] §7.3.2 non-linear paths designed: nurture loop, skip path, resurrection path, expansion loop, churn path, non-converter path
16. [ ] §7.4 offer economics with cost decomposition at 5/20/100 clients and founder capacity allocation
17. [ ] §7.5 journey pre-mortem with specific failure narrative + per-transition kill metrics + minimum viable journey
18. [ ] §7.6 stage transition data contracts per transition (data, format, mechanism, error handling)
19. [ ] §7.6 journey instrumentation: CRM fields, triggers, stall alerts per stage
20. [ ] §8 free layer strategic job stated + MECE coverage verified + design principles followed
21. [ ] §8.2 ≥3 free services across ≥2 tiers, each with: evidence grades, Bob's Usage (verbatim), objection handling, MEDDIC, conversion model, build spec, niche-name-swap test
22. [ ] §8.5.1 free layer pre-mortem written with niche-specific failure narrative
23. [ ] §8.5.2 free anchoring risk assessed with niche-specific mitigations
24. [ ] §8.5.3 breakeven analysis completed with kill switch
25. [ ] §8.6 free layer technical operations specified (health monitoring, scaling, data retention, versioning)
26. [ ] Free snapshot is fully specified (per §7.2 hinge assumption)
27. [ ] §9 paid portfolio architecture stated + §9.1 competitor audit source-verified + §9.1a Strategy Canvas
28. [ ] §9.2 ≥3 paid services, each with: evidence grades, portfolio role, price w/ strategic rationale, Bob's Usage (verbatim), objection handling, MEDDIC, conversion model, build spec, guarantee exposure, niche-name-swap test
29. [ ] §9.5.1 paid service pre-mortem written with niche-specific failure narrative
30. [ ] §9.5.2 guarantee financial exposure model: max monthly + annualized exposure, cash buffer required
31. [ ] §9.5.3 minimum viable paid portfolio: hinge paid service designated for first build; build sequence binding
32. [ ] §9.5.4 competitor undercutting scenario with specific competitor + defenses
33. [ ] §10 recurring portfolio strategy stated + §10.1 competitor audit source-verified + §10.1a Strategy Canvas
34. [ ] §10.2 core recurring service designed with: evidence grades, LTV model (LTV/CAC >3×), paid→recurring conversion model, Bob's Usage (verbatim), objection handling, churn prevention (niche-specific)
35. [ ] §10.4 moat trajectory quantified at 5/20/50/100 clients
36. [ ] §10.7 value delivery cadence: 6 timeline checkpoints + client monthly experience
37. [ ] §10.10 "Why Cancel?" pre-mortem: 3 reasons each with early warning signal + defense
38. [ ] §10.11.2 churn stress test at 4 scenarios with kill switch
39. [ ] §10.11.3 minimum viable recurring: Sprint validated before recurring built
40. [ ] §10.12.3 recurring health monitoring: 7 metrics with thresholds + alerts
41. [ ] §11 ≥3 workflows with full 26-field spec (§11.2) + evidence grades on all claims
42. [ ] §11.1 Step 3: build-vs-buy rationale + alternative tool comparison per workflow
43. [ ] §11.1 Step 7: every workflow enables a verbatim sales claim
44. [ ] §11.15.2 tool/API dependency risk matrix: criticality + deprecation risk + fallback per critical tool
45. [ ] §11.15.3 LLM quality drift monitoring: 4 metrics with thresholds
46. [ ] §11.15.4 cost spiral scenario modeled at 3 client-count levels
47. [ ] §11.16 testing requirements: 5 test types + dry-run protocol
48. [ ] §11.17.1 workflow performance benchmarks per type with runtime + cost targets
49. [ ] RIOS scores are justified (no unexplained 5s or 1s)
50. [ ] Top 5 open questions are listed with resolution plan (including signal validation entries from §6.5)
51. [ ] One section's claims do not contradict another section's
52. [ ] The funnel math is internally consistent (conversion rates compound logically; check §7.3 compound probability)
53. [ ] The EUR 500K gate math is explicitly shown
54. [ ] §6B.10 signal health monitoring specified with per-signal metrics and founder alert routing

---

## 5. PART 4: AUTOMATED WORKFLOW INTEGRATION

### 5.1 Workflow Catalog

The following workflow types are available. Not every workflow fits every niche. Select and adapt.

#### W1: Trigger-Signal Deep-Dive
**Purpose:** Research what triggers (events, conditions, patterns) signal a buying need in this niche, ranked by frequency and commercial impact.
**Input:** Niche definition, buyer persona, 5-10 competitor reviews, analyst reports, VOC if available
**Process:**
1. Web search for "common challenges in [niche]" and "[niche] pain points"
2. Extract trigger statements from competitor reviews (G2/Capterra: what problems led buyers to seek the product?)
3. Cross-reference with ClarityRev's existing trigger/leak archetypes
4. Rank triggers by: frequency × urgency × budget-likelihood
5. Validate against buyer committee mapping
**Output:** Ranked trigger list with signal sources and detection method
**Tool/API chain:** Firecrawl /search (relevance excerpts — discovery) → Firecrawl /scrape (competitor review pages, G2/Capterra public pages) → Reddit Research MCP (buyer language, primary Reddit method) → DataForSEO Keywords API (batched keyword volume for trigger-related search terms) → Claude analysis (pattern extraction, trigger ranking) → structured output per §5.3 spec
**Human review checkpoint:** Verify top 5 triggers make sense for this niche (founder knowledge)
**Evidence grade for output:** Typically `[H]` — triggers from secondary research need primary validation

#### W2: Competitive Landscape Scan
**Purpose:** Map the competitive environment for this niche with pricing, positioning, and white-space analysis.
**Input:** Niche definition, 5-10 competitor names (from initial search)
**Process:**
1. Web search: direct competitors in niche
2. Visit each competitor website: extract pricing, positioning, target buyer, features
3. Read 3-5 G2/Capterra reviews per competitor: extract strengths, weaknesses, buyer language
4. Identify DIY alternative analysis
5. Identify white space (what no competitor provides well)
6. Generate Strategy Canvas (Blue Ocean) comparing ClarityRev's hypothesized offer on key factors
**Output:** Competitive landscape matrix (competitor × dimension), Strategy Canvas, white-space statement
**Tool/API chain:** Firecrawl /search (competitor discovery, relevance excerpts) → Firecrawl /map (discover pricing URLs, 1 credit) → Firecrawl /scrape (homepages, pricing pages, JS-rendered pages with --wait-for) → DataForSEO Domain Analytics (technographics, $1.21/1K companies) → DataForSEO Labs API (competitor keyword overlap) → OpenRegistry MCP (company registry verification) → Claude analysis → chart generation → structured output per §5.3 spec
**Human review checkpoint:** Verify competitor list is complete (founder knowledge of niche)
**Evidence grade for output:** Competitor pricing: `[P]`. Strengths/weaknesses: `[E]`. White space: `[H]`.

#### W3: Distribution Path Discovery
**Purpose:** Identify aggregators, marketplaces, and distribution channels in this niche.
**Input:** Niche definition, buyer persona, ecosystem map
**Process:**
1. Web search for "[niche] agency partners", "[niche] consulting firms", "[niche] service providers"
2. Search app/software marketplaces relevant to the niche (HubSpot, Salesforce, Bullhorn, etc.)
3. Search for "[niche] community", "[niche] Slack group", "[niche] LinkedIn group"
4. Search for "[niche] VC investor portfolio" (capital allocator discovery)
5. Map each aggregator candidate to Aggregator Theory class
6. Assess warm access potential
**Output:** Aggregator candidate list per class, with contact/incentive notes
**Tool/API chain:** Firecrawl /search (aggregator/discovery queries) → Firecrawl /scrape (directory pages, marketplace listings) → OpenRegistry MCP (company category queries, 30 registries) → Registry Lookup API (global company registry, 5K calls/mo) → structured list per §5.3 spec
**Human review checkpoint:** Verify top 3 aggregator candidates with founder knowledge of the niche
**Evidence grade for output:** Aggregator existence: `[P]`. Warm access: `[P]` only if founder confirmed, else `[H]`.

#### W4: Pricing Landscape Analysis
**Purpose:** Understand what buyers in this niche pay for similar services and where ClarityRev should price.
**Input:** Competitive list, buyer persona, purchase authority thresholds
**Process:**
1. Extract pricing from competitor websites (visit each, note pricing page content)
2. Search G2/Capterra for pricing mentions in reviews
3. Calculate min, median, max for comparable offerings in this niche
4. Map to purchase authority thresholds (under what approval levels can the champion decide alone?)
5. Recommend pricing bands mapped to RIOS lifecycle stages
**Output:** Pricing table (competitor × price × pricing model), pricing band recommendations, authority threshold map
**Tool/API chain:** Firecrawl /map (discover pricing URLs, 1 credit) → Firecrawl /scrape (pricing pages, JS-rendered with --wait-for) → DataForSEO Keywords API (batched keyword CPC data for price sensitivity signals) → Claude comparison analysis → pricing recommendation → structured output per §5.3 spec
**Human review checkpoint:** Verify against ClarityRev's existing pricing philosophy (bands, not fixed, EUR 1.5-8K range)
**Evidence grade for output:** Competitor pricing from public pages: `[P]`. Authority thresholds: `[H]`.

#### W5: Buyer Language & Positioning Research
**Purpose:** Extract the actual language buyers in this niche use to describe their problems, so ClarityRev can mirror it in positioning and content.
**Input:** Niche definition, buyer roles, 10-15 competitor reviews, analyst reports, job descriptions
**Process:**
1. Web search for "[buyer title] challenges [topic]" (e.g., "VP Sales challenges pipeline management")
2. Extract problem statements from G2/Capterra reviews (buyers describe what they needed and why)
3. Analyze job descriptions for target titles — what KPIs and pain points are mentioned?
4. Read 3-5 articles/speeches by target buyers (LinkedIn, industry pubs)
5. Extract recurring language patterns: specific phrases, metaphors, EUR numbers, emotional charge
6. Map to ClarityRev's existing VOC language buckets (research/phase-2/)
**Output:** Buyer language patterns (top 10 phrases/themes), positioning recommendations, VOC debt notes
**Tool/API chain:** Firecrawl /search (buyer language discovery, relevance excerpts) → Firecrawl /scrape (G2/Capterra review pages, job description pages) → Reddit Research MCP (community language, primary Reddit method) → Public ATS APIs (Greenhouse, Lever — job posting language) → Claude pattern analysis (extract recurring phrases, themes, emotional charge) → language bucket mapping → structured output per §5.3 spec
**Human review checkpoint:** Do the extracted phrases sound genuine to a founder with sales experience in this niche?
**Evidence grade for output:** Review language: `[E]` (review bias acknowledged). Job description data: `[E]`. LinkedIn/article analysis: `[H]` (small sample).

#### W6: Funnel Economics Modeling
**Purpose:** Design and stress-test the funnel economics for this niche.
**Input:** All previous workflow outputs, ClarityRev cost structure, pricing bands
**Process:**
1. Model the funnel: prospects → contacts → snapshots → paid entry → recurring → expansion
2. Estimate conversion rates at each stage (with ranges, not point estimates)
3. Calculate CAC per stage
4. Calculate LTV at assumed churn rates (12%/yr baseline unless evidence says otherwise)
5. Calculate CAC payback period
6. Stress-test: what happens at 50% of expected conversion?
7. Check EUR 500K net profit gate: clients × price × margin = ?
**Output:** Funnel economics model (table), CAC/LTV ratios, payback analysis, stress test scenarios
**Tool/API chain:** Claude data analysis → spreadsheet model → structured output per §5.3 spec. Market benchmarks sourced from SHARED/benchmarks/_BENCHMARK_DATABASE.yaml (accumulated across niches). Cost assumptions from DATA-OPERATIONS-ARCHITECTURE.md §8.
**Human review checkpoint:** Is the funnel honest? Challenge every conversion assumption.
**Evidence grade for output:** All conversion estimates: `[S]`. This is a modeling exercise, not an empirical one. Flag every estimated number.

#### W7: Content & Authority Asset Strategy
**Purpose:** Determine what content assets (benchmark reports, calculators, teardowns) will attract this niche.
**Input:** Buyer persona, buyer language, pain quantification, trigger events
**Process:**
1. Identify the top-of-funnel content that would resonate with this niche's buyers
2. Search for existing content in this niche — what's already being written? What's the gap?
3. Design the authority asset (benchmark report, POV piece, calculator) per RIOS lifecycle
4. Design the free diagnostic snapshot for this niche (name, one number, data requirement, output format)
5. Plan distribution for each asset
6. Map content → snapshot → paid entry → recurring conversion path
**Output:** Content asset list (3-5 assets), snapshot specification, distribution plan, conversion path
**Tool/API chain:** Firecrawl /search (content gap analysis, relevance excerpts) → Firecrawl /scrape (competitor content pages, blog posts, lead magnets) → DataForSEO Keywords API (batched content keyword volume for SEO opportunity sizing) → Claude content strategy → snapshot specification per RIOS lifecycle → structured output per §5.3 spec
**Human review checkpoint:** Would a busy buyer in this niche spend 5 minutes on this content? If the answer isn't clearly yes, redesign.
**Evidence grade for output:** Content gap: `[E]`. Asset design: `[H]`. Distribution plan: `[H]`.

#### W8: Lead Enrichment & Signal Detection Pipeline
**Purpose:** Design the automated pipeline that detects trigger signals in this niche and enriches them into actionable intelligence.
**Input:** Trigger list (from W1), niche company list, system/stack requirements
**Process:**
1. Design signal detection: what data sources (CRM metrics, job changes, news, funding, etc.) and what API/tool captures each
2. Design enrichment: what data to add via Clay/n8n (company size, tech stack, growth signals, recent hires)
3. Design the detection → enrichment → analysis → delivery pipeline
4. Specify LLM role: what does the LLM analyze and decide vs. what is rule-based
5. Identify human review checkpoints
6. Estimate cost per run (API calls, LLM tokens, human review time)
**Output:** Pipeline architecture diagram (textual), tool/API chain specification, cost per run estimate
**Tool/API chain:** Context7 MCP (API capability verification — official docs, FREE) → Firecrawl /scrape (signal source verification pages) → DataForSEO Domain Analytics (technographics for enrichment stack assessment) → Claude pipeline design → specification → cost model. Tools referenced: Firecrawl /monitor (recurring signal checks, 1 credit/check), GDELT Project API (news/intent signals, free), Public ATS APIs (hiring signals, free), DataForSEO SERP API (ranking change signals) → structured output per §5.3 spec
**Human review checkpoint:** Can this pipeline be built with available tools and skills? If it requires a capability ClarityRev doesn't have, flag it as a build dependency.
**Evidence grade for output:** This is a design specification. Feasibility grades apply per tool/step.

#### W9: Niche Synthesis & Auto-Critique
**Purpose:** Review the completed niche canvas for internal consistency, evidence gaps, and quality issues.
**Input:** Completed sections 1-14
**Process:**
1. Cross-section consistency check: do the assumptions in section 3 (pain) match the offers in sections 7-10?
2. Evidence audit: are all claims graded? Do the evidence grades support the RIOS score?
3. Funnel logic check: does the conversion path from free to paid to recurring make logical sense?
4. Falsifiability check: what would prove this niche wrong, and is that documented in section 15?
5. Red-team check: what's the weakest assumption in the canvas? Is it flagged?
**Output:** Canvas quality report with flagged issues and suggested fixes
**Tool/API chain:** Evidence grade engine (DATA-OPERATIONS-ARCHITECTURE.md §6.2 — deterministic grade assignment) → Freshness audit script (DATA-OPERATIONS-ARCHITECTURE.md Appendix B) → Cross-reference verification (canvas-level gates per Part 3 §4.2) → Falsifiability check → Red-team adversarial checklist (Part 3) → Canvas quality report
**Human review checkpoint:** The agent should fix all flagged issues before the canvas is considered complete. If a fix can't be made in the current session, it must be logged in section 15.
**Evidence grade for output:** Internal consistency: `[P]` (objective check). Quality assessment: `[P]` (agent's professional judgment).

### 5.2 Workflow Selection Guide

Not every workflow fits every niche. Use this guide. Validated against 25-niche use cases and the verified toolchain in DATA-OPERATIONS-ARCHITECTURE.md §2.

| Workflow | Best For | Skip When | Credits Cost (STANDARD) |
|---|---|---|---|
| W1 Trigger-Signal Deep-Dive | Niches with well-understood trigger events | Niche is so new that triggers can't be researched (mark as validation need) | 5-10 credits |
| W2 Competitive Landscape | Every niche — always required | Only if competitive landscape is already documented in SHARED/competitors/ | 40-55 credits |
| W3 Distribution Discovery | Niches with ecosystem/marketplace/platform | Purely direct-sales niche with no aggregator path (rare) | 3-8 credits |
| W4 Pricing Landscape | Every niche — always required | Only if pricing is entirely value-based (no competitors to benchmark) | 6-20 credits |
| W5 Buyer Language | Every niche — always required | Only if VOC data already exists for this niche in SHARED/ | 5-15 credits |
| W6 Funnel Economics | Every niche — always required | Never skip. This is critical for the EUR 500K gate check. | 0 credits |
| W7 Content Strategy | Niches entering Attract phase | Niche served entirely through partners (different entry path) | 2-5 credits |
| W8 Signal Detection Pipeline | Niches moving into build phase | Niche that hasn't passed the VALIDATE/LAUNCH verdict | 2-5 credits |
| W9 Self-Audit | Every niche — always required | Never skip. Run last, fix findings before submitting. | 0 credits |

### 5.3 Tool/API Stack Specification Format

Every workflow specification must use this format. Tool references must use exact tool names from DATA-OPERATIONS-ARCHITECTURE.md §2.1 (Verified Tool Inventory). The format aligns with data schemas in DATA-OPERATIONS-ARCHITECTURE.md §5.

```yaml
workflow_name: "[Name]"
trigger: "[What event starts this workflow?]"
cadence: "[Real-time / Daily / Weekly / Monthly / Event-triggered]"

steps:
  - step: 1
    name: "[Step name]"
    tool: "[Tool from verified inventory: firecrawl_search, firecrawl_scrape, firecrawl_map, firecrawl_interact, dataforseo_serp, dataforseo_keywords, dataforseo_labs, dataforseo_domain_analytics, openregistry_mcp, reddit_research_mcp, context7_mcp, gdelt_api, eurostat_api, oecd_api, public_ats_api, financial_hub_mcp, manual]"
    action: "[What does the tool do? Specific: 'POST Firecrawl /search with query X and limit 10', 'GET DataForSEO Keywords API with batch of 50 keywords', 'Query Context7 MCP for endpoint /v3/companies/search']"
    input: "[What data does this step need? Reference specific data schemas from DATA-OPERATIONS-ARCHITECTURE.md §5]"
    output: "[What does this step produce? Reference specific file paths: N-XXX/02-competitor-intel/...]"
    human_review: "[YES/NO — if YES, what exactly does the human check?]"
    cost: "[Estimated cost: Firecrawl credits or DataForSEO $]"
    timeout_seconds: 60  # Per DATA-OPERATIONS-ARCHITECTURE.md §2.4 Global Timeout Policy

llm_role: "[What does the LLM decide/analyze? Be specific about boundaries of LLM vs rule-based.]"

error_handling: "[What happens when a step fails? Timeout, retry with exponential backoff (1s/2s/4s/8s + jitter per §8.3), fallback per §2.2 decision tree, mark SOURCE_UNAVAILABLE?]"

output_delivery: "[Where does the final output go? Niche canvas section, structured data file, shared registry?]"

dependency: "[What must exist before this workflow can run? Phase 0 calibration passed? Specific niche sections completed? Shared registry populated?]"
```

### 5.4 LLM/Agent Role Specification

When describing the LLM role in any workflow, specify ALL of:

1. **What the LLM analyzes** — the exact input data (not "the signals" but "the last 30 days of pipeline data from the CRM, filtered by stage and probability")
2. **What criteria the LLM applies** — the rules/judgment it uses (not "finds issues" but "flags deals that have been in stage >30 days without activity, scored by deal size × probability × days-aging")
3. **What format the LLM produces** — structured schema (not "a report" but "a JSON object with fields: deal_id, risk_score (0-100), reason (string), recommended_action (string)")
4. **What the LLM does NOT do** — explicit boundaries (not "LLM validates all outputs" but "LLM produces candidates; human must approve before sending to client")
5. **Confidence threshold** — at what confidence does the LLM act vs. escalate? ("If confidence <70%, flag for human review instead of delivering automatically")

**Agent Non-Determinism Assumption (BINDING):** Claude Code agents are non-deterministic components. The same prompt can produce different outputs on different runs. Every quality control mechanism MUST include either: (a) an independent observer that can verify the agent's output without relying on the agent's own computation (e.g., a separate agent re-fetching 10% of source URLs and comparing content hashes independently — see DATA-OPERATIONS-ARCHITECTURE.md audit recommendation Change #11), or (b) a mathematical invariant that the agent cannot plausibly fake (e.g., git history of trace-maps, checksums computed by a separate process). **The agent does NOT self-grade evidence.** The deterministic evidence grade engine (DATA-OPERATIONS-ARCHITECTURE.md §6.2) assigns grades mechanically from four binary criteria. Agent self-assigned grades are invalid and must be recomputed by the engine.

**Self-audit limitation:** The same agent executing the pipeline should NOT be the sole quality auditor of its own output. Every 5th niche (Mechanism 4, §6.3) must be audited by a FRESH agent with no shared context. Calibration protocol (§6.3, Mechanism 6) requires DUAL independent evaluation of the calibration niche before any niche evaluations begin.

---

## 6. PART 5: CROSS-NICHE COMPARABILITY

### 6.1 Standardized Scoring Rubric

Every niche canvas must produce these 4 scores for cross-niche comparison:

#### Score 1: Structural Attractiveness (1-10)
Based on: market size, growth rate, competitive intensity, aggregator density, budget availability, decision velocity
- 8-10: Large, growing, fragmented competition, many aggregators, budget exists, fast decisions
- 5-7: Medium market, stable, moderate competition, some aggregators, budget exists but not dedicated
- 3-4: Small market, mature, dominated by few competitors, few aggregators, no dedicated budget
- 1-2: Tiny market, declining, consolidated competition, no aggregators, must create budget

#### Score 2: Warm Access (1-10)
Based on: founder connections to buyers, aggregators, and partners in this niche
- 8-10: Founders have personal connections to 5+ potential buyers and 3+ aggregators
- 5-7: Founders have warmable connections to some buyers; aggregators are reachable
- 3-4: Founders have cold access only; niche requires cold outreach
- 1-2: Founders have zero connection to this niche; building relationships from scratch

#### Score 3: Commercial Viability (1-10)
Based on: RIOS score (from section 14), EUR 500K gate math, funnel economics
- 8-10: RIOS > 4.0, EUR 500K path clear at conservative conversion, pricing within bands
- 5-7: RIOS 3.0-4.0, EUR 500K path achievable at realistic conversion, pricing acceptable
- 3-4: RIOS 2.0-3.0, EUR 500K path requires optimistic conversion, pricing under pressure
- 1-2: RIOS < 2.0, EUR 500K path infeasible or unproven, pricing too low

#### Score 4: Build Feasibility (1-10)
Based on: workflow spec achievability, integration complexity, automation potential, data availability
- 8-10: All workflows buildable with existing tools, one system integration, high automation
- 5-7: Most workflows buildable, moderate integration work, mostly automatable
- 3-4: Some workflows require new capability, complex integration, significant human-in-loop
- 1-2: Core workflows unbuildable with current technology, requires new platform development

#### Composite Score
**Niche Priority Score = Structural Attractiveness × 0.3 + Warm Access × 0.25 + Commercial Viability × 0.35 + Build Feasibility × 0.1**

Weighting rationale (validated 2026-07-23): Commercial viability is heaviest (it's about revenue). Warm access gets 0.25 because direct-first GTM depends on founder network reach — a commercially perfect niche that Bob cannot access is worthless. Build feasibility is lightest because ClarityRev can build if the opportunity is strong; build difficulty should not veto a good market. Structural attractiveness (0.3) balances market pull against founder access.

**Weight validation:** These weights produce sensible rankings for the expected niche distribution (2-3 LAUNCH_PENDING, 8-12 DEEP, remainder STANDARD). The calibration niche will provide the first empirical test — if the composite score disagrees with founder intuition on ≥3 of the first 10 niches, weights should be re-examined. Weights may be adjusted post-calibration; any adjustment must be pre-registered in `_program/LEDGER.yaml` before being applied to scored niches.

**Normalization caveat:** Raw scores from different agents are normalized through the calibration protocol (§6.3, Mechanism 6). Composite scores reported in cross-niche comparisons use NORMALIZED scores, not raw scores. Both are recorded in the canvas frontmatter.

### 6.2 Common Data Format

Every canvas must expose a machine-readable summary at the document head. This format aligns with DATA-OPERATIONS-ARCHITECTURE.md §5 (Data Schemas) and §3.1 (Directory Structure). The YAML frontmatter is the canonical input for the `_program/LEDGER.yaml` aggregation.

```yaml
---
# NICHE-METHODOLOGY.md §6.2 — Canonical YAML Frontmatter
# Aligned with DATA-OPERATIONS-ARCHITECTURE.md schemas
niche_id: "N-001"                             # From directory structure: N-XXX
niche_name: "Mid-Market B2B SaaS Revenue Operations"
date: "2026-07-23"                            # ISO 8601
agent: "claude-opus-4-8"                      # Model used for canvas authoring
pipeline_depth: "DEEP"                        # STANDARD | DEEP | FORENSIC
verdict: "LAUNCH_PENDING"                     # LAUNCH_PENDING | VALIDATE_FIRST | CONDITIONAL | NO_GO

# Composite scoring
composite_score: 0.0                          # Normalized composite (post-calibration)
composite_score_raw: 0.0                      # Raw composite (pre-normalization)
calibration_applied: false                    # True if normalization from calibration protocol applied
scores:
  structural_attractiveness: 0
  warm_access: 0
  commercial_viability: 0
  build_feasibility: 0

# Evidence quality
evidence_quality: 0.0                         # Percentage of claims at [E] or higher
evidence_distribution:                        # Count of claims by grade
  grade_P: 0
  grade_E: 0
  grade_H: 0
  grade_S: 0
freshness_score: 0.0                          # Percentage of sources within SLA (from freshness audit §6.4)

# Key metrics
key_metrics:
  market_size_companies: 0
  market_size_revenue_eur: 0
  avg_acv_eur: 0
  target_monthly_price_eur: 0
  breakeven_clients: 0

# Credit consumption (from CREDIT_BUDGET.yaml)
credit_consumed:
  firecrawl: 0
  dataforseo_usd: 0.0

# Quality flags
open_questions: 0
freshness_violations: 0                       # Count of sources outside SLA at finalization
schema_violations: 0                          # Count of schema validation failures
high_uncertainty: false                       # True if >50% claims are [H] or [S]
---
```

This enables automated comparison across all 25 canvases. The `_program/LEDGER.yaml` aggregates frontmatter from all niches for portfolio-level analysis. Frontmatter is validated against the schema at `niche-program/schemas/frontmatter-schema.yaml` (to be created per DATA-OPERATIONS-ARCHITECTURE.md audit recommendation Change #13).

### 6.3 Preventing Methodology Drift

As agents work through 25 niches, methodology quality can degrade. Prevent drift with these mechanisms:

**Mechanism 1: Template Locking**
Every canvas MUST start by copying the template from Appendix A. No field can be removed, renamed, or reordered. If a field genuinely doesn't apply to a niche, write "N/A — [reason]" rather than skipping it.

**Mechanism 2: Evidence Grade Audit**
Before submission, the agent must count `[P]`, `[E]`, `[H]`, `[S]` claims. If >50% are `[H]` or `[S]`, the canvas must be flagged as HIGH-UNCERTAINTY and scored at half weight in comparisons.

**Mechanism 3: Contradiction Check**
Cross-reference dependent sections:
- Section 3 pain must match Section 6 triggers (if the pain is churn, triggers should include churn events)
- Section 8 free snapshot must logically lead to Section 9 paid entry
- Section 7 lifecycle must match Sections 8-10 offers
- Section 14 RIOS scores must be consistent with Section 3-5 assessments

**Mechanism 4: Sample-Based Quality Control**
Every 5th canvas (5, 10, 15, 20, 25) should be audited by a fresh agent using the adversarial checklist in Part 3. This catches drift that the original agent may not notice.

**Mechanism 5: The "McKinsey Partner" Test**
Before finalizing, the agent should ask: "Would I feel comfortable presenting this canvas to a McKinsey partner who knows this niche?" If the answer is no, identify the weakest section and strengthen it.

**Mechanism 6: Calibration Protocol (MANDATORY — BINDING)**

**Purpose:** 25 independent agents following the same methodology WILL produce incomparable outputs without calibration. Agent A's "Score 4" is not Agent B's "Score 4." This protocol establishes inter-rater reliability before any niche evaluations begin.

**Step 1 — Select Calibration Niche:**
A common "calibration niche" is selected before any niche evaluations begin. Requirements: well-understood, moderate complexity, accessible data, not one of the 25 evaluation niches. Recommended: "Mid-Market IT Staffing Agencies on Bullhorn" (uses existing Gapstars research, accessible CRM, well-understood buyer).

**Step 2 — Dual Independent Evaluation:**
Two independent agents each produce a complete 15-section canvas for the calibration niche. Agents work simultaneously, with no communication, using the same methodology version. Both canvases are submitted to the methodology owner for comparison.

**Step 3 — Inter-Rater Reliability Check:**
Compare the two calibration canvases on these dimensions:

| Dimension | Maximum Acceptable Delta | Action If Exceeded |
|---|---|---|
| RIOS composite score | ±0.5 points | Methodology ambiguity in scoring — clarify scoring anchors in §14 Part B |
| Niche verdict | Must match exactly | Verdict criteria ambiguous — tighten §14 Part D definitions |
| Evidence grade distribution (% `[P]`/`[E]`/`[H]`/`[S]`) | ±10 percentage points per grade | Grading standards inconsistent — add more `[P]`/`[E]`/`[H]`/`[S]` examples to Appendix B |
| Number of open questions (§15) | ±3 questions | Research depth expectations inconsistent — add per-section research depth examples |
| §14 Part B dimension scores (per dimension) | ±1.0 points | Score calibration needed — agents review each other's justifications, reconcile |
| Pain quantification (§3.2 EUR/year) | Within same order of magnitude | Market sizing methodology inconsistent — strengthen §3.3 formula requirements |

**Step 4 — Calibration Resolution:**
If any dimension exceeds the maximum acceptable delta:
1. Both agents review each other's canvases (blind to scores).
2. Agents identify the specific methodology sections where interpretation diverged.
3. Methodology is amended to clarify ambiguous sections.
4. Re-run calibration evaluation with amended methodology.
5. Repeat until all deltas are within acceptable range.

**Step 5 — Score Normalization:**
Once calibration passes, each agent's calibration scores establish their "grading tendency." Subsequent niche scores are normalized:
- If Agent A scored calibration niche RIOS at 3.2 and Agent B scored it at 3.8, Agent A grades ~0.6 points stricter than Agent B.
- Agent A's subsequent niche scores are adjusted upward by 0.3, Agent B's downward by 0.3, to center both on the calibration mean.
- Normalization is applied transparently; raw scores and adjusted scores are both recorded in the canvas YAML frontmatter.

**Step 6 — Ongoing Calibration:**
- Every 5th canvas includes a mini-calibration: the agent re-scores the calibration niche (abbreviated — §14 Part B only) to detect drift.
- If an agent's calibration re-score drifts by >0.5 from their original, their recent canvases are flagged for review.
- After all 25 niches are complete, one randomly selected niche is re-evaluated by a different agent as a final inter-rater reliability check.

**Calibration completion gate:** No niche evaluation begins until the calibration protocol is completed and all deltas are within acceptable range. This gate is BINDING. `[DESIGN]`.

**Mechanism 7: Independent Verification Sampling (MANDATORY — BINDING)**

**Purpose:** Agents are non-deterministic. The same agent that fetches data, structures it, hashes it, grades it, and maps it to claims cannot be the sole quality auditor of its own work. A hallucinating agent can fabricate competitors, pricing tiers, review quotes, and signal sources, and the evidence grade engine will rate them `[P]` as long as plausible-looking URLs are provided alongside the hallucination.

**Procedure:**
1. After canvas finalization, a separate (non-context-sharing) agent receives ONLY the `evidence/trace-map.yaml` from the completed canvas.
2. The verifier agent randomly selects 10% of source URLs from the trace-map (minimum 5 URLs, maximum 20).
3. The verifier independently re-fetches each URL, computes content hashes, and compares against trace-map entries.
4. If >20% of re-checked hashes mismatch the trace-map, the ENTIRE canvas is flagged for human review.
5. The verifier agent has its own credit budget (10% of the niche's consumed credits) and does NOT share any agent context with the original niche agent — only the URL list.

**Verifier scheduling:** Every 5th canvas (5, 10, 15, 20, 25) receives the full independent verification procedure. Additionally, any canvas with evidence_quality <50% (more than half claims at `[H]` or `[S]`) receives verification regardless of position in the sequence.

**This is the single highest-ROI fix for evidence integrity in the 25-niche program.** It catches hallucination-driven corruption that no self-audit can detect.

**Mechanism 8: Concurrent Execution Guard**

**Purpose:** 25 independent agents running in parallel (max 4 concurrent per DATA-OPERATIONS-ARCHITECTURE.md §1.2) introduce concurrency-specific drift risks not covered by Mechanisms 1-7.

**Guards:**
1. **Shared registry race conditions:** All writes to `SHARED/_REGISTRY.yaml`, `_pipelines/dedup-manifest.yaml`, and `DEAD_HOST_REGISTRY.yaml` use file-level advisory locking (flock). If lock acquisition fails >5s, retry with backoff; if >30s, halt and alert. Per DATA-OPERATIONS-ARCHITECTURE.md audit recommendation Changes #7/#28.
2. **Credit budget consistency:** `_program/CREDIT_BUDGET.yaml` is read at each pre-spend gate (§4.5). Only ONE agent updates it at a time (write lock). All other agents read-only during a write.
3. **Template version synchronization:** All agents use the SAME methodology version (this document's git commit hash). The version is recorded in each canvas frontmatter. If an agent detects a methodology change mid-evaluation (git pull during pipeline execution), it completes the current niche under the OLD version and logs the version delta.
4. **Staggered Phase 2 entry:** To prevent 4 concurrent niches from exceeding Firecrawl's 50-concurrent request limit, Phase 2 start times are staggered by 30-90 seconds of random jitter per niche. Per DATA-OPERATIONS-ARCHITECTURE.md §4.6.

**Parallel execution validation (2026-07-23):** Mechanisms 1-8 have been reviewed against 25-agent parallel execution. The calibration protocol (Mechanism 6) handles inter-rater differences. The concurrent execution guard (Mechanism 8) handles race conditions. The independent verification (Mechanism 7) handles agent non-determinism. Remaining risk: Phase 0 is one-time — tools, sessions, and API versions may change between niche 1 and niche 25. Mitigation: Phase 0 delta check every 10 niches (DATA-OPERATIONS-ARCHITECTURE.md audit recommendation Change #25).

---

## APPENDIX A: CANVAS TEMPLATE (copiable)

```markdown
---
niche_name: ""
date: ""
agent: ""
verdict: ""
composite_score: 0.0
scores:
  structural_attractiveness: 0
  warm_access: 0
  commercial_viability: 0
  build_feasibility: 0
evidence_quality: 0.0
key_metrics:
  market_size_companies: 0
  market_size_revenue_eur: 0
  avg_acv_eur: 0
  target_monthly_price_eur: 0
  breakeven_clients: 0
open_questions: 0
---

# Niche Canvas: [Niche Name]

## Section 1: Niche Identity & Definition
...

## Section 2: Buyer & Committee Mapping
...

## Section 3: Pain & Economics
...

## Section 4: Competitive Landscape
...

## Section 5: Ecosystem & Distribution
...

## §6.0: Unified Signal Architecture
...

## §6A: Sales Trigger Map (Bob's Outreach Timing)
...

## §6B: Client Signal Catalog (Engine Monitoring for Clients)
...

## §6.8: Signal Strategy Pre-Mortem & Assumption Audit
...

## Section 7: Customer Journey & Offer Architecture
- §7.1: Lifecycle Stages (with MECE verification, evidence grades, JTBD, TTV, stage-gate criteria, champion advocacy, founder time)
- §7.1a: Competitive Journey Comparison (Strategy Canvas)
- §7.2: The Diagnose Stage (with hinge assumption stress test at 3 output levels)
- §7.2a: Pricing Ladder Architecture (value-to-price ratios, competitor anchoring, max step-up rule)
- §7.3: Customer Journey Map (conversion model w/ rates + compound probability, non-linear paths, Bowtie Funnel overlay, referral mechanics)
- §7.4: Offer Economics Summary (per-stage revenue/cost/margin, cost decomposition at 5/20/100 clients, founder capacity allocation)
- §7.5: Journey Pre-Mortem & Assumption Audit (pre-mortem, hinge stress test, kill metrics, minimum viable journey, scenario planning)
- §7.6: Journey Technical Specification (data contracts, instrumentation, automation feasibility, FMEA)

## Section 8: Free Entry Services (Attract + Diagnose)
- §8 preamble: Free layer strategic job statement (attract volume / pre-qualify / educate / demonstrate superiority)
- §8.1: Competitor Free Layer Audit (≥3 competitors, source-verified, Match/Differentiate/Skip with strategic intent)
- §8.1a: Competitive Free-Layer Strategy Canvas
- §8.2: Free Service Design (≥3 services across ≥2 tiers; ~25 fields per service incl. Bob's Usage, objection handling, MEDDIC mapping, conversion model, build spec)
- §8.3: Free Layer Distribution (per service: channel, SEO, aggregator-native, cost, experiment design)
- §8.4: Free-to-Paid Conversion Design (per-tier post-completion sequence + nurture)
- §8.5: Free Layer Pre-Mortem & Economics (pre-mortem, free anchoring risk, breakeven analysis, competitor exploitation)
- §8.6: Free Layer Technical Operations (health monitoring, multi-tenant scaling, data retention, versioning)

## Section 9: Paid Entry Services (Prove)
- §9 preamble: Paid portfolio architecture statement (ladder/menu/sequence)
- §9.1: Competitor Paid Service Audit (≥3 competitors, source-verified, Match/Differentiate/Skip with strategic intent)
- §9.1a: Competitive Paid-Layer Strategy Canvas
- §9.2: Paid Service Portfolio (≥3 services w/ portfolio economics; ~30 fields per service incl. Bob's Usage, objection handling, MEDDIC, conversion model, build spec, guarantee exposure)
- §9.3: Service Type Patterns (8 types + Other, with margin profile + founder time per delivery)
- §9.4: Pricing Justification (strategic position, competitor anchoring, ROI, purchase authority, displacement)
- §9.5: Paid Service Pre-Mortem & Risk (pre-mortem, guarantee exposure model, minimum viable portfolio, competitor undercutting)
- §9.6: Paid Service Technical Operations (health monitoring, versioning)

## Section 10: Core Recurring Services (Commit + Expand)
- §10 preamble: Recurring portfolio strategy (single core / core+modules / platform)
- §10.1: Competitor Recurring Audit (≥3 competitors, source-verified, Match/Differentiate/Skip with strategic intent)
- §10.1a: Competitive Recurring Strategy Canvas
- §10.2: Core Recurring Service Design (~30 fields incl. LTV, conversion model, Bob's Usage, objection handling, onboarding, churn prevention)
- §10.3: Expansion Architecture (≥2 paths, specific triggers from §6B.4, conversion math, pricing)
- §10.4: Moat Connection (quantified trajectory at 5/20/50/100 clients)
- §10.5: Land-and-Expand Revenue Trajectory (24-month milestones + step-up triggers)
- §10.6: Service Tiering Driver (objective boundaries + competitor anchoring)
- §10.7: Value Delivery Cadence (6 timeline checkpoints + client monthly experience)
- §10.8: Onboarding-to-Recurring Conversion + Client Provisioning Automation
- §10.9: Competitive Retention Defense (switching cost math)
- §10.10: "Why Cancel?" Pre-Mortem (3 reasons + early warnings + churn benchmarks)
- §10.11: Recurring Pre-Mortem & Churn Stress Test (pre-mortem, 4 churn scenarios, minimum viable recurring)
- §10.12: Recurring Technical Operations (delivery automation, multi-tenant isolation, health monitoring)

## Section 11: Automated Workflow Specifications
- §11 preamble: Evidence grading standard + 4 design principles
- §11.1: First-Principles Workflow Design (7 steps incl. build-vs-buy rationale, alternative tool comparison, sales enablement)
- §11.2: Workflow Specification Format (26 fields per workflow incl. testing, rollback, demo-ability, SLA)
- §11.3: LLM Interface Design
- §11.4: Workflow Architecture Diagram
- §11.5: Core vs. Niche-Specific Classification
- §11.6: Workflow Dependency Graph
- §11.7: Workflow → Revenue Mapping
- §11.8: Client-Facing vs. Internal Flag
- §11.9: Output Quality Criteria
- §11.10: Data Freshness SLA
- §11.11: Workflow Composability
- §11.12: Multi-Tenant Architecture
- §11.13: Monitoring and Alerting
- §11.14: Workflow Failure Modes (FMEA table)
- §11.15: Workflow Pre-Mortem & Tool/API Risk (pre-mortem, dependency risk matrix, LLM drift monitoring, cost spiral)
- §11.16: Workflow Testing & Validation (5 test types, dry-run protocol)
- §11.17: Workflow Performance & Optimization (benchmarks, optimization triggers, documentation standards)

## Section 12: Evidence Stack & Proof Architecture
- §12.1: Zero-Client Honesty Statement (evidence-graded assets + "no references" assumption stress test)
- §12.2: Evidence-to-Buyer Mapping (MEDDIC-aligned, grades per cell + evidence gap priority matrix)
- §12.3: Competitor Evidence Comparison (named competitors + 24-month trajectory)
- §12.4: The Diagnostic Moment + Bob's Evidence Playbook (6 conversation stages, verbatim)
- §12.5: Proof-on-Their-Data (formula + output format)
- §12.6: Segment Benchmarks (existing + ClarityRev-built + systematic counter-evidence table)
- §12.7: Reference-Building Plan (monthly milestones + reference call protocol)
- §12.8: Methodology Validation (anchored, transparent, founder credibility)
- §12.9: Guarantee Design (mechanism, underwriter, attribution, exposure, honest negative)
- §12.10: Case Study Plan (structure, min viable, ideal, formats)
- §12.11: Security/Privacy Specification (structured, 9 fields with grades)
- §12.12: Evidence Freshness & Automation (pipeline per asset type)
- §12.13: Evidence Pre-Mortem & Risk (pre-mortem, competitor weaponization, confidence calibration)

## Section 13: GTM & Sales Motion
- Preamble: Founder GTM capacity (binding) + Bob time-budget (hours/week) + Bob pipeline capacity model
- §13.1: Channel Investment Allocation (per-channel ROI, experiment designs, commission rep script)
- §13.2: Full Funnel Model (ranges, benchmark sources, confidence calibration, 50% stress test)
- §13.3: Outreach Message Architecture (≥4 channel-persona combinations, all verbatim)
- §13.4: Objection Handling Playbook (top 5, verbatim responses, evidence citations, walk-away signals)
- §13.5: Sales Qualification Criteria (MEDDIC, qualified/disqualified, checklist)
- §13.6: GTM Tool Stack & Handoff (tools with build effort, GTM-to-delivery handoff, automation)
- §13.7: GTM Kill Switches & Early Warnings (channel kills, niche kills, founder resilience, competitive response timeline)
- §13.8: Nurture Sequence (6 touches, Day 1-60)
- §13.9: GTM Pre-Mortem & First-90-Days Plan (pre-mortem, week-by-week calendar, content/SEO roadmap)

## Section 14: RIOS Score & Diagnosis
- §14 preamble: Score calibration anchors (1-5 criteria), evidence grade inheritance rules, score inflation detection
- Part A: Gate Check (4 gates, evidence grades, explicit EUR 500K math template)
- Part B: RIOS Value Equation Score (8 dimensions, calibration, cross-references, grade inheritance, formula)
- Part C: Lowest-Term Diagnosis (lowest score, specific fix with owner + timeline, fix confidence)
- Part D: Overall Niche Verdict (4 verdicts, verdict confidence grade)
- Part E: Sensitivity Analysis (dimension swing impact on verdict)
- Part F: Competitive RIOS Comparison (optional, #1 competitor scored)
- Part G: RIOS Score Trajectory (today → M6 → M12 projection)
- Part H: Score Reconciliation Note (required if 5s or no ≤2s)

## Section 15: Open Questions & Validation Plan
- §15.1: Consolidated Evidence Grade Inventory (counts, health check, load-bearing [S] claims)
- §15.2: Top 5 Open Questions (decision-impact/cost ratio, owners, costs, priorities)
- §15.3: Most Dangerous Unknown (stated + pre-mortem + early warning indicators)
- §15.4: Validation Experiment Design (falsifiable hypothesis, method, criteria, sample, cost, decision)
- §15.5: Validation Timeline (monthly activities, owners, hours, month-end decisions)
- §15.6: Decision Triggers (upgrade, downgrade, kill, revisit, canvas refresh)
- §15.7: Decision-Tree for Verdict Changes
- §15.8: Required Signal Validation Entries (from §6.5)

---

## Agent Notes
- Evidence grade distribution: [P]: N, [E]: N, [H]: N, [S]: N
- Methodology deviations: [List any, or "None"]
- Confidence notes: [What would the agent want to verify first if given more time?]
```

---

## APPENDIX B: EVIDENCE GRADING REFERENCE

| Grade | Definition | What It Looks Like | How to Cite |
|---|---|---|---|
| **PROVEN [P]** | Multiple independent verifiable sources; quantitative data with known methodology; industry-standard metrics | "Gartner's 2025 Market Guide reports EUR X (methodology: survey of N=500, margin of error ±Y%). Confirmed by Forrester's 2025 Wave." | Source name, methodology note, publication date |
| **EVIDENCED [E]** | Single credible source OR multiple partial sources pointing same direction; plausible | "G2 reviews for [Competitor] consistently cite [pain] as the primary purchasing reason (12 of 20 reviews analyzed)." | Source name, sample size, date |
| **HYPOTHESIS [H]** | Logical inference from analogous markets; reasoned extrapolation; no direct data | "Based on analogous niche [X], where [Y] pattern is observed, we estimate similar dynamics apply here. Differentiators: [list]." | Analogy source, logic chain, key differences flagged |
| **SPECULATIVE [S]** | Best guess; no supporting data; analogy from very different context | "We estimate market size might be EUR [number] based on general industry growth rates, but no niche-specific data was found." | "No sources found — this is an estimate" |

**Grade degradation rule:** If you cite a secondary source that itself uses `[H]` claims, the claim degrades one grade in your canvas. E.g., a blog post that says "we estimate the market is EUR 1B" is at best `[H]` in your canvas, even though the blog post stated it definitively.

---

## APPENDIX C: COMMON FAILURE MODES CHEAT SHEET

| Section | #1 Failure Mode | #2 Failure Mode | Antidote |
|---|---|---|---|
| 1 | Scope creep (boundaries too broad) | False precision in market sizing | MECE IN/OUT list; triangulate from 3 sources |
| 2 | Generic buyer personas | Ignoring technical evaluator | Name specific KPIs per role; map security review process |
| 3 | Overstating pain (worst case = typical) | Ignoring current spending | Always give median + range; research what they already buy |
| 4 | Overlooking DIY/spreadsheet | Straw-man competitors | Analyze why they'd leave spreadsheets; honest competitor assessment |
| 5 | Aggregator wishful thinking | Ignoring cold reality | Verify warm access; model aggregator incentive explicitly |
| 6A | Confusing ClarityRev signals with buyer triggers | Signal infeasibility | Validate trigger = buyer's felt problem; verify detection tools exist (§6A.0 ACH) |
| 6A | Designing for average trigger volume, breaking on variance | Bob capacity overload | Model Bob's capacity constraint (§6A.3); specify triage tiebreakers when >3 Tier-1 triggers fire simultaneously |
| 6A | Presenting speculative signal-to-revenue numbers as analysis | False precision, eroded trust | Move signal-to-revenue chain to §15 as validation hypotheses; flag all numbers as `[S]` |
| 6B | Building an engineering spec with no sales asset | Demo falls flat, prospect doesn't "get it" | §6B.7 Demo Narrative — the signal catalog IS the demo; Bob walks through 3-5 signals in sequence |
| 6B | Assuming signal detection = signal value | Client ignores signals, churns | §6.8 Three-Link Chain — Detect → Act → Recover; adoption defenses in §6.8.6 |
| 6B | Never calibrating signal predictiveness | Uncalibrated signals erode trust | §6B.8 Signal Confidence Calibration; zero-client honesty protocol; cap LOW-confidence signals at Tier 3 |
| 6B | No signal health monitoring | Broken pipeline goes undetected for weeks | §6B.10 Signal Health Monitoring; per-signal metrics + founder alert routing |
| 6 | No unified signal architecture between §6A and §6B | Two independent systems contradict | §6.0 Unified Signal Preamble + Data Contract; all signals conform to one schema |
| 6 | Unstated competitor exploitation risk | Competitor copies signal strategy in 3 months | §6.8.3 Competitor Exploitation Assessment; identify defenses (compounding calibration, niche specificity, CRM-native delivery) |
| 7 | Copy-paste generic lifecycle | Skipping Diagnose/the hinge | Every stage must be niche-specific (§7.1 JTBD, stage-gate criteria, champion advocacy). Diagnose hinge assumption must be stress-tested at 3 output levels. |
| 7 | No conversion math | Journey is a story, not a model | §7.3 conversion rates (low-expected-high) per transition with compound probability calculation. At zero clients, flag `[S]`. |
| 7 | Linear-only journey design | Buyers stall/loop/skip with no designed response | §7.3.2 non-linear paths: nurture loop, skip path, resurrection path, churn path, non-converter path — minimum 5 |
| 7 | Unsurfaced hinge assumption | Entire journey built on untested "Snapshot creates urgency" premise | §7.2 hinge assumption with 3-output-level stress test + confidence grade. If LOW confidence, flag niche in §14. |
| 7 | No founder capacity integration | Journey assumes infinite Bob | §7.4 founder capacity allocation per stage with ceilings + overflow procedures. Bob = 40 hrs/week (binding). |
| 7 | No data flow between stages | Wesley can't build stage transitions | §7.6.1 stage transition data contracts: data passed, format, mechanism, error handling per transition |
| 7 | No journey instrumentation | Can't track where buyers are | §7.6.2 CRM fields, entry/exit triggers, stall alerts, notification routing per stage |
| 7 | No kill metrics | Journey runs indefinitely without evaluation | §7.5.3 per-transition kill metrics with thresholds and escalation actions |
| 7 | Designing 6 stages at zero clients | Cathedral when you need a door | §7.5.4 minimum viable journey: build only Diagnose→Prove first. Prove the hinge. Then stages 3-6. |
| 8 | Free layer designed in isolation | Overbuilding free layer | Connect every free service to a specific paid service (§9) via conversion hook. Free layer must have a stated strategic job (§8 preamble). |
| 8 | No free service tiering | All free services have same friction → wrong buyers enter | §8.2 tiering: Tier 1 (zero-friction), Tier 2 (low-friction), Tier 3 (data-connected). Minimum one per tier. |
| 8 | Free anchoring risk unaddressed | Buyers resist paying after receiving value for free | §8.5.2 free anchoring risk assessment with 4 mitigations. "Diagnosis is free. Recovery is guaranteed." |
| 8 | No free layer economics | Free layer is a cost center with no breakeven target | §8.5.3 breakeven analysis: cost per tier, conversion rate needed, kill switch at 50% of breakeven for 6 months |
| 8 | Free services have no sales usage guide | Bob doesn't know how to use them in conversation | §8.2 Bob's Usage (verbatim) + top 2 objections per free service |
| 8 | No build spec for free services | Wesley can't estimate build effort | §8.2 build spec: tools/APIs, build effort (S/M/L/XL), dependencies, cost per run |
| 8 | Free-tier data handled same as paid | Prospect data retained indefinitely without conversion | §8.6.3 free-tier data retention: 90 days max, auto-delete, no benchmark use without opt-in |
| 9 | Prove offer too heavy | Missing conversion path | Price under champion's authority (§2.3); map free→paid→recurring conversion paths with explicit rates |
| 9 | No guarantee exposure model | Guarantee invoked more than affordable | §9.5.2 guarantee financial exposure: max monthly + annualized exposure. Cash buffer required. |
| 9 | First "yes" psychologically too hard | Buyers hesitate at the first paid transaction | §9.2 purchase psychology: what makes this the easiest possible first "yes"? Price below solo approval threshold? |
| 9 | No paid service build spec | Wesley can't estimate build effort | §9.2 build spec: workflows (§11), tools/APIs, effort (S/M/L/XL), dependencies, cost per delivery |
| 9 | Building 3 paid services at zero clients | Cathedral when you need a door | §9.5.3 minimum viable paid portfolio: build ONE first (the hinge paid service). Validate with 10 deliveries. Then build second. |
| 9 | Competitor undercuts pricing, no defense | Lost deals to cheaper competitor | §9.5.4 competitor undercutting scenario: guarantee is the differentiator. "They charge 50% less. We guarantee 3× ROI or free." |
| 9 | No Bob's Usage per paid service | Rep can't present the offer on a call | §9.2 Bob's Usage (verbatim) + top 3 objection responses (verbatim) per paid service |
| 10 | Pricing too far from existing behavior | Ignoring onboarding cost | Benchmark against current spend (§3.6); calculate onboarding COGS (§10.2) |
| 10 | Recurring = "same thing but monthly" | Client sees no NEW value each month | §10.7 value delivery cadence: every interval delivers something the client didn't have before. §10.2 strategic rationale: why THIS niche needs ongoing intelligence. |
| 10 | Churn unmodeled | Churn kills the business silently | §10.11.2 churn stress test at 4 scenarios. Churn kill switch at 3%/month for 3 consecutive months. |
| 10 | No LTV model | Can't assess if recurring is viable | §10.2 LTV model: avg monthly revenue × expected lifetime. LTV/CAC ratio target >3×. |
| 10 | Building recurring before validating one-time | Cathedral when you need a door | §10.11.3 minimum viable recurring: validate Sprint first. 10 paid deliveries. >30% ask about ongoing → build recurring. |
| 10 | No switching cost math | Can't defend against competitor poaching | §10.9 "cheaper to stay" math: re-onboarding cost + lost benchmark data + CRM reintegration. Show net loss of switching. |
| 10 | Churn prevention is generic ("great service") | Doesn't prevent anything | §10.2 churn prevention: niche-specific. §10.10 early warning signals per cancellation reason. |
| 10 | No client provisioning automation | Onboarding is manual, slow, error-prone | §10.8.1 client provisioning: per-step automation, tools/APIs, human checkpoints, SLAs |
| 11 | Over-automation (no human judgment) | Under-specified LLM role | Add human checkpoints per §11.1 Step 6; specify LLM criteria and output format per §11.1 Step 4 |
| 11 | Tool choices from a template, not the niche | Workflow uses wrong tools, produces inferior output | §11.1 Step 3: build-vs-buy rationale + why this tool over the named alternative. Specific to THIS niche. |
| 11 | No sales enablement mapping | Workflow is infrastructure, not a product | §11.1 Step 7: every workflow enables a verbatim sales claim Bob can make |
| 11 | Critical API deprecated, no fallback | Workflow breaks silently | §11.15.2 tool/API dependency risk matrix: criticality 4-5 + HIGH deprecation risk → funded fallback required |
| 11 | LLM quality drifts undetected | Client receives degraded output for months | §11.15.3 LLM quality drift monitoring: 4 metrics + thresholds + automated alerts |
| 11 | Workflow costs spiral with scale | Workflows profitable at 10 clients lose money at 50 | §11.15.4 cost spiral scenario + §11.17.2 cost optimization triggers |
| 11 | No workflow testing before client delivery | First client is beta tester | §11.16 testing requirements: unit, integration, quality review, human baseline, client acceptance. Dry-run protocol. |
| 11 | No workflow rollback procedure | Bad deploy breaks client deliverables | §11.2 rollback/recovery: git-based rollback, version tagging, client communication |
| 12 | Guarantees ClarityRev can't deliver | Empty methodology claims | Underwrite guarantees with diagnostic data (§12.9); explain why method works (§12.8) |
| 12 | "No references" kills deals | Evidence strategy assumes empirical proof overcomes social proof gap | §12.1 "no references" assumption stress test: what if it doesn't? Mitigation + timeline to first reference. |
| 12 | Evidence stack is a list, not a playbook | Bob doesn't know WHEN to use WHICH evidence | §12.4 Bob's evidence playbook: 6 conversation stages, specific evidence asset per stage, verbatim what Bob says |
| 12 | Competitor weaponizes zero-client status | Lost deals to "safer" competitor | §12.13.2 competitor weaponization scenario: their attack, Bob's verbatim counter |
| 12 | Evidence gaps unprioritized | Team doesn't know which gap to close first | §12.2 evidence gap priority matrix: ranked by conversion impact with time-to-fill + mitigation per gap |
| 12 | No evidence trajectory | Can't show buyers that trust will grow over time | §12.3 competitive evidence trajectory: 24-month projection showing ClarityRev closing the gap while leading on empirical proof |
| 13 | Delusional funnel math | Ignoring CAC payback period | Use conservative conversion rates (0.5-3%) `[S]`; calculate payback in months. Stress-test at 50% of expected rates (§13.2). |
| 13 | Bob time-budget is percentages, not hours | Bob runs out of hours but plan says "70% allocation" | §13 Bob time-budget table: actual hours/week per channel. Pipeline capacity model: max 15-20 active deals. |
| 13 | No week-by-week execution plan | "What do I do this week?" unanswerable | §13.9.2 first-90-days calendar: Bob's focus by week with hour allocations, milestones, and kill switch checkpoints |
| 13 | GTM plan has no experiments — commits fully before testing | 500 cold outreaches burned with wrong message | §13.1 per-channel experiment design: 30-day test, success/fail thresholds, action on fail |
| 13 | Only one outreach message example | Messages that work for Champion fail for Economic Buyer | §13.3: ≥4 channel-persona combinations, all verbatim, using niche-specific buyer language from §2.6 |
| 13 | No competitive GTM response modeling | Competitor FUD campaign catches ClarityRev unprepared | §13.7 competitive response timeline: 4 phases, likely competitor action + ClarityRev counter per phase |
| 13 | Commission reps have no script | Reps improvise, brand consistency degrades | §13.1 commission rep onboarding script: verbatim. "You don't sell — the Snapshot sells." |
| 14 | Score inflation | Ignoring EUR 500K gate | Score calibration anchors (§14 Part B): explicit criteria for 1-5. Inflation detection: lowest score must be ≤2 or reconciliation note. >2 dimensions at 5 requires extraordinary evidence. |
| 14 | Scores untethered from evidence | RIOS score claims confidence the evidence doesn't support | Evidence grade inheritance (§14 Part B): each dimension's grade comes from source sections. Overall RIOS score inherits weakest grade. |
| 14 | No cross-reference traceability | Can't verify where scores came from | Mandatory cross-reference column: every score cites specific source sections (§3.3, §4, §12, etc.) |
| 14 | No sensitivity analysis | Don't know which dimension to fix first | §14 Part E: sensitivity analysis — which dimension swing changes the verdict? Highest-ROI validation target identified. |
| 14 | Verdict confidence unstated | LAUNCH PENDING on guesswork | §14 Part D: verdict confidence HIGH/MEDIUM/LOW. At zero clients, typically MEDIUM at best. |
| 15 | Pretending there are no unknowns | Unanswerable questions | Minimum 5 open questions (§15.2); focus on decision-critical ones. Evidence inventory (§15.1) forces honesty: count every `[S]` and `[H]`. |
| 15 | No validation ownership | Questions linger unresolved | §15.2: every question has named owner (Bob/Adriaan/Wesley) with hours. Validation timeline (§15.5) with monthly activities. |
| 15 | Most dangerous unknown not identified | Niche killed by surprise | §15.3: single most dangerous unknown stated + unknown pre-mortem + early warning indicators |
| 15 | Validation experiment not falsifiable | Can't prove ourselves wrong | §15.4: hypothesis must be falsifiable. Success AND fail criteria defined. Decision on both outcomes specified. |
| 15 | Canvas goes stale, no one notices | Build decisions made on outdated assumptions | §15.6 canvas refresh trigger: >90 days old + no validation progress → auto-downgrade verdict. §15.7 decision-tree enforces this. |

---

*End of NICHE-METHODOLOGY.md — This document is the binding specification for all 25 niche evaluations. No deviation without explicit logging in the canvas's methodology section.*

---

## APPENDIX D: BUILD DEPENDENCY GRAPH

**Purpose:** Provide a consolidated view of all dependencies between sections, workflows, and infrastructure components. Wesley uses this to determine build order. Without this, dependencies are scattered across narrative in 15 sections.

### D.1 Layer Dependency Diagram

```
LAYER 0 — INFRASTRUCTURE (Build First)
├── CRM/ATS Integration (§1.4) — OAuth, CSV fallback, API access
├── API Key Inventory — Clay, Firecrawl, Crunchbase, LinkedIn, etc.
├── Hosting & Database — Supabase, AWS Frankfurt
└── Monitoring Infrastructure — Health dashboards, alerting

LAYER 1 — DATA PIPELINES (Depends on Layer 0)
├── Signal Detection Engine (§6B) — consumes CRM API + external sources
├── Enrichment Pipeline (§11 — Clay, Clearbit, Apollo) — consumes API keys
├── Snapshot Engine (§7.2, §8.6) — consumes CRM + signal detection
└── Benchmark Infrastructure (§10.4, §12.6) — consumes Snapshot outputs

LAYER 2 — WORKFLOWS (Depends on Layer 1)
├── CORE Workflows (§11.5) — built once, shared across niches
│   ├── W_G2_Review_Scraper
│   ├── W_Competitor_Pricing_Monitor
│   ├── W_Clay_Enrichment_Pipeline
│   ├── W_LLM_Synthesis_Engine
│   └── W_RAG_Chat_Infrastructure
└── NICHE-SPECIFIC Workflows (§11.5) — built per niche
    ├── W_Niche_Signal_Detector — depends on §6B signal catalog
    ├── W_Niche_Snapshot_Engine — depends on Snapshot Engine + signals
    └── W_Niche_Digest_Generator — depends on signals + enrichment

LAYER 3 — COMMERCIAL SERVICES (Depends on Layer 2)
├── Free Services (§8) — powered by Snapshot Engine + workflows
├── Paid Services (§9) — powered by Sprint workflow + guarantee tracking
└── Recurring Services (§10) — powered by signal monitoring + digest workflows

LAYER 4 — CLIENT-FACING DELIVERY (Depends on Layer 3)
├── CRM-Native Delivery (§7.6.2) — Tasks, Notes, dashboard in client CRM
├── Email Digests (§10.7) — Weekly/monthly intelligence briefs
├── Client Dashboard (§10.12.2) — Per-client isolated view
└── QBR Materials (§10.7) — Quarterly business review generation

LAYER 5 — SALES & GTM TOOLING (Depends on Layer 3)
├── HubSpot Deal Pipeline (§13.6)
├── Sales Playbook Extract (§13.10)
├── Outreach Automation (§13.6)
└── Commission Rep Tooling (§13.1)
```

### D.2 Per-Section Dependency Matrix

| Section | Depends On | Feeds Into |
|---|---|---|
| §1 (Identity) | — (standalone research) | §2, §3, §4, §5, §7, §14 |
| §2 (Buyer) | §1 | §7, §8-10, §12, §13 |
| §3 (Pain) | §1, §2 | §6, §7, §8-10, §12, §14 |
| §4 (Competitors) | §1 | §7, §8-10, §12, §14 |
| §5 (Distribution) | §1, §2 | §7, §13 |
| §6.0 (Signal Architecture) | §1.4 | §6A, §6B, §11 |
| §6A (Sales Triggers) | §1, §2, §3, §6.0 | §6B, §13 |
| §6B (Client Signals) | §1.4, §3, §6.0, §6A | §7, §8-10, §11 |
| §6.8 (Signal Pre-Mortem) | §6A, §6B | §14, §15 |
| §7 (Journey) | §1.6, §2, §3, §6B | §8-10, §13 |
| §8 (Free Services) | §1.4, §2.6, §3, §4, §6B, §7 | §9, §11 |
| §9 (Paid Services) | §2.3, §3, §4, §6B, §7, §8 | §10, §11 |
| §10 (Recurring) | §1.6, §3, §4, §6B, §7, §9 | §11, §14 |
| §11 (Workflows) | §1.4, §1.7, §3, §6, §8-10 | Build queue |
| §12 (Evidence) | §2, §3, §4, §7, §8, §9 | §13, §14 |
| §13 (GTM) | §1, §2, §5, §6A, §7, §12 | Execution |
| §14 (RIOS Score) | All above | §15 |
| §15 (Validation) | All above | Portfolio decision |

### D.3 Build Sequence (Binding)

1. **Phase 0 — Infrastructure:** CRM integration, API keys, hosting, monitoring.
2. **Phase 1 — Core Workflows:** Build CORE workflows first (amortized across all niches).
3. **Phase 2 — Calibration Niche:** Build niche-specific workflows for the calibration niche only. Validate end-to-end.
4. **Phase 3 — First Launch Niche:** Build niche-specific workflows for the highest-ranked LAUNCH PENDING niche.
5. **Phase 4 — Scale:** Build niche-specific workflows for subsequent niches in priority order.

**Rule:** No niche-specific workflow is built until: (a) calibration niche validates the methodology, and (b) the target niche has LAUNCH PENDING verdict with HIGH/MEDIUM confidence.

### D.4 Firecrawl + Context7 Research Integration

**Firecrawl Capabilities for Niche Research:**

| Research Task | Firecrawl Tool | Best Practice |
|---|---|---|
| Competitor pricing extraction | `/scrape` with structured extraction | Use CSS selectors for pricing elements. Set `--wait-for` for JS-rendered pricing pages. Monitor pricing pages for changes. |
| G2/Capterra review corpus | `/crawl` on review category pages | Max depth 2, same domain. Extract: review text, rating, role, date. Target: ≥20 reviews per competitor. |
| Market size data | `/search` + `/scrape` | Search for "[niche] market size 2025 2026" then scrape best results. Triangulate ≥2 sources. |
| Aggregator identification | `/search` for directories | Search "[niche] agencies/consultants/partners" then `/crawl` directory pages. |
| Buyer language extraction | `/scrape` review pages | Extract verbatim quotes. Filter for role-specific language. |
| Company lists for First-5 | `/search` + `/scrape` | Search "[niche] companies [location]" then scrape directories. |
| Competitive intelligence monitoring | `/monitor` | Set up monitors on competitor pricing pages, changelogs. Alert on changes. |
| Deep niche research | `firecrawl-deep-research` skill | Multi-source synthesis for complex niche questions. |

**Context7 MCP Integration:**

| Research Task | Context7 Use |
|---|---|
| Tool/API documentation | Query Context7 for official docs of any tool/API being considered for workflows (§11). Verify API capabilities, endpoints, rate limits, and authentication before committing to a tool in the workflow spec. |
| CRM/ATS integration specs | Query official Bullhorn, HubSpot, Salesforce API docs to confirm OAuth scopes, object models, and field availability for §1.4 data accessibility gate. |
| Data provider capabilities | Query Clay, Apollo, Clearbit, Crunchbase docs to verify enrichment fields, API pricing, and rate limits before designing enrichment pipelines. |
| Best practices | Query for implementation patterns, SDK usage, and integration examples when designing §11 workflow architectures. |

**Search operator optimization for niche research:**
- `"exact niche name" market size` — quoted phrase for precision
- `site:g2.com "[competitor]"` — domain-scoped competitor review search
- `site:linkedin.com "[title]" "[industry]"` — buyer profile research
- `filetype:pdf "[niche]" benchmark` — analyst report discovery
- `after:2024-01-01 "[niche]" trends` — temporal filter for recency
- `-job -hiring -careers "[niche]"` — exclude recruitment noise
- `intitle:"[niche]" intitle:"market"` — title-scoped for authority
