
resource "aws_vpc" "vpc" {
  cidr_block = "172.16.0.0/16"
 // tags       = local.resource_tags
}


resource "aws_subnet" "bastion_subnet" {
  count             = var.count_num
  vpc_id            = aws_vpc.vpc.id
  availability_zone = local.use_az[count.index]
  cidr_block        = "172.16.${count.index}.0/24"

#   tags = {
#     ProjectEnv = var.project_env
#     az         = local.use_az[count.index]
#   }

}

resource "aws_subnet" "k8s_subnet" {
  count             = var.count_num
  vpc_id            = aws_vpc.vpc.id
  availability_zone = local.use_az[count.index]
  cidr_block        = "172.16.${count.index + var.count_num}.0/24"
#   tags = {
#     ProjectEnv = var.project_env
#     az         = local.use_az[count.index]
#   }
}

resource "aws_subnet" "db_subnet" {
  count             = var.count_num
  vpc_id            = aws_vpc.vpc.id
  availability_zone = local.use_az[count.index]
  cidr_block        = "172.16.${count.index + (var.count_num*2)}.0/24"
#   tags = {
#     ProjectEnv = var.project_env
#     az         = local.use_az[count.index]
#   }

}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
//  tags   = local.resource_tags
}



#nat gw
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.bastion_subnet[0].id
  depends_on    = [aws_internet_gateway.igw]
 // tags          = local.resource_tags
}

# resource "aws_nat_gateway" "nat_gw" {
#     count =var.count_num
#   allocation_id = aws_eip.nat_eip[count.index].id
#   subnet_id     = aws_subnet.bastion_subnet[count.index].id
#   depends_on    = [aws_internet_gateway.igw]
#  // tags          = local.resource_tags
# }

resource "aws_eip" "nat_eip" {
//    count = var.count_num
 // tags = local.resource_tags
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${data.aws_region.current.name}.s3"
}

resource "aws_vpc_endpoint_route_table_association" "s3vpcendpoint_assoication" {
  count           = var.count_num
  route_table_id  = aws_route_table.k8s_route_table[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}


#route table
resource "aws_route_table" "bastion_route_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
 // tags = local.resource_tags
}

resource "aws_route_table" "k8s_route_table" {
  count  = var.count_num
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
    //   nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }
 // tags = local.resource_tags
}

resource "aws_route_table" "db_route_table" {
  count  = var.count_num
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
 //   nat_gateway_id = aws_nat_gateway.nat_gw[count.index].id
  }
 // tags = local.resource_tags
}

#route_table_association
resource "aws_route_table_association" "bastion_subnet_route" {
  count          = var.count_num
  subnet_id      = aws_subnet.bastion_subnet[count.index].id
  route_table_id = aws_route_table.bastion_route_table.id
}


resource "aws_route_table_association" "k8s_route_table" {
  count          = var.count_num
  subnet_id      = aws_subnet.k8s_subnet[count.index].id
  route_table_id = aws_route_table.k8s_route_table[count.index].id
}

resource "aws_route_table_association" "db_route_table" {
  count          = var.count_num
  subnet_id      = aws_subnet.db_subnet[count.index].id
  route_table_id = aws_route_table.db_route_table[count.index].id
}
