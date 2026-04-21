variable "bucket_name" {
  description = "The name of the S3 bucket"
  default     = "my-first-terraform-bucket-sam-48291"
}

variable "project_name" {
  description = "Name used to tag all resources"
  default     = "sam-project"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  default     = "10.0.2.0/24"
}

variable "key_name" {
  description = "Name of the AWS key pair for SSH access"
  default     = "sam-key"
}

variable "ami_id" {
  description = "AMI ID for Ubuntu 22.04 in eu-west-1"
  default     = "ami-0d64bb532e0502c46"
}

variable "db_password" {
  description = "Password for the RDS database"
  sensitive   = true
  default     = "SecurePass123!"
}
variable "alert_email" {
  description = "Email address to receive CloudWatch alerts"
  default     = "sammyboy02@yahoo.com"
}
