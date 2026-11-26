# 1. AWS Provider
provider "aws" {
  region = var.aws_region
}
# 2. Get Latest Amazon Linux 2023 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
# 3. Use Existing VPC
data "aws_vpc" "main" {
  id = "vpc-03056c49513a18e80"
}
# 4. Use Existing Public Subnet
data "aws_subnet" "public" {
  id = "subnet-09664e6bf506d045c"
}
# 5. Create Security Group
resource "aws_security_group" "web" {
  name        = "${var.project_name}-sg"
  description = "Allow HTTP traffic to web server"
  vpc_id      = data.aws_vpc.main.id
  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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
# 6. Create EC2 Instance
resource "aws_instance" "web" {
  ami                         = data.aws_ami.amazon_linux.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  user_data                   = file("${path.module}/user_data.sh")
  metadata_options {
    http_tokens = "required"
  }
  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    encrypted             = true
    delete_on_termination = true
  }
  tags = {
    Name = "${var.project_name}-ec2"
  }
}
