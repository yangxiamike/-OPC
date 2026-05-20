param(
  [switch]$Stop
)

$ErrorActionPreference = "Stop"

# Codex/PowerShell sessions can contain both Path and PATH. Windows process
# startup treats them as duplicate keys, so normalize before Start-Process.
[Environment]::SetEnvironmentVariable("PATH", $null, "Process")
[Environment]::SetEnvironmentVariable(
  "Path",
  ([Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [Environment]::GetEnvironmentVariable("Path", "User")),
  "Process"
)

$hermes = Join-Path $env:USERPROFILE "AppData\Local\hermes\bin\hermes.cmd"
if (-not (Test-Path -LiteralPath $hermes)) {
  throw "Missing Hermes command: $hermes"
}

$profiles = @(
  @{ Name = "max_ceo"; Home = "$env:USERPROFILE\.hermes\profiles\max_ceo" },
  @{ Name = "thoth_sec"; Home = "$env:USERPROFILE\.hermes\profiles\thoth_sec" }
)

$logDir = "$env:USERPROFILE\.hermes\gateway-opc-logs"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null

function Invoke-GatewayStop {
  param([hashtable]$Profile)

  $env:HERMES_HOME = $Profile.Home
  Write-Host "Stopping $($Profile.Name) gateway..."
  & $hermes gateway stop | Out-Host
}

function Start-GatewayProcess {
  param([hashtable]$Profile)

  $profileHome = $Profile.Home
  $envFile = Join-Path $profileHome ".env"
  if (-not (Test-Path -LiteralPath $envFile)) {
    throw "Missing Hermes profile env file: $envFile"
  }

  $out = Join-Path $logDir "$($Profile.Name)-gateway.out.log"
  $err = Join-Path $logDir "$($Profile.Name)-gateway.err.log"

  $cmd = @"
`$env:HERMES_HOME='$profileHome'
Get-Content '$envFile' | ForEach-Object {
  if (`$_ -match '^([^#=]+)=(.*)$') {
    [Environment]::SetEnvironmentVariable(`$matches[1], `$matches[2], 'Process')
  }
}
`$feishuNoProxy = 'open.feishu.cn,localhost,127.0.0.1,::1'
`$hermesProxy = [Environment]::GetEnvironmentVariable('HERMES_HTTP_PROXY', 'Process')
if (`$hermesProxy) {
  foreach (`$proxyVar in @('HTTP_PROXY', 'HTTPS_PROXY', 'http_proxy', 'https_proxy')) {
    if (-not [Environment]::GetEnvironmentVariable(`$proxyVar, 'Process')) {
      [Environment]::SetEnvironmentVariable(`$proxyVar, `$hermesProxy, 'Process')
    }
  }
}
if (`$env:NO_PROXY) { `$env:NO_PROXY = `$env:NO_PROXY + ',' + `$feishuNoProxy } else { `$env:NO_PROXY = `$feishuNoProxy }
if (`$env:no_proxy) { `$env:no_proxy = `$env:no_proxy + ',' + `$feishuNoProxy } else { `$env:no_proxy = `$feishuNoProxy }
& '$hermes' gateway run --replace --accept-hooks 1>`$null
"@

  Write-Host "Starting $($Profile.Name) gateway..."
  Start-Process -FilePath "powershell.exe" `
    -ArgumentList @("-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", $cmd) `
    -WorkingDirectory $env:USERPROFILE `
    -RedirectStandardOutput $out `
    -RedirectStandardError $err `
    -WindowStyle Hidden | Out-Null
}

foreach ($profile in $profiles) {
  Invoke-GatewayStop -Profile $profile
}

if ($Stop) {
  Write-Host "Hermes Feishu gateways stopped."
  exit 0
}

Start-Sleep -Seconds 3

foreach ($profile in $profiles) {
  Start-GatewayProcess -Profile $profile
}

Start-Sleep -Seconds 8
$env:HERMES_HOME = $profiles[0].Home
& $hermes gateway list
