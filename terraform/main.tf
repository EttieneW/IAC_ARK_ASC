# ASA Dedicated Server - AWS Infrastructure as Code
# Provisions EC2 Windows Server, EBS, security group, optional key pair.

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Latest Windows Server 2022 base AMI
data "aws_ami" "windows_2022" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Optional: generate key pair for RDP/SSH (password retrieval via EC2 serial console or SSM)
resource "tls_private_key" "server" {
  count     = var.create_key_pair && var.key_name == "" ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "server" {
  count      = var.create_key_pair && var.key_name == "" ? 1 : 0
  key_name   = "${var.project_name}-key"
  public_key = tls_private_key.server[0].public_key_openssh
}

# Security group: ASA game ports + RDP for admin
# Ports: 7777, 27015, 7778 (UDP); 27020 (TCP RCON); 3389 (RDP)
resource "aws_security_group" "asa" {
  name        = "${var.project_name}-sg"
  description = "Ark Survival Ascended server and RDP"

  ingress {
    description = "ASA game port"
    from_port   = 7777
    to_port     = 7777
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ASA query port"
    from_port   = 27015
    to_port     = 27015
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ASA peer port"
    from_port   = 7778
    to_port     = 7778
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "RCON (optional)"
    from_port   = 27020
    to_port     = 27020
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "RDP"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = [var.allowed_admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-sg"
  }
}

# EBS volume for game server + SteamCMD (large install)
resource "aws_ebs_volume" "asa" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = var.ebs_volume_size_gb
  type              = "gp3"
  tags = {
    Name = "${var.project_name}-data"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# EC2 instance: Windows Server 2022
resource "aws_instance" "asa" {
  ami                    = data.aws_ami.windows_2022.id
  instance_type          = var.instance_type
  key_name               = var.key_name != "" ? var.key_name : aws_key_pair.server[0].key_name
  vpc_security_group_ids = [aws_security_group.asa.id]
  get_password_data      = false

  root_block_device {
    volume_size = 80
    volume_type = "gp3"
  }

  user_data = base64encode(templatefile("${path.module}/user_data.ps1", {
    git_repo_url = var.git_repo_url
  }))

  tags = {
    Name = var.project_name
  }
}

# Attach EBS data volume (user formats/uses in Windows as D: or E:)
resource "aws_volume_attachment" "asa" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.asa.id
  instance_id = aws_instance.asa.id
}

# Write generated private key to file (gitignored)
resource "local_file" "private_key" {
  count           = var.create_key_pair && var.key_name == "" ? 1 : 0
  content         = tls_private_key.server[0].private_key_pem
  filename        = "${path.module}/asa-server.pem"
  file_permission = "0600"
}
