# IAM role — allows EC2 to assume this role
resource "aws_iam_role" "ec2_role" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })

  tags = {
    Name      = "${var.project_name}-ec2-role"
    ManagedBy = "terraform"
  }
}

# IAM policy — defines exactly what the role can do
resource "aws_iam_role_policy" "s3_access" {
  name = "${var.project_name}-s3-access"
  role = aws_iam_role.ec2_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ]
      Resource = [
        "${aws_s3_bucket.assets.arn}",
        "${aws_s3_bucket.assets.arn}/*"
      ]
    }]
  })
}

# Instance profile — attaches the role to EC2
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-ec2-profile"
  role = aws_iam_role.ec2_role.name

  tags = {
    Name      = "${var.project_name}-ec2-profile"
    ManagedBy = "terraform"
  }
}
