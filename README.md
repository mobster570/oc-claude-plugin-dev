# Claude Code Plugins for OpenCode

This repository contains ported versions of Anthropic's official Claude Code plugin development resources, including the `plugin-dev` toolkit and `skill-creator`. These resources have been adapted for OpenCode, enabling developers to build high-quality Claude Code plugins using OpenCode as their AI coding assistant.

## What's Included

### Skills (8)
- `plugin-structure` — Plugin organization and manifest configuration
- `skill-development` — Creating skills with progressive disclosure
- `hook-development` — Advanced hooks API and event-driven automation
- `mcp-integration` — Model Context Protocol server integration
- `command-development` — Creating slash commands with frontmatter and arguments
- `agent-development` — Creating autonomous agents
- `plugin-settings` — Configuration patterns using local settings files
- `skill-creator` — Creating and iteratively improving skills with eval framework

### Agents (4)
- `agent-creator` — Creates agent configurations from user requirements
- `plugin-validator` — Validates plugin structure, manifest, and components
- `skill-reviewer` — Reviews skill quality and triggering effectiveness
- `claude-code-guide` — Claude Code documentation expert (read-only)

### Commands (1)
- `/create-plugin` — Guided end-to-end plugin creation workflow (8 phases)

## Installation

### Using install script (recommended)
```bash
# Bash/macOS/Linux/WSL
bash install.sh [target-directory]

# PowerShell/Windows
.\install.ps1 [-TargetDir <path>]
```

### Manual copy
```bash
cp -r .opencode/ /path/to/your/project/
```

## Usage

In OpenCode, skills are loaded automatically when relevant. You can also explicitly load them by name.

Agents trigger automatically based on your queries. Examples:
- "Create an agent for..."
- "Validate my plugin"
- "How do Claude Code hooks work?"

To start the guided plugin creation workflow, run:
`/create-plugin A plugin for SQL formatting`

## Prerequisites

- OpenCode installed
- Python 3.x (required for skill-creator evaluation scripts)
- Claude Code CLI (`claude`) — optional, required only for skill-creator evaluation workflow (`claude -p` calls)

## Known Limitations

- Tool name differences: `AskUserQuestion` is mapped to OpenCode's `question` tool; `TodoWrite` to `todowrite`; `Task` to `task`. Compatibility notes are included in the `/create-plugin` command.
- `claude -p` calls in skill-creator scripts require the Claude Code CLI to be installed.
- Agent triggering behavior may differ between Claude Code and OpenCode.
- Skill content teaches Claude Code plugin development (this is intentional, as the goal is to build plugins for Claude Code).

## License

Original plugin content by Anthropic. See individual skill directories for license files.
