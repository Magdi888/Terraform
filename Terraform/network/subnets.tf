resource "aws_subnet" "public-1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.public_subnet-1_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name = "public-1"
  }
}
resource "aws_subnet" "public-2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.public_subnet-2_cidr
  availability_zone = "${var.region}b"
  tags = {
    Name = "public-2"
  }
}
resource "aws_subnet" "private-1" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.private_subnet-1_cidr
  availability_zone = "${var.region}a"
  tags = {
    Name = "private-1"
  }
}
resource "aws_subnet" "private-2" {
  vpc_id     = aws_vpc.myvpc.id
  cidr_block = var.private_subnet-2_cidr
  availability_zone = "${var.region}b"
  tags = {
    Name = "private-2"
  }
}