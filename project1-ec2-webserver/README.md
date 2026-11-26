# Project 1: AWS EC2 Web Server using Terraform
## Project Overview
This project demonstrates Infrastructure as Code (IaC)
using Terraform to deploy an Apache web server on AWS EC2.
## Technologies Used
- AWS
- Terraform
- Linux
- Amazon Linux 2023
- Apache HTTP Server
- Bash scripting
- Git
## AWS Resources
1. VPC
2. Public Subnet
3. Internet Gateway
4. Route Table
5. Route Table Association
6. Security Group
7. EC2 Instance
## Project Architecture
Terraform provisions AWS infrastructure.
An EC2 instance is launched in a public subnet.
User Data automatically installs and starts Apache.
The website is accessible through the EC2 public IP.
## Project Structure
project1-ec2-webserver/
- main.tf
- variables.tf
- outputs.tf
- user_data.sh
- .gitignore
- README.md
## Deployment Commands
Initialize Terraform:
terraform init
Format configuration:
terraform fmt
Validate configuration:
terraform validate
Review infrastructure:
terraform plan
Deploy infrastructure:
terraform apply
Destroy infrastructure:
terraform destroy
## Expected Result
An Apache web server hosted on an AWS EC2 instance
with a custom HTML homepage.
## Security
- Encrypted EBS root volume
- IMDSv2 enabled
- HTTP access through port 80
- No public SSH access configured
## Author
Cloud Infrastructure Project
