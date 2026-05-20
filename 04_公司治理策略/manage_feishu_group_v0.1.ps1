param(
  [Parameter(Mandatory=$true)]
  [ValidateSet("create", "add-members")]
  [string]$Action,

  [string]$Name,

  [string]$Description = "",

  [ValidateSet("private", "public")]
  [string]$ChatType = "private",

  [ValidateSet("group", "topic")]
  [string]$ChatMode = "group",

  [string]$ChatId = "",

  [string[]]$UserOpenIds = @(),

  [string[]]$BotAppIds = @(),

  [string]$OwnerOpenId = "",

  [switch]$SetBotManager,

  [switch]$External,

  [switch]$AllowExternal,

  [switch]$DryRun,

  [string]$ProfileEnvPath = (Join-Path $env:USERPROFILE ".hermes\profiles\thoth_sec\.env")
)

$ErrorActionPreference = "Stop"

$workspaceRoot = Split-Path -Parent $PSScriptRoot
$projectRoot = Get-ChildItem -LiteralPath $workspaceRoot -Directory | Where-Object { $_.Name -like "03_*" } | Select-Object -First 1
if (-not $projectRoot) {
  throw "Missing 03_* project directory under $workspaceRoot"
}

$deskProject = Get-ChildItem -LiteralPath $projectRoot.FullName -Directory | Where-Object { $_.Name -like "OPC_*" } | Select-Object -First 1
if (-not $deskProject) {
  throw "Missing OPC Feishu Hermes project directory under $($projectRoot.FullName)"
}

$toolsDir = Get-ChildItem -LiteralPath $deskProject.FullName -Directory | Where-Object { $_.Name -like "04_*" } | Select-Object -First 1
if (-not $toolsDir) {
  throw "Missing 04_* script directory under $($deskProject.FullName)"
}

$scriptPath = Join-Path $toolsDir.FullName "manage_feishu_group_v0.1.ps1"

if (-not (Test-Path -LiteralPath $scriptPath)) {
  throw "Missing Feishu group management script: $scriptPath"
}

& $scriptPath @PSBoundParameters
exit $LASTEXITCODE
