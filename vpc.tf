
resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.0.0.0/16"
  tags       = {
    Name = var.VPC_NAME
  }
}

resource "aws_subnet" "demo-public-subnet-1" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.pubsub1
  availability_zone = var.zone1
  tags = {
    Name = "demo-public-subnet-1"
  }
}

resource "aws_subnet" "demo-public-subnet-2" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.pubsub2
  availability_zone = var.zone2
  tags = {
    Name = "demo-public-subnet-2"
  }
}

resource "aws_subnet" "demo-public-subnet-3" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.pubsub3
  availability_zone = var.zone3
  tags = {
    Name = "demo-public-subnet-3"
  }
}

resource "aws_subnet" "demo-private-subnet-1" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.pvtsub1
  availability_zone = var.zone1

  tags = {
    Name = "demo-private-subnet-1"
  }
}

resource "aws_subnet" "demo-private-subnet-2" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.pvtsub2
  availability_zone = var.zone2

  tags = {
    Name = "demo-private-subnet-2"
  }
}

resource "aws_subnet" "demo-private-subnet-3" {
  vpc_id     = aws_vpc.demo-vpc.id
  cidr_block = var.pvtsub3
  availability_zone = var.zone3

  tags = {
    Name = "demo-private-subnet-3"
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
  subnet_id = aws_subnet.demo-public-subnet-1.id
  route_table_id = aws_route_table.demo-pub-rt.id
}

resource "aws_route_table_association" "public-association-2" {
  subnet_id = aws_subnet.demo-public-subnet-2.id
  route_table_id = aws_route_table.demo-pub-rt.id
}

resource "aws_route_table_association" "public-association-3" {
  subnet_id = aws_subnet.demo-public-subnet-3.id
  route_table_id = aws_route_table.demo-pub-rt.id
}



resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "demo-nat-gtw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.demo-public-subnet-2.id

  tags = {
    Name = "demo-nat-gtw"
  }
}

resource "aws_route_table" "demo-pvt-rt" {
  vpc_id = aws_vpc.demo-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.demo-nat-gtw.id
  }
}

resource "aws_route_table_association" "private-association-1" {
  subnet_id = aws_subnet.demo-private-subnet-1.id
  route_table_id = aws_route_table.demo-pvt-rt.id
}

resource "aws_route_table_association" "private-association-2" {
  subnet_id = aws_subnet.demo-private-subnet-2.id
  route_table_id = aws_route_table.demo-pvt-rt.id
}

resource "aws_route_table_association" "private-association-3" {
  subnet_id = aws_subnet.demo-private-subnet-3.id
  route_table_id = aws_route_table.demo-pvt-rt.id
}





