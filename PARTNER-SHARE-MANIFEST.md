# Partner Share Manifest — Niche Research Program

**For:** Bob & Adriaan
**Purpose:** Curated file list so you can give the Niche Research Program to your LLM of choice (ChatGPT, Claude, Gemini) and have a conversation about it.
**Date:** 2026-07-23

---

## What to share

Give your LLM these 7 files (in this order). They're chosen to tell the complete story without drowning in operational detail:

### File 1: `niche-program/README.md`
**Why:** Entry point. Explains the directory structure and what's where. Your LLM reads this first to understand the map of the territory.

### File 2: `niche-program/NICHE-METHODOLOGY.md`
**Why:** THE document. The binding 15-section Niche Canvas specification. This is what every niche evaluation produces. It covers:
- **§1:** Niche identity, market sizing, data accessibility gates
- **§2:** Buyer committee mapping — who buys, who influences, what triggers them
- **§3:** Pain architecture — what hurts, how much it costs, ROI proof structure
- **§4:** Competitive landscape — direct competitors, white space, positioning
- **§5:** Ecosystem & distribution — aggregators, channels, partners
- **§6:** Signal architecture — what triggers to monitor, what signals to detect
- **§7-10:** Offer architecture — free entry → paid → recurring → expansion
- **§11:** Automated workflow specifications — what to build
- **§14:** RIOS scoring — the 8-dimension framework for comparing niches
- **Part 2:** Research Protocol — what questions we answer for each niche
- **Part 3:** Quality Gates — what "done" means
- **Part 5:** Cross-Niche Comparability — how we rank 25 niches against each other

### File 3: `niche-program/DATA-OPERATIONS-ARCHITECTURE.md`
**Why:** How we actually gather the data. Tools (Firecrawl, DataForSEO, 65+ MCP servers, 20+ free APIs), credit budgets, freshness SLAs, data schemas, and the 4-phase execution pipeline. Your LLM can explain exactly what data we collect for each niche and how.

### File 4: `niche-program/schemas/README.md`
**Why:** Shows the structured data formats. Every competitor profile, review corpus, market sizing estimate, and niche canvas produces machine-readable YAML. This is how we compare niches apples-to-apples.

### File 5: `niche-program/schemas/canvas-frontmatter-schema.yaml`
**Why:** The exact machine-readable output every niche produces. Shows what fields are comparable across niches — scores, metrics, evidence quality, credit consumption. This is the dashboard your LLM can help you interpret.

### File 6: `niche-program/research/_program/SLI_DEFINITIONS.yaml`
**Why:** The quality gates. Shows what "good data" means — freshness compliance >90%, fetch success rate >95%, evidence quality >50%. Your LLM can explain what quality controls protect the program.

### File 7: `niche-program/SESSION-STARTER.md`
**Why:** Program context — what's built, what remains, session history. Gives your LLM the timeline and current state.

---

## What NOT to share (and why)

| Not Included | Reason |
|---|---|
| `_pipelines/` scripts | Operational Python code — not relevant for understanding the program |
| `_pipelines/test/` | Test suite — internal QA |
| `_pipelines/IMPLEMENTATION-SPEC.md` | Engineering specification — too detailed |
| `_pipelines/SCRIPTS-AUDIT-PROMPT.md` | Audit prompt — internal QA |
| `lenses/` directory | Architecture design files — internal |
| `discovery/` directory | Phase 0 research data — too detailed |
| `references/` directory | Tool reference docs — too detailed |
| `research/N-*/` directories | Test data from script testing — not real niche evaluations |

---

## How to use

1. **Paste the prompt** from `PARTNER-LLM-PROMPT.md` into your LLM (ChatGPT, Claude, Gemini — any works)
2. **Attach the 7 files** listed above (most LLMs support file upload; if yours doesn't, paste them as text after the prompt)
3. **Have a conversation.** The prompt instructs the LLM to be your program explainer. Ask follow-up questions about anything you want to understand deeper.

---

## What you should be able to discuss with your LLM after sharing these files

- "What is the Niche Research Program and how does it work?"
- "What data will we have about each niche when the program completes?"
- "How do we compare 25 niches and pick the best one?"
- "What competitor intelligence will we have for each niche?"
- "How does this help us build a data-backed website?"
- "What buyer language, pain points, and triggers will we know for each niche?"
- "What's the RIOS framework and how does it score niches?"
- "How does the offer architecture work — free entry, paid, recurring?"
- "What's the quality control — how do we know the data is good?"
- "How much does this cost to run and how long does it take?"
