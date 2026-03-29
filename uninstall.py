#!/usr/bin/env python3
"""Uninstall Claude Code Plugins for OpenCode.

Usage:
    python uninstall.py                  # Uninstall from global ~/.config/opencode/
    python uninstall.py <target-dir>     # Uninstall from <target-dir>/.opencode/
"""

import shutil
import sys
from pathlib import Path

source_dir = Path(__file__).resolve().parent / "plugin-src"

if len(sys.argv) > 1:
    install_dir = Path(sys.argv[1]).resolve() / ".opencode"
    install_mode = "project-local"
else:
    install_dir = Path.home() / ".config" / "opencode"
    install_mode = "global"

if not install_dir.exists():
    print(f"Nothing to uninstall — {install_dir} does not exist.")
    sys.exit(0)

print(f"Uninstalling Claude Code Plugins for OpenCode ({install_mode})...")
print(f"Target: {install_dir}")
print()

removed = []

# Remove only the items that install.py would have copied from plugin-src
for component in ("skills", "agents", "commands", "plugins"):
    src = source_dir / component
    if not src.exists():
        continue
    for item in src.iterdir():
        target = install_dir / component / item.name
        if target.exists():
            if target.is_dir():
                shutil.rmtree(target)
            else:
                target.unlink()
            removed.append(f"{component}/{item.name}")

if not removed:
    print("No installed components found.")
    sys.exit(0)

# Clean up empty component directories
for component in ("skills", "agents", "commands", "plugins"):
    comp_dir = install_dir / component
    if comp_dir.exists() and not any(comp_dir.iterdir()):
        comp_dir.rmdir()

# Clean up empty install directory
if install_dir.exists() and not any(install_dir.iterdir()):
    install_dir.rmdir()

print(f"Removed {len(removed)} components:")
for name in sorted(removed):
    print(f"  - {name}")
print()
print("Uninstall complete.")
