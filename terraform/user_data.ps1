# PowerShell user-data for Windows EC2 - optional bootstrap
# Installs Chocolatey, Git; optionally clones repo. Run ASA bootstrap script manually after first RDP.
$ErrorActionPreference = "Stop"

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Refresh env and install Git
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
choco install -y git

# Optional: clone repo if URL provided (replace with your repo URL in terraform.tfvars)
# if ("${git_repo_url}" -ne "") {
#   New-Item -ItemType Directory -Force -Path C:\Ark | Out-Null
#   & "C:\Program Files\Git\bin\git.exe" clone "${git_repo_url}" C:\Ark
# }

# Log for debugging
"User-data finished at $(Get-Date)" | Out-File -FilePath C:\userdata.log -Append
