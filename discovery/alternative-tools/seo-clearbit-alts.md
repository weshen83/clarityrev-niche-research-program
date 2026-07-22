# C1a: Free Alternatives to Semrush/Ahrefs + Clearbit

> Research date: 2026-07-23
> Context: ClarityRev revenue intelligence startup, evaluating 25 B2B niches (European/Benelux focus)
> Existing stack: Firecrawl (100K credits), DataForSEO ($50), Context7 MCP, 15+ MCP servers, BuiltWith, Wappalyzer, Hunter.io, Reddit API, OpenAlex, Apollo.io free tier

---

## PART 1: SEMRUSH / AHREFS ALTERNATIVES

---

### 1.1 Serper.dev
- **URL:** https://serper.dev
- **Type:** API (freemium)
- **Free tier limits:** 2,500 queries (one-time, not monthly). No credit card required. Supports web, images, news, maps, places, videos, shopping, scholar, patents, autocomplete. ~1-2s latency.
- **Commercial use:** Allowed (standard API ToS)
- **Sufficiency for 25 niches:** INSUFFICIENT for sustained use — 2,500 is a one-time trial, not recurring. Enough for one-off research across 25 niches (at ~100 calls per niche), but not for ongoing monitoring.
- **Data freshness:** Real-time Google SERP data
- **Deprecation risk:** LOW — well-established, popular with AI/agent ecosystem (n8n, LangChain integrations)
- **Notes:** Best one-shot free tier to get started. Popular for AI agent integrations. No monthly recurring free credits — once you burn through the 2,500, you pay.

---

### 1.2 SERPJET
- **URL:** https://serpjet.io
- **Type:** API (freemium)
- **Free tier limits:** 1,000 searches/month (recurring, resets monthly). No credit card required. 10 result types: web, images, videos, news, shopping, maps, places, scholar, patents, autocomplete.
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** BORDERLINE — 1,000/month split across 25 niches = ~40 calls per niche per month. Enough for basic periodic checks, not for deep initial research on all niches simultaneously. Fine for ongoing monitoring of priority niches.
- **Data freshness:** Real-time
- **Deprecation risk:** LOW-MEDIUM — newer entrant but gaining traction
- **Notes:** Best recurring free tier. The 1,000/month is genuine and doesn't require a card. This could serve as a long-term free SERP source for monitoring.

---

### 1.3 Scrapeless Deep SerpApi
- **URL:** https://www.scrapeless.com
- **Type:** API (freemium)
- **Free tier limits:** 2,000 free API calls to start (one-time). Covers 20+ Google surfaces (Search, Maps, News, Scholar, Flights, Trends, Hotels, Jobs, Lens). Paid: $1.05/1K queries after free tier.
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** INSUFFICIENT for sustained use — 2,000 is one-time. Good for a single deep research pass across all 25 niches (80 calls/niche).
- **Data freshness:** Real-time
- **Deprecation risk:** MEDIUM — newer platform, less established
- **Notes:** Broadest Google surface coverage of any free SERP API. Good for a one-time research sprint.

---

### 1.4 SerpApi (free tier)
- **URL:** https://serpapi.com
- **Type:** API (freemium)
- **Free tier limits:** 100 searches/month (recurring). Paid plans from $25/month for 1,000 searches. Most mature SERP API with broadest engine coverage.
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** INSUFFICIENT — only 100 searches/month is too few for 25 niches. Could use for selective spot checks on 3-4 priority niches.
- **Data freshness:** Real-time
- **Deprecation risk:** LOW — most established dedicated SERP API
- **Notes:** 100/month is very limited, but SerpApi is used as the data backend for many other tools (e.g., Apify's Keyword Difficulty Checker). If you already have it for one tool, you can multi-purpose.

---

### 1.5 OpenSEO
- **URL:** https://github.com/every-app/open-seo
- **Type:** Open source (MIT license) — self-hosted
- **Free tier limits:** The software itself is free and open source. Self-host via Docker (local) or Cloudflare (free tier). BUT it requires a DataForSEO API key for actual SEO data. DataForSEO: $1 free credit on signup, then $50 minimum deposit.
- **Commercial use:** Allowed (MIT license)
- **Sufficiency for 25 niches:** SUFFICIENT — if you fund a DataForSEO account with $50. Example costs: 100 keyword research requests at 150 results ≈ $3.50. 100 backlink domain searches ≈ $6.34. For ~$25-30 of DataForSEO credit you could complete initial research across 25 niches. Ongoing monitoring would cost per-query.
- **Data freshness:** As fresh as DataForSEO data (updated regularly)
- **Deprecation risk:** LOW-MEDIUM — 3,500+ GitHub stars, active development, TypeScript/TypeScript ecosystem. Risk is tied to DataForSEO API availability.
- **Notes:** The standout open source SEO suite. MIT licensed, Docker/Cloudflare deploy, MCP server for AI agent integration. Pre-built "Agent Skills" for keyword research, clustering, competitive analysis. The architecture (free software + pay-for-data) is the most viable long-term free SEO stack.

---

### 1.6 DataSEO MCP / SEO Research MCP
- **URL:** https://github.com/egebese/dataseo-mcp
- **Type:** Open source MCP server — free
- **Free tier limits:** Completely free. Uses Ahrefs' free tools/data as backend. Provides: `get_backlinks_list(domain)` returning domain rating, backlink count, referring domains, anchor text; also keyword research and traffic estimation.
- **Commercial use:** Allowed (MIT license)
- **Sufficiency for 25 niches:** SUFFICIENT for backlink analysis (free, no API key needed). The Ahrefs free data layer is generous enough for initial competitive backlink research across 25 niches.
- **Data freshness:** Dependent on Ahrefs free data update cadence
- **Deprecation risk:** MEDIUM — relies on Ahrefs' continued free tool availability; Ahrefs could restrict access. GitHub repo is early-stage.
- **Notes:** Excellent for zero-cost backlink analysis. Integrates as MCP server directly into Claude Code or any MCP-compatible IDE. No API keys required for core functions.

---

### 1.7 Google Search Console API
- **URL:** https://developers.google.com/webmaster-tools
- **Type:** Free API (requires verified site ownership)
- **Free tier limits:** Completely free. Generous quotas: 30M queries/day per project, 1,200 queries/minute per site, 50K data rows/day per search type per property. 16-month historical data limit.
- **Commercial use:** Allowed (Google ToS)
- **Sufficiency for 25 niches:** SUFFICIENT — but only for sites you own. Cannot research competitor sites. For your own properties (e.g., ClarityRev website), you get top-tier search analytics, keyword performance, CTR, impressions, average position data for free.
- **Data freshness:** ~2-3 day delay (not real-time)
- **Deprecation risk:** LOW — core Google product, unlikely to be deprecated
- **Notes:** Essential free tool for monitoring your own site's SEO performance. Not useful for competitor research. No keyword difficulty scores. Combine with open source tools for the gaps.

---

### 1.8 Screaming Frog SEO Spider (Free Tier)
- **URL:** https://www.screamingfrog.co.uk/seo-spider/
- **Type:** Desktop application (free tier)
- **Free tier limits:** Crawls up to 500 URLs per crawl. No signup required. Advanced features restricted (JavaScript rendering, custom extraction, API integrations, GA/GSC/PSI integrations, crawl saving, comparison, scheduled crawls).
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** BORDERLINE — 500 URL limit per crawl is fine for small site audits but restrictive for larger competitor sites. For initial technical SEO audits of niche competitors (small-medium sites), it works. For enterprise competitor sites (thousands of pages), the paid license at EUR 245/year is needed.
- **Data freshness:** As of crawl time
- **Deprecation risk:** LOW — very mature tool (15+ years), actively maintained
- **Notes:** Industry standard for technical SEO auditing. The 500-URL free tier is genuinely useful for small-to-medium site audits. No API, so manual/automated via scripting is limited on free tier.

---

### 1.9 keywords_research_generator (Flutter package)
- **URL:** https://pub.dev/packages/keywords_research_generator
- **Type:** Open source Flutter/Dart library
- **Free tier limits:** 100% free-tier APIs — Google Autocomplete (500-1000 phrases/seed), Datamuse (no API key), Google Trends (no API key), Wikipedia (no API key), Google Search Console (free OAuth). Provides search volume estimates, SEO difficulty scores (0-100), CPC estimates, search intent classification.
- **Commercial use:** Allowed (open source license)
- **Sufficiency for 25 niches:** SUFFICIENT — all data sources are genuinely free and have high rate limits. Google Autocomplete alone can generate thousands of keyword ideas per niche. Accuracy of volume/difficulty estimates is lower than professional tools.
- **Data freshness:** Real-time for trends/autocomplete; GSC data has ~2-3 day delay
- **Deprecation risk:** LOW — individual API sources are stable. If one source changes, only that provider needs replacing.
- **Notes:** Smart architecture — uses Google's own free APIs (Autocomplete, Trends) to infer keyword data. Volume estimates are inferred (not exact), but good enough for niche sizing. Would need to be used programmatically or adapted for your Python/Node stack.

---

### 1.10 RankForge API
- **URL:** https://www.toolify.ai/openclaw-skills/rankforge-9139
- **Type:** API (freemium)
- **Free tier limits:** 100 requests/day free. Includes keyword research, keyword difficulty scoring, full audit analysis.
- **Commercial use:** Allowed (check ToS)
- **Sufficiency for 25 niches:** BORDERLINE — 100 requests/day = ~3,000/month. If each niche needs 20-40 keyword difficulty checks, that's ~500-1,000 checks total for initial research — doable in a few days of free tier.
- **Data freshness:** Real-time
- **Deprecation risk:** MEDIUM — smaller provider, less well-known
- **Notes:** Generous daily free limit. Good for batch keyword research and difficulty scoring. API key via email registration.

---

### 1.11 Apify Keyword Difficulty Checker
- **URL:** https://apify.com/groupoject/keyword-difficulty-checker
- **Type:** Apify Actor (pay-per-event)
- **Free tier limits:** NOT free on Apify side ($0.50/1K results). Requires a SerpApi key — SerpApi free tier gives 100 searches/month. So you can run 100 keyword difficulty checks/month for free (if you already have a free SerpApi key).
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** INSUFFICIENT — 100 checks/month spread across 25 niches = 4 checks per niche. Enough for a quick pulse check, not for deep keyword research.
- **Data freshness:** Live SERP data via SerpApi
- **Deprecation risk:** LOW — Apify is well-established
- **Notes:** Best understood as a value-add if you already have SerpApi. The free tier via SerpApi's 100/month makes this a niche supplement, not a primary tool.

---

### 1.12 BabbarMCP
- **URL:** https://github.com/BabbarTech/BabbarMCP
- **Type:** Open source MCP server (MIT license)
- **Free tier limits:** Code is free and open source. BUT requires a Babbar.tech API key for live data — Babbar is a paid service (no transparent free tier found).
- **Commercial use:** Allowed (MIT license)
- **Sufficiency for 25 niches:** NOT APPLICABLE without paid Babbar subscription
- **Deprecation risk:** MEDIUM — depends on Babbar.tech viability
- **Notes:** Included for completeness. The MCP server pattern is interesting, but data costs mean it's not truly free. Only use if Babbar's pricing works for you.

---

### 1.13 BacklinkLog SDK
- **URL:** https://packagist.org/packages/backlinklog/sdk
- **Type:** Open source PHP SDK — genuinely free
- **Free tier limits:** No API key required. Provides access to an open public directory of domains. Supports domain search, recently added domains, keyword filtering.
- **Commercial use:** Allowed (check license)
- **Sufficiency for 25 niches:** BORDERLINE — useful for discovering domains in a niche (which domains have backlinks from specific sources), but data depth is limited to the public directory. Not a full backlink profile analysis tool.
- **Data freshness:** Unknown (depends on directory update frequency)
- **Deprecation risk:** MEDIUM-HIGH — limited adoption, PHP-only SDK
- **Notes:** Niche utility. Genuinely free with no API key. Limited scope — useful as a supplementary signal, not a primary backlink analysis tool.

---

### 1.14 Tourist (Open Source SERP)
- **URL:** https://github.com/pogzyb/tourist
- **Type:** Open source self-hosted (serverless)
- **Free tier limits:** Free to deploy on your own infrastructure (Docker, AWS, Azure). Uses DuckDuckGo + Selenium for SERP extraction. No third-party data costs. Infrastructure costs are your own (serverless, so minimal for low volume).
- **Commercial use:** Allowed (check license)
- **Sufficiency for 25 niches:** BORDERLINE — free to run, but DuckDuckGo results are less accurate than Google SERP for SEO research. Infrastructure costs at 25K calls would be a few dollars on AWS Lambda. Early-stage project — API may break.
- **Data freshness:** Live
- **Deprecation risk:** HIGH — "early development" explicitly stated, 25 GitHub stars, 118 commits. API may change unexpectedly.
- **Notes:** Interesting concept — self-hosted SERP with no third-party data costs. Not production-ready yet. Worth watching for future use, but don't depend on it now.

---

### 1.15 Free Keyword Difficulty Estimator (Ottawa SEO)
- **URL:** https://ottawaseo.com/tools/keyword-difficulty-estimator/
- **Type:** Free web tool + public API
- **Free tier limits:** Completely free, no signup, no email. No logging of inputs. Uses SERP feature density, top-10 domain authority distribution, and intent type. Open methodology.
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** INSUFFICIENT as primary tool — no bulk API, designed for one-off checks. Fine for occasional spot-checks on specific keywords.
- **Data freshness:** Real-time
- **Deprecation risk:** MEDIUM — individual tool from a consultancy
- **Notes:** Useful for quick manual checks. No bulk/batch capability makes it impractical for programmatic use across 25 niches.

---

## PART 2: CLEARBIT ALTERNATIVES

---

### 2.1 Apify — Website Company Enricher
- **URL:** https://apify.com/great_pistachio/website-company-enricher
- **Type:** Open source Apify Actor (ISC license)
- **Free tier limits:** Pay-per-event on Apify platform: ~$0.25-$0.50 per 100 domains. No recurring free tier. Open source code is freely available. Extracts: company name, emails, phones, social links (LinkedIn, Twitter, Crunchbase, GitHub), tech stack (55+ technologies), address, logo, favicon.
- **Commercial use:** Allowed (ISC license)
- **Sufficiency for 25 niches:** SUFFICIENT — 25 niches × ~20 companies per niche = 500 domains. At ~$0.25-0.50/100 domains, total cost: ~$1.25-2.50. Very cheap for a complete company enrichment dataset.
- **Data freshness:** Live crawl — as fresh as the crawl
- **Deprecation risk:** LOW — open source, can self-host if Apify platform changes
- **Notes:** Best overall Clearbit alternative for company enrichment. Open source so no lock-in. Tech stack detection (55+ technologies) is a bonus for competitive intelligence. Output is structured JSON.

---

### 2.2 Scala API (Company Data)
- **URL:** https://score.get-scala.com (inferred)
- **Type:** API (freemium)
- **Free tier limits:** 50 lookups/month free. No API key needed for basic lookups. 250M+ company records from 40+ government registries. Returns: company name, country, revenue, employees, credit score, legal form, VAT, contacts.
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** INSUFFICIENT — 50 lookups/month is too few for initial research across 25 niches (needs 500-1,000). Fine for spot-checking specific companies.
- **Data freshness:** Government registry data (updated as registries update)
- **Deprecation risk:** MEDIUM — smaller/lesser-known provider
- **Notes:** Good for European company data (40+ government registries). No API key needed for basic lookups is unusual and valuable. CLI tools available: `npx enrich-companies` or `pip install enrich-companies`.

---

### 2.3 GoCreative Company Enrich
- **URL:** https://www.npmjs.com/package/gocreative-company-enrich
- **Type:** npm package (freemium)
- **Free tier limits:** 5 calls/day per IP (no API key needed). Enriches company from domain: name, description, industry, employees, socials, tech stack. Full SDK covers 145+ endpoints.
- **Commercial use:** Allowed (check license)
- **Sufficiency for 25 niches:** INSUFFICIENT — 5 calls/day × 30 days = 150 calls/month. Spread across 25 niches = 6 companies per niche. Only enough for basic validation, not comprehensive research.
- **Data freshness:** Live
- **Deprecation risk:** MEDIUM — limited adoption
- **Notes:** Interesting no-API-key approach. 5/day is extremely limiting but could be useful as a secondary enrichment source. No attribution required.

---

### 2.4 @tofuhq/enrich
- **URL:** https://www.npmjs.com/package/@tofuhq/enrich
- **Type:** CLI/npm package (freemium)
- **Free tier limits:** Free tier with credit-based pricing. Credits only consumed on successful data returns (no result = no charge). CLI enrichment commands: `enrich company get stripe.com --fields headcount,funding` and `enrich company search --where 'country in US' --where 'employees < 1000'`. Batch CSV enrichment.
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** BORDERLINE — depends on exact free tier limits (not clearly published). The "no-result-no-charge" model is fair. Designed for AI agent workflows. Worth testing.
- **Data freshness:** Live
- **Deprecation risk:** MEDIUM — newer entrant
- **Notes:** Built for AI-agent-driven enrichment. The search/filter capability (by country, employee count) is unique among free options — allows niche filtering before enrichment.

---

### 2.5 Company Researcher (exa-labs)
- **URL:** https://github.com/exa-labs/company-researcher
- **Type:** Open source
- **Free tier limits:** Completely free and open source. Gathers company info from: websites, LinkedIn, Crunchbase, PitchBook, funding data, news, social media, Wikipedia, GitHub, YouTube, Reddit. Input a company URL → comprehensive research output.
- **Commercial use:** Allowed (check license)
- **Sufficiency for 25 niches:** SUFFICIENT — free, self-hosted, pulls from multiple public sources. The multi-source approach (Wikipedia + LinkedIn + Crunchbase + news) provides richer company intelligence than single-source APIs.
- **Data freshness:** Live — pulls from current web sources
- **Deprecation risk:** MEDIUM — scraping approaches may break when target sites change. Requires maintenance.
- **Notes:** The multi-source aggregation approach is powerful. Combines data from 10+ public sources into one output. Self-hosted so no API costs. Good for deep company research on shortlisted companies, not for bulk enrichment of hundreds of companies.

---

### 2.6 NinjaPear Logo API
- **URL:** https://nubela.co/blog/introducing-logo-api-the-definitive-and-free-alternative-to-clearbits-deprecated-logo-api/
- **Type:** API (free forever)
- **Free tier limits:** Completely free forever. 300 requests/minute (~12.96M/month). No attribution required. PNG output. Simple: `curl https://nubela.co/api/v1/company/logo?website=stripe.com`
- **Commercial use:** Allowed — no attribution required
- **Sufficiency for 25 niches:** SUFFICIENT — effectively unlimited for your use case. 12.96M requests/month is far beyond what you'd need for 25 niches.
- **Data freshness:** On-demand
- **Deprecation risk:** MEDIUM — single-purpose API from a company (Nubela). If they discontinue it, there's no SLA. But it's been running since Clearbit Logo API shutdown.
- **Notes:** Best free logo API for 2026. No attribution, no credit card, essentially unlimited. PNG format only. Use when you need company logos for dashboards/reports across your 25 niches.

---

### 2.7 Brandfetch Logo API
- **URL:** https://brandfetch.com
- **Type:** API (free forever)
- **Free tier limits:** Free forever for logo access. 500,000 requests/month (soft limit). No attribution required for free tier. SVG + PNG output. Also returns brand colors, fonts, design assets. 60M+ brands covered.
- **Commercial use:** Allowed — no attribution required
- **Sufficiency for 25 niches:** SUFFICIENT — 500K requests/month is more than enough. SVG logos are a bonus for high-quality rendering.
- **Data freshness:** Regularly updated brand database
- **Deprecation risk:** LOW-MEDIUM — Brandfetch is an established brand asset platform
- **Notes:** Better than NinjaPear if you need SVG (vector) logos. Also provides brand identity data (colors, fonts) which could be useful for competitor brand analysis across your niches.

---

### 2.8 Hunter.io Company Logo API
- **URL:** https://hunter.io/changelog/company-logo-api-free/
- **Type:** API (completely free)
- **Free tier limits:** Completely free, no signup, no API key required. 16M+ company logos. Simple URL format: `https://logos.hunter.io/{domain}`
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** SUFFICIENT — no rate limits published, no API key needed. Use as a fallback or primary logo source.
- **Data freshness:** Live
- **Deprecation risk:** LOW-MEDIUM — Hunter.io is well-established. This is a free add-on to their paid email service.
- **Notes:** Simplest integration — zero setup, just a URL pattern. 16M logos covers most companies you'd research. No authentication means it's easily embedded.

---

### 2.9 Logo.dev
- **URL:** https://logo.dev
- **Type:** API (freemium)
- **Free tier limits:** 500,000 requests/month free. BUT **mandatory attribution required** on free tier (visible link back to Logo.dev). Paid from $400/year to remove attribution. SVG, PNG, dark mode support.
- **Commercial use:** Allowed, but with attribution
- **Sufficiency for 25 niches:** SUFFICIENT for internal dashboards. NOT suitable for client-facing products without attribution.
- **Data freshness:** Well-maintained brand database
- **Deprecation risk:** LOW — officially positioned as Clearbit Logo API successor
- **Notes:** Most feature-rich free logo API (SVG, dark mode, PNG, 50M companies). The attribution requirement is the main downside. If you're building internal tools or research databases where attribution is fine, this is excellent.

---

### 2.10 Enrow (Email Finder)
- **URL:** https://enrow.io
- **Type:** API (freemium)
- **Free tier limits:** 50 email credits/month + 200 verifications/month. Credits consumed only on successful finds (failed lookups don't cost). No credit card required for free tier. 1 credit = 1 valid email.
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** BORDERLINE — 50 emails/month is enough for spot-testing email patterns across niches (2 emails/niche/month), not enough for bulk email enrichment. Good for validation/testing.
- **Data freshness:** Live verification
- **Deprecation risk:** LOW-MEDIUM — growing tool with positive reviews
- **Notes:** Pay-per-success model is transparent. Triple verification including catch-all detection. Integrates with Instantly, MillionVerifier workflows. Good complement to Hunter.io.

---

### 2.11 Prospeo (Email Finder)
- **URL:** https://prospeo.io
- **Type:** API (freemium)
- **Free tier limits:** 75 email credits/month API + 100 Chrome extension credits/month. Full enrichment (50+ data points per contact). No credit card required. 98% email accuracy (5-step verification). Database: 300M+ professional profiles, 143M+ verified emails.
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** BORDERLINE — 75/month is slightly more generous than Enrow but still insufficient for bulk enrichment across 25 niches. Enough for ~3 niche deep-dives per month.
- **Data freshness:** 7-day refresh cycle (industry average is 4-6 weeks)
- **Deprecation risk:** LOW-MEDIUM — established platform
- **Notes:** Best data freshness among free email finders (7-day refresh vs industry 4-6 weeks). 50+ data points per contact is comprehensive. Good integration with enrichment workflows.

---

### 2.12 Tomba.io (Email Finder)
- **URL:** https://tomba.io
- **Type:** API (freemium)
- **Free tier limits:** 25 searches/month + 50 verifications/month. API access included. Endpoints: Domain Search, Email Finder, Email Verifier, Email Enrichment, Author Finder, LinkedIn Finder.
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** INSUFFICIENT — 25 searches/month is too low for meaningful cross-niche research. Fine for one-off lookups.
- **Data freshness:** Live
- **Deprecation risk:** LOW — established (7+ years in market)
- **Notes:** Client libraries for Go, PHP, R, Deno, Python. Good developer experience, but the free tier is very limited compared to Enrow (50) or Prospeo (75).

---

### 2.13 Kaspr (Contact Data)
- **URL:** https://kaspr.io
- **Type:** API/Extension (freemium)
- **Free tier limits:** 15 B2B email credits/month + 5 phone credits/month + 5 direct email credits/month. No credit card required. LinkedIn Chrome extension included. CRM integrations (Salesforce, HubSpot, Pipedrive, Zoho).
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** INSUFFICIENT — 15 emails/month is very low. Not enough for any meaningful research volume.
- **Data freshness:** Live
- **Deprecation risk:** LOW-MEDIUM — well-funded, growing
- **Notes:** Free tier is too restrictive for your use case. Primarily a LinkedIn extension tool, not an API-first enrichment platform.

---

### 2.14 @absolutejs/enrich (Open Source Email Finder)
- **URL:** https://www.npmjs.com/package/@absolutejs/enrich
- **Type:** Open source (BSL 1.1 → Apache 2.0 in 2030)
- **Free tier limits:** Completely free, self-hosted. Performs local MX/SMTP/catch-all verification and pattern-based email finding. No paid API dependency. Generates common corporate email patterns (first.last, etc.) and confirms deliverability via SMTP probing.
- **Commercial use:** Allowed (BSL 1.1 — check terms, converts to Apache 2.0)
- **Sufficiency for 25 niches:** SUFFICIENT — no per-call costs. Self-hosted so you can run unlimited email pattern discovery. SMTP probing requires outbound port 25 access.
- **Data freshness:** Live verification
- **Deprecation risk:** MEDIUM — SMTP probing risks IP blacklisting. Requires maintenance. Single developer project (last updated June 2026).
- **Notes:** The only genuinely free, unlimited email finder. Trade-off: SMTP probing (connecting to target mail servers to verify) can get your IP blacklisted if done at scale. Use with proxy rotation or rate limiting. Best for low-volume, high-accuracy needs. Excellent for validating email patterns discovered via other means.

---

### 2.15 B2B Enrichment MCP
- **URL:** https://github.com/Aleksey-Panf/b2b-enrichment-mcp
- **Type:** Open source MCP server
- **Free tier limits:** Free open source MCP server combining Hunter.io (50 email credits/month free) + Apollo.io company enrichment (unlimited on free plan for view-only). Tools: domain email discovery, email verification, company enrichment (headcount, funding, tech stack), person enrichment.
- **Commercial use:** Allowed (open source license)
- **Sufficiency for 25 niches:** BORDERLINE — combines the free tiers of Hunter + Apollo. Company enrichment is solid (unlimited company data views). Email finding limited to Hunter's 50/month. Good for company-level research, limited for contact-level enrichment.
- **Data freshness:** Live (via Hunter + Apollo)
- **Deprecation risk:** MEDIUM — depends on Hunter + Apollo free tier policies and MCP server maintenance
- **Notes:** Best for combining free company enrichment (Apollo) with email finding (Hunter) in one MCP interface. Company enrichment on Apollo is genuinely free and unlimited (viewing, not exporting). This is useful for building company profiles across your 25 niches.

---

### 2.16 Apollo.io Free Tier (Company + Contact Data)
- **URL:** https://apollo.io
- **Type:** Platform (freemium)
- **Free tier limits:** Free tier with 50-100 email credits/month (sources vary). Company browsing/search is free and unlimited. Viewing profiles costs no credits — only exporting (email = 1 credit, phone = 5 credits). 200M+ contact database. No API access on free tier.
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** BORDERLINE — company research (browsing profiles, building lists) is free and unlimited. Great for identifying which companies exist in each niche. Exporting contacts is severely limited by 50-100 credits/month. Use for niche discovery/validation, not for bulk contact acquisition.
- **Data freshness:** Good — Apollo actively maintains its database
- **Deprecation risk:** LOW — well-funded ($100M+ raised), major platform
- **Notes:** Apollo's free tier is actually quite useful for what you need: company discovery and qualification across niches. The 200M+ contact database is browsable freely. Use it to identify companies per niche, then use other free tools (Hunter, Enrow, Prospeo) for contact enrichment. No API access on free tier means manual or browser-automation workflows.

---

### 2.17 Hunter.io (Email Finder + Company Data)
- **URL:** https://hunter.io
- **Type:** API (freemium)
- **Free tier limits:** 50 unified credits/month (1 credit = 1 email found, 0.5 credits = 1 verification). Full API access included. Also: free Company Logo API (no key needed), free Email Verification API (limited usage).
- **Commercial use:** Allowed
- **Sufficiency for 25 niches:** BORDERLINE — 50 emails/month = ~2 emails per niche. Fine for pattern validation across niches, insufficient for bulk enrichment. Use for discovering email patterns per company (e.g., checking that companies in a niche use `first@company.com` format).
- **Data freshness:** Live
- **Deprecation risk:** LOW — established since 2017, reliable
- **Notes:** You already have Hunter.io. Its free tier is now 50 unified credits (restructured in 2026). Good for validating email naming conventions per niche. The free Logo API and Verification API are bonuses.

---

## PART 3: STRATEGIC RECOMMENDATIONS

### Recommended Free SEO Stack (No-Cost or Near-Zero)

| Layer | Tool | Cost | Purpose |
|-------|------|------|---------|
| SERP data | SERPJET | Free (1,000/mo recurring) | Ongoing SERP monitoring across niches |
| One-time deep research | Scrapeless | Free (2,000 one-time) | Initial SERP sweep across all 25 niches |
| Keyword research | Google Search Console API | Free (own sites) | Your own keyword performance |
| Keyword difficulty | RankForge API | Free (100/day) | Batch keyword difficulty scoring |
| Open source SEO suite | OpenSEO + DataForSEO $50 | $50 deposit | Keyword research, backlinks, rank tracking |
| Backlink analysis | DataSEO MCP | Free | Ahrefs-powered backlink data |
| Technical SEO | Screaming Frog (free tier) | Free | Small site technical audits |
| Keyword ideation | keywords_research_generator | Free | Google Autocomplete/Trends keyword expansion |

### Recommended Free Company Data Stack (No-Cost or Near-Zero)

| Layer | Tool | Cost | Purpose |
|-------|------|------|---------|
| Bulk company enrichment | Apify Website Company Enricher | ~$0.25/100 domains | Company details + tech stack for all niche companies |
| Company discovery | Apollo.io free tier | Free | Identify which companies exist in each niche |
| Company logos | Brandfetch (SVG) or NinjaPear (PNG) | Free | Logo display on dashboards/reports |
| Deep company research | Company Researcher (exa-labs) | Free | Multi-source intelligence on key companies |
| Email finding (low volume) | Hunter.io or Enrow | Free (50/mo) | Pattern validation, select contact enrichment |
| Self-hosted email finder | @absolutejs/enrich | Free (self-hosted) | Unlimited email pattern discovery |
| Company enrichment MCP | B2B Enrichment MCP | Free | Combined Apollo + Hunter in MCP interface |

### Cost Estimate for Initial 25-Niche Research

| Expense | Amount |
|---------|--------|
| SERPJET (free recurring) | $0 |
| Scrapeless (2,000 one-time) | $0 |
| DataForSEO initial deposit (for OpenSEO) | $50 (deposit, consumed gradually) |
| Apify Website Company Enricher (~500 domains) | ~$1.25-2.50 |
| Logo APIs (Brandfetch, NinjaPear) | $0 |
| Email hunting (Hunter + Enrow free tiers) | $0 |
| **Total initial cost** | **~$51.25-52.50** (mostly the DataForSEO deposit) |
| **Monthly recurring cost** | **~$0** (SERPJET, Apollo, GSC are free ongoing) |

### Key Risk: Free Tier Deprecation

- **Clearbit** (acquired by HubSpot) is the cautionary tale — every free API was shut down
- **Apollo.io** has been reducing free tier limits over time
- **Hunter.io** restructured from 25+50 to 50 unified credits in 2026
- **DataForSEO** increased prices ~20% in July 2026
- **Mitigation:** Prefer open source self-hosted options (OpenSEO, Website Company Enricher, @absolutejs/enrich) where possible to avoid vendor lock-in
