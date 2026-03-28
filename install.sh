#!/bin/bash
# install.sh — Install Claude Code Plugins for OpenCode
# Usage:
#   bash install.sh                  # Global install to ~/.config/opencode/
#   bash install.sh <target-dir>     # Project-local install to <target-dir>/.opencode/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/.opencode"

if [ -n "$1" ]; then
    # Project-local install
    INSTALL_DIR="$1/.opencode"
    INSTALL_MODE="project-local"
else
    # Global install
    INSTALL_DIR="$HOME/.config/opencode"
    INSTALL_MODE="global"
fi

# Guard: source == target
RESOLVED_SOURCE="$(cd "$SOURCE_DIR" 2>/dev/null && pwd)"
RESOLVED_INSTALL="$(cd "$INSTALL_DIR" 2>/dev/null && pwd)" 2>/dev/null || true
if [ -n "$RESOLVED_SOURCE" ] && [ -n "$RESOLVED_INSTALL" ] && [ "$RESOLVED_SOURCE" = "$RESOLVED_INSTALL" ]; then
    echo "Source and install directory are the same: $RESOLVED_SOURCE"
    echo "Nothing to copy — plugin files are already in place."
    exit 0
fi

echo "Installing Claude Code Plugins for OpenCode ($INSTALL_MODE)..."
echo "Source: $SOURCE_DIR"
echo "Target: $INSTALL_DIR"
echo ""

# Check if target already exists
if [ -d "$INSTALL_DIR" ]; then
    echo "WARNING: $INSTALL_DIR already exists."
    echo "Merging into existing directory (existing files may be overwritten)."
    echo ""
fi

# Create target directories
mkdir -p "$INSTALL_DIR/skills"
mkdir -p "$INSTALL_DIR/agents"
mkdir -p "$INSTALL_DIR/commands"
mkdir -p "$INSTALL_DIR/plugins"

shopt -s nullglob

# Copy skills
echo "Installing skills..."
for skill in "$SOURCE_DIR/skills"/*; do
    cp -R "$skill" "$INSTALL_DIR/skills/"
done

# Copy agents
echo "Installing agents..."
for agent in "$SOURCE_DIR/agents"/*; do
    cp -R "$agent" "$INSTALL_DIR/agents/"
done

# Copy commands
echo "Installing commands..."
for cmd in "$SOURCE_DIR/commands"/*; do
    cp -R "$cmd" "$INSTALL_DIR/commands/"
done

# Copy plugins
echo "Installing plugins..."
for plugin in "$SOURCE_DIR/plugins"/*; do
    cp -R "$plugin" "$INSTALL_DIR/plugins/"
done

# Summary
echo ""
echo "Installation complete! ($INSTALL_MODE)"
echo ""
echo "Installed components:"

skills=("$INSTALL_DIR/skills"/*/)
echo "  Skills (${#skills[@]}):"
for skill in "${skills[@]}"; do
    [ -e "$skill" ] || continue
    echo "    - $(basename "$skill")"
done

agents=("$INSTALL_DIR/agents"/*.md)
echo "  Agents (${#agents[@]}):"
for agent in "${agents[@]}"; do
    [ -e "$agent" ] || continue
    echo "    - $(basename "$agent")"
done

commands=("$INSTALL_DIR/commands"/*.md)
echo "  Commands (${#commands[@]}):"
for cmd in "${commands[@]}"; do
    [ -e "$cmd" ] || continue
    echo "    - $(basename "$cmd")"
done

plugins=("$INSTALL_DIR/plugins"/*)
echo "  Plugins (${#plugins[@]}):"
for plugin in "${plugins[@]}"; do
    [ -e "$plugin" ] || continue
    echo "    - $(basename "$plugin")"
done

echo ""
if [ "$INSTALL_MODE" = "global" ]; then
    echo "Global plugins loaded automatically. Restart OpenCode to apply."
else
    echo "Restart OpenCode in your project directory to load the new components."
fi
