# Security group for RDS — only allows traffic from EC2 on port 3306
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Allow MySQL traffic from EC2 only"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.project_name}-rds-sg"
    ManagedBy = "terraform"
  }
}

# Subnet group — tells RDS which subnets it can use
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.public.id]

  tags = {
    Name      = "${var.project_name}-db-subnet-group"
    ManagedBy = "terraform"
  }
}

# RDS MySQL database in the private subnet
resource "aws_db_instance" "main" {
  identifier        = "${var.project_name}-database"
  engine            = "mysql"
  engine_version    = "8.0"
  instance_class    = "db.t3.micro"
  allocated_storage = 20
  db_name           = "appdb"
  username          = "admin"
  password          = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Ensures database is in private subnet
  publicly_accessible = false

  # Skips final snapshot when destroyed — fine for learning
  skip_final_snapshot = true

  tags = {
    Name      = "${var.project_name}-database"
    ManagedBy = "terraform"
  }
}
