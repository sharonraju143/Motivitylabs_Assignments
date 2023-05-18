resource "aws_security_group" "project-beanstalk-elb-sg" {
  name = "project-beanstalk-elb-sg"
  vpc_id = aws_vpc.demo-vpc.id
  ingress {
    from_port = 80
    protocol  = "tcp"
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "project-bastion-sg" {
  name = "project-bastion-sg"
  vpc_id = aws_vpc.demo-vpc.id
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "project-prod-sg" {
  name = "project-prod-sg"
  vpc_id = aws_vpc.demo-vpc.id
  ingress {
    from_port = 22
    protocol  = "tcp"
    to_port   = 22
    security_groups = [aws_security_group.project-bastion-sg.id]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "project-backend-sg" {
  name = "project-backend-sg"
  vpc_id = aws_vpc.demo-vpc.id
  ingress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    security_groups = [aws_security_group.project-prod-sg.id]
  }
  egress {
    from_port = 0
    protocol  = "-1"
    to_port   = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_security_group_rule" "allow_itself" {
  from_port         = 0
  protocol          = "tcp"
  security_group_id = aws_security_group.project-backend-sg.id
  source_security_group_id = aws_security_group.project-backend-sg.id
  to_port           = 65535
  type              = "ingress"
}

