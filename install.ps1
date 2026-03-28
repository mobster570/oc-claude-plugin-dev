# install.ps1 — Install Claude Code Plugins for OpenCode
# Usage: .\install.ps1 [-TargetDir <path>]
# Default target: current directory

param(
    [string]$TargetDir = (Get-Location).Path
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host "Installing Claude Code Plugins for OpenCode..."
Write-Host "Source: $ScriptDir"
Write-Host "Target: $TargetDir"
Write-Host ""

# Check if target .opencode/ already exists
if (Test-Path "$TargetDir\.opencode") {
    Write-Warning ".opencode directory already exists at $TargetDir\.opencode"
    Write-Host "Merging into existing directory (existing files may be overwritten)."
    Write-Host ""
}

# Create target directories
New-Item -ItemType Directory -Force -Path "$TargetDir\.opencode\skills" | Out-Null
New-Item -ItemType Directory -Force -Path "$TargetDir\.opencode\agents" | Out-Null
New-Item -ItemType Directory -Force -Path "$TargetDir\.opencode\commands" | Out-Null

# Copy skills (8 skill directories)
Write-Host "Installing skills..."
Get-ChildItem "$ScriptDir\.opencode\skills" -Force | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination "$TargetDir\.opencode\skills\" -Recurse -Force
}

# Copy agents (4 agent files)
Write-Host "Installing agents..."
Get-ChildItem "$ScriptDir\.opencode\agents" -Force | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination "$TargetDir\.opencode\agents\" -Recurse -Force
}

# Copy commands (1 command file)
Write-Host "Installing commands..."
Get-ChildItem "$ScriptDir\.opencode\commands" -Force | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination "$TargetDir\.opencode\commands\" -Recurse -Force
}

# Summary
Write-Host ""
Write-Host "Installation complete!"
Write-Host ""
Write-Host "Installed components:"
$skills = Get-ChildItem "$TargetDir\.opencode\skills" -Directory -ErrorAction SilentlyContinue
Write-Host "  Skills ($($skills.Count)):"
foreach ($skill in $skills) {
    Write-Host "    - $($skill.Name)"
}
$agents = Get-ChildItem "$TargetDir\.opencode\agents" -Filter "*.md" -ErrorAction SilentlyContinue
Write-Host "  Agents ($($agents.Count)):"
foreach ($agent in $agents) {
    Write-Host "    - $($agent.Name)"
}
$commands = Get-ChildItem "$TargetDir\.opencode\commands" -Filter "*.md" -ErrorAction SilentlyContinue
Write-Host "  Commands ($($commands.Count)):"
foreach ($cmd in $commands) {
    Write-Host "    - $($cmd.Name)"
}
Write-Host ""
Write-Host "Usage: Restart OpenCode in your project directory to load the new components."
