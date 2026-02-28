# ASA AWS IAC - Terraform variables
# Copy to terraform.tfvars and set values (terraform.tfvars is gitignored)

variable "aws_region" {
  description = "AWS region for the ASA server"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type (e.g. c5.2xlarge, c6i.2xlarge for 8 vCPU / 16 GB RAM)"
  type        = string
  default     = "c5.2xlarge"
}

variable "key_name" {
  description = "Name of existing EC2 key pair for SSH/RDP. Leave empty to generate a new key with Terraform."
  type        = string
  default     = ""
}

variable "create_key_pair" {
  description = "If true and key_name is empty, Terraform creates a new key pair and saves private key to asa-server.pem"
  type        = bool
  default     = true
}

variable "ebs_volume_size_gb" {
  description = "Size in GB for the game server EBS volume (200-500 recommended)"
  type        = number
  default     = 300
}

variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
  default     = "asa-server"
}

variable "allowed_admin_cidr" {
  description = "CIDR block allowed to access RDP (3389) and WinRM/SSH. Use your IP or 0.0.0.0/0 for any (less secure)."
  type        = string
  default     = "0.0.0.0/0"
}

variable "git_repo_url" {
  description = "Optional: Git repo URL to clone in user-data (for bootstrap). Leave empty to clone manually."
  type        = string
  default     = ""
}
