terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

# Create a VPC
resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "demo-vpc"
  }
}

resource "aws_subnet" "demo-public-subnet-1" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
  tags = {
    Name = "demo-public-subnet-1"
  }
}

resource "aws_subnet" "demo-public-subnet-2" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "demo-public-subnet-2"
  }
}

resource "aws_subnet" "demo-private-subnet-1" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "demo-private-subnet-1"
  }
}

resource "aws_subnet" "demo-private-subnet-2" {
  vpc_id            = aws_vpc.demo-vpc.id
  cidr_block        = "10.0.4.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "demo-private-subnet-2"
  }
}

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "demo-igw"
  }
}

resource "aws_route_table" "demo-pub-rt" {
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }
}

resource "aws_route_table_association" "public-association-1" {
  subnet_id      = aws_subnet.demo-public-subnet-1.id
  route_table_id = aws_route_table.demo-pub-rt.id
}

resource "aws_route_table_association" "public-association-2" {
  subnet_id      = aws_subnet.demo-public-subnet-2.id
  route_table_id = aws_route_table.demo-pub-rt.id
}


/*resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "demo-nat-gtw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.demo-public-subnet-2.id

  tags = {
    Name = "demo-nat-gtw"
  }
}
*/
resource "aws_route_table" "demo-pvt-rt" {
  vpc_id = aws_vpc.demo-vpc.id
 /* route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.demo-nat-gtw.id
  } */
}

resource "aws_route_table_association" "private-association-1" {
  subnet_id      = aws_subnet.demo-private-subnet-1.id
  route_table_id = aws_route_table.demo-pvt-rt.id
}

resource "aws_route_table_association" "private-association-2" {
  subnet_id      = aws_subnet.demo-private-subnet-2.id
  route_table_id = aws_route_table.demo-pvt-rt.id
}

resource "aws_security_group" "demo-public-security-group" {
  name        = "demo-public-security-group"
  description = "Allow SSH,HTTP,HTTPS"
  vpc_id      = aws_vpc.demo-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "demo-private-security-group" {
  name        = "demo-private-security-group"
  description = "Allow MYSQL"
  vpc_id      = aws_vpc.demo-vpc.id
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "demo-tg" {
  name     = "demo-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.demo-vpc.id
}

resource "aws_lb_listener" "demo-alb-listener" {
  load_balancer_arn = aws_lb.demo-alb.arn
  port              = 80
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo-tg.arn
  }
}

resource "aws_lb" "demo-alb" {
  name                       = "demo-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.demo-public-security-group.id]
  subnets                    = [aws_subnet.demo-public-subnet-1.id, aws_subnet.demo-public-subnet-2.id]
  enable_deletion_protection = false
  tags = {
    Name = "demo-ALB"
  }
}

resource "aws_launch_configuration" "demo-lc" {
  name                        = "demo-lc"
  image_id                    = "ami-07f3ef11ec14a1ea3"
  instance_type               = "t2.micro"
  key_name                    = "Ansible"
  security_groups             = [aws_security_group.demo-public-security-group.id]
  associate_public_ip_address = true
}

resource "aws_autoscaling_group" "demo-asg" {
  name                 = "demo-asg"
  min_size             = 1
  desired_capacity     = 1
  max_size             = 1
  health_check_type    = "EC2"
  launch_configuration = aws_launch_configuration.demo-lc.name
  target_group_arns = [
    aws_lb_target_group.demo-tg.arn,
  ]
  vpc_zone_identifier = [
    aws_subnet.demo-public-subnet-1.id,
    aws_subnet.demo-public-subnet-2.id
  ]
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_db_subnet_group" "demo-db-subnet-group" {
  name       = "demo-db-subnet-group"
  subnet_ids = [aws_subnet.demo-private-subnet-1.id, aws_subnet.demo-private-subnet-2.id]
  tags = {
    Name = "demo-db-subnet-group"
  }
}

resource "aws_db_instance" "demo-rds" {
  identifier               = "database-1"
  allocated_storage        = 10
  skip_final_snapshot      = true
  delete_automated_backups = true
  db_name                  = "biryani"
  engine                   = "mysql"
  engine_version           = "8.0.32"
  instance_class           = "db.t3.micro"
  username                 = "admin"
  password                 = "123456789"
  vpc_security_group_ids   = [aws_security_group.demo-private-security-group.id]
  db_subnet_group_name     = "demo-db-subnet-group"
}
