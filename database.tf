resource "aws_db_subnet_group" "database_subnets" {
  name       = "database_subnets"
  subnet_ids = [module.network.private_subnet-1_id, module.network.private_subnet-2_id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "myrds" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "mydb"
  username             = var.rds_user
  password             = var.rds_user_pass
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.database_subnets.name
  vpc_security_group_ids = [aws_security_group.allow_ssh_and_3306_and_6379.id]
  port = 3306
}
########################################## elastic cache ##################################################
resource "aws_elasticache_cluster" "elasticache_cluster" {
  cluster_id           = "redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
  engine_version       = "3.2.10"
  port                 = 6379
  subnet_group_name = aws_elasticache_subnet_group.redis_subnets.name
  security_group_ids = [aws_security_group.allow_ssh_and_3306_and_6379.id]

}

resource "aws_elasticache_subnet_group" "redis_subnets" {
  name       = "redis-subnets"
  subnet_ids = [module.network.private_subnet-1_id, module.network.private_subnet-2_id]

}