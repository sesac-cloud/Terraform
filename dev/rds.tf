resource "aws_db_instance" "rds_instance" {
  identifier             = "${var.project_env}-rds"
  allocated_storage      = 10
  max_allocated_storage  = 30
  db_name                = var.project_env
  db_subnet_group_name   = aws_db_subnet_group.db_sbn_group.name
  engine                 = "mysql"
  engine_version         = "8.0.33"
  instance_class         = "db.t3.micro"
  username               = var.dbuser
  password               = var.dbpw
  vpc_security_group_ids = [aws_security_group.dbsg.id]
  skip_final_snapshot    = true
  availability_zone      = local.use_az[0]
  tags                   = local.resource_tags
}

resource "aws_db_subnet_group" "db_sbn_group" {
  name       = "${var.project_env}-db-subnet-group"
  subnet_ids = aws_subnet.db_subnet[*].id
  tags       = local.resource_tags

}
resource "aws_security_group" "dbsg" {
  name        = "db-sg"
  description = "Allow for db"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    cidr_blocks = ["172.16.0.0/22"]
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.resource_tags
}
