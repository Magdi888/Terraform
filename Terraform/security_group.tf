resource "aws_security_group" "bastion_sg" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic"
  vpc_id      = module.network.vpc_id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

}

resource "aws_security_group" "application_sg" {
  name        = "allow_ssh-and port 3000"
  description = "Allow ssh and 3000 inbound traffic"
  vpc_id      = module.network.vpc_id

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [module.network.vpc_cidr]
    
  }

  ingress {
    description      = "port 3000"
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = [module.network.vpc_cidr]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

}

resource "aws_security_group" "rds_sg" {
  name        = "allow port 3306"
  description = "Allow 3306 inbound traffic"
  vpc_id      = module.network.vpc_id

  ingress {
    description      = "port 3306"
    from_port        = 3306
    to_port          = 3306
    protocol         = "tcp"
    cidr_blocks      = [module.network.vpc_cidr]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

}

resource "aws_security_group" "rediscluster_sg" {
  name        = "allow port 6379"
  description = "Allow 6379 inbound traffic"
  vpc_id      = module.network.vpc_id

  

  ingress {
    description      = "port 6379"
    from_port        = 6379
    to_port          = 6379
    protocol         = "tcp"
    cidr_blocks      = [module.network.vpc_cidr]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

}

resource "aws_security_group" "lb_sg" {
  name        = "loadbalancer sg"
  description = "loadbalancer sg"
  vpc_id      = module.network.vpc_id

  ingress {
    description      = "ssh"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }

 }