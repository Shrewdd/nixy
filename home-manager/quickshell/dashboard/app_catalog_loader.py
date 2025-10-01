#!/usr/bin/env python3
from __future__ import annotations

import configparser
"""Legacy stub kept for reference.

The dashboard no longer imports this module directly; its application discovery
logic is now embedded inline within `shell.qml` so the Quickshell runtime can
boot without relying on external scripts. The file is intentionally left as a
placeholder to preserve git history and to document why the script disappeared.

Once all downstream references are removed, this file can be safely deleted.
"""

__all__ = ["app_catalog_loader"]


def app_catalog_loader():  # pragma: no cover - placeholder shim
    """Return an empty catalog and explain deprecation."""

    return {
        "apps": [],
        "note": (
            "app_catalog_loader.py is deprecated; the loader now lives inline "
            "in shell.qml."
        ),
    }
        os.path.join(home, ".local", "share", "applications"),
