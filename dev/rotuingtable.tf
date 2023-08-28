#route table
resource "aws_route_table" "bastion_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table" "k8s_route_table" {
  count  = 2
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

resource "aws_route_table" "db_route_table" {
  count  = 2
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
}

#route_table_association
resource "aws_route_table_association" "bastion_subnet_route" {
    count = 2
  subnet_id      = aws_subnet.bastion_subnet[count.index].id
  route_table_id = aws_route_table.bastion_route_table.id
}


resource "aws_route_table_association" "k8s_route_table" {
  count          = 2
  subnet_id      = aws_subnet.k8s_subnet[count.index].id
  route_table_id = aws_route_table.k8s_route_table[count.index].id
}

resource "aws_route_table_association" "db_route_table" {
  count          = 2
  subnet_id      = aws_subnet.db_subnet[count.index].id
  route_table_id = aws_route_table.db_route_table[count.index].id
}
