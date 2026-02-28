# One-time bootstrap: install SteamCMD and Ark Survival Ascended dedicated server (Windows).
# Run this on a fresh Windows Server EC2 after first RDP. Configs are then managed via repo (pull_and_restart.ps1).
# Requires: PowerShell 5.1+, internet, ~50 GB free on drive chosen for ArkServer.

$ErrorActionPreference = "Stop"
$SteamCmdZip = "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
$SteamCmdDir = "C:\SteamCMD"
$ArkServerDir = "C:\ArkServer"
$AsaAppId = "2430930"

# Create dirs
New-Item -ItemType Directory -Force -Path $SteamCmdDir | Out-Null
New-Item -ItemType Directory -Force -Path $ArkServerDir | Out-Null

# Download and extract SteamCMD
if (-not (Test-Path "$SteamCmdDir\steamcmd.exe")) {
    Write-Host "Downloading SteamCMD..."
    $zipPath = "$env:TEMP\steamcmd.zip"
    Invoke-WebRequest -Uri $SteamCmdZip -OutFile $zipPath -UseBasicParsing
    Expand-Archive -Path $zipPath -DestinationPath $SteamCmdDir -Force
    Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
    Write-Host "SteamCMD installed."
} else {
    Write-Host "SteamCMD already present."
}

# Install or update ASA dedicated server (~32-50 GB)
Write-Host "Installing/updating Ark Survival Ascended dedicated server (App ID $AsaAppId). This may take a long time."
& "$SteamCmdDir\steamcmd.exe" +force_install_dir $ArkServerDir +login anonymous +app_update $AsaAppId validate +quit
if ($LASTEXITCODE -ne 0) { throw "SteamCMD app_update failed with exit code $LASTEXITCODE" }

# Ensure config dir exists (pull_and_restart.ps1 will copy repo configs here)
$configDir = Join-Path $ArkServerDir "ShooterGame\Saved\Config\WindowsServer"
New-Item -ItemType Directory -Force -Path $configDir | Out-Null
Write-Host "Config path ready: $configDir"

Write-Host "Bootstrap complete. Next: clone this repo to C:\Ark (or your chosen path), then run scripts\server\pull_and_restart.ps1 to apply configs and start the server."
