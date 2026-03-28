# PROJECT KNOWLEDGE BASE

**Generated:** 2026-03-29
**Commit:** b9b0e4d
**Branch:** master

## OVERVIEW

Ported Anthropic Claude Code plugin development resources for OpenCode. Documentation-driven toolkit: 8 skills, 4 agents, 1 command — teaches and enables building Claude Code plugins. No traditional build system; distribution is file-copy via install scripts.

## STRUCTURE

```
./
├── .opencode/
│   ├── agents/           # 4 autonomous subagents (.md with YAML frontmatter)
│   ├── commands/         # 1 guided workflow (/create-plugin)
│   └── skills/           # 8 skill modules (SKILL.md + references/ + examples/)
│       ├── skill-creator/      # ★ Eval framework (Python scripts, nested agents)
│       ├── hook-development/   # ★ Bash validation/testing toolchain
│       ├── command-development/# 7 reference docs, 2 examples
│       ├── plugin-structure/   # Foundational: manifest + directory layout
│       ├── agent-development/  # Agent creation patterns + validator script
│       ├── mcp-integration/    # MCP server configs (JSON examples)
│       ├── plugin-settings/    # .local.md config pattern + parsers
│       └── skill-development/  # Skill writing patterns (minimal, 2 files)
├── install.sh            # Bash installer (Unix/macOS/WSL)
├── install.ps1           # PowerShell installer (Windows)
└── README.md             # Component inventory + compatibility matrix
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Understand plugin manifest / directory layout | `skills/plugin-structure/` | Start here for any new plugin |
| Create a skill | `skills/skill-creator/SKILL.md` | Full eval/iterate framework with Python scripts |
| Write skill descriptions / triggering | `skills/skill-development/SKILL.md` | Progressive disclosure pattern |
| Create an agent | `skills/agent-development/SKILL.md` | Frontmatter, system prompts, triggering |
| Create a slash command | `skills/command-development/SKILL.md` | 7 reference docs in `references/` |
| Create or test hooks | `skills/hook-development/` | Has own AGENTS.md; bash test/lint toolchain |
| Add MCP server | `skills/mcp-integration/SKILL.md` | JSON examples in `examples/` |
| Add plugin settings | `skills/plugin-settings/SKILL.md` | .local.md parsing scripts in `scripts/` |
| Run skill evaluations | `skills/skill-creator/scripts/` | Has own AGENTS.md; Python eval runner |
| Guided plugin creation | `commands/create-plugin.md` | 8-phase workflow, loads skills dynamically |
| Validate plugin structure | `agents/plugin-validator.md` | Autonomous validation agent |
| Review skill quality | `agents/skill-reviewer.md` | Reviews triggering effectiveness |
| Claude Code docs expert | `agents/claude-code-guide.md` | Read-only documentation agent |
| Generate new agents | `agents/agent-creator.md` | Creates agent configs from requirements |
| Install to another project | `install.sh` / `install.ps1` | Copies `.opencode/` to target dir |

All paths relative to `.opencode/` unless noted.

## CONVENTIONS

**Naming**: Kebab-case everywhere — directories, files, plugin names, skill names, agent names.

**Skill structure** (consistent across all 8):
```
skill-name/
├── SKILL.md          # YAML frontmatter + body (required, exact filename)
├── references/       # Deep-dive docs (loaded on demand)
├── examples/         # Implementation examples
└── scripts/          # Validation/utility scripts (bash or python)
```

**Agents**: Single `.md` file with YAML frontmatter (`name`, `description`, `model`, `color`) + system prompt body. Color conventions: blue/cyan=analysis, green=generation, yellow=validation, red=security.

**Commands**: Single `.md` with frontmatter. Legacy format — prefer `skills/` for new components.

**Paths**: In educational content about Claude Code plugins, `${CLAUDE_PLUGIN_ROOT}` is the standard convention for intra-plugin references. For accessing this project's own skill resources (scripts, references, examples), use paths relative to each skill's base directory — OpenCode provides the base directory path when loading a skill.

**Tool name mapping** (Claude Code → OpenCode):
- `AskUserQuestion` → `question`
- `TodoWrite` → `todowrite`
- `Task` → `task`

**Content teaches Claude Code plugin development** — this is intentional. The toolkit itself is an OpenCode plugin, but the skills teach building plugins for Claude Code.

## ANTI-PATTERNS (THIS PROJECT)

- **NEVER hardcode credentials** in `.mcp.json` or configs. Use `${API_TOKEN}` env vars.
- **NEVER skip Phase 3** (Detailed Design) in `/create-plugin` workflow. All ambiguities must resolve before implementation.
- **Avoid rigid ALWAYS/NEVER in caps** in skill instructions — explain reasoning instead so the model understands WHY.
- **DO NOT suggest improvements during benchmark analysis** — that's for the improvement step, not benchmarking.
- **DO NOT infer which skill produced output** during blind comparison evaluation.
- **No TODO comments** in released commands — automated checks enforce this.
- Skill descriptions should be **under 60 characters** for proper display.

## COMMANDS

```bash
# Install to another project
bash install.sh /path/to/project          # Unix/macOS/WSL
powershell .\install.ps1 -TargetDir C:\path  # Windows

# Validate hooks
.opencode/skills/hook-development/scripts/validate-hook-schema.sh path/to/hooks.json

# Lint hook scripts
.opencode/skills/hook-development/scripts/hook-linter.sh path/to/hook.sh

# Validate agent files
.opencode/skills/agent-development/scripts/validate-agent.sh path/to/agent.md

# Run skill evaluations (requires Python 3.x + Claude CLI)
python .opencode/skills/skill-creator/scripts/run_eval.py --skill-path <path> --evals <evals.json>

# Quick-validate a skill
python .opencode/skills/skill-creator/scripts/quick_validate.py <skill-dir>
```

## NOTES

- **No build step**: Distribution is file-copy. No npm/pip/cargo.
- **Python 3.x required** only for skill-creator evaluation scripts. Optional dependency.
- **Claude Code CLI** (`claude -p`) required only for skill-creator eval runs. Optional.
- **Self-referential**: The toolkit teaches plugin development by being a plugin itself.
- `.gitkeep` files in `agents/`, `commands/`, `skills/` — preserve empty dir structure.
- `.sisyphus/` is git-ignored project tracking metadata, not part of the plugin.
- `nul` file in root is a Windows artifact — harmless.
