output "vpc-id" {
  value = aws_vpc.vpc.id
}

output "igw-id" {
  value = aws_internet_gateway.igw.id
}

output "pub-subnet1-id" {
  value = aws_subnet.pub-subnet1.id
}

output "pub-subnet2-id" {
  value = aws_subnet.pub-subnet2.id
}

output "prv-subnet1-id" {
  value = aws_subnet.prv-subnet1.id
}

output "prv-subnet2-id" {
  value = aws_subnet.prv-subnet2.id
}