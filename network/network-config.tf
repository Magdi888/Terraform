## internet getway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "mygw"
  }
}
#### eip
resource "aws_eip" "ip-1" {
  depends_on                = [aws_internet_gateway.gw]
}
### nat getway

resource "aws_nat_gateway" "mynat" {
  allocation_id = aws_eip.ip-1.id
  subnet_id     = aws_subnet.public-1.id

  tags = {
    Name = "gw NAT"
  }

  
  depends_on = [aws_internet_gateway.gw]
}