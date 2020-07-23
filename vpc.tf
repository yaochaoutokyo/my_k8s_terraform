resource "aws_vpc" "kubernetes-vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Terraform = "true"
    Name = "kubernetes"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.kubernetes-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Terraform = "true"
    Name = "kubernetes"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.kubernetes-vpc.id

  tags = {
    Terraform = "true"
    Name = "kubernetes"
  }
}

resource "aws_route_table" "route-table" {
  vpc_id = aws_vpc.kubernetes-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Terraform = "true"
    Name = "kubernetes"
  }
}

resource "aws_route_table_association" "route-table-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.route-table.id
}