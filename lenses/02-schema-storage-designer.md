# DATA ARCHITECTURE — 25-Niche Evaluation Operations

**Lens 2: Schema & Storage Designer**
**Date:** 2026-07-23
**Status:** DESIGN — not yet validated against real data

---

## TABLE OF CONTENTS

1. [Directory Structure](#1-directory-structure)
2. [Schema Specifications](#2-schema-specifications)
3. [Traceability Pattern](#3-traceability-pattern)
4. [File Naming Convention](#4-file-naming-convention)
5. [Cross-Agent Sharing Pattern](#5-cross-agent-sharing-pattern)
6. [Adversarial Verdict](#6-adversarial-verdict)

---

## 1. DIRECTORY STRUCTURE

### Design Principles

- **Predictability**: Any agent, given a niche ID and a data type, can compute the save/find path without asking.
- **Separation of concerns**: Raw fetched content, structured processed data, niche-specific outputs, and cross-niche reference data live in separate trees.
- **Scalability**: Adding niche 26 requires adding one directory. No existing structure reorganisation.
- **Versioning**: Every processed file carries a version tag. Overwrites are explicit.
- **Canonical paths**: One path is authoritative for each data type. No ambiguous locations.

### Top-Level Architecture

```
research/niche-program/                  ← ROOT: all 25-niche evaluation data
  ├── SHARED/                            ← Cross-niche reference data (read-only to agents)
  │   ├── README.md                      ← What SHARED contains and how to use it
  │   ├── benchmarks/
  │   │   ├── SaaS-pricing-bands-v1.yaml      ← Calibrated pricing bands per revenue tier
  │   │   ├── company-counts-by-segment-v1.yaml
  │   │   └── employee-count-brackets-v1.yaml
  │   ├── competitors/
  │   │   ├── master-competitor-list-v1.yaml   ← All competitors across all niches, deduplicated
  │   │   ├── usergems-v1.yaml                 ← Cross-niche competitor profile (reusable across niches)
  │   │   ├── syncgtm-v1.yaml
  │   │   ├── gong-v1.yaml
  │   │   └── index.yaml                      ← Which competitor profiles exist, which niches reference them
  │   ├── regulatory/
  │   │   ├── gdpr-applicability-v1.yaml       ← GDPR findings applicable to all niches
  │   │   └── ai-act-scope-v1.yaml
  │   ├── tools/
  │   │   ├── tool-inventory-v1.yaml           ← Canonical tool/capability index
  │   │   └── tool-categories-v1.yaml
  │   ├── taxonomy/
  │   │   ├── niche-categories-v1.yaml         ← The 25+ niche category taxonomy with definitions
  │   │   ├── signal-types-v1.yaml             ← Standard signal type taxonomy
  │   │   └── buyer-role-taxonomy-v1.yaml      ← Standard buyer role definitions
  │   └── triggers/
  │       ├── triggers-catalog-v1.yaml         ← Cross-niche trigger registry
  │       └── trigger-frequency-benchmarks-v1.yaml
  │
  ├── N-001/                                   ← Niche directory (repeat for N-002 .. N-025)
  │   ├── _meta.yaml                           ← Niche metadata: name, category, status, lead agent
  │   ├── 01-company-discovery/
  │   │   ├── companies-v2.yaml               ← Discovered companies in this niche
  │   │   ├── company-index-v1.csv            ← Flat index for spreadsheet export
  │   │   └── discovery-log-v1.yaml           ← What queries were used, what was excluded
  │   ├── 02-competitor-intel/
  │   │   ├── competitors-v2.yaml             ← Competitor profiles specific to this niche
  │   │   └── competitor-gaps-v1.yaml         ← Gaps identified after competitor analysis
  │   ├── 03-market-sizing/
  │   │   ├── market-size-v1.yaml             ← TAM/SAM/SOM estimates with data sources
  │   │   ├── buyer-count-estimate-v1.yaml    ← Number of potential buyers
  │   │   └── pricing-benchmarks-v1.yaml      ← Pricing anchors collected for this niche
  │   ├── 04-voice-of-customer/
  │   │   ├── review-corpora-v2.yaml          ← Structured review data (G2, Capterra, etc.)
  │   │   ├── voc-quotes-v1.yaml              ← Verbatim buyer quotes with source URLs
  │   │   ├── voc-patterns-v1.yaml            ← Language patterns extracted from VOC
  │   │   └── community-signals-v1.yaml       ← Reddit/HN/Slack community mentions
  │   ├── 05-signal-feasibility/
  │   │   ├── signal-feasibility-v1.yaml      ← What signals can be detected, how reliably
  │   │   ├── data-sources-probed-v1.yaml     ← Which data sources were tested & results
  │   │   └── signal-cost-estimate-v1.yaml    ← Cost per signal per source
  │   ├── 06-technographic/
  │   │   ├── technographic-profiles-v1.yaml  ← Tech stacks of actors in this niche
  │   │   └── tool-adoption-patterns-v1.yaml  ← Which tools are dominant
  │   ├── 07-buyer-insight/
  │   │   ├── buyer-personas-v1.yaml          ← Structured buyer profiles
  │   │   ├── buying-process-v1.yaml          ← How purchasing happens in this niche
  │   │   └── decision-criteria-v1.yaml       ← What buyers prioritise
  │   ├── 08-pricing/
  │   │   ├── competitor-pricing-v1.yaml      ← Pricing data for this niche's competitors
  │   │   ├── wtp-evidence-v1.yaml            ← Willingness-to-pay data points
  │   │   └── price-anchors-v1.yaml           ← Specific EUR anchors from competitor surfaces
  │   ├── _canvas/
  │   │   ├── niche-canvas-v1.yaml            ← The completed RIOS canvas for this niche
  │   │   └── canvas-audit-v1.yaml            ← Quality audit of the canvas (traceability check)
  │   └── _work/
  │       ├── query-log-v1.yaml               ← All Firecrawl/DataForSEO queries run for this niche
  │       └── agent-notes-v1.yaml             ← Agent observations, dead ends, hunches
  │
  ├── CALIBRATION/                            ← Calibration niche (N-000)
  │   ├── _meta.yaml
  │   ├── 01-company-discovery/
  │   ├── ... (same structure as N-XXX)
  │   └── _canvas/
  │       ├── calibration-canvas-v1.yaml
  │       └── calibration-report-v1.yaml      ← How actual results compare to expected
  │
  ├── _pipelines/                             ← Processing pipeline scripts & manifests
  │   ├── raw-to-structured/
  │   │   └── firecrawl-to-yaml.yaml          ← Manifest file: .firecrawl/FILE → N-XXX/XX-*/FILE
  │   ├── cross-niche-merge/
  │   │   └── competitor-dedup-manifest.yaml  ← Rules for merging competitor data across niches
  │   └── canvas-audit/
  │       └── traceability-check-procedure.md ← Automated audit steps
  │
  └── _program/
      ├── program-status-v1.yaml              ← Overall progress: which niches are at which stage
      ├── cross-niche-patterns-v1.yaml         ← Patterns detected across multiple niches
      ├── niche-rankings-v1.yaml               ← How niches compare on standardised criteria
      └── session-2026-07-23/                  ← Dated program session directories
          └── ...
```

### Key Structural Decisions

**Why `research/niche-program/` instead of nesting inside `strategy/`?**
- Research data grows large (25 niches x 12 data types). Keeping it under `research/` keeps it separate from strategy/decision artifacts. The canvases in `_canvas/` are the bridge between data and strategy.

**Why `SHARED/` and not symlinks?**
- Symlinks break across platforms and confuse agents. SHARED/ is a physical directory. Agents copy from SHARED/ into their niche context as needed, or reference SHARED/ paths explicitly.

**Why `_work/` inside each niche?**
- Agents need somewhere to log partial results, dead-ends, and observations that are NOT structured data. The leading underscore signals "not a data type, not validated."

**Why `_pipelines/` at the top level?**
- Processing scripts (raw -> structured, cross-niche merge, audit) operate across multiple niches. Placing them in each niche would duplicate and drift. One central pipeline directory with clear manifests.

**Why numbered subdirectories (01-company-discovery, etc.)?**
- Numeric ordering ensures consistent sort across filesystems and tools. The numbers are the recommended evaluation sequence but not mandatory — agents can skip or reorder.

---

## 2. SCHEMA SPECIFICATIONS

Each schema below is defined as JSON Schema (draft-07) with: required fields, optional fields, field types, and example values.

### 2.1 Competitor Profile Schema (`competitor-profile-schema.json`)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "clarityrev://schemas/competitor-profile-v1.json",
  "title": "Competitor Profile",
  "description": "A structured profile of a competitor in a specific niche",
  "type": "object",
  "required": [
    "meta", "competitor_id", "company_name", "category", "geography",
    "niches_where_relevant", "pricing_visible", "pricing_bands_euro"
  ],
  "properties": {
    "meta": {
      "type": "object",
      "required": ["artifact", "version", "date", "produced_by", "evidence_rule"],
      "properties": {
        "artifact": {"type": "string", "description": "File name of this artifact"},
        "version": {"type": "string", "pattern": "^[0-9]+\\.[0-9]+$"},
        "date": {"type": "string", "format": "date"},
        "produced_by": {"type": "string", "description": "Agent or workflow that produced this"},
        "evidence_rule": {"type": "string", "description": "e.g. 'OBSERVED/INFERRED/UNKNOWN per C-23'"}
      }
    },
    "competitor_id": {"type": "string", "pattern": "^comp-[a-f0-9]{8}$"},
    "company_name": {"type": "string", "minLength": 1},
    "url": {"type": "string", "format": "uri"},
    "audited_at": {"type": "string", "format": "date"},
    "category": {
      "type": "array",
      "items": {"type": "string"},
      "description": "Primary category labels, e.g. ['DATA_PLATFORM', 'managed_gtm']"
    },
    "geography": {
      "type": "array",
      "items": {"type": "string", "enum": ["US", "EU", "NL", "BE", "UK", "Global Western", "APAC", "Other"]}
    },
    "nl_benelux_flag": {"type": "boolean"},
    "is_substitute": {"type": "boolean", "description": "TRUE only if this is an AI substitute per C-03 (Claude/ChatGPT/Perplexity/Gemini)"},
    "is_managed_service": {"type": "string", "enum": ["TRUE", "FALSE", "HYBRID", "UNKNOWN"]},
    "clarityrev_threat_level": {"type": "string", "enum": ["HIGH", "MEDIUM", "LOW", "NONE", "UNKNOWN"]},
    "positioning_statement": {"type": "string"},
    "named_service_lines": {
      "type": "array",
      "items": {"type": "string"},
      "minItems": 1
    },
    "shortlisted_offer_categories": {
      "type": "array",
      "items": {"type": "string"}
    },
    "pricing_visible": {"type": "boolean"},
    "pricing_discovery_method": {
      "type": "string",
      "enum": ["DIRECT_SCRAPE", "SECONDHAND", "QUOTE_GATED", "NOT_FOUND", "LOGIN_WALLED"]
    },
    "pricing_bands_euro": {
      "type": "object",
      "required": ["low", "high", "basis_tier", "basis_description"],
      "properties": {
        "low": {"type": "number", "minimum": 0},
        "high": {"type": "number", "minimum": 0},
        "basis_tier": {"type": "string", "description": "Which tier this band represents"},
        "basis_description": {"type": "string", "description": "What this price covers"},
        "is_monthly_recurring": {"type": "boolean"},
        "source_url": {"type": "string", "format": "uri"},
        "currency": {"type": "string"},
        "basis_note": {"type": "string", "description": "Why this band was chosen over the obvious field (see G-017)"}
      }
    },
    "tool_stack": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "tool_name": {"type": "string"},
          "category": {"type": "string"},
          "observation_method": {"type": "string", "enum": ["OBSERVED", "INFERRED", "UNKNOWN"]},
          "confidence": {"type": "string", "enum": ["HIGH", "MEDIUM", "LOW"]}
        }
      }
    },
    "niches_where_relevant": {
      "type": "array",
      "items": {"type": "string", "pattern": "^N-[0-9]{3}$"},
      "description": "Cross-reference: which niches does this competitor appear in?"
    },
    "evidence_citations": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["claim", "source_url", "observed_at"],
        "properties": {
          "claim": {"type": "string"},
          "source_url": {"type": "string", "format": "uri"},
          "observed_at": {"type": "string", "format": "date"},
          "evidence_method": {"type": "string", "enum": ["DIRECT_SCRAPE", "SCREENSHOT", "VERBATIM", "INFERRED"]},
          "finding_id": {"type": "string"}
        }
      }
    }
  }
}
```

### 2.2 Company Discovery List Schema (`company-discovery-schema.json`)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "clarityrev://schemas/company-discovery-v1.json",
  "title": "Company Discovery List",
  "description": "A list of companies identified as active in a niche",
  "type": "object",
  "required": ["meta", "niche_id", "companies", "search_queries_used"],
  "properties": {
    "meta": {
      "type": "object",
      "required": ["version", "date", "produced_by"],
      "properties": {
        "version": {"type": "string"},
        "date": {"type": "string", "format": "date"},
        "produced_by": {"type": "string"},
        "total_companies": {"type": "integer"},
        "included_count": {"type": "integer"},
        "excluded_count": {"type": "integer"}
      }
    },
    "niche_id": {"type": "string", "pattern": "^N-[0-9]{3}$"},
    "companies": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["company_name", "source", "discovery_date"],
        "properties": {
          "company_id": {"type": "string", "description": "Canonical ID from master index"},
          "company_name": {"type": "string"},
          "url": {"type": "string", "format": "uri"},
          "headquarters": {"type": "string"},
          "employee_count_estimate": {"type": "integer"},
          "revenue_estimate_euro": {"type": "number"},
          "source": {"type": "string", "description": "e.g. 'Firecrawl search', 'DataForSEO', 'Crunchbase'"},
          "source_url": {"type": "string", "format": "uri"},
          "discovery_date": {"type": "string", "format": "date"},
          "relevance_to_niche": {"type": "string", "enum": ["CORE", "ADJACENT", "MARGINAL", "UNCLEAR"]},
          "notes": {"type": "string"}
        }
      },
      "minItems": 1
    },
    "search_queries_used": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["query", "source_type", "date_run", "result_count"],
        "properties": {
          "query": {"type": "string"},
          "source_type": {"type": "string", "enum": ["FIRECRAWL_SEARCH", "FIRECRAWL_SCRAPE", "DATAFORSEO", "CONTEXT7", "MANUAL"]},
          "date_run": {"type": "string", "format": "date"},
          "result_count": {"type": "integer"},
          "included_count": {"type": "integer"},
          "excluded_reasons": {"type": "string"}
        }
      }
    },
    "exclusion_log": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "company_name": {"type": "string"},
          "reason": {"type": "string"},
          "excluded_by": {"type": "string"}
        }
      }
    }
  }
}
```

### 2.3 Market Sizing Schema (`market-sizing-schema.json`)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "clarityrev://schemas/market-sizing-v1.json",
  "title": "Market Sizing Data",
  "description": "TAM/SAM/SOM estimates and derivation for a niche",
  "type": "object",
  "required": ["meta", "niche_id", "tam", "sam", "som", "derivation_method", "confidence"],
  "properties": {
    "meta": {
      "type": "object",
      "required": ["version", "date", "produced_by"],
      "properties": {
        "version": {"type": "string"},
        "date": {"type": "string", "format": "date"},
        "produced_by": {"type": "string"}
      }
    },
    "niche_id": {"type": "string", "pattern": "^N-[0-9]{3}$"},
    "tam": {
      "type": "object",
      "required": ["label", "value_euro", "derivation"],
      "properties": {
        "label": {"type": "string", "description": "e.g. 'Total Addressable Market'"},
        "value_euro": {"type": "number", "minimum": 0},
        "low_estimate_euro": {"type": "number"},
        "high_estimate_euro": {"type": "number"},
        "derivation": {"type": "string", "description": "Formula or logic used"},
        "source_citations": {
          "type": "array",
          "items": {"type": "string", "format": "uri"}
        }
      }
    },
    "sam": {"$ref": "#/properties/tam"},
    "som": {"$ref": "#/properties/tam"},
    "derivation_method": {
      "type": "string",
      "enum": ["TOP_DOWN_EXTERNAL_ANALYST", "TOP_DOWN_COMPANY_COUNT", "BOTTOM_UP_BUYER_COUNT", "HYBRID", "ESTIMATE_ONLY"]
    },
    "confidence": {"type": "string", "enum": ["HIGH", "MEDIUM", "LOW", "INSUFFICIENT_DATA"]},
    "company_count_basis": {
      "type": "object",
      "properties": {
        "total_companies_in_segment": {"type": "integer"},
        "companies_meeting_criteria": {"type": "integer"},
        "buyers_per_company_estimate": {"type": "integer"},
        "average_contract_value_euro": {"type": "number"},
        "penetration_rate_assumption_percent": {"type": "number"}
      }
    },
    "pricing_anchor_comparables": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "comparable_name": {"type": "string"},
          "price_euro": {"type": "number"},
          "source_url": {"type": "string", "format": "uri"}
        }
      }
    }
  }
}
```

### 2.4 Review Corpus Schema (`review-corpus-schema.json`)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "clarityrev://schemas/review-corpus-v1.json",
  "title": "Review Corpus",
  "description": "Structured review data extracted from G2, Capterra, TrustRadius, and other platforms",
  "type": "object",
  "required": ["meta", "niche_id", "reviews", "coverage_report"],
  "properties": {
    "meta": {
      "type": "object",
      "required": ["version", "date", "sources_covered"],
      "properties": {
        "version": {"type": "string"},
        "date": {"type": "string", "format": "date"},
        "sources_covered": {
          "type": "array",
          "items": {"type": "string", "enum": ["G2", "CAPTERRA", "TRUSTRADIUS", "GETAPP", "GARTNER", "REDDIT", "OTHER"]}
        },
        "total_reviews_extracted": {"type": "integer"},
        "reviews_after_dedup": {"type": "integer"}
      }
    },
    "niche_id": {"type": "string", "pattern": "^N-[0-9]{3}$"},
    "reviews": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["review_id", "source", "title", "rating", "date", "url"],
        "properties": {
          "review_id": {"type": "string"},
          "source": {"type": "string", "enum": ["G2", "CAPTERRA", "TRUSTRADIUS", "GETAPP", "GARTNER", "OTHER"]},
          "product_name": {"type": "string"},
          "reviewer_title": {"type": "string"},
          "reviewer_company_segment": {"type": "string"},
          "title": {"type": "string"},
          "rating": {"type": "number", "minimum": 1, "maximum": 5},
          "pros": {"type": "string"},
          "cons": {"type": "string"},
          "date": {"type": "string", "format": "date"},
          "url": {"type": "string", "format": "uri"},
          "verified_purchase": {"type": "boolean"},
          "reviewer_employee_count": {"type": "string"},
          "extracted_quotes": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "quote": {"type": "string"},
                "theme_tags": {"type": "array", "items": {"type": "string"}},
                "sentiment": {"type": "string", "enum": ["POSITIVE", "NEGATIVE", "NEUTRAL", "MIXED"]}
              }
            }
          }
        }
      }
    },
    "coverage_report": {
      "type": "object",
      "properties": {
        "platforms_with_data": {"type": "array", "items": {"type": "string"}},
        "platforms_attempted_no_data": {"type": "array", "items": {"type": "string"}},
        "platforms_blocked": {"type": "array", "items": {"type": "string"}},
        "oldest_review_date": {"type": "string", "format": "date"},
        "newest_review_date": {"type": "string", "format": "date"}
      }
    },
    "key_themes": {
      "type": "object",
      "description": "Aggregated theme analysis across all reviews",
      "properties": {
        "top_pains": {"type": "array", "items": {"type": "object"}},
        "top_desires": {"type": "array", "items": {"type": "object"}},
        "common_adjectives": {"type": "array", "items": {"type": "string"}},
        "reviewer_role_distribution": {"type": "object"}
      }
    }
  }
}
```

### 2.5 Buyer Language Extract Schema (`buyer-language-schema.json`)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "clarityrev://schemas/buyer-language-v1.json",
  "title": "Buyer Language Extracts",
  "description": "Verbatim buyer quotes and language patterns extracted from VOC sources",
  "type": "object",
  "required": ["meta", "niche_id", "quotes", "language_buckets"],
  "properties": {
    "meta": {
      "type": "object",
      "required": ["version", "date", "total_quotes_collected", "sources_sample"],
      "properties": {
        "version": {"type": "string"},
        "date": {"type": "string", "format": "date"},
        "total_quotes_collected": {"type": "integer"},
        "sources_sample": {
          "type": "array",
          "items": {
            "type": "object",
            "properties": {
              "source_type": {"type": "string", "enum": ["REVIEW_PLATFORM", "REDDIT", "HN", "SLACK", "INTERVIEW", "BLOG", "FORUM", "OTHER"]},
              "source_name": {"type": "string"},
              "quote_count": {"type": "integer"}
            }
          }
        }
      }
    },
    "niche_id": {"type": "string", "pattern": "^N-[0-9]{3}$"},
    "quotes": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["quote_id", "verbatim", "source_url", "speaker_context", "collected_date"],
        "properties": {
          "quote_id": {"type": "string", "description": "Format: VOC-N001-0001"},
          "verbatim": {"type": "string", "description": "Exact quote, including typos"},
          "source_url": {"type": "string", "format": "uri"},
          "speaker_context": {"type": "string", "description": "Role, company, situation"},
          "collected_date": {"type": "string", "format": "date"},
          "themes": {"type": "array", "items": {"type": "string"}},
          "sentiment": {"type": "string", "enum": ["FRUSTRATED", "NEUTRAL", "POSITIVE", "SKEPTICAL", "URGENT"]},
          "buyer_language_tags": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "phrase": {"type": "string"},
                "is_headline_candidate": {"type": "boolean"},
                "is_copy_fragment": {"type": "boolean"}
              }
            }
          },
          "counter_evidence_flag": {"type": "boolean", "description": "True if this quote challenges our hypothesis"},
          "wtp_anchor": {
            "type": "object",
            "properties": {
              "amount_euro": {"type": "number"},
              "context": {"type": "string"},
              "confidence": {"type": "string", "enum": ["HIGH", "MEDIUM", "LOW"]}
            }
          }
        }
      }
    },
    "language_buckets": {
      "type": "object",
      "description": "Language patterns grouped by theme for offer copywriting",
      "additionalProperties": {
        "type": "object",
        "properties": {
          "bucket_label": {"type": "string"},
          "headline_phrases": {"type": "array", "items": {"type": "string"}},
          "objection_phrases": {"type": "array", "items": {"type": "string"}},
          "desired_outcome_phrases": {"type": "array", "items": {"type": "string"}},
          "source_quote_ids": {"type": "array", "items": {"type": "string"}}
        }
      }
    },
    "counter_evidence": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "claim": {"type": "string"},
          "contradicting_quote_id": {"type": "string"},
          "severity": {"type": "string", "enum": ["HIGH", "MEDIUM", "LOW"]}
        }
      }
    }
  }
}
```

### 2.6 Signal Feasibility Report Schema (`signal-feasibility-schema.json`)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "clarityrev://schemas/signal-feasibility-v1.json",
  "title": "Signal Feasibility Report",
  "description": "Assessment of which signals can be detected for a niche, with reliability and cost data",
  "type": "object",
  "required": ["meta", "niche_id", "signals_assessed"],
  "properties": {
    "meta": {
      "type": "object",
      "required": ["version", "date", "produced_by"],
      "properties": {
        "version": {"type": "string"},
        "date": {"type": "string", "format": "date"},
        "produced_by": {"type": "string"}
      }
    },
    "niche_id": {"type": "string", "pattern": "^N-[0-9]{3}$"},
    "signals_assessed": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["signal_id", "signal_name", "signal_type", "feasibility_verdict"],
        "properties": {
          "signal_id": {"type": "string", "description": "Format: SIG-N001-001"},
          "signal_name": {"type": "string", "description": "e.g. 'New VP Sales hired'"},
          "signal_type": {
            "type": "string",
            "enum": ["JOB_POSTING", "FUNDING_EVENT", "EXECUTIVE_MOVE", "PRODUCT_LAUNCH", "REGULATORY_FILING", "EARNINGS_CALL", "SOCIAL_POST", "WEBSITE_CHANGE", "REVIEW_SURGE", "OTHER"]
          },
          "feasibility_verdict": {
            "type": "string",
            "enum": ["DETECTABLE_RELIABLE", "DETECTABLE_NOISY", "DETECTABLE_EXPENSIVE", "NOT_DETECTABLE_CURRENTLY", "UNKNOWN"]
          },
          "feasibility_evidence": {"type": "string", "description": "What was tested and what happened"},
          "data_sources_available": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "source_name": {"type": "string"},
                "probe_status": {"type": "string", "enum": ["ACCESSIBLE", "RATE_LIMITED", "LOGIN_WALLED", "TOS_BLOCKED", "PAID_ONLY", "NOT_ATTEMPTED"]},
                "cost_per_query_euro": {"type": "number"},
                "reliability_rating": {"type": "string", "enum": ["HIGH", "MEDIUM", "LOW", "UNKNOWN"]}
              }
            }
          },
          "false_positive_risk": {"type": "string", "enum": ["LOW", "MEDIUM", "HIGH", "UNKNOWN"]},
          "refresh_frequency": {"type": "string", "description": "e.g. 'Daily', 'Weekly', 'Event-triggered'"},
          "test_results": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "test_date": {"type": "string", "format": "date"},
                "query_used": {"type": "string"},
                "results_count": {"type": "integer"},
                "precision_estimate": {"type": "string"},
                "notes": {"type": "string"}
              }
            }
          },
          "cost_estimate": {
            "type": "object",
            "properties": {
              "per_signal_per_month_euro": {"type": "number"},
              "setup_cost_euro": {"type": "number"},
              "cost_basis": {"type": "string"}
            }
          }
        }
      }
    }
  }
}
```

### 2.7 Pricing Data Schema (`pricing-data-schema.json`)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "clarityrev://schemas/pricing-data-v1.json",
  "title": "Pricing Data",
  "description": "Pricing data collected from competitor surfaces and buyer WTP signals",
  "type": "object",
  "required": ["meta", "niche_id", "competitor_entries", "wtp_entries"],
  "properties": {
    "meta": {
      "type": "object",
      "required": ["version", "date", "pricing_discovery_status"],
      "properties": {
        "version": {"type": "string"},
        "date": {"type": "string", "format": "date"},
        "pricing_discovery_status": {"type": "string", "enum": ["SUFFICIENT_ANCHORS", "INSUFFICIENT_DATA", "NOT_ATTEMPTED"]},
        "total_live_pages_scraped": {"type": "integer"},
        "total_prices_collected": {"type": "integer"}
      }
    },
    "niche_id": {"type": "string", "pattern": "^N-[0-9]{3}$"},
    "competitor_entries": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["competitor_id", "entry_type", "eur_converted", "source_url", "discovery_method", "date_collected"],
        "properties": {
          "competitor_id": {"type": "string"},
          "competitor_name": {"type": "string"},
          "entry_type": {
            "type": "string",
            "enum": ["MONTHLY_RECURRING", "ANNUAL", "ONE_TIME_SETUP", "PER_SEAT", "PER_CREDIT", "PROJECT_FEE", "USAGE_BASED", "QUOTE_GATED", "UNPUBLISHED"]
          },
          "tier_label": {"type": "string", "description": "e.g. 'Starter', 'Pro', 'GTM Engineering'"},
          "price_original": {"type": "number"},
          "currency": {"type": "string"},
          "eur_converted": {"type": "number"},
          "eur_conversion_rate": {"type": "number"},
          "basis_note": {"type": "string", "description": "Why this price was selected as the KT-3 anchor (see G-017)"},
          "source_url": {"type": "string", "format": "uri"},
          "discovery_method": {
            "type": "string",
            "enum": ["DIRECT_SCRAPE", "SECONDHAND_BLOG", "SECONDHAND_REVIEW", "SECONDHAND_SOCIAL", "INFERRED"]
          },
          "pricing_page_status": {
            "type": "string",
            "enum": ["PUBLIC", "LOGIN_WALLED", "CONTACT_SALES", "NOT_FOUND", "404_KNOWN_REBRAND", "404_UNKNOWN"]
          },
          "date_collected": {"type": "string", "format": "date"},
          "verified_live": {"type": "boolean"},
          "near_miss_flag": {"type": "boolean", "description": "True if this is close to a KT threshold"},
          "clarityrev_band": {"type": "string", "enum": ["BELOW_ENTRY", "ENTRY_1_5_3K", "CORE_3K", "PREMIUM_5K", "ENTERPRISE_8K_PLUS", "ABOVE_RANGE"]}
        }
      },
      "minItems": 1
    },
    "wtp_entries": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "source": {"type": "string", "description": "e.g. 'Gapstars conversation', 'VOC interview'"},
          "amount_euro": {"type": "number"},
          "context": {"type": "string"},
          "confidence": {"type": "string", "enum": ["HIGH", "MEDIUM", "LOW"]},
          "source_url_or_transcript_ref": {"type": "string"}
        }
      }
    },
    "price_anchors_summary": {
      "type": "object",
      "properties": {
        "lowest_monthly_eur": {"type": "number"},
        "median_monthly_eur": {"type": "number"},
        "typical_setup_fee_eur": {"type": "number"},
        "typical_contract_term": {"type": "string"},
        "total_anchors": {"type": "integer"},
        "direct_scrape_anchors": {"type": "integer"},
        "secondhand_anchors": {"type": "integer"},
        "coverage_gate_verdict": {
          "type": "string",
          "enum": ["PASS", "FAIL", "INSUFFICIENT_DATA", "NOT_APPLICABLE"]
        }
      }
    }
  }
}
```

### 2.8 Technographic Profile Schema (`technographic-profile-schema.json`)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "clarityrev://schemas/technographic-profile-v1.json",
  "title": "Technographic Profile",
  "description": "Technology stack profiles of companies and actors in a niche",
  "type": "object",
  "required": ["meta", "niche_id", "dominant_tools", "stack_patterns"],
  "properties": {
    "meta": {
      "type": "object",
      "required": ["version", "date", "total_tools_identified"],
      "properties": {
        "version": {"type": "string"},
        "date": {"type": "string", "format": "date"},
        "total_tools_identified": {"type": "integer"},
        "tool_discovery_method": {
          "type": "string",
          "enum": ["BUILTWITH", "SIMILARWEB", "WAPPALYZER", "CRM_DATA", "SELF_REPORTED", "MANUAL", "MULTIPLE"]
        }
      }
    },
    "niche_id": {"type": "string", "pattern": "^N-[0-9]{3}$"},
    "dominant_tools": {
      "type": "object",
      "description": "Tools with significant adoption in this niche",
      "additionalProperties": {
        "type": "object",
        "required": ["category", "adoption_estimate"],
        "properties": {
          "category": {"type": "string", "description": "e.g. 'CRM', 'MARKETING_AUTOMATION', 'DATA_ENRICHMENT'"},
          "tool_name": {"type": "string"},
          "adoption_estimate": {"type": "string", "enum": ["DOMINANT", "COMMON", "PRESENT", "RARE", "ABSENT"]},
          "adoption_basis": {"type": "string", "description": "What evidence supports this estimate"},
          "integration_required_for_delivery": {"type": "boolean"},
          "notes": {"type": "string"}
        }
      }
    },
    "stack_patterns": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["pattern_name", "companies_exhibiting"],
        "properties": {
          "pattern_name": {"type": "string", "description": "e.g. 'HubSpot + SalesLoft + Gong'"},
          "description": {"type": "string"},
          "companies_exhibiting": {
            "type": "array",
            "items": {"type": "string"},
            "minItems": 1
          },
          "estimated_prevalence": {"type": "string", "enum": ["HIGH", "MEDIUM", "LOW"]},
          "gap_opportunity": {"type": "string", "description": "What ClarityRev could add to this stack"}
        }
      }
    },
    "technographic_gaps": {
      "type": "object",
      "description": "Missing tech capabilities that represent ClarityRev opportunities",
      "properties": {
        "unserved_needs": {"type": "array", "items": {"type": "string"}},
        "underserved_tools": {"type": "array", "items": {"type": "string"}},
        "integration_hooks": {"type": "array", "items": {"type": "string"}}
      }
    }
  }
}
```

### 2.9 Niche Canvas Schema (extension of the RIOS canvas)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "clarityrev://schemas/niche-canvas-v1.json",
  "title": "Niche Evaluation Canvas",
  "description": "Completed evaluation canvas for one niche, with full traceability to source data",
  "type": "object",
  "required": [
    "meta", "niche_id", "overall_verdict", "recommendation",
    "scoring", "claim_traceability"
  ],
  "properties": {
    "meta": {
      "type": "object",
      "required": ["version", "date_completed", "lead_agent", "status"],
      "properties": {
        "version": {"type": "string"},
        "date_completed": {"type": "string", "format": "date"},
        "lead_agent": {"type": "string", "description": "Which agent or team evaluated this niche"},
        "status": {
          "type": "string",
          "enum": ["IN_PROGRESS", "COMPLETE", "AUDITED", "PARKED", "REJECTED"]
        },
        "evaluation_duration_days": {"type": "integer"}
      }
    },
    "niche_id": {"type": "string", "pattern": "^N-[0-9]{3}$"},
    "niche_name": {"type": "string"},
    "overall_verdict": {
      "type": "string",
      "enum": ["PURSUE", "CONSIDER", "PARK", "REJECT"]
    },
    "recommendation": {
      "type": "string",
      "description": "Plain-language summary of why this niche gets the verdict"
    },
    "scoring": {
      "type": "object",
      "required": ["market_size_score", "signal_feasibility_score", "competition_score", "buyer_access_score", "fit_score"],
      "properties": {
        "market_size_score": {"type": "integer", "minimum": 1, "maximum": 5},
        "signal_feasibility_score": {"type": "integer", "minimum": 1, "maximum": 5},
        "competition_score": {"type": "integer", "minimum": 1, "maximum": 5, "description": "Higher = less competition"},
        "buyer_access_score": {"type": "integer", "minimum": 1, "maximum": 5},
        "fit_score": {"type": "integer", "minimum": 1, "maximum": 5, "description": "Fit with ClarityRev capabilities"},
        "total": {"type": "integer", "maximum": 25},
        "confidence": {"type": "string", "enum": ["HIGH", "MEDIUM", "LOW", "PROVISIONAL"]}
      }
    },
    "claim_traceability": {
      "type": "object",
      "description": "Every factual claim in the canvas linked to source data",
      "required": ["entries"],
      "properties": {
        "entries": {
          "type": "array",
          "items": {
            "type": "object",
            "required": ["claim_id", "claim_text", "source_file", "source_line", "source_url", "fetch_date"],
            "properties": {
              "claim_id": {"type": "string", "description": "Format: C-N001-001"},
              "claim_text": {"type": "string", "description": "The specific factual claim"},
              "field_path": {"type": "string", "description": "Which canvas field this claim supports"},
              "source_file": {"type": "string", "description": "Path relative to research/niche-program/"},
              "source_line": {"type": "integer", "description": "Line number in source_file"},
              "source_url": {"type": "string", "format": "uri", "description": "Original URL where data was fetched"},
              "raw_fetch_file": {"type": "string", "description": "Path relative to .firecrawl/ for raw fetch evidence"},
              "fetch_date": {"type": "string", "format": "date"},
              "evidence_quality": {
                "type": "string",
                "enum": ["DIRECT_OBSERVATION", "FIRST_HAND_REPORT", "AGGREGATED", "INFERRED", "ASSUMED"]
              },
              "audit_verdict": {
                "type": "string",
                "enum": ["VERIFIED", "DISPUTED", "UNVERIFIED"]
              }
            }
          }
        }
      }
    },
    "gates": {
      "type": "object",
      "properties": {
        "gate_1_warm_access": {"type": "string", "enum": ["PASS", "FAIL", "UNVERIFIED"]},
        "gate_2_signal_feasibility": {"type": "string", "enum": ["PASS", "FAIL", "UNVERIFIED"]},
        "gate_3_pricing_coverage": {"type": "string", "enum": ["PASS", "FAIL", "INSUFFICIENT_DATA"]},
        "gate_4_research_traceability": {"type": "string", "enum": ["PASS", "FAIL", "UNVERIFIED"]},
        "gate_5_competitor_preemption": {"type": "string", "enum": ["PASS", "NOT_TRIPPED", "TRIPPED", "UNVERIFIED"]}
      }
    }
  }
}
```

### 2.10 Cross-Niche Patterns Schema (`cross-niche-patterns-schema.json`)

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "$id": "clarityrev://schemas/cross-niche-patterns-v1.json",
  "title": "Cross-Niche Patterns",
  "description": "Patterns, signals, and insights that emerge across multiple niches",
  "type": "object",
  "required": ["meta", "patterns", "shared_competitors", "recommendations"],
  "properties": {
    "meta": {
      "type": "object",
      "required": ["version", "date", "niches_covered_count"],
      "properties": {
        "version": {"type": "string"},
        "date": {"type": "string", "format": "date"},
        "niches_covered": {"type": "array", "items": {"type": "string", "pattern": "^N-[0-9]{3}$"}},
        "niches_covered_count": {"type": "integer"}
      }
    },
    "patterns": {
      "type": "array",
      "items": {
        "type": "object",
        "required": ["pattern_id", "description", "niches_where_observed"],
        "properties": {
          "pattern_id": {"type": "string", "description": "Format: XP-001"},
          "description": {"type": "string"},
          "pattern_type": {
            "type": "string",
            "enum": ["BUYER_BEHAVIOR", "PRICING_STRATEGY", "TECH_STACK_CONVERGENCE", "SIGNAL_OVERLAP", "COMPETITOR_OVERLAP", "LANGUAGE_PATTERN", "TIMING_PATTERN"]
          },
          "niches_where_observed": {
            "type": "array",
            "items": {"type": "string", "pattern": "^N-[0-9]{3}$"},
            "minItems": 2
          },
          "evidence_summary": {"type": "string"},
          "implication_for_clarityrev": {"type": "string"},
          "confidence": {"type": "string", "enum": ["HIGH", "MEDIUM", "LOW", "HYPOTHESIS"]}
        }
      }
    },
    "shared_competitors": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "competitor_id": {"type": "string"},
          "company_name": {"type": "string"},
          "niches_present": {"type": "array", "items": {"type": "string"}},
          "overall_threat_level": {"type": "string", "enum": ["HIGH", "MEDIUM", "LOW"]}
        }
      }
    },
    "recommendations": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "recommendation_id": {"type": "string"},
          "action": {"type": "string"},
          "rationale": {"type": "string"},
          "affected_niches": {"type": "array", "items": {"type": "string"}}
        }
      }
    }
  }
}
```

---

## 3. TRACEABILITY PATTERN

### Principle: Every factual claim in a canvas must trace to a specific source file, line number, and original URL.

The traceability chain has 4 layers:

```
LAYER 1: .firecrawl/              ← Raw fetched content (markdown, HTML, JSON)
LAYER 2: research/niche-program/  ← Structured, validated data files (YAML)
LAYER 3: _canvas/                 ← Niche evaluation canvas (YAML with claim_traceability)
LAYER 4: Audit                    ← Automated audit verifying every [E] claim
```

### Traceability Data Model

Each traceability entry carries exactly these fields:

```
claim_id: "C-N001-042"           ← Unique ID: C-{niche}-{sequential}
claim_text: "SyncGTM charges EUR 2,300/mo for the managed Fractional GTMe tier"
field_path: "scoring.market_size_score"
source_file: "N-001/02-competitor-intel/competitors-v2.yaml"
source_line: 47
raw_fetch_file: ".firecrawl/syncgtm-pricing-scrape-2026-07-17.json"
source_url: "https://syncgtm.com/solution/ai-gtme"
fetch_date: "2026-07-17"
evidence_quality: "DIRECT_OBSERVATION"
audit_verdict: "VERIFIED"
```

### How Traceability Is Enforced

**At fill time** (when creating the canvas):
- Every field in the canvas's `claim_traceability.entries` array references a `source_file` path relative to `research/niche-program/`.
- The `source_line` is filled from the YAML file (can be approximate, but should point within 3 lines of the data).
- The `raw_fetch_file` links to the `.firecrawl/` original.

**At audit time** (the quality audit):
1. **Lint**: Every `[E]` (evidence-tagged) claim in the canvas has a non-null `source_file` and `source_url`.
2. **Verify**: A random sample of 20% of claims are checked: does source_file:source_line actually contain data that supports the claim?
3. **Live check**: For DIRECT_OBSERVATION claims, is the URL still serving the claimed data? (This catches rebrand/404 issues per G-015.)
4. **Report**: Canvas audit outputs `canvas-audit-v1.yaml` with per-claim verdicts.

### Canvas-to-Source Traceability Example

```
N-001/_canvas/niche-canvas-v1.yaml:
  claim_traceability:
    entries:
      - claim_id: "C-N001-001"
        claim_text: "This niche has 14,000 addressable companies in EU"
        field_path: "scoring.market_size_score"
        source_file: "N-001/03-market-sizing/market-size-v1.yaml"
        source_line: 23
        source_url: "https://eurostat.eu/..."
        raw_fetch_file: ".firecrawl/eurostat-b2b-services-stats-2026-07-20.md"
        fetch_date: "2026-07-20"
        evidence_quality: "FIRST_HAND_REPORT"
        audit_verdict: "VERIFIED"
```

### Quality Auditor Workflow

The auditor reads the canvas, picks each claim in `claim_traceability.entries`, navigates to `source_file:source_line`, and confirms:

1. The file exists at the expected path
2. The data at that line supports the claim
3. The `raw_fetch_file` exists in `.firecrawl/`
4. The original URL pattern is valid

The auditor writes `canvas-audit-v1.yaml` with:
- `total_claims`: N
- `claims_verified`: N
- `claims_disputed`: []
- `claims_unverifiable`: [] (source file missing, line doesn't match, URL 404s)
- `overall_verdict`: PASS | PASS_WITH_FINDINGS | FAIL

---

## 4. FILE NAMING CONVENTION

### Convention Template

```
{niche_id}-{data_type}-{descriptor}-{version}.{ext}
```

### Field Definitions

| Field | Required | Format | Example |
|-------|----------|--------|---------|
| `niche_id` | YES | `N-{NNN}` or `CALIB` or `SHARED` | `N-001`, `CALIB`, `SHARED` |
| `data_type` | YES | Lowercase, hyphen-separated, from controlled vocabulary | `competitor-profile`, `review-corpus`, `market-size` |
| `descriptor` | YES | Lowercase, hyphen-separated, meaningful disambiguation | `syncgtm`, `g2-sales-categories`, `buyer-persona-cto` |
| `version` | YES | `v{N}` where N increments on substantive changes | `v1`, `v2`, `v3` |
| `ext` | YES | File extension | `yaml`, `json`, `csv`, `md` |

### Controlled Vocabulary for `data_type`

```
company-discovery
competitor-profile
competitor-gap
market-size
buyer-count-estimate
pricing-benchmark
pricing-entry
review-corpus
voc-quotes
voc-patterns
community-signal
signal-feasibility
signal-cost-estimate
data-source-probe
technographic-profile
tool-adoption-pattern
buyer-persona
buying-process
decision-criteria
wtp-evidence
price-anchor
niche-canvas
canvas-audit
discovery-log
query-log
agent-notes
cross-niche-pattern
program-status
```

### Examples

| File | Interpretation |
|------|----------------|
| `N-001-competitor-profile-syncgtm-v2.yaml` | Niche 001, competitor profile for SyncGTM, version 2 |
| `N-003-review-corpus-g2-categories-v1.yaml` | Niche 003, G2 review corpus, first version |
| `N-005-market-size-v1.yaml` | Niche 005, market sizing, first version |
| `N-007-signal-feasibility-v2.yaml` | Niche 007, signal feasibility, second version |
| `N-001-wtp-evidence-gapstars-conversation-v1.yaml` | Niche 001, WTP evidence from Gapstars conversation |
| `SHARED-benchmark-pricing-bands-v1.yaml` | Cross-niche benchmark, pricing bands |
| `SHARED-taxonomy-niche-categories-v1.yaml` | Cross-niche taxonomy |
| `CALIB-competitor-profile-testcorp-v1.yaml` | Calibration niche, competitor profile |
| `CALIB-canvas-audit-v1.yaml` | Calibration niche audit |
| `N-012-company-discovery-v2.yaml` | Niche 012, company discovery list, updated |
| `N-004-query-log-v1.yaml` | Niche 004, search query log |

### Sortability Rules

- `N-{NNN}` zero-padded to 3 digits so alphabetical sort = numeric sort
- `v1`, `v2`, ... `v10` sorts correctly up to v9; for v10+, use `v01`/`v02` or accept `v10` < `v9` (mitigation: keep versions low by replacing, not incrementing)
- Date-first filenames: when files are generated periodically, place date at the front: `2026-07-23-N-001-signal-check-v1.yaml`

### What Gets a Version Bump

- **Patch** (v1 → v1.1): Adding optional fields, fixing typo in a value, updating a URL. File name stays same; `meta.version` field changes.
- **Minor** (v1 → v2): Adding new data (new companies, new signals assessed). File name changes.
- **Major** (v1 → v3): Schema change, re-analysis of all data, correction of systematic error. File name changes + changelog entry.

### Anti-Patterns (DO NOT USE)

| Anti-pattern | Why | Correct alternative |
|---|---|---|
| `final-competitor-list.yaml` | "final" is never final | `N-001-competitor-profile-v2.yaml` |
| `data_dump.json` | No semantic info | `N-003-company-discovery-v1.json` |
| `SyncGTM stuff.yaml` | Spaces, no niche context | `N-001-competitor-profile-syncgtm-v1.yaml` |
| `v1_final_REALLY_final.yaml` | Version chaos | `N-005-market-size-v2.yaml` |

---

## 5. CROSS-AGENT SHARING PATTERN

### What Is Shared vs. What Is Niche-Specific

```
SHARED/ (read-only to all niche agents)
├── benchmarks/            ← Pricing bands, company count brackets — reusable inputs
├── competitors/           ← Competitor profiles that span multiple niches
├── regulatory/            ← GDPR, AI Act — applicable to all niches
├── tools/                 ← Canonical tool inventory — one source of truth
├── taxonomy/              ← Category definitions, signal types, buyer roles
└── triggers/              ← Trigger catalog — cross-niche

N-XXX/ (owned by one niche agent)
├── 01-company-discovery/  ← Niche-specific companies
├── 02-competitor-intel/   ← Niche-specific competitors + gap analysis
├── 03-market-sizing/      ← TAM/SAM/SOM for this niche
├── 04-voice-of-customer/  ← Quotes and patterns from this niche's buyers
├── 05-signal-feasibility/ ← Signal reliability for this niche
├── 06-technographic/      ← Tech stacks in this niche
├── 07-buyer-insight/      ← Buyer personas and decision processes
├── 08-pricing/            ← Pricing data specific to this niche
├── _canvas/               ← This niche's evaluation output
└── _work/                 ← Working notes, dead ends
```

### Discovery Protocol: How Agent N-007 Finds Data from N-003

**Step 1: Check SHARED/ first.**
If the competitor or tool you need already has a profile in `SHARED/competitors/`, use it directly. Do not re-fetch.

**Step 2: Check the competitor's `niches_where_relevant` field.**
Every competitor profile lists which niches reference it. If N-003 has already profiled this competitor, the profile is in `SHARED/competitors/` with `niches_where_relevant: ["N-003", "N-007"]`.

**Step 3: For niche-specific data, check the source niche directory.**
The manifest file `_pipelines/cross-niche-merge/competitor-dedup-manifest.yaml` records which niche first profiled each cross-niche entity. Agent N-007 reads this manifest to find the original data.

**Step 4: Contribute back to SHARED/.**
If Agent N-007 discovers a competitor already in SHARED/ but for a different niche, it adds its niche ID to the `niches_where_relevant` array. If it discovers a NEW competitor that spans multiple niches, it creates the profile in SHARED/ and adds its niche to the dedup manifest.

### Concurrent Access Rules

1. **No two agents write to the same N-XXX directory.** Each niche is owned by exactly one agent or team at a time.
2. **SHARED/ files have an owner field** (`maintained_by`). Agents may propose updates via the `_pipelines/` merge process, but may not directly overwrite.
3. **Locking is not required** for this file-based architecture. The convention is: read SHARED/ at the start of a session, contribute back at the end. Concurrent writes to different N-XXX directories are safe.
4. **Version increments** in SHARED/ are batched — accumulated updates are merged by a periodic dedup agent, not applied in real time.

### Cross-Niche Merge Pipeline

```
Timeline: Weekly or after every 5 completed niches

1. Each niche agent finishes → writes its N-XXX/_canvas/niche-canvas-v1.yaml
2. The merge agent reads all completed canvases
3. For SHARED/competitors/: merges new competitors, updates niches_where_relevant
4. For SHARED/patterns/: detects patterns that appear in ≥2 niches → cross-niche-patterns-v1.yaml
5. For _program/niche-rankings-v1.yaml: ranks all completed niches on standardised scores
6. For _program/cross-niche-patterns-v1.yaml: synthesises findings across niches
```

### What If Two Niches Contradict Each Other?

Example: N-003 finds "buyers in this niche demand <EUR 1K/mo" but N-007 (overlapping niche) finds EUR 2-3K/mo.

Resolution path:
1. Both claims exist in their niche canvases with traceability
2. The cross-niche pattern agent flags the contradiction as `pattern_type: BUYER_BEHAVIOR` with `confidence: HYPOTHESIS`
3. The contradiction is logged in `_program/cross-niche-patterns-v1.yaml` with both source niche IDs
4. No automatic resolution — a human (Wesley) adjudicates

---

## 6. ADVERSARIAL VERDICT

### Would Lens 2 sign off?

**Verdict: SIGN OFF WITH CONDITIONS**

### What passes:

1. **Directory structure**: Clean separation of SHARED vs. niche-specific. Numeric ordering prevents ambiguity. The `_canvas/` and `_work/` conventions handle the boundary between structured data and informal notes. `_pipelines/` prevents script drift.

2. **Schema completeness**: 10 schemas cover the full evaluation pipeline (company discovery through niche canvas). Every schema has required fields, controlled enums where classification exists, and example values. The evidence_citations arrays in competitor profiles mirror the real Phase-3 pattern.

3. **Traceability pattern**: Four-layer model (raw fetch -> structured data -> canvas claim -> audit) is sound. The `claim_traceability.entries` array with source_file + source_line + source_url is the exact mechanism needed to make "[E]" claims auditable. 20% spot-check at audit time is a reasonable sample.

4. **File naming convention**: Niche-ID-prefixed, controlled data-type vocabulary, versioned, no spaces. Sortable. The anti-pattern table prevents common failures.

5. **Cross-agent sharing**: SHARED/ is a clear boundary. The `niches_where_relevant` field on competitor profiles is the key innovation — it solves "how does Agent N-007 discover data from N-003." The merge pipeline (batch after every 5 niches) prevents conflicts.

### What needs attention before production use:

1. **Schema validation tooling**: The JSON Schemas defined here must be paired with a CI step (or at minimum a pre-commit hook) that validates every YAML file against its schema. Without validation, schemas are documentation, not contracts. **Recommendation**: Add a `validate_schemas.py` or similar in `_pipelines/` that runs `pip install jsonschema` and checks all YAML files.

2. **File naming version ceiling**: v1-v9 sorts correctly; v10 breaks alpha sort. For a 25-niche program, most files will not exceed v3. But the convention should specify: at v10, rename to v01-99 format or accept the sort issue. **Recommendation**: Cap at v9 and force a merge/archive step before hitting v10.

3. **Concurrent write detection**: The "no two agents write to the same N-XXX" rule is enforced by convention, not by lock. For a human-led program this is fine; for fully autonomous agent swarms, add a `.lock` file convention. **Recommendation**: Accept convention-based for now; add lock files if agents start colliding.

4. **Calibration niche completeness**: The CALIBRATION/ directory exists in structure but is not yet integrated into the validation pipeline. The calibration report (comparing expected vs. actual results) is the only mechanism that proves the architecture works. **Recommendation**: Run CALIBRATION/ first (before scaling to 25 niches) and fix any schema or directory issues before proceeding.

5. **`_work/` directory sprawl**: Agent notes and dead ends will accumulate. Without a retention policy, `_work/` could grow unbounded. **Recommendation**: Add a note to `_work/README.md` that agents may clean old entries after canvas completion, and that `_work/` is excluded from cross-niche pattern detection.

6. **Missing: Raw-to-Structured pipeline procedure**: The architecture defines the destination (the schemas) and the origin (`.firecrawl/`) but does not specify the EXACT procedure for converting a raw Firecrawl output into a structured YAML file. **Recommendation**: Add a `_pipelines/raw-to-structured/PROCEDURE.md` that walks through a worked example.

### Final assessment:

**SIGN OFF** — This architecture is implementable, predictable, and traceable. The conditions above are improvements, not blockers. The strongest element is the traceability chain (`.firecrawl/` → structured YAML → canvas claim → audit), which mirrors the proven Phase-3 pattern and formalises it for the 25-niche scale. The cross-agent sharing via SHARED/ + `niches_where_relevant` field solves the discovery problem without requiring a database. Begin with the calibration niche, validate against real data, then scale.
