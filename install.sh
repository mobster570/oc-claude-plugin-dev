#!/bin/bash
# install.sh — Install Claude Code Plugins for OpenCode
# Usage: bash install.sh [target-directory]
# Default target: current directory

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-$(pwd)}"

echo "Installing Claude Code Plugins for OpenCode..."
echo "Source: $SCRIPT_DIR"
echo "Target: $TARGET_DIR"
echo ""

# Check if target .opencode/ already exists
if [ -d "$TARGET_DIR/.opencode" ]; then
    echo "WARNING: $TARGET_DIR/.opencode already exists."
    echo "Merging into existing directory (existing files may be overwritten)."
    echo ""
fi

# Create target directories
mkdir -p "$TARGET_DIR/.opencode/skills"
mkdir -p "$TARGET_DIR/.opencode/agents"
mkdir -p "$TARGET_DIR/.opencode/commands"

shopt -s nullglob

# Copy skills (8 skill directories)
echo "Installing skills..."
for skill in "$SCRIPT_DIR/.opencode/skills"/*; do
    cp -R "$skill" "$TARGET_DIR/.opencode/skills/"
done

# Copy agents (4 agent files)
echo "Installing agents..."
for agent in "$SCRIPT_DIR/.opencode/agents"/*; do
    cp -R "$agent" "$TARGET_DIR/.opencode/agents/"
done

# Copy commands (1 command file)
echo "Installing commands..."
for cmd in "$SCRIPT_DIR/.opencode/commands"/*; do
    cp -R "$cmd" "$TARGET_DIR/.opencode/commands/"
done

# Summary
echo ""
echo "Installation complete!"
echo ""
echo "Installed components:"

skills=("$TARGET_DIR/.opencode/skills"/*/)
echo "  Skills (${#skills[@]}):"
for skill in "${skills[@]}"; do
    [ -e "$skill" ] || continue
    echo "    - $(basename "$skill")"
done

agents=("$TARGET_DIR/.opencode/agents"/*.md)
echo "  Agents (${#agents[@]}):"
for agent in "${agents[@]}"; do
    [ -e "$agent" ] || continue
    echo "    - $(basename "$agent")"
done

commands=("$TARGET_DIR/.opencode/commands"/*.md)
echo "  Commands (${#commands[@]}):"
for cmd in "${commands[@]}"; do
    [ -e "$cmd" ] || continue
    echo "    - $(basename "$cmd")"
done

echo ""
echo "Usage: Restart OpenCode in your project directory to load the new components."
