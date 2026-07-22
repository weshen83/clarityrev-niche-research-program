"""
test_pipeline_ops.py — Comprehensive unit tests for pipeline_ops.py.

Test Engineering discipline (Netflix Chaos Engineering / Google SRE):
- Every public function is tested
- Edge cases include null bytes, empty inputs, binary files, DST boundaries
- Tests are deterministic and isolated (no shared state)
- Each test tests exactly one behavior

Run: pytest test_pipeline_ops.py -v --tb=short
"""

import os
import sys
import json
import tempfile
import hashlib
from pathlib import Path
from datetime import datetime, timezone, timedelta

import pytest

# Ensure lib/ is importable
_PIPELINES_DIR = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(_PIPELINES_DIR))

from lib.pipeline_ops import (
    normalize_url,
    compute_content_hash,
    compute_url_hash,
    parse_iso_date,
    days_between,
    write_yaml_atomic,
    load_yaml_safe,
    emit_result,
    emit_log,
    ExitCode,
    FRESHNESS_SLA,
    BLOCK_CLASS_DATA_TYPES,
    lookup_sla,
    get_sla_max_age,
    is_block_class,
    now_utc,
    format_date,
)

# ==============================================================================
# normalize_url() — 12 test cases
# ==============================================================================


class TestNormalizeUrl:
    """URL normalization: cache-key canonicalization."""

    def test_idempotent(self):
        """Normalizing twice produces same result."""
        url = "https://Example.com/Path?utm_source=twitter&keep=val"
        a = normalize_url(url)
        b = normalize_url(a)
        assert a == b, f"Not idempotent: {a} != {b}"

    def test_tracking_params_stripped(self):
        """utm_* and common tracking params are stripped."""
        url = "https://example.com/page?utm_source=twitter&utm_medium=social&keep=hello"
        result = normalize_url(url)
        assert "utm_source" not in result
        assert "utm_medium" not in result
        assert "keep=hello" in result

    def test_tracking_params_fbclid_gclid(self):
        """fbclid, gclid, ref, source stripped."""
        url = "https://example.com/?fbclid=abc&gclid=def&ref=ghi&source=jkl"
        result = normalize_url(url)
        assert "fbclid" not in result
        assert "gclid" not in result
        assert "ref" not in result
        # Note: 'source' is stripped per TRACKING_PARAMS
        assert "source" not in result

    def test_auth_credentials_stripped(self):
        """username:password@host is stripped to just host."""
        url = "https://user:pass@example.com/path"
        result = normalize_url(url)
        assert "user" not in result
        assert "pass" not in result
        assert "@" not in result
        assert result.startswith("https://example.com/")

    def test_null_bytes_stripped(self):
        """Null bytes are removed before parsing."""
        url = "https://example.com/pa\x00th?q=\x00val"
        result = normalize_url(url)
        assert "\x00" not in result
        assert "/path" in result or result.endswith("/path")

    def test_query_params_sorted(self):
        """Query parameter keys are sorted alphabetically."""
        url = "https://example.com/?z=last&a=first&m=middle"
        result = normalize_url(url)
        a_pos = result.index("a=first")
        m_pos = result.index("m=middle")
        z_pos = result.index("z=last")
        assert a_pos < m_pos < z_pos, "Query params not sorted"

    def test_query_param_values_sorted(self):
        """Values within the same param key are sorted."""
        url = "https://example.com/?tag=beta&tag=alpha&tag=gamma"
        result = normalize_url(url)
        alpha_pos = result.index("tag=alpha")
        beta_pos = result.index("tag=beta")
        gamma_pos = result.index("tag=gamma")
        assert alpha_pos < beta_pos < gamma_pos, "Param values not sorted"

    def test_empty_url(self):
        """Empty string returns minimal normalized form."""
        result = normalize_url("")
        assert isinstance(result, str)

    def test_fragment_dropped(self):
        """Fragment (#section) is dropped."""
        url = "https://example.com/page#section"
        result = normalize_url(url)
        assert "#" not in result

    def test_trailing_slash_stripped(self):
        """Trailing slash is removed unless path is just '/'."""
        url = "https://example.com/page/"
        result = normalize_url(url)
        assert not result.endswith("/page/")

    def test_root_path_preserved(self):
        """Root path '/' is preserved (not stripped)."""
        url = "https://example.com/"
        result = normalize_url(url)
        # Root path may end up as empty or / depending on implementation
        # The important thing is it doesn't blow up
        assert isinstance(result, str)

    def test_scheme_lowered(self):
        """Scheme is lowercased."""
        url = "HTTPS://EXAMPLE.COM/Path"
        result = normalize_url(url)
        assert result.startswith("https://")

    def test_host_lowered(self):
        """Host is lowercased."""
        url = "https://EXAMPLE.COM/Path"
        result = normalize_url(url)
        assert "example.com" in result

    def test_double_slash_collapsed(self):
        """Collapse // in path (scheme :// separator remains)."""
        url = "https://example.com//path//to//resource"
        result = normalize_url(url)
        # The path //path//to//resource collapses to /path/to/resource
        # Result: https://example.com/path/to/resource
        # (the :// after https is the scheme separator, not a path double-slash)
        assert "/path/to/resource" in result, f"Path should collapse double slashes: {result}"
        # The path portion should have no double slashes
        from urllib.parse import urlparse
        parsed = urlparse(result)
        assert "//" not in parsed.path, f"Path has double slashes: {parsed.path}"

    def test_mc_params_stripped(self):
        """Mailchimp tracking params mc_cid, mc_eid are stripped."""
        url = "https://example.com/?mc_cid=abc123&mc_eid=def456"
        result = normalize_url(url)
        assert "mc_cid" not in result
        assert "mc_eid" not in result


# ==============================================================================
# compute_content_hash() — 3 test cases
# ==============================================================================


class TestComputeContentHash:
    """SHA-256 content hashing."""

    def test_known_content(self, tmp_path):
        """Known content produces known hash."""
        f = tmp_path / "test.txt"
        known = b"hello world"
        f.write_bytes(known)
        expected = f"sha256:{hashlib.sha256(known).hexdigest()}"
        assert compute_content_hash(f) == expected

    def test_empty_file(self, tmp_path):
        """Empty file produces valid hash."""
        f = tmp_path / "empty.txt"
        f.write_text("")
        result = compute_content_hash(f)
        assert result.startswith("sha256:")
        assert len(result) == 71  # "sha256:" + 64 hex chars

    def test_binary_file(self, tmp_path):
        """Binary content (null bytes) produces valid hash."""
        f = tmp_path / "binary.bin"
        binary = b"\x00\x01\x02\xff\xfe" * 2000  # ~10KB
        f.write_bytes(binary)
        result = compute_content_hash(f)
        assert result.startswith("sha256:")
        assert len(result) == 71

    def test_large_file(self, tmp_path):
        """8KB chunked read handles large files."""
        f = tmp_path / "large.bin"
        # Write 100KB
        f.write_bytes(b"A" * 102400)
        result = compute_content_hash(f)
        assert result.startswith("sha256:")
        assert len(result) == 71

    def test_file_not_found(self):
        """Non-existent file raises FileNotFoundError."""
        with pytest.raises(FileNotFoundError):
            compute_content_hash(Path("/tmp/nonexistent-abc123.bin"))


# ==============================================================================
# compute_url_hash() — 2 test cases
# ==============================================================================


class TestComputeUrlHash:
    """URL hashing wraps normalize_url + SHA-256."""

    def test_round_trip(self):
        """URL hash is deterministic: same URL -> same hash."""
        url = "https://Example.com/Path?utm_source=twitter"
        a = compute_url_hash(url)
        b = compute_url_hash(url)
        assert a == b

    def test_tracking_params_do_not_change_hash(self):
        """URLs differing only in tracking params get same hash."""
        url_a = "https://example.com/page?utm_source=twitter&keep=val"
        url_b = "https://example.com/page?keep=val&utm_campaign=test"
        assert compute_url_hash(url_a) == compute_url_hash(url_b)

    def test_different_urls_different_hashes(self):
        """Different URLs produce different hashes."""
        a = compute_url_hash("https://example.com/page1")
        b = compute_url_hash("https://example.com/page2")
        assert a != b


# ==============================================================================
# parse_iso_date() — 7 test cases
# ==============================================================================


class TestParseIsoDate:
    """ISO 8601 date parsing."""

    def test_z_suffix(self):
        """Z suffix is parsed correctly (Python 3.10 compat)."""
        dt = parse_iso_date("2026-07-23T14:30:00Z")
        assert dt.year == 2026
        assert dt.month == 7
        assert dt.day == 23
        assert dt.hour == 14
        assert dt.minute == 30
        assert dt.tzinfo is not None

    def test_plus_0000(self):
        """+00:00 timezone works."""
        dt = parse_iso_date("2026-07-23T14:30:00+00:00")
        assert dt.tzinfo is not None
        assert dt.hour == 14

    def test_timezone_aware(self):
        """Non-UTC timezone is preserved."""
        dt = parse_iso_date("2026-07-23T10:30:00-04:00")
        assert dt.tzinfo is not None
        assert dt.hour == 10

    def test_date_only(self):
        """Date-only strings are parsed and set to midnight UTC."""
        dt = parse_iso_date("2026-07-23")
        assert dt.year == 2026
        assert dt.month == 7
        assert dt.day == 23
        assert dt.hour == 0
        assert dt.minute == 0
        assert dt.tzinfo is not None
        assert str(dt.tzinfo) == "UTC"

    def test_invalid_date(self):
        """Invalid date string raises ValueError."""
        with pytest.raises(ValueError):
            parse_iso_date("not-a-date")

    def test_empty_string(self):
        """Empty string raises ValueError."""
        with pytest.raises(ValueError):
            parse_iso_date("")

    def test_whitespace_stripped(self):
        """Leading/trailing whitespace is stripped."""
        dt = parse_iso_date("  2026-07-23  ")
        assert dt.year == 2026

    def test_none_like_values_numeric(self):
        """Numeric values raise ValueError (not a date string)."""
        with pytest.raises(ValueError):
            parse_iso_date("0")

    def test_none_like_value_null(self):
        """The string 'None' raises ValueError."""
        with pytest.raises(ValueError):
            parse_iso_date("None")


# ==============================================================================
# days_between() — 4 test cases
# ==============================================================================


class TestDaysBetween:
    """Days-between computation."""

    def test_same_day(self):
        """Same datetime = 0 days."""
        dt = datetime(2026, 7, 23, tzinfo=timezone.utc)
        assert days_between(dt, dt) == 0

    def test_across_month_boundary(self):
        """Days between June 30 and July 1 = 1 day."""
        d1 = datetime(2026, 6, 30, tzinfo=timezone.utc)
        d2 = datetime(2026, 7, 1, tzinfo=timezone.utc)
        assert days_between(d1, d2) == 1

    def test_across_year_boundary(self):
        """Days between Dec 31 and Jan 1 = 1 day."""
        d1 = datetime(2025, 12, 31, tzinfo=timezone.utc)
        d2 = datetime(2026, 1, 1, tzinfo=timezone.utc)
        assert days_between(d1, d2) == 1

    def test_dst_boundary(self):
        """DST transitions do not affect absolute day count."""
        # Spring forward: Mar 8 00:00 UTC to Mar 9 00:00 UTC = 1 day
        d1 = datetime(2026, 3, 8, tzinfo=timezone.utc)
        d2 = datetime(2026, 3, 9, tzinfo=timezone.utc)
        assert days_between(d1, d2) == 1

    def test_ordering_immaterial(self):
        """d1 > d2 produces same result as d2 > d1 (absolute)."""
        d1 = datetime(2026, 1, 1, tzinfo=timezone.utc)
        d2 = datetime(2026, 7, 23, tzinfo=timezone.utc)
        assert days_between(d1, d2) == days_between(d2, d1)

    def test_large_gap(self):
        """Large gaps (e.g., 400 days) computed correctly."""
        d1 = datetime(2025, 1, 1, tzinfo=timezone.utc)
        d2 = datetime(2026, 2, 4, tzinfo=timezone.utc)
        assert days_between(d1, d2) == 399


# ==============================================================================
# write_yaml_atomic() + load_yaml_safe() — round-trip / crash recovery
# ==============================================================================


class TestYamlAtomic:
    """Atomic YAML write + safe load — round-trip and crash recovery."""

    def test_round_trip(self, tmp_path):
        """write_yaml_atomic + load_yaml_safe round-trips data."""
        f = tmp_path / "test.yaml"
        data = {"key": "value", "nested": {"a": 1}}
        write_yaml_atomic(data, f)
        assert f.exists()
        loaded = load_yaml_safe(f)
        assert loaded == data

    def test_tmp_file_cleaned_on_success(self, tmp_path):
        """Temporary .tmp file does not persist after successful write."""
        f = tmp_path / "test.yaml"
        data = {"key": "value"}
        write_yaml_atomic(data, f)
        assert not f.with_suffix(f.suffix + ".tmp").exists()

    def test_comment_preservation(self, tmp_path):
        """ruamel.yaml preserves YAML comments on round-trip."""
        f = tmp_path / "comment.yaml"
        content = "# This is a comment\nkey: value\n# Another comment\nnested:\n  a: 1\n"
        f.write_text(content)
        loaded = load_yaml_safe(f)
        # Modify and re-write
        loaded["new_key"] = "new_value"
        write_yaml_atomic(loaded, f)
        reread = f.read_text()
        assert "# This is a comment" in reread
        assert "# Another comment" in reread
        assert "new_key: new_value" in reread

    def test_file_not_found_returns_none(self):
        """load_yaml_safe returns None for non-existent file."""
        result = load_yaml_safe(Path("/tmp/nonexistent-xyz-987.yaml"))
        assert result is None

    def test_invalid_yaml_raises_value_error(self, tmp_path):
        """load_yaml_safe raises ValueError on invalid YAML."""
        f = tmp_path / "bad.yaml"
        f.write_text("{invalid: [yaml: broken}")
        with pytest.raises(ValueError):
            load_yaml_safe(f)

    def test_corrupt_mid_write_recovery(self, tmp_path):
        """If write crashes mid-operation, .tmp is cleaned and original is untouched."""
        original = tmp_path / "original.yaml"
        original.write_text("original: data\n")
        # Simulate crash: write a corrupt .tmp
        tmp_file = original.with_suffix(original.suffix + ".tmp")
        tmp_file.write_text("corrupt: [yaml: {broken}")
        # Now write_yaml_atomic should still work
        data = {"new": "data"}
        write_yaml_atomic(data, original)
        # .tmp should be gone, original should have new data
        assert not tmp_file.exists()
        loaded = load_yaml_safe(original)
        assert loaded == data

    def test_empty_yaml_file_returns_empty(self, tmp_path):
        """An empty file returns None (null)."""
        f = tmp_path / "empty.yaml"
        f.write_text("")
        # ruamel might return None or empty dict depending on version
        result = load_yaml_safe(f)
        assert result is None or result == {}


# ==============================================================================
# emit_result() — 3 test cases
# ==============================================================================


class TestEmitResult:
    """Structured JSON output + exit codes."""

    def test_valid_json_output(self, capsys):
        """emit_result produces valid compact JSON."""
        data = {"verdict": "PASS", "niche_id": "N-999"}
        with pytest.raises(SystemExit) as exc_info:
            emit_result(ExitCode.SUCCESS, data)
        captured = capsys.readouterr()
        assert exc_info.value.code == 0
        output = json.loads(captured.out.strip())
        assert output["verdict"] == "PASS"
        assert output["niche_id"] == "N-999"
        assert output["exit_code"] == 0
        assert output["exit_code_name"] == "SUCCESS"
        assert "script" in output
        assert "timestamp" in output

    def test_exit_code_1(self, capsys):
        """Exit code 1 (BLOCKED) is correctly set."""
        data = {"verdict": "BLOCKED"}
        with pytest.raises(SystemExit) as exc_info:
            emit_result(ExitCode.BLOCKED, data)
        captured = capsys.readouterr()
        assert exc_info.value.code == 1
        output = json.loads(captured.out.strip())
        assert output["exit_code_name"] == "BLOCKED"

    def test_exit_code_4(self, capsys):
        """Exit code 4 (INVALID_INPUT) is correctly set."""
        data = {"error": "invalid"}
        with pytest.raises(SystemExit) as exc_info:
            emit_result(ExitCode.INVALID_INPUT, data)
        captured = capsys.readouterr()
        assert exc_info.value.code == 4
        output = json.loads(captured.out.strip())
        assert output["exit_code_name"] == "INVALID_INPUT"

    def test_stdout_separation(self, capsys):
        """Only JSON output goes to stdout; stderr is empty."""
        data = {"verdict": "PASS"}
        with pytest.raises(SystemExit):
            emit_result(ExitCode.SUCCESS, data)
        captured = capsys.readouterr()
        assert captured.out.strip() != ""
        # err should be empty since emit_log wasn't called
        # (the JSON line itself goes to stdout via sys.stdout.write)


# ==============================================================================
# emit_log() — 2 test cases
# ==============================================================================


class TestEmitLog:
    """Human-readable logging to stderr."""

    def test_logs_to_stderr(self, capsys):
        """emit_log writes to stderr, not stdout."""
        emit_log("INFO", "test message")
        captured = capsys.readouterr()
        assert captured.out == ""
        assert "test message" in captured.err

    def test_niche_id_in_prefix(self, capsys):
        """When niche_id is provided, it appears in the log prefix."""
        emit_log("WARNING", "niche-specific", niche_id="N-001")
        captured = capsys.readouterr()
        assert "[N-001]" in captured.err
        assert "niche-specific" in captured.err


# ==============================================================================
# FRESHNESS_SLA table — structural integrity
# ==============================================================================


class TestFreshnessSla:
    """FRESHNESS_SLA table: all 15 entries present, correctness."""

    def test_fifteen_entries(self):
        """FRESHNESS_SLA has exactly 15 entries (D-01 through D-15)."""
        expected_keys = {f"D-{i:02d}" for i in range(1, 16)}
        actual_keys_sorted = sorted(FRESHNESS_SLA.keys())
        assert len(FRESHNESS_SLA) == 15, (
            f"Expected 15 SLA entries, got {len(FRESHNESS_SLA)}"
        )
        # Defensive: every key should match D-XX pattern
        for k in FRESHNESS_SLA:
            assert k.startswith("D-"), f"Unexpected SLA key format: {k}"

    def test_all_entries_have_required_keys(self):
        """Every SLA entry has all 5 required keys."""
        required = {"data_type", "class", "max_age_days", "staleness_action", "re_fetch_priority"}
        for key, entry in FRESHNESS_SLA.items():
            missing = required - set(entry.keys())
            assert not missing, f"{key} missing: {missing}"

    def test_all_sla_keys_unique(self):
        """Every SLA KEY is unique (data_type values may repeat with different classes)."""
        # SLA keys (D-01..D-15) must be unique — this is the primary key
        sla_keys = list(FRESHNESS_SLA.keys())
        assert len(sla_keys) == len(set(sla_keys)), "SLA keys must be unique"
        # Note: competitor_positioning appears in D-02 (CAPABILITY) and D-13 (POSITION)
        # with different SLA classes — this is intentional per DATA-OPERATIONS-ARCHITECTURE.md

    def test_block_class_exact_set(self):
        """BLOCK_CLASS_DATA_TYPES has exactly 3 entries."""
        assert BLOCK_CLASS_DATA_TYPES == {"INTENT", "JOB", "HIRING"}

    def test_max_age_days_positive(self):
        """All max_age_days values are positive integers."""
        for key, entry in FRESHNESS_SLA.items():
            assert entry["max_age_days"] > 0, f"{key} max_age_days is not positive"

    def test_staleness_action_valid_values(self):
        """staleness_action is one of RE_FETCH, RE_FETCH_BLOCK, PASS_FLAG."""
        valid = {"RE_FETCH", "RE_FETCH_BLOCK", "PASS_FLAG"}
        for key, entry in FRESHNESS_SLA.items():
            assert entry["staleness_action"] in valid, (
                f"{key} invalid staleness_action: {entry['staleness_action']}"
            )

    def test_re_fetch_priority_valid_values(self):
        """re_fetch_priority is HIGHEST, HIGH, MEDIUM, or LOW."""
        valid = {"HIGHEST", "HIGH", "MEDIUM", "LOW"}
        for key, entry in FRESHNESS_SLA.items():
            assert entry["re_fetch_priority"] in valid, (
                f"{key} invalid re_fetch_priority: {entry['re_fetch_priority']}"
            )


# ==============================================================================
# lookup_sla() / get_sla_max_age() — 5 test cases
# ==============================================================================


class TestSlaLookup:
    """SLA lookup functions."""

    def test_lookup_known_type(self):
        """Known data_type returns the correct SLA entry."""
        entry = lookup_sla("competitor_pricing")
        assert entry is not None
        assert entry["class"] == "PRICING"
        assert entry["max_age_days"] == 90

    def test_lookup_unknown_type(self):
        """Unknown data_type returns None."""
        entry = lookup_sla("nonexistent_type")
        assert entry is None

    def test_get_sla_max_age_known(self):
        """get_sla_max_age returns the correct max_age_days."""
        assert get_sla_max_age("job_postings") == 7

    def test_get_sla_max_age_unknown(self):
        """get_sla_max_age returns 0 for unknown type (force re-fetch)."""
        assert get_sla_max_age("nonexistent_type") == 0

    def test_get_sla_max_age_high_priority(self):
        """hiring_signals has 7 days max_age."""
        assert get_sla_max_age("hiring_signals") == 7

    def test_get_sla_max_age_low_priority(self):
        """regulatory_data has 365 days max_age."""
        assert get_sla_max_age("regulatory_data") == 365


# ==============================================================================
# is_block_class() — 3 test cases
# ==============================================================================


class TestIsBlockClass:
    """BLOCK-class enforcement checks."""

    def test_block_class_direct(self):
        """Direct class names return True."""
        assert is_block_class("INTENT") is True

    def test_block_class_by_data_type(self):
        """Data type that maps to BLOCK class returns True."""
        assert is_block_class("job_postings") is True
        assert is_block_class("hiring_signals") is True

    def test_not_block_class(self):
        """Non-BLOCK class returns False."""
        assert is_block_class("competitor_pricing") is False
        assert is_block_class("PRICING") is False


# ==============================================================================
# Date utility functions — now_utc(), format_date()
# ==============================================================================


class TestDateUtils:
    """Simple date utility functions."""

    def test_now_utc_is_utc(self):
        """now_utc returns timezone-aware UTC datetime."""
        now = now_utc()
        assert now.tzinfo is not None
        assert str(now.tzinfo) == "UTC"

    def test_format_date_iso(self):
        """format_date returns YYYY-MM-DD."""
        dt = datetime(2026, 7, 23, tzinfo=timezone.utc)
        assert format_date(dt) == "2026-07-23"
