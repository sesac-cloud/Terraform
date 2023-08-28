resource "aws_db_instance" "default" {
  allocated_storage     = 10
  max_allocated_storage = 30
  db_name               = "${var.project_env}-rds"
  engine                = "mysql"
  engine_version        = "8.0.33"
  instance_class        = "db.t3.micro"
  username              = "adminroot"
  password              = var.db_pass

  skip_final_snapshot = true
  availability_zone   = local.use_az[0]
  tags                = resource_tags
}

resource "aws_db_subnet_group" "db_sbn_group" {
  name       = "${var.project_env}-subnet-group"
  subnet_ids = [aws_subnet.db_db_subnet]
  tags       = resource_tags

}