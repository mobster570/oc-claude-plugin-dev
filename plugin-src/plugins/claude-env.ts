import type { Plugin } from "@opencode-ai/plugin"
import { dirname, resolve } from "path"
import { fileURLToPath } from "url"

/**
 * Injects CLAUDE_* environment variables into shell execution.
 *
 * Claude Code hook scripts expect these variables, but OpenCode doesn't set
 * them natively. This plugin bridges the gap using OpenCode's shell.env hook.
 *
 * - CLAUDE_PROJECT_DIR: project root directory (from OpenCode's plugin context)
 * - CLAUDE_PLUGIN_ROOT: plugin root directory (derived from this plugin's location)
 */

const __filename = fileURLToPath(import.meta.url)
const PLUGIN_ROOT = resolve(dirname(__filename), "..")

export const ClaudeEnvPlugin: Plugin = async ({ directory }) => {
  return {
    "shell.env": async (_input, output) => {
      if (!output.env.CLAUDE_PROJECT_DIR) {
        output.env.CLAUDE_PROJECT_DIR = directory
      }
      if (!output.env.CLAUDE_PLUGIN_ROOT) {
        output.env.CLAUDE_PLUGIN_ROOT = PLUGIN_ROOT
      }
    },
  }
}
