# install.ps1 — Install Claude Code Plugins for OpenCode
# Usage:
#   .\install.ps1                     # Global install to ~/.config/opencode/
#   .\install.ps1 -TargetDir <path>   # Project-local install to <path>/.opencode/

param(
    [string]$TargetDir
)

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$SourceDir = Join-Path $ScriptDir ".opencode"

if ($TargetDir) {
    # Project-local install
    $InstallDir = Join-Path $TargetDir ".opencode"
    $InstallMode = "project-local"
} else {
    # Global install
    $InstallDir = Join-Path $HOME ".config\opencode"
    $InstallMode = "global"
}

# Guard: source == target
$ResolvedSource = (Resolve-Path $SourceDir -ErrorAction SilentlyContinue)
$ResolvedInstall = (Resolve-Path $InstallDir -ErrorAction SilentlyContinue)
if ($ResolvedSource -and $ResolvedInstall) {
    $S = $ResolvedSource.Path.TrimEnd('\', '/')
    $I = $ResolvedInstall.Path.TrimEnd('\', '/')
    if ($S -eq $I) {
        Write-Host "Source and install directory are the same: $S"
        Write-Host "Nothing to copy — plugin files are already in place."
        exit 0
    }
}

Write-Host "Installing Claude Code Plugins for OpenCode ($InstallMode)..."
Write-Host "Source: $SourceDir"
Write-Host "Target: $InstallDir"
Write-Host ""

# Check if target already exists
if (Test-Path $InstallDir) {
    Write-Warning "Directory already exists at $InstallDir"
    Write-Host "Merging into existing directory (existing files may be overwritten)."
    Write-Host ""
}

# Create target directories
New-Item -ItemType Directory -Force -Path (Join-Path $InstallDir "skills") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $InstallDir "agents") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $InstallDir "commands") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $InstallDir "plugins") | Out-Null

# Copy skills
Write-Host "Installing skills..."
Get-ChildItem (Join-Path $SourceDir "skills") -Force | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination (Join-Path $InstallDir "skills\") -Recurse -Force
}

# Copy agents
Write-Host "Installing agents..."
Get-ChildItem (Join-Path $SourceDir "agents") -Force | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination (Join-Path $InstallDir "agents\") -Recurse -Force
}

# Copy commands
Write-Host "Installing commands..."
Get-ChildItem (Join-Path $SourceDir "commands") -Force | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination (Join-Path $InstallDir "commands\") -Recurse -Force
}

# Copy plugins
Write-Host "Installing plugins..."
Get-ChildItem (Join-Path $SourceDir "plugins") -Force | ForEach-Object {
    Copy-Item -Path $_.FullName -Destination (Join-Path $InstallDir "plugins\") -Recurse -Force
}

# Summary
Write-Host ""
Write-Host "Installation complete! ($InstallMode)"
Write-Host ""
Write-Host "Installed components:"
$skills = Get-ChildItem (Join-Path $InstallDir "skills") -Directory -ErrorAction SilentlyContinue
Write-Host "  Skills ($($skills.Count)):"
foreach ($skill in $skills) {
    Write-Host "    - $($skill.Name)"
}
$agents = Get-ChildItem (Join-Path $InstallDir "agents") -Filter "*.md" -ErrorAction SilentlyContinue
Write-Host "  Agents ($($agents.Count)):"
foreach ($agent in $agents) {
    Write-Host "    - $($agent.Name)"
}
$commands = Get-ChildItem (Join-Path $InstallDir "commands") -Filter "*.md" -ErrorAction SilentlyContinue
Write-Host "  Commands ($($commands.Count)):"
foreach ($cmd in $commands) {
    Write-Host "    - $($cmd.Name)"
}
$plugins = Get-ChildItem (Join-Path $InstallDir "plugins") -ErrorAction SilentlyContinue
Write-Host "  Plugins ($($plugins.Count)):"
foreach ($plugin in $plugins) {
    Write-Host "    - $($plugin.Name)"
}
Write-Host ""
if ($InstallMode -eq "global") {
    Write-Host "Global plugins loaded automatically. Restart OpenCode to apply."
} else {
    Write-Host "Restart OpenCode in your project directory to load the new components."
}
