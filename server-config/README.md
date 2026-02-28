# Server config – versioned ASA settings

These INI files are the **source of truth** for your Ark Survival Ascended server. They are copied to the server by `scripts/server/pull_and_restart.ps1`.

## Files

| File | Purpose |
|------|---------|
| **WindowsServer/GameUserSettings.ini** | Server name, max players, passwords, RCON, XP/taming/harvest multipliers, message of the day. |
| **WindowsServer/Game.ini** | Breeding speeds, loot tables, dino spawns, engram overrides. |

## Target path on the server

After `pull_and_restart.ps1` runs, these files are copied to:

- `C:\ArkServer\ShooterGame\Saved\Config\WindowsServer\` (default; path is configurable in the script).

Edit the INI files in this repo, commit and push. On the server, run `pull_and_restart.ps1` to pull and apply the new config, then restart the ASA server.
