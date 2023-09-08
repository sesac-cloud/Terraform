
resource "aws_vpc" "vpc" {
  cidr_block = "172.16.0.0/16"
  tags       = local.resource_tags
}


resource "aws_subnet" "bastion_subnet" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  availability_zone = local.use_az[count.index]
  cidr_block        = "172.16.${count.index}.0/24"

  tags = {
    ProjectEnv = var.project_env
    az         = local.use_az[count.index]
  }

}

resource "aws_subnet" "k8s_subnet" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  availability_zone = local.use_az[count.index]
  cidr_block        = "172.16.${count.index + 2}.0/24"
  tags = {
    ProjectEnv = var.project_env
    az         = local.use_az[count.index]
  }
}

resource "aws_subnet" "db_subnet" {
  count             = 2
  vpc_id            = aws_vpc.vpc.id
  availability_zone = local.use_az[count.index]
  cidr_block        = "172.16.${count.index + 4}.0/24"
  tags = {
    ProjectEnv = var.project_env
    az         = local.use_az[count.index]
  }

}

#internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags   = local.resource_tags
}



#nat gw
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.bastion_subnet[0].id
  depends_on    = [aws_internet_gateway.igw]
  tags          = local.resource_tags
}

resource "aws_eip" "nat_eip" {
  tags = local.resource_tags
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.use_region}.s3"
}

resource "aws_vpc_endpoint_route_table_association" "s3vpcendpoint_assoication" {
  count           = 2
  route_table_id  = aws_route_table.k8s_route_table[count.index].id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}
