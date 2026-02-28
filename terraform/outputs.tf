# ASA server - Terraform outputs
# Use: terraform output

output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.asa.id
}

output "instance_public_ip" {
  description = "Public IP to RDP or connect to the server"
  value       = aws_instance.asa.public_ip
}

output "rdp_command" {
  description = "How to connect via RDP (use the IP above)"
  value       = "RDP: Connect to ${aws_instance.asa.public_ip} as Administrator. Get password from EC2 Console > Instance > Actions > Security > Get Windows password (use key pair)."
}

output "private_key_path" {
  description = "Path to generated private key (if create_key_pair was true)"
  value       = var.create_key_pair && var.key_name == "" ? "${path.module}/asa-server.pem" : "N/A - using existing key"
}
