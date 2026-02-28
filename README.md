# Ark Survival Ascended – AWS IAC Server

Infrastructure-as-Code and config repo for hosting an **Ark Survival Ascended** dedicated server on AWS. Use Terraform to provision a Windows Server EC2 instance, then manage server config in git: edit INI files, push, and on the server run **git pull** and a restart script to apply changes.

## Quick links

- **[Prerequisites](docs/PREREQUISITES.md)** – AWS account, Terraform, SSH/RDP
- **[First-time deploy](docs/FIRST_TIME_DEPLOY.md)** – Step-by-step to get the server running
- **[Operations](docs/OPERATIONS.md)** – SSH/RDP in, restart, pull new configs

## Repo structure

| Path | Purpose |
|------|---------|
| `terraform/` | AWS EC2, security group, EBS, key pair (Terraform) |
| `server-config/WindowsServer/` | Versioned `GameUserSettings.ini` and `Game.ini` (source of truth) |
| `scripts/bootstrap/` | One-time install: SteamCMD + ASA server |
| `scripts/server/` | Run on server: `restart.ps1`, `pull_and_restart.ps1`, `status.ps1` |
| `scripts/deploy/` | Run from PC: `deploy.ps1` (Terraform apply + connect info) |
| `scope/` | Task/scope notes for this project |


## Changing server config

1. Edit `server-config/WindowsServer/GameUserSettings.ini` (and/or `Game.ini`) in this repo.
2. Commit and push.
3. On the server: open PowerShell in the repo folder and run `.\scripts\server\pull_and_restart.ps1` (pulls, copies configs, restarts the ASA server).

See [Operations](docs/OPERATIONS.md) for details.

## Adding a remote and pushing

After cloning or creating this repo locally, add your remote and push:

```powershell
git remote add origin <your-repo-url>
git push -u origin main
```

Then on the Windows server, clone the same repo (e.g. to `C:\Ark`) and use the server scripts as above.
