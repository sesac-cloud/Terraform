output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = aws_rds_cluster.rds_cluster.endpoint
}
