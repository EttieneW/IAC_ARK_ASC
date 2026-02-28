# Paths used by server scripts (restart, pull_and_restart, status).
# Edit these if your install locations differ. Run from repo root (e.g. C:\Ark).

$Script:ArkServerPath = "C:\ArkServer"
$Script:RepoPath      = if ($PSScriptRoot) {
    $scriptsServer = $PSScriptRoot
    (Resolve-Path (Join-Path $scriptsServer "..\..")).Path
} else {
    "C:\Ark"
}
$Script:ConfigDest    = Join-Path $ArkServerPath "ShooterGame\Saved\Config\WindowsServer"
$Script:ExePath       = Join-Path $ArkServerPath "ShooterGame\Binaries\Win64\ArkAscendedServer.exe"
$Script:ProcessName   = "ArkAscendedServer"
# Default launch args (map and common options). Override via launch_args.txt in repo root.
$Script:DefaultLaunchArgs = "TheIsland_WP?listen?Port=7777?QueryPort=27015 -WinLiveMaxPlayers=70 -UseBattlEye"
