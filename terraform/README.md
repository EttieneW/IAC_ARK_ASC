# Terraform – ASA server on AWS

This directory provisions the AWS infrastructure for the Ark Survival Ascended dedicated server: EC2 Windows Server, EBS volume, security group, and optional key pair.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- [AWS CLI](https://aws.amazon.com/cli/) configured (`aws configure`)
- Copy `terraform.tfvars.example` to `terraform.tfvars` and set variables (region, instance type, `allowed_admin_cidr`, etc.)

## Commands

```powershell
cd terraform
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

To destroy:

```powershell
terraform destroy -var-file=terraform.tfvars
```

## Outputs

After apply:

- `instance_public_ip` – RDP/connect to this IP
- `instance_id` – EC2 instance ID
- `rdp_command` – Short reminder for RDP and password retrieval
- `private_key_path` – Path to generated key (if `create_key_pair` is true)

## Variables

See `variables.tf` and `terraform.tfvars.example`. Important:

- **key_name**: Leave empty to generate a new key (saved as `asa-server.pem` in this directory; gitignored).
- **allowed_admin_cidr**: CIDR allowed to hit RDP (port 3389). Use your IP (e.g. `1.2.3.4/32`) for security.
- **ebs_volume_size_gb**: Size for the data volume (default 300). ASA + SteamCMD need substantial space.

## Security

- Do not commit `terraform.tfvars` or `*.pem` files.
- Restrict `allowed_admin_cidr` to your IP when possible.
