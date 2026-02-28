# Git pull, copy server-config to ASA install, then restart server. Run on the server (e.g. after SSH).
. "$PSScriptRoot\paths.ps1"
$ErrorActionPreference = "Stop"
$logDir = Join-Path $RepoPath "logs"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$logFile = Join-Path $logDir "pull_restart_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

function Log { param($m) "$(Get-Date -Format 'o') $m" | Tee-Object -FilePath $logFile -Append; Write-Host $m }

Set-Location $RepoPath
Log "Pulling latest from git..."
& git pull
if ($LASTEXITCODE -ne 0) { Log "WARNING: git pull had non-zero exit (e.g. no remote or merge conflict). Continuing." }

$configSrc = Join-Path $RepoPath "server-config\WindowsServer"
if (-not (Test-Path $configSrc)) {
    Log "ERROR: server-config\WindowsServer not found in repo."
    exit 1
}
New-Item -ItemType Directory -Force -Path $ConfigDest | Out-Null
foreach ($name in @("GameUserSettings.ini", "Game.ini")) {
    $src = Join-Path $configSrc $name
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $ConfigDest -Force
        Log "Copied $name to $ConfigDest"
    }
}

Log "Running restart..."
& "$PSScriptRoot\restart.ps1"
Log "pull_and_restart done."
