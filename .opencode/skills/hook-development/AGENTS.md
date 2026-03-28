# HOOK-DEVELOPMENT KNOWLEDGE BASE

## OVERVIEW

Event-driven automation for Claude Code plugins. Covers all hook types (PreToolUse, PostToolUse, Stop, SessionStart, etc.) with bash validation/testing toolchain. Prompt-based hooks recommended over command-based.

## STRUCTURE

```
hook-development/
├── SKILL.md              # Main skill (712 lines) — hook types, events, configuration
├── scripts/              # ★ Validation & testing toolchain
│   ├── validate-hook-schema.sh  # Validates hooks.json structure
│   ├── test-hook.sh             # Tests hooks with sample JSON input
│   ├── hook-linter.sh           # Lints bash scripts for security + best practices
│   └── README.md                # Script usage + typical workflow
├── references/
│   ├── patterns.md       # Common hook implementation patterns
│   ├── advanced.md       # Advanced hook techniques
│   └── migration.md      # Migration guide for hook API changes
└── examples/
    ├── validate-bash.sh  # PreToolUse: validates bash commands before execution
    ├── validate-write.sh # PreToolUse: validates file write operations
    └── load-context.sh   # SessionStart: loads project context
```

## WHERE TO LOOK

| Task | File | Notes |
|------|------|-------|
| Understand hook types & events | `SKILL.md` | Prompt-based (recommended) vs command-based |
| Validate hooks.json config | `scripts/validate-hook-schema.sh` | JSON structure, event names, timeouts |
| Test a hook before deploying | `scripts/test-hook.sh` | Generates sample input, validates output |
| Lint hook scripts | `scripts/hook-linter.sh` | Security: quoting, shebang, error handling |
| Full script docs + workflow | `scripts/README.md` | 7-step workflow: write → lint → test → deploy |
| Common patterns | `references/patterns.md` | Reusable hook implementations |
| Advanced techniques | `references/advanced.md` | Complex hook scenarios |
| Example: block dangerous bash | `examples/validate-bash.sh` | PreToolUse hook reference |
| Example: validate file writes | `examples/validate-write.sh` | PreToolUse hook reference |

## DEVELOPMENT WORKFLOW

```
1. Write hook script       → #!/bin/bash + set -euo pipefail
2. Lint                    → hook-linter.sh my-hook.sh
3. Generate test input     → test-hook.sh --create-sample PreToolUse > input.json
4. Test                    → test-hook.sh -v my-hook.sh input.json
5. Add to hooks.json       → Configure event, matcher, timeout
6. Validate config         → validate-hook-schema.sh hooks.json
7. Deploy & test in Claude → claude --debug
```

## CONVENTIONS

- **Exit codes**: 0=approved, 2=blocked/denied (not 1 — that means error)
- **Always use** `set -euo pipefail` in bash hooks
- **Always quote** variables: `"$variable"` — prevents injection
- **Always read stdin**: hooks receive JSON input via stdin
- **Errors to stderr**: `echo "error" >&2`
- **Paths**: In Claude Code plugin examples, use `${CLAUDE_PLUGIN_ROOT}`. For this skill's own bundled resources, use paths relative to the skill's base directory (provided by OpenCode at load time)
- **Timeouts**: hooks.json supports 1-300 second range
- **Prompt hooks preferred**: Use `"type": "prompt"` for context-aware validation. Supported on: Stop, SubagentStop, UserPromptSubmit, PreToolUse
- **Hook events**: PreToolUse, PostToolUse, Stop, SubagentStop, SessionStart, SessionEnd, UserPromptSubmit, PreCompact, Notification
