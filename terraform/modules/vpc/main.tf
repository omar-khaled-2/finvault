


resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
}

data "aws_availability_zones" "available" {
  state = "available"
}


resource "aws_subnet" "public" {
  count = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]

}


resource "aws_subnet" "private" {
  count = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + length(aws_subnet.public[*].id))
  availability_zone       = data.aws_availability_zones.available.names[count.index]
}





resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
 
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.internet_gateway.id
}
resource "aws_eip" "nat" {
  domain = "vpc"

}

resource "aws_route_table_association" "public_assoc" {
  count = length(aws_subnet.public[*].id)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

}

resource "aws_route" "private" {
  route_table_id = aws_route_table.private.id
  nat_gateway_id = aws_nat_gateway.nat_gateway.id
  destination_cidr_block     = "0.0.0.0/0"
}

resource "aws_route_table_association" "private_assoc" {
  count = length(aws_subnet.private[*].id)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}
