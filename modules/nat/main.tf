resource "aws_eip" "nat-gw1-eip" {
  domain     = "vpc"
  tags   = {
    Name = "${var.project-name}-eip1"
  }
}

resource "aws_eip" "nat-gw2-eip" {
  domain     = "vpc"
  tags   = {
    Name = "${var.project-name}-eip2"
  }
}

resource "aws_nat_gateway" "nat-gw1" {
  allocation_id = aws_eip.nat-gw1-eip.id
  subnet_id     = var.public-subnet1-id
  depends_on = [var.igw-id]

  tags = {
    Name = "${var.project-name}-nat-gw1"
  }
}

resource "aws_nat_gateway" "nat-gw2" {
  allocation_id = aws_eip.nat-gw2-eip.id
  subnet_id     = var.public-subnet2-id
  depends_on = [var.igw-id]

  tags = {
    Name = "${var.project-name}-nat-gw2"
  }
}

resource "aws_route_table" "prv-route-table1" {
  vpc_id = var.vpc-id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw1.id
  }

  tags = {
    Name = "${var.project-name}-prv-route-table1"
  }
}

resource "aws_route_table_association" "prv-sn1-rt-assoc" {
  subnet_id      = var.prv-subnet1-id
  route_table_id = aws_route_table.prv-route-table1.id
}

resource "aws_route_table" "prv-route-table2" {
  vpc_id = var.vpc-id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-gw2.id
  }

  tags = {
    Name = "${var.project-name}-route-table2"
  }
}

resource "aws_route_table_association" "prv-sn2-rt-assoc" {
  subnet_id      = var.prv-subnet2-id
  route_table_id = aws_route_table.prv-route-table2.id
}