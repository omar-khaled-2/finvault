


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
}


resource "aws_subnet" "public_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-1"
  }
}


resource "aws_subnet" "public_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
  tags = {
    Name = "public-2"
  }
}

resource "aws_subnet" "private_1" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1a"
    tags = {
      Name = "private-1"
    }
}

resource "aws_subnet" "private_2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.4.0/24"
    availability_zone = "us-east-1b"
    tags = {
      Name = "private-2"
    }
}


resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.main.id
 
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}


resource "aws_route_table_association" "public_1_assoc" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.route_table.id
}

resource "aws_route_table_association" "public_2_assoc" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.route_table.id
}

