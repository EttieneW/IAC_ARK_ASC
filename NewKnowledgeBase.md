# New Knowledge Base

Notes learned while building the ASA AWS IAC repo.

## Ark Survival Ascended dedicated server

- **App ID (SteamCMD):** 2430930.
- **Executable:** `ArkAscendedServer.exe` under `ShooterGame\Binaries\Win64` (Windows).
- **Config path:** `ShooterGame\Saved\Config\WindowsServer\` — `GameUserSettings.ini` (server name, players, multipliers, RCON), `Game.ini` (breeding, loot, spawns).
- **Ports:** 7777 UDP (game), 27015 UDP (query), 7778 UDP (peer), 27020 TCP (RCON optional). All must be open in security group and Windows Firewall.
- **Map names (ASA):** e.g. `TheIsland_WP`, `Ragnarok_WP` (suffix `_WP` for ASA).
- **Launch:** `ArkAscendedServer.exe <map>?listen?Port=7777?QueryPort=27015 -WinLiveMaxPlayers=70 -UseBattlEye`.

## AWS / Terraform

- **Windows AMI:** Use owner `amazon` and name filter `Windows_Server-2022-English-Full-Base-*` for AWS-managed Windows Server 2022.
- **EBS attachment:** Device `/dev/sdf` on Linux becomes a separate volume in Windows (e.g. E:); user may need to bring disk online and format in Disk Management.
- **Key pair:** Terraform can create `tls_private_key` + `aws_key_pair`; use `local_file` (requires `hashicorp/local` provider) to write the PEM. Never commit the PEM.
- **User-data:** Windows EC2 user-data runs once at first boot; PowerShell can install Chocolatey and Git. Bootstrap for the game server is run manually after RDP so the user can monitor the large download.

## Repo layout

- Config flow: edit INI in repo → push → on server `git pull` + copy configs + restart. Keeps server config in version control and repeatable.
- `launch_args.txt` in repo root overrides default map/options for `restart.ps1`; gitignore `launch_args.txt` so local overrides are not committed.
