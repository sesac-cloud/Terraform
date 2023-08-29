resource "aws_db_instance" "rds_instance" {
  allocated_storage     = 10
  max_allocated_storage = 30
  db_name               = "${var.project_env}rds"
  db_subnet_group_name  = aws_db_subnet_group.db_sbn_group.name
  engine                = "mysql"
  engine_version        = "8.0.33"
  instance_class        = "db.t3.micro"
  username              = "adminroot"
  password              = "sadsadsadasd"

  skip_final_snapshot = true
  availability_zone   = local.use_az[0]
  tags                = local.resource_tags
}

resource "aws_db_subnet_group" "db_sbn_group" {
  name       = "${var.project_env}-subnet-group"
  subnet_ids = aws_subnet.db_subnet[*].id
  tags       = local.resource_tags

}