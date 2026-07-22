"""
file_lock.py — Advisory file locking for concurrent agent access.

Google SRE pattern: lock before mutate. Wait with backoff. Break stale locks.
Designed for 4 concurrent niche agents reading/writing shared YAML files.

Usage:
    with FileLock(path_to_shared_file, timeout_seconds=30):
        data = load_yaml_safe(path)
        data["new_entry"] = ...
        write_yaml_atomic(data, path)
"""

import os
import time
from pathlib import Path


class FileLockError(Exception):
    """Base exception for FileLock failures."""
    pass


class FileLock:
    """Advisory file lock using atomic O_CREAT|O_EXCL lock file creation.

    Implements the context manager protocol so locks are always released,
    even on exception.

    Attributes:
        lock_path: Path to the lock file (hidden .<filename>.lock).
        timeout: Maximum seconds to wait for lock acquisition.
        _held: Whether the lock is currently held by this instance.
    """

    def __init__(self, file_path: Path, timeout_seconds: int = 30):
        self.lock_path = file_path.parent / f".{file_path.name}.lock"
        self.timeout = timeout_seconds
        self._held = False

    def __enter__(self) -> "FileLock":
        waited = 0
        while waited < self.timeout:
            try:
                # Create lock file atomically (O_EXCL fails if exists)
                fd = os.open(
                    str(self.lock_path),
                    os.O_CREAT | os.O_EXCL | os.O_WRONLY,
                )
                os.write(
                    fd,
                    f"locked_by=niche_agent\ntimestamp={time.time()}\n".encode(),
                )
                os.close(fd)
                self._held = True
                return self
            except FileExistsError:
                # Check if lock is stale (>5 minutes old)
                if self._is_stale():
                    self._break_lock()
                    continue
                time.sleep(1)
                waited += 1
        raise FileLockError(
            f"Could not acquire lock on {self.lock_path} "
            f"within {self.timeout}s"
        )

    def __exit__(self, *args) -> None:
        self.release()

    def release(self) -> None:
        """Release the lock by removing the lock file."""
        if self._held and self.lock_path.exists():
            self.lock_path.unlink(missing_ok=True)
        self._held = False

    def _is_stale(self) -> bool:
        """Check if the existing lock file is older than 5 minutes."""
        try:
            mtime = self.lock_path.stat().st_mtime
            return (time.time() - mtime) > 300  # 5 minutes
        except OSError:
            return True

    def _break_lock(self) -> None:
        """Remove a stale lock file."""
        self.lock_path.unlink(missing_ok=True)
