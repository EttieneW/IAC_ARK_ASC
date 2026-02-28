# Task: ASA AWS IAC Git Repo

## Scope

Implement a git repository and Infrastructure-as-Code setup for hosting an Ark Survival Ascended dedicated server on AWS, with deployment scripts and documentation so anyone can deploy and operate the server (SSH/RDP, git pull, restart).

## Status

Completed. Delivered:

- Git init and folder structure; `.gitignore` for Terraform, keys, and OS cruft.
- Terraform: EC2 Windows Server 2022, EBS volume, security group (ASA ports + RDP), optional key pair, user_data for Chocolatey/Git.
- Versioned server config: `server-config/WindowsServer/GameUserSettings.ini`, `Game.ini`, and `server-config/README.md`.
- Bootstrap script: `scripts/bootstrap/install_asa_server.ps1` (SteamCMD + ASA App ID 2430930).
- Server scripts: `scripts/server/paths.ps1`, `restart.ps1`, `pull_and_restart.ps1`, `status.ps1`; optional `launch_args.txt` for launch options.
- Deploy script: `scripts/deploy/deploy.ps1` (Terraform apply + connect info).
- Documentation: `README.md`, `CHANGELOG.md`, `docs/PREREQUISITES.md`, `docs/FIRST_TIME_DEPLOY.md`, `docs/OPERATIONS.md`, `docs/TROUBLESHOOTING.md`, `terraform/README.md`.

## Reference

Plan: ASA AWS IAC Git Repo (see project plan / .cursor/plans).
