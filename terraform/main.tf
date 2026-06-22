data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "ubuntu_ec2" {
  name        = "${var.project_name}-ubuntu-ec2-sg"
  description = "Allow SSH access to Ubuntu EC2 instances"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name        = "${var.project_name}-ubuntu-ec2-sg"
    Environment = "dev"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.ubuntu_ec2.id
  cidr_ipv4         = var.ssh_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.ubuntu_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_key_pair" "ubuntu" {
  key_name   = "${var.project_name}-ubuntu-key"
  public_key = file(pathexpand(var.key_name))

  tags = {
    Name        = "${var.project_name}-ubuntu-key"
    Environment = "dev"
  }
}

resource "aws_instance" "ubuntu" {
  count = var.ec2_instance_count

  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.ubuntu_instance_type
  key_name                    = aws_key_pair.ubuntu.key_name
  subnet_id                   = element(data.aws_subnets.default.ids, count.index)
  vpc_security_group_ids      = [aws_security_group.ubuntu_ec2.id]
  associate_public_ip_address = true

  tags = {
    Name        = "${var.project_name}-ubuntu-${count.index + 1}"
    Environment = "dev"
  }
}
