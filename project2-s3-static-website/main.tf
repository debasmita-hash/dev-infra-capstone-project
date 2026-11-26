terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 6.0"
   }
   random = {
     source  = "hashicorp/random"
     version = "~> 3.0"
   }
 }
}
# AWS Provider Configuration
provider "aws" {
 region = var.aws_region
}
# Input Variables
variable "aws_region" {
 description = "AWS region"
 type        = string
 default     = "ap-south-1"
}
variable "bucket_prefix" {
 description = "Prefix for S3 bucket name"
 type        = string
 default     = "debasmita-project2-website"
}
# Generate Random ID
resource "random_id" "suffix" {
 byte_length = 4
}
# Create S3 Bucket
resource "aws_s3_bucket" "website" {
 bucket = "${var.bucket_prefix}-${random_id.suffix.hex}"
 tags = {
   Name        = "Project2-Static-Website"
   Environment = "Capstone"
 }
}
# Configure Public Access
resource "aws_s3_bucket_public_access_block" "website" {
 bucket = aws_s3_bucket.website.id
 block_public_acls       = true
 ignore_public_acls      = true
 block_public_policy     = false
 restrict_public_buckets = false
}
# Enable Static Website Hosting
resource "aws_s3_bucket_website_configuration" "website" {
 bucket = aws_s3_bucket.website.id
 index_document {
   suffix = "index.html"
 }
}
# Allow Public Read Access
resource "aws_s3_bucket_policy" "website" {
 bucket = aws_s3_bucket.website.id
 depends_on = [
   aws_s3_bucket_public_access_block.website
 ]
 policy = jsonencode({
   Version = "2012-10-17"
   Statement = [
     {
       Sid       = "PublicReadGetObject"
       Effect    = "Allow"
       Principal = "*"
       Action    = "s3:GetObject"
       Resource  = "${aws_s3_bucket.website.arn}/*"
     }
   ]
 })
}
# Upload index.html
resource "aws_s3_object" "index" {
 bucket       = aws_s3_bucket.website.id
 key          = "index.html"
 source       = "${path.module}/index.html"
 content_type = "text/html"
 etag         = filemd5("${path.module}/index.html")
 depends_on = [
   aws_s3_bucket_policy.website
 ]
}
# Output Bucket Name
output "bucket_name" {
 value = aws_s3_bucket.website.id
}
# Output Website URL
output "website_url" {
 value = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
}
