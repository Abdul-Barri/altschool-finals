# Create VPC

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
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

# Create an Elastic IP for NAT Gateway 3

resource "aws_eip" "eip3" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
  tags = {
    Name = "eks-eip3"
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

# Create a NAT Gateway 3

resource "aws_nat_gateway" "nat-gatw3" {
  allocation_id = aws_eip.eip3.id
  subnet_id     = aws_subnet.pub-sub3.id

  tags = {
    Name = "eks-nat3"
  }
  depends_on = [aws_internet_gateway.igw]
}

# Create public Route Table

resource "aws_route_table" "pub-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.route-cidr
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
    cidr_block     = var.route-cidr
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
    cidr_block     = var.route-cidr
    nat_gateway_id = aws_nat_gateway.nat-gatw2.id
  }

  tags = {
    Name = "eks-priv-rt2"
  }
}

# Create Route Table for private sub 3

resource "aws_route_table" "priv-rt3" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = var.route-cidr
    nat_gateway_id = aws_nat_gateway.nat-gatw3.id
  }

  tags = {
    Name = "eks-priv-rt3"
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

# Associate public subnet 3 with public route table

resource "aws_route_table_association" "pub-sub3-association" {
  subnet_id      = aws_subnet.pub-sub3.id
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

# Associate private subnet 3 with private route table 3

resource "aws_route_table_association" "priv-sub3-association" {
  subnet_id      = aws_subnet.priv-sub3.id
  route_table_id = aws_route_table.priv-rt3.id
}

# Create Public Subnet-1

resource "aws_subnet" "pub-sub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub-sub1-cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az1
  tags = {
    Name = "eks-pub-sub1"
  }
}

# Create Public Subnet-2

resource "aws_subnet" "pub-sub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub-sub2-cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az2
  tags = {
    Name = "eks-pub-sub2"
  }
}

# Create Public Subnet-3

resource "aws_subnet" "pub-sub3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub-sub3-cidr
  map_public_ip_on_launch = true
  availability_zone       = var.az3
  tags = {
    Name = "eks-pub-sub3"
  }
}

# Create Private Subnet-1

resource "aws_subnet" "priv-sub1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.priv-sub1-cidr
  availability_zone       = var.az1
  map_public_ip_on_launch = false
  tags = {
    Name = "eks-priv-sub1"
  }
}

# Create Private Subnet-2

resource "aws_subnet" "priv-sub2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.priv-sub2-cidr
  availability_zone       = var.az2
  map_public_ip_on_launch = false
  tags = {
    Name = "eks-priv-sub2"
  }
}

# Create Private Subnet-3

resource "aws_subnet" "priv-sub3" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.priv-sub3-cidr
  availability_zone       = var.az3
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