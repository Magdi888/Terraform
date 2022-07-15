resource "aws_vpc" "myvpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "myvpc"
  }
}

resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "public-1"
  }
}
resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "public-2"
  }
}
resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "private-1"
  }
}
resource "aws_subnet" "private-2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = "10.0.4.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "private-2"
  }
}