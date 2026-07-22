# Outbound Sequence Specification

**Source:** PROGRAM-FIX-SPECIFICATION.md, Workstream F, F-P3-3
**Status:** BINDING — produce for the selected niche from canvas output
**Audience:** Bob (primary outbound exec) + automated sequence tools
**Prerequisite:** A completed Niche Canvas, including buyer persona (§2), pain architecture (§3), competitive landscape (§4), trigger events (§6), diagnostic snapshot (§8), and pricing (§10)

---

## 1. Cold Email Sequence (5 Emails)

**Design principles:**
- Every email maps to a specific canvas section — no generic sales email templates
- Every email uses verbatim buyer language from the buyer-language corpus
- Personalization is per-prospect: company name, role, observed trigger event
- Sequence spans 2-3 weeks (send M/W/F, not daily)

---

### Email 1: Trigger + Pain (Section 6 → Section 3)

**Day:** 1
**Subject line:** [Trigger Event] at [Company Name]?
**Goal:** Open the conversation by naming the trigger event the buyer likely experienced.

```
Hi [First Name],

I noticed [trigger event from §6 — specific to this buyer's company or industry]. 
For [Niche]s, that usually means [specific §3 pain consequence].

Most [Niche Role]s tell us [verbatim buyer quote, copy_ready=true, FRUSTRATED].

Is that landing on your radar?

Best,
Bob
ClarityRev
```

**Canvas source:** §6 trigger event (personalized), §3 pain consequence, §2 buyer language (verbatim quote).
**Success metric:** Reply rate > 15%.
**Fallback:** If no trigger event is observable for a specific buyer, use a generic §6 common trigger + §3 pain combo.

---

### Email 2: Competitive Insight (Section 4)

**Day:** 4
**Subject line:** What [Niche]s say about [Competitor]
**Goal:** Position ClarityRev as the alternative to the tools that don't work.

```
Hi [First Name],

A lot of [Niche] teams we talk to are using [Competitor 1] or [Competitor 2]. 
The feedback we keep hearing:

[Verbatim quote from competitor reviews — FRUSTRATED, copy_ready=true]

We built ClarityRev differently. Instead of [competitor weakness], we 
[ClarityRev advantage from §4].

Would you be open to a 10-min comparison?

Best,
Bob
```

**Canvas source:** §4 competitor weaknesses + verbatim review quotes, §4 ClarityRev advantage.
**Success metric:** Reply rate > 12% (lower than email 1 because it's cold comparison).
**Trigger:** Only send if prospect hasn't replied to email 1.

---

### Email 3: ROI Proof (Section 3 + Section 10)

**Day:** 8
**Subject line:** The math on [pain] for [Company Name]
**Goal:** Make the financial case concrete. Show the cost of inaction.

```
Hi [First Name],

Quick math for a typical [Niche Company your size]:

If [pain from §3.1] costs [€X/year from §3.2 quantified pain], and 
ClarityRev helps reduce that by [estimated impact from §14 ROI logic], 
the ROI at [€3K/month from §10 Core pricing] is clear.

[One-liner summary: e.g., "At 10 deals/year, a 15% win-rate lift pays for 
the entire annual investment in month two."]

Want us to run the numbers for your team specifically?

Best,
Bob
```

**Canvas source:** §3 quantified pain, §14 RIOS ROI logic, §10 Core pricing.
**Success metric:** Reply rate > 10% (specifically "yes, run the numbers").
**Trigger:** Only send if prospect hasn't replied to email 1 or 2.

---

### Email 4: Social Proof (Section 7 + Placeholder)

**Day:** 11
**Subject line:** Early results from [Niche] teams
**Goal:** Build credibility by showing early traction — even if zero clients, use the diagnostic snapshot volume.

```
Hi [First Name],

We've been running [Number] diagnostic snapshots for [Niche] teams in the 
last [X weeks]. The pattern we're seeing:

[1-2 anonymized insights from diagnostic snapshots — aggregated, not attributed]

One ops director told us: [verbatim quote from diagnostic debrief, 
ASPIRATIONAL_GOAL or HOPEFUL].

If you want to see what your pipeline would reveal, the snapshot is free.
No sales pitch — just data.

https://clarityrev.com/niche-snapshot

Best,
Bob
```

**Canvas source:** §7 buyer lifecycle insights, §8 diagnostic snapshot. Adapted from real early adopter data.
**Success metric:** Snapshot clicks > 8%.
**Trigger:** Only send if prospect hasn't replied to any previous email.

---

### Email 5: Diagnostic Snapshot Offer (Section 8)

**Day:** 15
**Subject line:** One last idea, [First Name]
**Goal:** Final low-friction offer before moving to nurture.

```
Hi [First Name],

One last idea before I get out of your inbox.

We built a [Niche] diagnostic snapshot that shows [3 specific insights from §8].
It takes 30 minutes, costs nothing, and [one tangible outcome, e.g., "you'll 
see exactly where your pipeline is leaking"].

If now's not the right time, no worries. I'll check back in [X months].

https://clarityrev.com/niche-snapshot

Best,
Bob
```

**Canvas source:** §8 diagnostic snapshot details, §3 pain (for the outcome), §6 trigger cadence (for next check-in timing).
**Success metric:** Snapshot clicks > 5% + unsubscribe rate < 2%.
**Trigger:** Final email. After this, prospect moves to 60-day nurture cooldown set on X date.

---

## 2. LinkedIn DM Templates (3 Buyer Roles)

### Template A: Economic Buyer (e.g., CRO, VP Sales, Head of Revenue)

**Tone:** Strategic, outcome-focused, peer-level.
**Canvas source:** §2 economic buyer persona.

> Hi [First Name], I've been studying [Niche] signal detection gaps and noticed [trigger event/trend from §6]. Most [Niche CRO]s I talk to flag [§3 primary pain] as the #1 pipeline blind spot. I put together a one-page summary of the signal patterns we're seeing across [X] [Niche] teams — would that be useful?

**Goal:** Intelligence sharing, not selling. Get the "one-pager" request.
**CTA:** "Would [one-pager/summary/snapshot] be useful?"

---

### Template B: Champion/Influencer (e.g., Director of Sales Ops, Head of RevOps)

**Tone:** Tactical, execution-focused, empathy with their daily reality.
**Canvas source:** §2 champion persona.

> Hey [First Name], saw you're [specific observation from their LinkedIn — new role, post, company news]. With [pain from §3], I've been helping [Niche Ops] leaders diagnose [specific trigger consequence]. Built a snapshot that does [X] in about 30 minutes. Want to see how yours compares?

**Goal:** Low-friction diagnostic offer. Champions are easier to convert to a snapshot.
**CTA:** "Want to see how yours compares?"

---

### Template C: End User (e.g., Sales Manager, Account Executive)

**Tone:** Ground-level, empathy with day-to-day friction.
**Canvas source:** §2 end-user persona.

> Hi [First Name], a lot of [Niche AE]s tell me they [verbatim pain quote — FRUSTRATED]. Curious if [Company Name] has the same challenge — or if you've found a workaround that's working? Always looking to learn what actually works for sales teams.

**Goal:** Conversation start, not conversion. End users inform buying decisions but don't make them. Plant the seed.
**CTA:** Open question about their experience.

---

## 3. Discovery Call Script (30-Minute Structure)

**Duration:** 30 minutes sharp — Bob sets a timer.

### Phase 1: Rapport + Context (5 min)

**Goal:** Establish peer credibility and understand the buyer's situation.
**Canvas source:** §2 buyer persona context.

```
Bob: "Thanks for the time, [First Name]. I know your team is at [Company Name] — 
[Niche, size, notable trait]. Before I dive into what we found on the diagnostic 
side, tell me: what's top of mind for you right now on the [pipeline/revenue] front?"
```

**Listen for:**
- Which §3 pain(s) they mention first (priority ranking)
- Whether they cite a §6 trigger event (urgency)
- Language patterns that match the buyer-language corpus (signal copy direction)
- Their current tool stack (competitor mapping from §4)

**Red flag:** If they don't name a pain within 2 minutes, they're not in-market. Adjust pitch toward education (lead magnet) rather than pilot.

### Phase 2: Pain Diagnosis (10 min)

**Goal:** Validate and quantify the §3 pain hypothesis.
**Canvas source:** §3 pain architecture.

```
Bob: "That's really helpful. We're seeing that [trigger/signal pattern from §6] 
is creating [pain from §3] for a lot of [Niche] teams. What's the impact on your 
team specifically — [ask the §3 quantified question, e.g., 'how many deals do 
you estimate you're losing to blind spots?']"
```

**Questions to ask (adapt to what they shared in Phase 1):**
1. "How do you currently detect [trigger event]?" (Competitor usage — maps to §4)
2. "What happens when [trigger event] occurs and your team misses it?" (Cost of inaction — §3.3)
3. "Have you tried [Competitor X] for this? What worked/didn't?" (§4 competitive data)
4. "If this were solved, what would change for your team?" (Aspirational goal — §3 buyer language)

**Diagnostic anchor:** If they sent a pre-call diagnostic snapshot, review the findings here. The snapshot IS the diagnosis — use it.

### Phase 3: Solution Teaser + ClarityRev Fit (10 min)

**Goal:** Plant ClarityRev as the obvious solution WITHOUT a feature demo.
**Canvas source:** §7-10 ClarityRev specific.

```
Bob: "The way we're approaching this at ClarityRev: instead of [competitor approach 
from §4], we track [§6 signals] directly and deliver [§8 snapshot + §9 pilot] — 
specifically for [Niche]. We don't ask your team to change their CRM or adopt 
a new platform. We plug into [CRM from §7] and deliver a weekly [list/prioritization/
alert]."

"Here's what a pilot looks like: [§9 pilot structure — duration, what they get, 
what it costs, guarantee]."
```

**Do NOT:**
- Open a dashboard or show screenshots (creates feature-expectation mismatch)
- Talk about AI/ML stack (buyers don't care)
- Compare feature lists (they'll pick the wrong criteria)

**DO:**
- Anchor every claim to the diagnostic they received or the pain they stated
- Frame ClarityRev as the solution for their specific problem, not a platform
- Use their language from Phase 1-2 to describe what ClarityRev does

### Phase 4: Next Steps (5 min)

**Goal:** Clear, low-friction commitment.
**Canvas source:** §8 snapshot, §9 pilot.

```
Bob: "Based on what you've shared, I see two paths:
1. [If diagnostic was NOT done]: I send you the [Niche] diagnostic snapshot — 
   you get the report in 48 hours, we do a 15-minute debrief.
2. [If diagnostic WAS done or if they're hot]: We set up a 2-week paid pilot — 
   €[pilot price from §9]. If you don't see [quantified result from §14 ROI logic], 
   you pay nothing. Fair?"

"What works better for you?"
```

**Commitment ladder** (lowest friction first):
1. Diagnostic snapshot (free, 30-min debrief) — always available
2. Pilot (paid, 2-4 weeks, guaranteed) — if diagnostic showed pain
3. Core subscription (€3K/mo) — only after pilot validates

**If no commitment:**
"Totally fair. What would need to change for this to become a priority?"

**If objection:** See Objection Handling Guide (§4 below).

---

## 4. Objection Handling Guide (Top 10 Objections)

**Source:** Competitor reviews (§4 corpus of what buyers complain about) + ClarityRev response derived from canvas. Each objection includes the competitor review evidence that confirms this is a real buyer concern.

---

### Objection 1: "We already use [Competitor]."

**Competitor review evidence:** "We invested in [Competitor] but the signals were too noisy — we got 200 alerts a week and 3 were relevant." (Source: G2 review, FRUSTRATED)
- **Acknowledge:** "Good — you've seen what a signal detection tool looks like. Most teams tell us [Competitor] catches [X] but misses [Y from §4 competitor weakness]."
- **Differentiate:** "We focus on [§6 specific signals] for [Niche]. That means fewer alerts, higher relevance."
- **Bridge:** "Would a comparison of what [Competitor] catches vs. what we catch for [Niche] be useful?"

---

### Objection 2: "We don't have the budget."

**Competitor review evidence:** "The platform was €5K/mo and we barely used half the features. Huge waste of budget." (Source: G2 review, RESIGNED)
- **Acknowledge:** "Understood. We start at €[§10 starter price]/month. No annual commitment."
- **Reframe:** "The diagnostic snapshot is free. You'll see the ROI case before spending anything."
- **Bridge:** "If a pilot saved you [§3 quantified pain ÷ 12] per month, would that change the budget conversation?"

---

### Objection 3: "We just implemented [System X]."

**Competitor review evidence:** "We spent 4 months integrating [Competitor] and it still doesn't work with our Salesforce instance the way they promised." (Source: Reddit, FRUSTRATED)
- **Acknowledge:** "Integration fatigue is real. We're not asking you to rip and replace."
- **Differentiate:** "ClarityRev snaps into [§7 CRM from canvas] in less than a day. We don't replace your stack — we make it smarter."
- **Bridge:** "The diagnostic snapshot doesn't require any integration. Just a 30-min call to understand your setup."

---

### Objection 4: "I need to see proof it works first."

**Competitor review evidence:** "The demo looked amazing. Real-world performance was a fraction of what they showed." (Source: G2 review, SKEPTICAL)
- **Acknowledge:** "You're right to be skeptical — especially with AI tools."
- **Bridge:** "That's exactly why we lead with the diagnostic snapshot. You get real data about your pipeline before committing anything. If it doesn't reveal value, no problem."

---

### Objection 5: "We already know our pipeline."

**Competitor review evidence:** "We thought we knew our pipeline too. The tool showed we were missing 40% of signals — we just didn't know what we didn't know." (Source: G2 review, ANXIOUS)
- **Acknowledge:** "Most [Niche Role]s think they know their pipeline."
- **Bridge:** "The diagnostic snapshot typically shows [§8 specific insight] that surprises even experienced teams. 30 minutes, free, see for yourself."

---

### Objection 6: "This is too niche for us."

**Competitor review evidence:** "The tool was built for enterprise sales. For mid-market it was overkill. Way too complex." (Source: Capterra review, FRUSTRATED)
- **Acknowledge:** "We focus on [Niche] specifically — and that's intentional."
- **Reframe:** "Because we're built for [Niche], not adapted from enterprise sales tools, the setup is faster, the signals are more relevant, and the pricing fits your scale."
- **Bridge:** "What would an ideal tool for [Niche] look like to you?"

---

### Objection 7: "We tried AI tools and they overpromised."

**Competitor review evidence:** "AI-powered pipeline predictions were a joke. The tool said '30% probability' on everything. Pure black box." (Source: Reddit, SKEPTICAL)
- **Acknowledge:** "The AI hype has created a lot of noise. We get it."
- **Differentiate:** "We don't predict. We detect. Signal monitoring is deterministic — a trigger fires, we catch it, we alert you. No black box."
- **Bridge:** "The diagnostic is the proof. You'll see exactly how we work, with your data."

---

### Objection 8: "How is this different from an SDR?"

**Competitor review evidence:** "They promised AI SDRs but it was just automated email sequences. More spam." (Source: G2 review, RESIGNED)
- **Acknowledge:** "We're not an SDR replacement or an outreach tool."
- **Differentiate:** "ClarityRev is signal detection + enrichment for YOU — the sales leader. We tell you WHO to call and WHY. You do the calling. Your team keeps the relationship."
- **Bridge:** "Think of us as your competitive intelligence radar, not your outbound team."

---

### Objection 9: "We need to see ROI in writing."

**Competitor review evidence:** "They claimed 3x ROI in the sales deck. We saw maybe 1.2x after 8 months. Felt misled." (Source: G2 review, ANXIOUS)
- **Acknowledge:** "ROI projections without data are just marketing."
- **Bridge:** "That's why we do the diagnostic first. Real pipeline analysis, real numbers. Then the pilot is transactional — [€pilot price], [duration], [guarantee]. If it doesn't work, you're not locked in."

---

### Objection 10: "We'll revisit in [X months]."

**Competitor review evidence:** "We put off the decision for 6 months. By then, our competitor had already implemented a signal system and was outpacing us." (Source: Interview transcript, RESIGNED)
- **Acknowledge:** "I understand timing isn't right for a full rollout."
- **Bridge:** "The diagnostic snapshot takes 30 minutes now. You'll have the data ready for when the timing is right. No commitment, no follow-up until you say so."
- **Close:** "When's best for that 30-minute diagnostic call?"

---

## Appendix A: Sequence Automation Rules

| Rule | Condition | Action |
|---|---|---|
| Reply stop | Prospect replies to any email | Stop sequence. Flag for Bob's personal follow-up within 24 hours. |
| Bounce | Email bounces (hard or soft) | Remove from sequence. Log in CRM. Do not retry. |
| Unsubscribe | One-click unsubscribe | Remove from ALL sequences. Log in CRM. Forever suppress. |
| Out-of-office | Auto-reply received | Pause sequence. Resume after OOO end date. |
| Meeting booked | Diagnostic call scheduled via link | Stop sequence. Add to call prep queue. |
| Trigger observed mid-sequence | New signal detected via §6 monitoring | Interrupt current position. Send Email 1 variant with new trigger. Reset sequence position. |
| Nurture cooldown | All 5 sent, no reply | Move to 60-day nurture. No sends. Re-enter at Email 1 after 60 days only if new trigger observed. |

## Appendix B: Role-to-Template Mapping

| Buyer Role | Canvas §2 Persona | Primary Template | Sequence Speed |
|---|---|---|---|
| CRO / VP Sales | Economic buyer | Email + Template A | Standard (2-3 weeks) |
| Head of RevOps / Sales Ops Director | Champion/Influencer | Email + Template B | Accelerated (10-14 days) |
| Sales Manager / AE | End user | LinkedIn only (Template C) | Slow burn (no email sequence) |
| CEO / Founder (small co) | Economic buyer | Email + Template A (shortened to 3 emails) | Accelerated (7-10 days) |

---

*End of OUTBOUND-SPEC.md*
