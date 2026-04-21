# AWS Secure Web Infrastructure — Terraform

A production-grade, multi-tier AWS infrastructure built entirely 
with Terraform as Infrastructure as Code.

## Architecture

## Infrastructure Built

| Resource | Details |
|---|---|
| VPC | 10.0.0.0/16 — custom private network |
| Public Subnet | 10.0.1.0/24 — eu-west-1a |
| Private Subnet | 10.0.2.0/24 — eu-west-1b |
| EC2 | Ubuntu web server running nginx |
| RDS | MySQL 8.0 — private subnet, no public IP |
| S3 | Static assets bucket — no public access |
| IAM Role | Least privilege S3 access — no hardcoded credentials |
| CloudWatch | CPU alarms on EC2 and RDS |
| SNS | Email alerts when thresholds breached |
| Remote State | Terraform state stored in S3 with versioning |

## Security Design Decisions

- RDS sits in private subnet with no public IP — only reachable from EC2 on port 3306
- EC2 accesses S3 via IAM role with temporary credentials — no access keys stored on server
- Security groups enforce least privilege at every layer
- All public S3 access blocked
- Terraform state stored remotely in S3 — never committed to Git

## Key Architecture Decisions

**Why EC2 over Lambda?**
Persistent web server with predictable load suits EC2.
Lambda would be more cost effective for sporadic workloads.

**Why RDS over DynamoDB?**
Relational data with complex queries suits MySQL.
DynamoDB would suit high-scale key-value workloads.

**Why IAM Role over Access Keys?**
Roles provide temporary, automatically rotated credentials.
Access keys are long-lived secrets that can be compromised.

**What I would add at scale:**
- Auto Scaling Group to replace fixed EC2 instances
- Application Load Balancer for traffic distribution
- CloudFront CDN for static asset delivery
- ElastiCache for database query caching
- WAF for web application firewall protection

## Technology Stack

- **Cloud:** AWS (EC2, VPC, RDS, S3, IAM, CloudWatch, SNS)
- **IaC:** Terraform
- **OS:** Ubuntu Linux
- **Database:** MySQL 8.0
- **Web Server:** nginx
- **Scripting:** Bash (User Data)
- **Version Control:** Git / GitHub

## How to Deploy

git clone https://github.com/sammyboy80/aws-terraform-infrastructure.git
cd aws-terraform-infrastructure
terraform init
terraform plan
terraform apply
terraform destroy

## Author

Bidemi Olawumi — Cloud Security Engineer
LinkedIn: https://linkedin.com/in/sammyboy80
EOF
