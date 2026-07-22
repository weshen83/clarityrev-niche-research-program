# Niche Program — Schema Validation Files

## Purpose

This directory contains JSON Schema–compatible YAML schema definitions for all
structured data formats used in the 25-niche evaluation program. These schemas
validate data at **ingestion time** — before any data enters the pipeline or is
consumed by canvas authoring agents.

## Why Schema Validation at Ingestion Time?

- **Catches errors early.** Schema violations are detected before they propagate
  into mid-canvas processing, where they would be harder to trace and fix.
- **Enforces consistency.** Every niche agent produces data in the same format,
  enabling automated aggregation in `_program/LEDGER.yaml` and cross-niche
  comparison.
- **Provides clear error messages.** Agents receive immediate feedback on which
  fields are missing, which values are out of range, and which enum constraints
  are violated.

## Schema Files

| File | Source | Validates |
|---|---|---|
| `competitor-profile-schema.yaml` | DATA-OPERATIONS-ARCHITECTURE.md §5.1 | Competitor profile files in `02-competitor-intel/` |
| `review-corpus-schema.yaml` | DATA-OPERATIONS-ARCHITECTURE.md §5.2 | Review corpus files in `04-voice-of-customer/` |
| `market-sizing-schema.yaml` | DATA-OPERATIONS-ARCHITECTURE.md §5.3 | Market sizing files in `03-market-sizing/` |
| `canvas-frontmatter-schema.yaml` | NICHE-METHODOLOGY.md §6.2 | Canvas YAML frontmatter in `_canvas/frontmatter-N-XXX.yaml` |

## Schema Format

Each schema file defines:

- **`schema`** — metadata (name, version, source document, file pattern)
- **`fields`** — the full field list with:
  - `field` — field name
  - `type` — data type (string, integer, number, boolean, array, object)
  - `required` — REQUIRED or OPTIONAL (with default if applicable)
  - `description` — field purpose and formatting rules
  - `enum` — controlled vocabulary where applicable
  - `validation` — field-level constraints
- **`enums`** — consolidated reference for controlled vocabularies
- **`validation`** — cross-field validation rules with severity (ERROR or WARNING)

## Validation Script

The validation pipeline is executed via:

```
_pipelines/validate-schema.sh
```

(To be created. The script reads each structured data file, validates it against
the corresponding schema, and reports PASS/FAIL with detailed error messages.)

## Integration

- Schema validation runs at the **ingestion gate** before any data is written to
  `niche-program/research/{NICHE_ID}/` directories.
- Each schema follows the specifications in DATA-OPERATIONS-ARCHITECTURE.md §5
  and NICHE-METHODOLOGY.md §6.2.
- Frontmatter validation is required before any canvas is accepted into
  `_program/LEDGER.yaml` aggregation.
- The `schema_violations` field in `canvas-frontmatter-schema.yaml` tracks the
  count of validation failures for each niche.
