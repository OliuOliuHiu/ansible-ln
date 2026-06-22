output "ubuntu_instance_ids" {
  value       = aws_instance.ubuntu[*].id
  description = "The IDs of the Ubuntu EC2 instances"
}

output "ubuntu_public_ips" {
  value       = aws_instance.ubuntu[*].public_ip
  description = "The public IP addresses of the Ubuntu EC2 instances"
}

output "ubuntu_private_ips" {
  value       = aws_instance.ubuntu[*].private_ip
  description = "The private IP addresses of the Ubuntu EC2 instances"
}

output "ubuntu_ssh_commands" {
  value = [
    for instance in aws_instance.ubuntu :
    "ssh -i ${var.key_private} ubuntu@${instance.public_ip}"
  ]
  description = "SSH commands to connect to the Ubuntu EC2 instances"
}
