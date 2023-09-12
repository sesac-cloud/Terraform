# resource "aws_db_instance" "rds_instance" {
#   identifier             = "${var.project_env}-rds"
#   allocated_storage      = 100
#   iops                   = 1000
#   //max_allocated_storage  = 30
#   db_name                = var.project_env
#   db_subnet_group_name   = aws_db_subnet_group.db_sbn_group.name
#   engine                 = "mysql"
#   engine_version         = "8.0.33"
#   instance_class         = "db.m5.large"
#   username               = var.dbuser
#   password               = var.dbpw
#   vpc_security_group_ids = [aws_security_group.dbsg.id]
#   skip_final_snapshot    = true
 
#   //tags                   = local.resource_tags
# }

resource "aws_db_subnet_group" "db_sbn_group" {
  name       = "${var.project_env}-db-subnet-group"
  subnet_ids = var.db_subnet[*].id
 // tags       = local.resource_tags

}
resource "aws_security_group" "dbsg" {
  name        = "db-sg"
  description = "Allow for db"
  vpc_id      = var.vpc_id

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

 // tags = local.resource_tags
}


////


resource "aws_rds_cluster" "rds_cluster" {

  cluster_identifier = "${var.project_env}-rds-cluster"

  engine            = "mysql"
  engine_version    = "8.0.33"
  db_cluster_instance_class    =  "db.m5d.xlarge"
  allocated_storage      = 100
  iops                   = 1000
  storage_type      = "io1"
  //storage_encrypted = var.storage_encrypted
  //kms_key_id        = var.kms_key_id

  database_name                             = var.project_env
  master_username                            = var.dbuser
  master_password                            = var.dbpw
  port                                = 3306
  
 
  vpc_security_group_ids = [aws_security_group.dbsg.id]
  db_subnet_group_name   = aws_db_subnet_group.db_sbn_group.name
  //
  //db_cluster_parameter_group_name   = var.db_cluster_parameter_group_name
  //

  #Option group is not supported in PostgreSQL
  #option_group_name      = var.option_group_name
  network_type           = "IPV4"

 

  # allow_major_version_upgrade = false
  # apply_immediately           = var.apply_immediately
 # preferred_maintenance_window          = var.preferred_maintenance_window

  # snapshot_identifier       = var.snapshot_identifier
  # copy_tags_to_snapshot     = var.copy_tags_to_snapshot
   skip_final_snapshot       = true
  

  //backup_retention_period = var.backup_retention_period
  //preferred_backup_window           = var.preferred_backup_window
  
  //enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  //deletion_protection      = var.deletion_protection

  //tags = var.tags

 // depends_on = [aws_cloudwatch_log_group.this]


}
