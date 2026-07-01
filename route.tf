# Internet Gateway

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.kafka_vpc.id

  tags = {
    Name = "Kafka-IGW"
  }
}


# Elastic IP for NAT

resource "aws_eip" "nat" {

  domain = "vpc"

}


# NAT Gateway

resource "aws_nat_gateway" "nat" {

  allocation_id = aws_eip.nat.id

  subnet_id = aws_subnet.public.id

  depends_on = [
    aws_internet_gateway.igw
  ]

  tags = {
    Name = "Kafka-NAT"
  }

}


# Public Route Table

resource "aws_route_table" "public_rt" {

  vpc_id = aws_vpc.kafka_vpc.id


  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }


  tags = {
    Name = "Public-Route-Table"
  }

}



# Public Association

resource "aws_route_table_association" "public_assoc" {

  subnet_id = aws_subnet.public.id

  route_table_id = aws_route_table.public_rt.id

}



# Private Route Table

resource "aws_route_table" "private_rt" {

  vpc_id = aws_vpc.kafka_vpc.id


  route {

    cidr_block = "0.0.0.0/0"

    nat_gateway_id = aws_nat_gateway.nat.id

  }


  tags = {
    Name = "Private-Route-Table"
  }

}



# Private Associations

resource "aws_route_table_association" "private_a" {

  subnet_id = aws_subnet.private_a.id

  route_table_id = aws_route_table.private_rt.id

}



resource "aws_route_table_association" "private_b" {

  subnet_id = aws_subnet.private_b.id

  route_table_id = aws_route_table.private_rt.id

}



resource "aws_route_table_association" "private_c" {

  subnet_id = aws_subnet.private_c.id

  route_table_id = aws_route_table.private_rt.id

}
