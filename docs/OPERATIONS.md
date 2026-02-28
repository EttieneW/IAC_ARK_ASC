# Operations

How to connect to the server and manage it day-to-day.

## Connecting to the server

### RDP (recommended on Windows)

1. Get the instance **public IP** (from Terraform output or EC2 console).
2. Open **Remote Desktop Connection** (mstsc).
3. Connect to the IP, user **Administrator**, password from EC2 “Get Windows password” (using your key pair).

### SSH (if configured)

If you have OpenSSH or WinRM set up on the Windows instance, you can connect with your key:

```powershell
ssh -i terraform\asa-server.pem Administrator@<instance-public-ip>
```

## Running scripts on the server

Open PowerShell on the server and go to the repo (e.g. `C:\Ark`). Run scripts from there.

### Apply new config and restart

After you’ve edited `server-config/WindowsServer/*.ini` in the repo and pushed:

```powershell
cd C:\Ark
.\scripts\server\pull_and_restart.ps1
```

This will:

1. `git pull`
2. Copy `server-config/WindowsServer/GameUserSettings.ini` and `Game.ini` into the ASA config folder.
3. Restart the ASA server (stop existing process, start with launch args).

### Restart only (no config change)

```powershell
cd C:\Ark
.\scripts\server\restart.ps1
```

### Check if the server is running

```powershell
cd C:\Ark
.\scripts\server\status.ps1
```

## Logs

- Restart/pull logs: `C:\Ark\logs\` (e.g. `restart_*.log`, `pull_restart_*.log`).
- ASA server logs: in the ASA install under `ShooterGame\Saved\Logs` (path depends on your install; default `C:\ArkServer\ShooterGame\Saved\Logs`).

## Changing server config

1. On your PC: edit `server-config/WindowsServer/GameUserSettings.ini` and/or `Game.ini`.
2. Commit and push to your remote.
3. On the server: run `.\scripts\server\pull_and_restart.ps1` as above.

## Launch arguments (map, ports, etc.)

- Default launch arguments are in `scripts/server/paths.ps1` (`$DefaultLaunchArgs`).
- To override: copy `launch_args.txt.example` to `launch_args.txt` in the repo root, edit the line (e.g. map name, ports), commit and push. On the server, `restart.ps1` and `pull_and_restart.ps1` use `launch_args.txt` when present.

## Paths (if you moved the install)

If ASA is not in `C:\ArkServer` or the repo is not in `C:\Ark`, edit `scripts/server/paths.ps1` on the server (or in the repo and push) and set `$ArkServerPath` and `$RepoPath` accordingly.
