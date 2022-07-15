resource "aws_instance" "bastion" {
  ami           = "ami-052efd3df9dad4825" 
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public-1.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "bastion"
  }

}

resource "aws_instance" "application" {
  ami           = "ami-052efd3df9dad4825" 
  instance_type = "t2.micro"

  subnet_id = aws_subnet.private-1.id
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_3000.id]
  key_name = aws_key_pair.generated_key.key_name


  tags = {
    Name = "application"
  }

}
