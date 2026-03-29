#!/usr/bin/env python3
"""Install Claude Code Plugins for OpenCode.

Usage:
    python install.py                  # Global install to ~/.config/opencode/
    python install.py <target-dir>     # Project-local install to <target-dir>/.opencode/
"""

import shutil
import sys
from pathlib import Path

COMPONENTS = ["skills", "agents", "commands", "plugins"]

script_dir = Path(__file__).resolve().parent
source_dir = script_dir / "plugin-src"

if len(sys.argv) > 1:
    install_dir = Path(sys.argv[1]).resolve() / ".opencode"
    install_mode = "project-local"
else:
    install_dir = Path.home() / ".config" / "opencode"
    install_mode = "global"

# Guard: source == target
if source_dir.resolve() == install_dir.resolve():
    print(f"Source and install directory are the same: {source_dir}")
    print("Nothing to copy — plugin files are already in place.")
    sys.exit(0)

print(f"Installing Claude Code Plugins for OpenCode ({install_mode})...")
print(f"Source: {source_dir}")
print(f"Target: {install_dir}")
print()

# Create target directories and copy components
for component in COMPONENTS:
    target = install_dir / component
    target.mkdir(parents=True, exist_ok=True)

    print(f"Installing {component}...")
    src = source_dir / component
    if src.exists():
        for item in src.iterdir():
            dest = target / item.name
            if item.is_dir():
                shutil.copytree(item, dest, dirs_exist_ok=True)
            else:
                shutil.copy2(item, dest)

# Summary
print()
print(f"Installation complete! ({install_mode})")
print()
print("Installed components:")

for component in COMPONENTS:
    target = install_dir / component
    if component == "skills":
        items = sorted(p.name for p in target.iterdir() if p.is_dir())
    elif component in ("agents", "commands"):
        items = sorted(p.name for p in target.iterdir() if p.suffix == ".md")
    else:
        items = sorted(p.name for p in target.iterdir()) if target.exists() else []

    print(f"  {component.capitalize()} ({len(items)}):")
    for name in items:
        print(f"    - {name}")

print()
if install_mode == "global":
    print("Global plugins loaded automatically. Restart OpenCode to apply.")
else:
    print("Restart OpenCode in your project directory to load the new components.")
