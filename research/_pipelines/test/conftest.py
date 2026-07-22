"""
conftest.py -- Shared pytest fixtures for the ClarityRev Niche Pipeline test suite.

Google SRE pattern: test fixtures are explicit, isolated, and deterministic.
Every fixture creates temporary directories and cleans up after itself.
No fixture writes to the actual pipeline directories.

Usage:
    pytest test_pipeline_ops.py -v
"""

import os
import sys
import json
import hashlib
import tempfile
from pathlib import Path
from datetime import datetime, timezone, timedelta
from typing import Dict, Any, List, Optional

import pytest

# Ensure the lib/ directory is importable for tests
_PIPELINES_DIR = Path(__file__).resolve().parent.parent  # _pipelines/
sys.path.insert(0, str(_PIPELINES_DIR))


# ─── Helper: create nested directories in temp ─────────────────────────────────

def _touch(path: Path, content: str = ""):
    """Create a file with content, ensuring parent directories exist."""
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content)


def _write_yaml(path: Path, data: Dict[str, Any]):
    """Write a YAML file using ruamel.yaml."""
    from ruamel.yaml import YAML
    yaml = YAML()
    yaml.preserve_quotes = True
    path.parent.mkdir(parents=True, exist_ok=True)
    with open(path, "w") as f:
        yaml.dump(data, f)


# ─── Fixtures ──────────────────────────────────────────────────────────────────


@pytest.fixture
def temp_niche_dir():
    """
    Create a temporary directoroy structure mimicking the real niche layout.

    Structure:
        {tmp}/
          research/
            N-999/
              _canvas/evidence/
              _canvas/frontmatter-N-999.yaml
              02-competitor-intel/
              04-voice-of-customer/
    """
    with tempfile.TemporaryDirectory(prefix="clarityrev-test-") as tmpdir:
        root = Path(tmpdir)
        research_dir = root / "research"
        niche_dir = research_dir / "N-999"
        canvas_dir = niche_dir / "_canvas"
        evidence_dir = canvas_dir / "evidence"
        frontmatter_file = canvas_dir / "frontmatter-N-999.yaml"
        ci_dir = niche_dir / "02-competitor-intel"
        voc_dir = niche_dir / "04-voice-of-customer"

        canvas_dir.mkdir(parents=True, exist_ok=True)
        evidence_dir.mkdir(parents=True, exist_ok=True)
        ci_dir.mkdir(parents=True, exist_ok=True)
        voc_dir.mkdir(parents=True, exist_ok=True)

        yield {
            "root": root,
            "research": research_dir,
            "niche_dir": niche_dir,
            "canvas_dir": canvas_dir,
            "evidence_dir": evidence_dir,
            "frontmatter": frontmatter_file,
            "ci_dir": ci_dir,
            "voc_dir": voc_dir,
        }


@pytest.fixture
def sample_trace_map(temp_niche_dir) -> Path:
    """
    Create a sample trace-map.yaml with 5 claims and varied sources.
    Two sources are stale (fresh_until in the past).
    One BLOCK-class source is stale and unrecoverable.
    """
    now = datetime.now(timezone.utc)
    past = (now - timedelta(days=30)).strftime("%Y-%m-%d")
    future = (now + timedelta(days=30)).strftime("%Y-%m-%d")
    far_past = (now - timedelta(days=400)).strftime("%Y-%m-%d")

    trace_map = {
        "claims": [
            {
                "claim_id": "C-001",
                "claim_text": "Competitor A has lower pricing",
                "sources": [
                    {
                        "source_file": "N-999/02-competitor-intel/N-999-competitor-pricing-acme-v1.yaml",
                        "fetch_date": future,
                        "freshness_status": "FRESH",
                        "fresh_until": future,
                        "data_type": "competitor_pricing",
                        "sla_class": "PRICING",
                    }
                ],
            },
            {
                "claim_id": "C-002",
                "claim_text": "Market growing 15% YoY",
                "sources": [
                    {
                        "source_file": "N-999/02-competitor-intel/N-999-market-sizing-v1.yaml",
                        "fetch_date": past,
                        "freshness_status": "STALE",
                        "fresh_until": past,
                        "data_type": "market_sizing",
                        "sla_class": "MARKET",
                    }
                ],
            },
            {
                "claim_id": "C-003",
                "claim_text": "Hiring spree at Competitor B",
                "sources": [
                    {
                        "source_file": "N-999/02-competitor-intel/N-999-hiring-signals-v1.yaml",
                        "fetch_date": far_past,
                        "freshness_status": "STALE",
                        "fresh_until": far_past,
                        "data_type": "hiring_signals",
                        "sla_class": "HIRING",
                        "re_fetch_attempted": True,
                        "re_fetch_success": False,
                    }
                ],
            },
            {
                "claim_id": "C-004",
                "claim_text": "News sentiment is positive",
                "sources": [
                    {
                        "source_file": "N-999/04-voice-of-customer/N-999-news-intent-v1.yaml",
                        "fetch_date": past,
                        "freshness_status": "STALE",
                        "fresh_until": past,
                        "data_type": "news_intent",
                        "sla_class": "INTENT",
                    }
                ],
            },
            {
                "claim_id": "C-005",
                "claim_text": "Multiple sources using same file",
                "sources": [
                    {
                        "source_file": "N-999/02-competitor-intel/N-999-competitor-pricing-acme-v1.yaml",
                        "fetch_date": future,
                        "freshness_status": "FRESH",
                        "fresh_until": future,
                        "data_type": "competitor_pricing",
                        "sla_class": "PRICING",
                    },
                    {
                        "source_file": "N-999/02-competitor-intel/N-999-tech-stack-v1.yaml",
                        "fetch_date": future,
                        "freshness_status": "FRESH",
                        "fresh_until": future,
                        "data_type": "technographics",
                        "sla_class": "TECHNO",
                    },
                ],
            },
        ]
    }

    tm_path = temp_niche_dir["evidence_dir"] / "trace-map.yaml"
    _write_yaml(tm_path, trace_map)
    return tm_path


@pytest.fixture
def sample_credit_budget(temp_niche_dir) -> Path:
    """Create a sample CREDIT_BUDGET.yaml for testing."""
    budget = {
        "firecrawl_remaining": 10000,
        "dataforseo_remaining": 50.0,
        "niches": {
            "N-001": {"estimated_credits": 150, "actual_credits": 142},
            "N-002": {"estimated_credits": 200, "actual_credits": 215},
        },
    }
    program_dir = temp_niche_dir["root"] / "research" / "_program"
    program_dir.mkdir(parents=True, exist_ok=True)
    path = program_dir / "CREDIT_BUDGET.yaml"
    _write_yaml(path, budget)
    return path


@pytest.fixture
def sample_cache_manifest(temp_niche_dir) -> Path:
    """Create a sample CACHE_MANIFEST.yaml with one fresh and one stale entry."""
    now = datetime.now(timezone.utc)
    fresh_file = temp_niche_dir["ci_dir"] / "N-999-competitor-pricing-acme-v1.yaml"
    fresh_content = {
        "fetch_date": now.strftime("%Y-%m-%d"),
        "competitor_id": "comp_acme_v1",
        "name": "Acme Corp",
    }
    _write_yaml(fresh_file, fresh_content)
    content_hash_fresh = f"sha256:{hashlib.sha256(Path(fresh_file).read_bytes()).hexdigest()}"

    stale_dir = temp_niche_dir["ci_dir"]
    stale_file = stale_dir / "N-999-market-sizing-v1.yaml"
    stale_content = {
        "fetch_date": (now - timedelta(days=400)).strftime("%Y-%m-%d"),
        "tam": {"revenue_eur": 1000000},
    }
    _write_yaml(stale_file, stale_content)
    content_hash_stale = f"sha256:{hashlib.sha256(Path(stale_file).read_bytes()).hexdigest()}"

    manifest = {
        "entries": {
            "sha256:aaaafreshhash1234567890abcdef": {
                "structured_file": "N-999/02-competitor-intel/N-999-competitor-pricing-acme-v1.yaml",
                "fetch_date": now.strftime("%Y-%m-%d"),
                "content_hash": content_hash_fresh,
            },
            "sha256:bbbstalehash1234567890abcdef": {
                "structured_file": "N-999/02-competitor-intel/N-999-market-sizing-v1.yaml",
                "fetch_date": (now - timedelta(days=400)).strftime("%Y-%m-%d"),
                "content_hash": content_hash_stale,
            },
        }
    }
    pipelines_dir = Path(__file__).resolve().parent.parent
    path = pipelines_dir / "CACHE_MANIFEST.yaml"
    _write_yaml(path, manifest)
    return path


@pytest.fixture
def sample_dead_host_registry(temp_niche_dir) -> Path:
    """Create a sample DEAD_HOST_REGISTRY.yaml."""
    registry = {
        "blocked_hosts": [
            {
                "host": "dead-site.example.com",
                "blocked_until": None,
                "reason": "Consistent 503 errors",
            },
            {
                "host": "expired-block.example.com",
                "blocked_until": (datetime.now(timezone.utc) - timedelta(days=10)).strftime("%Y-%m-%d"),
                "reason": "Was broken, now should be fine",
            },
        ]
    }
    program_dir = temp_niche_dir["root"] / "research" / "_program"
    program_dir.mkdir(parents=True, exist_ok=True)
    path = program_dir / "DEAD_HOST_REGISTRY.yaml"
    _write_yaml(path, registry)
    return path


@pytest.fixture
def sample_competitor_profile_yaml(temp_niche_dir) -> Dict[str, Path]:
    """
    Create a valid competitor-profile YAML file for schema validation tests,
    plus a few intentionally broken variants.
    """
    dir_ = temp_niche_dir["ci_dir"]

    valid = {
        "competitor_id": "comp_syncgtm_v1",
        "name": "SyncGTM",
        "url": "https://syncgtm.com",
        "fetch_date": "2026-07-01",
        "fetch_method": "firecrawl_scrape",
        "freshness_sla": "90d",
        "fresh_until": "2026-09-29",
        "freshness_status": "FRESH",
        "niches_where_relevant": [],
        "source_urls": [
            {
                "url": "https://syncgtm.com",
                "fetch_date": "2026-07-01",
                "http_status": 200,
                "content_hash": "sha256:abc123",
                "raw_file": ".firecrawl/syncgtm-com-20260701.md",
            }
        ],
        "profile": {
            "funding": "VC-backed ($5M Series A)",
            "delivery_model": "SOFTWARE",
            "gtm_motion": "Sales-led",
            "estimated_customers": "500+ (G2 reviews: 150)",
            "positioning_headline": "Revenue Intelligence for Modern GTM Teams",
            "pricing": [
                {
                    "tier": "Growth",
                    "price_monthly_eur": 1500,
                    "billing": "monthly",
                    "source_url": "https://syncgtm.com/pricing",
                    "source_verified_date": "2026-07-01",
                }
            ],
            "strengths": ["Multi-source signal detection", "Rich integrations"],
            "weaknesses": ["Self-serve pricing jumps at scale"],
            "review_summary": {
                "total_reviews_analyzed": 25,
                "sources": ["G2 (15)", "Capterra (7)", "Reddit (3)"],
                "avg_rating": 4.2,
                "top_praise": "Ease of use, multi-source signals",
                "top_complaint": "Pricing at scale",
            },
            "tech_stack": [
                {
                    "category": "AI/LLM",
                    "tools": ["GPT-4", "Claude"],
                    "detection_method": "dataforseo_domain_analytics",
                }
            ],
            "vulnerabilities": ["No native HubSpot integration"],
        },
    }

    missing_required = dict(valid)
    del missing_required["competitor_id"]

    invalid_enum = dict(valid)
    invalid_enum["fetch_method"] = "invalid_method"

    invalid_url = dict(valid)
    invalid_url["url"] = "not-a-url"

    rating_out_of_range = dict(valid)
    rating_out_of_range["profile"]["review_summary"]["avg_rating"] = 6.5

    total_reviews_mismatch = dict(valid)
    total_reviews_mismatch["profile"]["review_summary"]["total_reviews_analyzed"] = 999

    valid_path = dir_ / "N-999-competitor-profile-syncgtm-v1.yaml"
    missing_required_path = dir_ / "N-999-competitor-profile-missing-v1.yaml"
    invalid_enum_path = dir_ / "N-999-competitor-profile-enum-v1.yaml"
    invalid_url_path = dir_ / "N-999-competitor-profile-url-v1.yaml"
    rating_path = dir_ / "N-999-competitor-profile-rating-v1.yaml"
    reviews_path = dir_ / "N-999-competitor-profile-reviews-v1.yaml"

    _write_yaml(valid_path, valid)
    _write_yaml(missing_required_path, missing_required)
    _write_yaml(invalid_enum_path, invalid_enum)
    _write_yaml(invalid_url_path, invalid_url)
    _write_yaml(rating_path, rating_out_of_range)
    _write_yaml(reviews_path, total_reviews_mismatch)

    return {
        "valid": valid_path,
        "missing_required": missing_required_path,
        "invalid_enum": invalid_enum_path,
        "invalid_url": invalid_url_path,
        "rating_out_of_range": rating_path,
        "total_reviews_mismatch": reviews_path,
    }


@pytest.fixture
def sample_review_corpus_yaml(temp_niche_dir) -> Dict[str, Path]:
    """Create a valid review-corpus YAML file for schema validation tests."""
    dir_ = temp_niche_dir["voc_dir"]

    valid = {
        "competitor_name": "SyncGTM",
        "fetch_date": "2026-07-01",
        "total_reviews": 25,
        "sources": {
            "g2": {"count": 15, "url": "https://g2.com/products/syncgtm/reviews"},
            "capterra": {
                "count": 7,
                "url": "https://capterra.com/p/123/syncgtm/reviews",
            },
            "reddit": {"count": 3, "subreddits": ["r/RevOps", "r/sales"]},
        },
        "reviews": [
            {
                "review_id": "rev_001",
                "source": "g2",
                "source_url": "https://g2.com/products/syncgtm/reviews/1",
                "rating": 5,
                "reviewer_role": "VP Sales",
                "reviewer_company_size": "50-200 employees",
                "date": "2026-06-15",
                "title": "Great product",
                "pros": "Easy to set up",
                "cons": "",
                "verbatim_quotes": ["SyncGTM transformed our pipeline management."],
            },
            {
                "review_id": "rev_002",
                "source": "g2",
                "source_url": "https://g2.com/products/syncgtm/reviews/2",
                "rating": 4,
                "reviewer_role": "Revenue Operations Manager",
                "reviewer_company_size": "200-500 employees",
                "date": "2026-06-10",
                "title": "Good but pricey",
                "pros": "Accurate lead scoring",
                "cons": "Expensive at scale",
                "verbatim_quotes": [
                    "The lead scoring is the most accurate I have seen.",
                    "But it gets expensive quickly.",
                ],
            },
        ],
        "theme_analysis": {
            "top_praise_themes": [
                {"theme": "Ease of setup", "frequency": 15, "pct": 60},
            ],
            "top_complaint_themes": [
                {"theme": "Pricing at scale", "frequency": 8, "pct": 32},
            ],
        },
    }

    valid_path = dir_ / "N-999-review-corpus-syncgtm-v1.yaml"
    _write_yaml(valid_path, valid)
    return {"valid": valid_path}
