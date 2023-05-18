resource "aws_db_subnet_group" "demo-db-subnet-group" {
  name       = "demo-db-subnet-group"
  subnet_ids = [aws_subnet.demo-private-subnet-1.id, aws_subnet.demo-private-subnet-2.id, aws_subnet.demo-private-subnet-3.id]
  tags = {
    Name = "demo-db-subnet-group"
  }
}

resource "aws_db_instance" "demo-rds" {
  allocated_storage      = 20
  db_name                = var.dbname
  engine                 = "mysql"
  engine_version         = "5.7.34"
  instance_class         = "db.t2.micro"
  username               = var.dbuser
  password               = var.dbpass
  multi_az               = "false"
  publicly_accessible    = "false"
  skip_final_snapshot    = "true"
  vpc_security_group_ids = [aws_security_group.project-backend-sg.id]
  db_subnet_group_name   = aws_db_subnet_group.demo-db-subnet-group.name
}

resource "aws_elasticache_subnet_group" "elasticache-subnet-grp" {
  name = "elasticache-subnet-grp"
  subnet_ids = [aws_subnet.demo-private-subnet-1.id, aws_subnet.demo-private-subnet-2.id, aws_subnet.demo-private-subnet-3.id]
}
resource "aws_elasticache_cluster" "project-cache" {
  cluster_id = "project-cache"
  engine = "memcached"
  node_type = "cache.t2.micro"
  num_cache_nodes = "1"
  port = 11211
  security_group_ids = [aws_security_group.project-backend-sg.id]
  subnet_group_name = aws_elasticache_subnet_group.elasticache-subnet-grp.name
}

resource "aws_mq_broker" "project-rmq" {
  broker_name        = "project-rmq"
  engine_type        = "ActiveMQ"
  engine_version     = "5.15.0"
  host_instance_type = "mq.t2.micro"
  security_groups= [aws_security_group.project-backend-sg.id]
  subnet_ids = [aws_subnet.demo-private-subnet-1.id]

  user {
    password = var.rmqpass
    username = var.rmquser
  }
}