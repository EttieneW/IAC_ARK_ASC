# Troubleshooting

## Instance not reachable (RDP/SSH)

- **Security group**: Ensure the Terraform security group allows RDP (port 3389) from your IP (`allowed_admin_cidr`). Check the EC2 console → Instance → Security.
- **Elastic IP**: If the instance has a new public IP after a restart, update your RDP target. Consider assigning an Elastic IP in Terraform if you need a fixed IP.
- **Windows firewall**: The default Windows Server AMI should allow RDP. If you changed firewall rules, ensure port 3389 is open.
- **Password**: Use “Get Windows password” in the EC2 console with the correct key pair (the one attached to the instance). If you regenerated the key, the old password cannot be recovered.

## Server not in the game list / cannot connect

- **Ports**: ASA uses UDP 7777 (game), 27015 (query), 7778 (peer), and optionally TCP 27020 (RCON). The Terraform security group opens these. Verify in EC2 → Security groups → Inbound rules.
- **Firewall on the server**: Windows Firewall must allow these ports (inbound). Default Windows Server may need rules for 7777/27015/7778 UDP and 27020 TCP.
- **Map and launch args**: Ensure the server is started with the correct map (e.g. `TheIsland_WP`) and options. Check `launch_args.txt` or `scripts/server/paths.ps1` and run `status.ps1` to confirm the process is running.

## Config changes not applying

- **Path**: `pull_and_restart.ps1` copies from `server-config\WindowsServer\` in the repo to `C:\ArkServer\ShooterGame\Saved\Config\WindowsServer\`. If you use different paths, update `scripts/server/paths.ps1`.
- **Restart**: Config is read at server start. Always run `pull_and_restart.ps1` (or at least `restart.ps1`) after changing INI files so the server restarts with the new config.
- **Wrong file**: Confirm you edited `GameUserSettings.ini` and/or `Game.ini` in the repo and that those files were copied (check the pull_restart log in `C:\Ark\logs`).

## SteamCMD / bootstrap failures

- **Disk space**: ASA server is large (~32–50 GB). Ensure the EBS volume and drive have enough free space.
- **Network**: SteamCMD must reach the internet. If the instance is in a private subnet without NAT, it cannot download. Use a public subnet or add NAT.
- **SteamCMD errors**: Run SteamCMD manually from `C:\SteamCMD` and try:
  ```
  force_install_dir C:\ArkServer
  login anonymous
  app_update 2430930 validate
  quit
  ```
  Resolve any Steam errors (e.g. rate limits, auth) before re-running the bootstrap script.

## Terraform apply fails

- **Credentials**: Run `aws sts get-caller-identity` to confirm AWS CLI is configured.
- **Quotas**: Check EC2 instance limits (vCPU, volume size) for your account and region.
- **AMI**: The Terraform config uses a public Windows Server 2022 AMI. If the AMI ID or name filter fails, update the `data "aws_ami" "windows_2022"` block in `terraform/main.tf` for your region.

## Server process exits immediately

- **Dependencies**: Install Visual C++ Redistributable (x64) on the server if not already present.
- **Paths**: Ensure `ArkAscendedServer.exe` exists under `C:\ArkServer\ShooterGame\Binaries\Win64\` and that `restart.ps1` is using the correct working directory.
- **Logs**: Check `ShooterGame\Saved\Logs` in the ASA install for crash or startup errors.
