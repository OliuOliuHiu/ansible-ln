variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
}

variable "project_name" {
  description = "The name of the project"
  type        = string
}

variable "ec2_instance_count" {
  description = "The number of Ubuntu EC2 instances to create"
  type        = number
  default     = 3
}

variable "ubuntu_instance_type" {
  description = "The EC2 instance type for Ubuntu servers"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "The public key file path used to create the AWS EC2 key pair"
  type        = string
  default     = "~/.ssh/ansible-learn.pub"
}

variable "key_private" {
  description = "The private key file path used to SSH into EC2 instances. Defaults to key_name without .pub."
  type        = string
  default     = "~/.ssh/ansible-learn"
}

variable "ssh_cidr" {
  description = "The CIDR block allowed to SSH into EC2 instances"
  type        = string
  default     = "0.0.0.0/0"
}
