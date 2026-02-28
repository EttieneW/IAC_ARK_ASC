# Check if ASA server process is running. Run on the server (e.g. after SSH/RDP).
. "$PSScriptRoot\paths.ps1"
$p = Get-Process -Name $ProcessName -ErrorAction SilentlyContinue
if ($p) {
    Write-Host "ASA server is RUNNING. PID: $($p.Id)"
    Write-Host "Path: $($p.Path)"
} else {
    Write-Host "ASA server is NOT running."
}
