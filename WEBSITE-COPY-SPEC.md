# Website Copy Specification

**Source:** PROGRAM-FIX-SPECIFICATION.md, Workstream F, F-P2-2
**Status:** BINDING — every section below must be produced from the selected niche's canvas output
**Audience:** Copywriter building the ClarityRev niche-specific landing page
**Prerequisite:** A completed Niche Canvas for the selected niche, including:
- Section 2: Buyer Persona (roles, job titles, context)
- Section 3: Pain Architecture (quantified pain, costs of inaction)
- Section 4: Competitive Landscape (top 3 competitors + their weaknesses)
- Section 6: Trigger Events & Signals (what starts the buying process)
- Section 7: Buyer Lifecycle & Decision Process
- Section 8: Free Lead Magnet (the diagnostic snapshot)
- Section 9: Paid Pilot Offer
- Section 10: Pricing & Packaging
- Section 14: RIOS Scoring & Verdict

---

## 1. Hero Section

**Copy direction:** Lead with the buyer's most painful expressed pain in their own words. The hero must make the buyer think "they're talking about me" in <3 seconds.

**Structure:**
| Element | Source in Canvas | Emotional Tone | Requirements |
|---|---|---|---|
| **Headline (H1)** | §3.1 primary pain, verbatim buyer language from buyer-language-schema entries where headline_candidate=true | Resonates with EXPRESSED_PAIN or ASPIRATIONAL_GOAL | Must be ≤10 words. Buyers must recognize themselves instantly. Avoid jargon ClarityRev invented — use the buyer's words. |
| **Subheadline** | §3.2 quantified cost of inaction + §6 trigger events | Compounds the pain, then hints at resolution | 1-2 sentences. Must make the cost of not solving the problem feel unbearable. "You're leaving $X on the table every quarter because [trigger event]." |
| **Primary CTA** | §8 free diagnostic snapshot offer name | HOPEFUL — low commitment, high perceived value | ≤5 words. "Get Your [Niche] Revenue Snapshot" or "See Your Pipeline Health Score." Must be a free, no-risk offer. |
| **Trust indicator** | §4 competitor weaknesses (implicit) | Confident, credible | A numbered stat or claim that signals ClarityRev is the right team for this niche. E.g., "Built for [Niche] — not repurposed from [Competitor]." |

**Verbatim buyer language to use:** Pull at least 3 FRUSTRATED or URGENT quotes from buyer-language extracts where headline_candidate=true. The copywriter should test each as the H1 candidate.

**Conversion goal:** Click-through to lead magnet landing page (not pricing, not about). Target: ≥40% of clicks from hero.

---

## 2. The Problem Section

**Copy direction:** Quantify the pain in the buyer's own words. Make the cost of inaction concrete and urgent. Create enough discomfort that the free diagnostic snapshot feels like relief.

**Structure:**
| Element | Source in Canvas | Emotional Tone | Requirements |
|---|---|---|---|
| **Problem headline** | §3.1 primary pain (from buyer language) | FRUSTRATED — the buyer's complaint, verbatim | "This is what [Niche Role]s say keeps them up at night." |
| **Pain block 1** | §3.2 quantified pain #1 (with EUR/year or % impact) | URGENT — make it hurt | "The average [Niche Company] loses €[X] per year because [pain]. That's [Y]% of revenue." Cite source if [P] grade. |
| **Pain block 2** | §3.2 quantified pain #2 | ANXIOUS — show the ripple effects | "This doesn't just cost money. It costs [consequence: deals, morale, pipeline predictability]." |
| **Pain block 3** | §3.3 cost of inaction | RESIGNED → AWAKENING — what happens if nothing changes | "The [Niche]s who ignore this problem are [consequence: falling behind competitors, losing market share, missing board targets]." |
| **Buyer quote(s)** | §3 buyer language, copy_ready=true | Matches the emotional charge of the block | Pull real verbatim quotes from competitor reviews. These are the most powerful element — let the buyer speak. |

**Verbatim buyer language to use:** Use EXPRESSED_PAIN and LATENT_PAIN verbatim quotes. Group by emotional charge — FRUSTRATED quotes for pain block 1, ANXIOUS for block 2, RESIGNED for block 3.

**Conversion goal:** Emotional readiness for the solution. The buyer should feel "something must change." Target: ≥70% of visitors read past the hero into this section (scroll depth).

---

## 3. How It Works Section

**Copy direction:** Do NOT describe signal detection, enrichment, or AI analysis in technical terms. Describe the outcome the buyer experiences — in their language, at their level of abstraction.

**Structure:**
| Step | Source in Canvas | What to Communicate | Emotional Tone |
|---|---|---|---|
| **Step 1: We Watch** | §6 triggers + §5 signal sources | ClarityRev monitors [X] signal sources for [specific trigger events]. Buyer sees only the relevant signals. | HOPEFUL — relief from manual monitoring |
| **Step 2: We Spot** | §7 lifecycle + §5 signals | When a signal fires, ClarityRev enriches it with [buyer context: company data, intent scores, relationship mapping]. | CONFIDENT — trust the system |
| **Step 3: You Act** | §8 diagnostic snapshot + §9 delivery | Every week, Bob gets a prioritized list: who to call, what to say, and why they'll listen. | EMPOWERED — the path is clear |

**Verbatim buyer language to use:** Avoid "AI-powered," "ML-driven," "real-time analytics." Instead, use the buyer's aspirational language from ASPIRATIONAL_GOAL quotes. If they say "I want a system that just tells me who to call," then Step 3 is "We tell you who to call."

**Conversion goal:** The buyer should understand exactly what ClarityRev does for THEM in their words. Target: ≤45 seconds to read all 3 steps.

---

## 4. "vs Competitor X" Pages (One per Top-3 Competitor)

**Copy direction:** Use the competitor's own reviews against them. Every competitor weakness page starts with: "What [Niche Buyer]s say about [Competitor]." Followed by verbatim complaints from G2/Capterra/Reddit. Against this, present ClarityRev's approach as the solution to what competitors do wrong.

**Structure (per competitor):**
| Section | Source in Canvas | Emotional Tone | Key Content |
|---|---|---|---|
| **Headline** | §4 competitor weakness (primary) | FRUSTRATED — buyer's complaint | "Why [Niche]s are switching from [Competitor] to ClarityRev" |
| **"The [Competitor] Problem"** | §4 top pain from competitor reviews (copy_ready=true verbatim quotes) | FRUSTRATED → RESIGNED | 3-5 verbatim complaints from competitor reviews. Let the competitor's own customers make the case. |
| **How ClarityRev is Different** | §4 ClarityRev advantage (1-3 differentiators) | HOPEFUL — relief | Direct contrast: "They [competitor failing]. We [ClarityRev solution]." |
| **Pricing comparison** | §10 competitor pricing data | REASSURED — better value | If ClarityRev is cheaper: show the savings. If similar price: show the additional value. |
| **CTA** | §8 diagnostic snapshot | Low-commitment offer | "See how ClarityRev compares to [Competitor] for your team — free snapshot." |

**Verbatim buyer language to use:** This page MUST use the competitor's unhappy customers' words. This is the most convert-heavy page type. Every claim must be sourced to a real review.

**Conversion goal:** For buyers evaluating ClarityRev against [Competitor]. Target: ≥25% of lead magnet conversions come from these pages.

---

## 5. Pricing Page

**Copy direction:** Frame pricing as value delivered, not cost. Use the pricing bands from strategy/clarityrev-offer-framework.md. Each tier answers "who is this for" and "what do they get."

**Structure:**
| Element | Source in Canvas | Emotional Tone | Requirements |
|---|---|---|---|
| **Pricing headline** | §10 pricing philosophy | CONFIDENT — value-first | "Pricing for [Niche]s ready to stop guessing and start closing." |
| **Tier 1: Starter** | §10 entry-level (EUR 1.5-3K/mo) | Low risk, high value | For: [buyer persona low-end]. Includes: [core signals + snapshot]. CTA: "Start with a Free Snapshot." |
| **Tier 2: Core** | §10 core (EUR 3K/mo) | Confident investment | For: [buyer persona mid-market]. Includes: [all signals + enrichment + weekly prioritization]. |
| **Tier 3: Premium** | §10 premium (EUR 5K/mo) | For serious teams | For: [buyer persona enterprise]. Includes: [custom signals + integrations + priority support]. |
| **Enterprise** | §10 enterprise (EUR 8K+/mo) | Partnership level | For: [buyer persona large enterprise]. Includes: [dedicated + custom + SLA]. |
| **Guarantee** | §9 pilot structure | TRUST — zero risk | "Not sure? Start with a paid pilot. Cancel any time within [X] weeks. If you don't see [quantified result], you don't pay." |

**Verbatim buyer language to use:** Use ASPIRATIONAL_GOAL quotes near pricing to reinforce "this is what you get." Use SKEPTICAL quotes near the guarantee to address the "I've been burned before" concern.

**Conversion goal:** Direct purchase for Tier 1-2. Consultation request for Tier 3+. Target: ≥5% of pricing page visitors start a pilot.

---

## 6. Social Proof Section (Placeholder)

**Copy direction:** Since ClarityRev has zero clients, this section must use placeholder structure that will be populated after the first 3 clients. Do NOT fabricate testimonials. Do NOT use generic "trusted by" logos.

**Structure:**
| Element | Source | Emotional Tone | Requirements |
|---|---|---|---|
| **Headline** | N/A — placeholder | HONEST | "Results from our first [Niche] clients — coming soon." |
| **Case study template** | Framework from §7 lifecycle | HOPEFUL — shows what's coming | Placeholder structure: [Client Name] — [Challenge verbatim from §3] — [Solution] — [Result: quantified targets] |
| **Interview invite CTA** | §2 buyer persona | URGENT — be part of something | "Are you a [Niche Role]? Join our early adopter program and shape the product that solves [primary pain]." |
| **Trust indicators (alternative)** | §4 competitor weaknesses + §14 RIOS | CONFIDENT — credibility without clients | "Built by the team that understands [Niche] because [reason founder experience applies to this niche]." |

**Conversion goal:** Do not let the empty social proof section reduce conversion. Instead, turn it into an early-adopter recruitment opportunity. Target: ≥3 signups for the early adopter program in the first month.

---

## 7. Lead Magnet Landing Page (Diagnostic Snapshot)

**Copy direction:** The free diagnostic snapshot is the primary conversion mechanism. This page does one thing: get the visitor to book the diagnostic call. No navigation, no distractions.

**Structure:**
| Element | Source in Canvas | Emotional Tone | Requirements |
|---|---|---|---|
| **Headline** | §8 snapshot title (from buyer language) | URGENT + HOPEFUL | "Get Your [Niche] Revenue Diagnostics Report" — should feel like a medical scan for their pipeline. |
| **What they get** | §8 snapshot contents (3-5 bullet points) | HOPEFUL — tangible value | Specific deliverables they'll receive. Not "market insights" but "Your team's top 5 missed opportunities this quarter, ranked by revenue impact." |
| **What it costs** | §8 free offer | REASSURED | "Free. No credit card. 30-minute debrief call included." |
| **What they learn** | §8 diagnostic insights | CURIOSITY + ANXIETY | "You'll discover: [3 specific things the snapshot reveals, each tied to a §3 pain]." |
| **Calendar / CTA** | N/A — scheduling tool | LOW FRICTION | "Book your 30-min diagnostic call. We do the analysis. You get the report." |
| **Social proof (if available)** | §7 early adopter testimonials (after first 3 clients) | TRUST | Placeholder: "Join [X] [Niche]s who have already received their diagnostic." |

**Verbatim buyer language to use:** The entire page should be in the buyer's voice. Headline = buyer's pain verbatim. Bullet points = buyer's expressed goals. The diagnostic should sound like it was designed BY this buyer FOR this buyer.

**Conversion goal:** Booked diagnostic calls. Target: ≥15% of visitors book a call. This is the primary inbound conversion funnel.

---

## 8. Blog Content Calendar (12 Topics)

**Copy direction:** Each blog post maps to a trigger event or buyer question from the canvas. Content is designed to be discovered by buyers searching for the pain, not the solution.

| # | Topic Title | Maps to Canvas Section | Target Keyword | Conversion Path |
|---|---|---|---|---|
| 1 | "Why [Niche Role]s are missing [X]% of their pipeline — and how to fix it" | §3.1 primary pain + §6 trigger | [niche] pipeline leakage | Lead magnet landing page |
| 2 | "[Trigger Event] is costing [Niche]s [€X] — here's the data" | §6 primary trigger + §3.2 quantified pain | [trigger event] cost [niche] | Lead magnet landing page |
| 3 | "5 [Niche] competitive intelligence signals your CRM misses" | §5 signal types + §4 competitor landscape | [niche] competitive intelligence | Lead magnet landing page |
| 4 | "[Competitor A] vs [Competitor B] vs ClarityRev for [Niche]" | §4 competitor comparison | [competitor A] vs [competitor B] [niche] | vs Competitor page |
| 5 | "How [Niche Company] closed [€X] in revenue using signal detection" | §7 lifecycle + §9 pilot | [niche] revenue intelligence case study | Lead magnet → consultation |
| 6 | "The hidden cost of [pain] for [Niche]s" | §3.3 cost of inaction | cost of [pain] [niche] | Lead magnet landing page |
| 7 | "What [Niche Role]s look for in a revenue intelligence partner" | §2 buyer persona priorities | choosing revenue intelligence [niche] | Pricing page |
| 8 | "Q1 [current_year] [Niche] trends: [trigger trend from signals]" | §6 signal trends | [niche] trends [year] | Lead magnet landing page |
| 9 | "Why [Niche]s are switching from [Competitor] to independent signal detection" | §4 competitor weaknesses | [competitor] alternatives [niche] | vs Competitor page |
| 10 | "How to build a [Niche] sales pipeline that predicts itself" | §6-7 lifecycle | [niche] sales pipeline automation | Lead magnet landing page |
| 11 | "[Niche] buyer behavior in [year/time period]: what the data says" | §2 buyer persona | [niche] buyer behavior | Lead magnet landing page |
| 12 | "From trigger to close: the anatomy of a [Niche] deal in the AI era" | §7 lifecycle + §5 signals | [niche] deal workflow AI | Consultation CTA |

**Content guidelines:**
- Every blog post must reference at least one verbatim buyer quote from the buyer-language corpus
- Every blog post must end with a CTA to the lead magnet or a specific service page
- No post may use fabricated stats. If the canvas has [S] claims, disclose uncertainty ("Our research suggests..." or "Industry data indicates...")
- Topics should be published in order 1-12, with a 1-week cadence (12-week content runway)

**Conversion goal:** Organic search traffic → lead magnet conversions. Target: ≥500 organic visits/month by month 4, ≥20 lead magnet conversions/month by month 6.

---

## Appendix: Copy Source Mapping

This table maps every website section to its canvas section, ensuring the copywriter can trace every claim:

| Website Section | Primary Canvas Source | Secondary Canvas Source | Buyer-Language Filter |
|---|---|---|---|
| Hero | §3.1 | §6, §8 | headline_candidate=true, EXPRESSED_PAIN |
| The Problem | §3.2, §3.3 | §6 | copy_ready=true, FRUSTRATED/URGENT/ANXIOUS |
| How It Works | §5, §6, §7, §8 | §9 | ASPIRATIONAL_GOAL |
| vs Competitor X | §4 | §10 | competitor_mentioned not empty |
| Pricing | §10 | §9 | SKEPTICAL, ASPIRATIONAL_GOAL |
| Social Proof | §7 | — | N/A (placeholder until clients) |
| Lead Magnet | §8 | §3, §6 | URGENT, HOPEFUL |
| Blog | §2, §3, §4, §5, §6, §7 | — | All classifications |

---

*End of WEBSITE-COPY-SPEC.md*
