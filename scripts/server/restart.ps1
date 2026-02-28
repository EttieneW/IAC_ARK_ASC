# Stop and start the ASA dedicated server. Run on the server.
# Uses launch args from repo\launch_args.txt if present, else default (TheIsland_WP, port 7777).
. "$PSScriptRoot\paths.ps1"
$ErrorActionPreference = "Stop"
$logDir = Join-Path $RepoPath "logs"
New-Item -ItemType Directory -Force -Path $logDir | Out-Null
$logFile = Join-Path $logDir "restart_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

function Log { param($m) "$(Get-Date -Format 'o') $m" | Tee-Object -FilePath $logFile -Append; Write-Host $m }

if (-not (Test-Path $ExePath)) {
    Log "ERROR: Executable not found: $ExePath. Run bootstrap first."
    exit 1
}

$p = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
if ($p) {
    Log "Stopping ASA server (PID $($p.Id))..."
    $p | Stop-Process -Force
    Start-Sleep -Seconds 3
}

$launchArgsFile = Join-Path $RepoPath "launch_args.txt"
$launchArgs = $DefaultLaunchArgs
if (Test-Path $launchArgsFile) {
    $launchArgs = (Get-Content $launchArgsFile -Raw).Trim()
    Log "Using launch args from launch_args.txt"
}
$workDir = Split-Path $ExePath -Parent
Log "Starting ASA server in $workDir"
Start-Process -FilePath $ExePath -ArgumentList $launchArgs -WorkingDirectory $workDir -WindowStyle Normal
Log "Server start requested. Check status.ps1 to confirm."
