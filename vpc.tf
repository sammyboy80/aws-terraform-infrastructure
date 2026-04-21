# The VPC — your private network in AWS
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr

  tags = {
    Name      = "${var.project_name}-vpc"
    ManagedBy = "terraform"
  }
}

# Public subnet — where your EC2 web servers will live
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    Name      = "${var.project_name}-public-subnet"
    ManagedBy = "terraform"
  }
}

# Private subnet — where your RDS database will live
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "eu-west-1b"

  tags = {
    Name      = "${var.project_name}-private-subnet"
    ManagedBy = "terraform"
  }
}

# Internet Gateway — connects your VPC to the internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name      = "${var.project_name}-igw"
    ManagedBy = "terraform"
  }
}

# Route table — tells public subnet traffic how to reach the internet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name      = "${var.project_name}-public-rt"
    ManagedBy = "terraform"
  }
}

# Associate the route table with the public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
