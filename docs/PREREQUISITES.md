# Prerequisites

Before you run the first-time deploy, ensure you have the following.

## AWS

- **AWS account** with permissions to create EC2 instances, security groups, EBS volumes, and key pairs.
- **AWS CLI** installed and configured (`aws configure`). Used by Terraform.
- **Terraform** installed (e.g. [terraform.io/downloads](https://www.terraform.io/downloads)). Tested with Terraform >= 1.0 and AWS provider ~> 5.0.

## Access to the server

- **RDP client** (e.g. Windows Remote Desktop, or “Remote Desktop Connection”) to connect to the Windows Server instance. Alternatively, if you enable WinRM/SSH on the instance, you can use those.
- **EC2 key pair**: Either use an existing key pair (set `key_name` in `terraform.tfvars`) or let Terraform generate one (private key will be saved as `terraform/asa-server.pem`; you need it to retrieve the Windows password from the EC2 console).

## Optional

- **Git** on your PC (to clone this repo and push config changes).
- **Git** on the Windows server (installed by Terraform user-data via Chocolatey, or install manually) so you can clone the repo and run `pull_and_restart.ps1`.

## Version notes

- Terraform: >= 1.0
- AWS provider: ~> 5.0
- AWS CLI: v2 recommended
