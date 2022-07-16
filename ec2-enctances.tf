resource "aws_instance" "bastion" {
  ami           = var.ami 
  instance_type = var.instance_type

  subnet_id = module.network.public_subnet-1_id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = aws_key_pair.generated_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "bastion"
  }
  provisioner "local-exec" {
    command = "echo ${self.public_ip}"
  
  }

}

resource "aws_instance" "application" {
  ami           = var.ami 
  instance_type = var.instance_type

  subnet_id = module.network.private_subnet-1_id
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_3000.id]
  key_name = aws_key_pair.generated_key.key_name


  tags = {
    Name = "application"
  }

}
