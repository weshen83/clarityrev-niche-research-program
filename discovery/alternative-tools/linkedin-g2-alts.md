# C1d: Free Alternatives to LinkedIn Sales Navigator + Owler/G2

> Research date: 2026-07-23
> Context: Direct research

## PART 1: LINKEDIN SALES NAVIGATOR ALTERNATIVES

### 1.1 Official LinkedIn API (Free)
- **Available:** Two free self-serve products only:
  - **Sign In with LinkedIn (OpenID Connect):** Returns basic profile info (name, headline, photo, email). Uses `openid`, `profile`, `email` scopes. Old `r_liteprofile` deprecated Aug 2023.
  - **Share on LinkedIn** (`w_member_social`): Post/comment/like on own profile.
- **Not available without partner approval:** Sales Navigator, Community Management, Advertising, Talent Solutions APIs. All require partnership with custom pricing.
- **Verdict:** NOT useful for professional data research.

### 1.2 CommonRoom
- **Free tier:** 500 contacts, 50 organizations. Coverage: ~60% org coverage, ~30% job title coverage for sample test
- **Verdict:** BORDERLINE -- limited but real free tier. Manual export only (no programmatic) on free plan.

### 1.3 LinkedIn Scraping -- LEGAL NOTE
- **Proxycurl:** Launched ~2021, reached ~$10M ARR. Sued by Microsoft/LinkedIn Jan 2025. Shut down July 4, 2025. Founder: "Regardless of the merits of LinkedIn's lawsuit, there is no winning in fighting this."
- **Legal risk:** While hiQ vs LinkedIn (9th Cir) found scraping public data may not violate CFAA, LinkedIn enforces via contract law. Any scraping-based LinkedIn data tool carries existential legal risk.
- **Verdict:** AVOID building on or depending on LinkedIn-sourced data.

### 1.4 Apollo.io as LinkedIn Alternative
- We already have this. 200M+ contact database. Free tier: unlimited browsing, ~50 exports/month.
- Best safe alternative for professional search data.

## PART 2: G2 REVIEWS & COMPETITIVE INTELLIGENCE

### 2.1 Gralio SaaS Database (MCP)
- **URL:** https://cursormcp.dev/mcp-servers/582-gralio-saas-database
- **Type:** Free MCP endpoint
- **Free tier limits:** 3M+ SaaS reviews. Includes pricing, funding, alternatives, sentiment data. Free MCP access.
- **Verdict:** BEST FREE OPTION for SaaS review data.

### 2.2 omkarcloud/g2-scraper (GitHub)
- **Type:** Open source (MIT, 48 stars)
- **Free tier limits:** Self-hosted TypeScript scraper. G2 products, descriptions, reviews, ratings, comparisons, alternatives.
- **Verdict:** SUFFICIENT -- can run unlimited self-hosted

### 2.3 Decodo G2 Scraper API
- **Free tier:** 2,000 requests/month. Managed service (handles JS rendering, CAPTCHA, proxies).
- **Verdict:** BORDERLINE -- 2K/mo might be enough for initial pass

### 2.4 Advanced-G2-Scraper (RapidAPI)
- **Free tier:** API key on RapidAPI. G2 products, vendors, reviews, user profiles. RESTful JSON.
- **Verdict:** BORDERLINE -- depends on RapidAPI free tier limits

### 2.5 ReviewHook
- **Type:** Unified multi-platform review API (G2 + others)
- **Status:** Free beta. Good for monitoring reviews across platforms.
- **Verdict:** Worth testing

### 2.6 Outscraper MCP
- **Type:** Open source MCP server. 25+ extraction tools including G2 Reviews.
- **Verdict:** USEFUL -- MCP-native, fits our stack

### 2.7 Product Hunt API
- **Type:** Official free API
- **Data:** Product launches, upvotes, comments, makers, topics
- **Verdict:** Free, official, good for product intelligence

### 2.8 Trustpilot API
- **Type:** Free tier for business reviews
- **Note:** Commercial licensing may apply. Check terms.
- **Verdict:** Supplementary

### 2.9 News Monitoring for Competitive Intel
- **NewsAPI:** 100 requests/day free. Sources: major news outlets. Good for company news tracking.
- **GNews API:** 100 requests/day free. Google News access. Alternative to NewsAPI.
- **RSS feeds:** Free, unlimited via Firecrawl scraping.
- **Verdict:** SUPPLEMENTARY -- can build company monitoring workflows with Firecrawl

## SUMMARY: LINKEDIN + G2 FREE STACK

**Professional data:** Apollo.io free + CommonRoom free (no LinkedIn scraping risk)
**SaaS reviews:** Gralio MCP (free) + Product Hunt API (free official)
**Review scraping fallback:** omkarcloud/g2-scraper self-hosted or Decodo 2K/mo
**News monitoring:** NewsAPI 100/day + RSS feeds via Firecrawl
