# Run from your PC: applies Terraform, then prints RDP/connect info and reminder to run pull_and_restart on the server.
# Requires: Terraform and AWS CLI configured (no credentials in this script).
$ErrorActionPreference = "Stop"
$tfDir = Join-Path $PSScriptRoot "..\..\terraform"
if (-not (Test-Path (Join-Path $tfDir "main.tf"))) { throw "Terraform main.tf not found at $tfDir" }
Push-Location $tfDir
try {
    if (-not (Test-Path ".terraform")) { & terraform init }
    $varFile = Join-Path $tfDir "terraform.tfvars"
    if (Test-Path $varFile) {
        & terraform apply -var-file=terraform.tfvars -auto-approve
    } else {
        Write-Host "No terraform.tfvars found. Copy from terraform.tfvars.example and fill in values, then run again."
        & terraform apply -auto-approve
    }
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
    $ip = & terraform output -raw instance_public_ip 2>$null
    $id  = & terraform output -raw instance_id 2>$null
    Write-Host ""
    Write-Host "=== Server is up ==="
    Write-Host "Instance ID: $id"
    Write-Host "Public IP:   $ip"
    Write-Host "RDP: Connect to $ip as Administrator. Get password: EC2 Console > Instance > Actions > Security > Get Windows password (use the key pair)."
    Write-Host ""
    Write-Host "On the server after first login: clone this repo, run bootstrap, then run: .\scripts\server\pull_and_restart.ps1"
} finally {
    Pop-Location
}
