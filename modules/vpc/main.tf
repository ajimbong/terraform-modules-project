resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc-cidr
  instance_tenancy     = "default"
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project-name}-vpc"
  }
}

resource "aws_subnet" "pub-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub-subnet1-cidr
  availability_zone       = var.az-1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project-name}-pub-subnet1"
  }
}

resource "aws_subnet" "pub-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.pub-subnet2-cidr
  availability_zone       = var.az-2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project-name}-pub-subnet2"
  }
}

resource "aws_subnet" "prv-subnet1" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.prv-subnet1-cidr
  availability_zone       = var.az-1
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project-name}-prv-subnet1"
  }
}

resource "aws_subnet" "prv-subnet2" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.prv-subnet2-cidr
  availability_zone       = var.az-2
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.project-name}-prv-subnet2"
  }
}


# IGW and Public Subnet RT
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.project-name}-igw"
  }
}

resource "aws_route_table" "pub-route-table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project-name}-pub-route-table"
  }
}

resource "aws_route_table_association" "pub-sn1-rt-assoc" {
  subnet_id      = aws_subnet.pub-subnet1.id
  route_table_id = aws_route_table.pub-route-table.id
}

resource "aws_route_table_association" "pub-sn2-rt-assoc" {
  subnet_id      = aws_subnet.pub-subnet2.id
  route_table_id = aws_route_table.pub-route-table.id
}