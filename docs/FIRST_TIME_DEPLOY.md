# First-time deploy

Follow these steps once to get the ASA server running on AWS.

## 1. Clone the repo

On your PC:

```powershell
git clone <this-repo-url> C:\Ark
cd C:\Ark
```

(Or create the repo locally and add the remote later.)

## 2. Configure Terraform variables

```powershell
cd terraform
copy terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars: set aws_region, instance_type, allowed_admin_cidr (your IP for RDP), etc.
```

Important: set `allowed_admin_cidr` to your IP (e.g. `1.2.3.4/32`) to restrict RDP; use `0.0.0.0/0` only if you accept access from any IP.

## 3. Apply Terraform

```powershell
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

Or from repo root: `.\scripts\deploy\deploy.ps1` (runs apply and prints connect info).

Note the **instance public IP** from the output.

## 4. Wait for the instance

Wait until the instance is in “running” state and status checks pass. Windows may need a few minutes to finish booting.

## 5. Get the Windows password

- In AWS EC2 Console: select the instance → **Actions** → **Security** → **Get Windows password**.
- Use the private key (the one from `key_name` or `terraform/asa-server.pem`) to decrypt the password.

## 6. RDP into the server

- Connect via RDP to the instance **public IP**.
- User: `Administrator`.
- Password: the one you retrieved in step 5.

## 7. Run the bootstrap script once

On the server (in PowerShell, as Administrator):

- Copy or clone this repo to the server (e.g. `C:\Ark`). If the repo is on GitHub/elsewhere, install Git (e.g. via Chocolatey: `choco install -y git`) and run:
  ```powershell
  git clone <this-repo-url> C:\Ark
  cd C:\Ark
  ```
- Run the bootstrap to install SteamCMD and the ASA dedicated server:
  ```powershell
  .\scripts\bootstrap\install_asa_server.ps1
  ```
  This can take a long time (download is large). When it finishes, the ASA files will be under `C:\ArkServer` and the config directory will exist.

## 8. Copy configs and start the server

Still on the server:

- (Optional) Copy `launch_args.txt.example` to `launch_args.txt` and edit if you want a different map or options.
- Run:
  ```powershell
  cd C:\Ark
  .\scripts\server\pull_and_restart.ps1
  ```
  This pulls the repo (if already cloned), copies `server-config/WindowsServer/*.ini` into the ASA config folder, and starts the server.

## 9. Verify

- In Ark Survival Ascended (client): open the server list and search for your server name (or connect by IP and port).
- Or use Steam’s “View” → “Servers” and look for your server.
- Default ports: game **7777**, query **27015** (UDP). Ensure the EC2 security group allows these (they are included in the Terraform config).

## Next steps

- For daily ops (restart, apply new config): see [Operations](OPERATIONS.md).
- To change server name, max players, multipliers: edit `server-config/WindowsServer/GameUserSettings.ini`, commit and push, then on the server run `.\scripts\server\pull_and_restart.ps1`.
