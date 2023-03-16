# Create VPC

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "eks-vpc"
  }
}

# Create Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "eks-igw"
  }
}

# Create an Elastic IP for NAT Gateway 1

resource "aws_eip" "eip1" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "eks-eip1"
  }
}

# Create an Elastic IP for NAT Gateway 2

resource "aws_eip" "eip2" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "eks-eip2"
  }
}

# Create NAT Gateway 1

resource "aws_nat_gateway" "nat-gatw1" {
  allocation_id = aws_eip.eip1.id
  subnet_id     = aws_subnet.pub-sub1.id

  tags = {
    Name = "eks-nat1"
  }
  depends_on = [aws_internet_gateway.igw]
}

# Create a NAT Gateway 2

resource "aws_nat_gateway" "nat-gatw2" {
  allocation_id = aws_eip.eip2.id
  subnet_id     = aws_subnet.pub-sub2.id

  tags = {
    Name = "eks-nat2"
  }
  depends_on = [aws_internet_gateway.igw]
}

# Create public Route Table

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "eks-pub-rt"
  }
}

# Create Route Table for private sub 1

resource "aws_route_table" "priv-rt1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gatw1.id
  }

  tags = {
    Name = "eks-priv-rt1"
  }
}

# Create Route Table for private sub 2

resource "aws_route_table" "priv-rt2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gatw2.id
  }

  tags = {
    Name = "eks-priv-rt2"
  }
}

# Associate public subnet 1 with public route table

resource "aws_route_table_association" "pub-sub1-association" {
  subnet_id      = aws_subnet.pub-sub1.id
  route_table_id = aws_route_table.pub-rt.id
}

# Associate public subnet 2 with public route table

resource "aws_route_table_association" "pub-sub2-association" {
  subnet_id      = aws_subnet.pub-sub2.id
  route_table_id = aws_route_table.pub-rt.id
}

# Associate private subnet 1 with private route table 1

resource "aws_route_table_association" "priv-sub1-association" {
  subnet_id      = aws_subnet.priv-sub1.id
  route_table_id = aws_route_table.priv-rt1.id
}

# Associate private subnet 2 with private route table 2

resource "aws_route_table_association" "priv-sub2-association" {
  subnet_id      = aws_subnet.priv-sub2.id
  route_table_id = aws_route_table.priv-rt2.id
}

# Create Public Subnet-1

resource "aws_subnet" "pub-sub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags = {
    Name = "eks-pub-sub1"
  }
}

# Create Public Subnet-2

resource "aws_subnet" "pub-sub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1b"
  tags = {
    Name = "eks-pub-sub2"
  }
}

# Create Private Subnet-1

resource "aws_subnet" "priv-sub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
  tags = {
    Name = "eks-priv-sub1"
  }
}

# Create Private Subnet-2

resource "aws_subnet" "priv-sub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false
  tags = {
    Name = "eks-priv-sub2"
  }
}

# Create a security group for the EKS cluster

resource "aws_security_group" "eks-security-group" {
  name_prefix = "eks-security-group"
  description = "Security group for EKS cluster"
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}