output "s3_endpoint" {
  value = aws_vpc_endpoint.s3.id
}
output "bastion_subnet" {
  value = aws_subnet.bastion_subnet[*]
}
output "k8s_subnet" {
  value = aws_subnet.k8s_subnet[*]
}
output "db_subnet" {
  value = aws_subnet.db_subnet[*]
}
output "mq_subnet" {
  value = aws_subnet.mq_subnet[*]
}
output "vpc_id" {
  value = aws_vpc.vpc.id
}
output "vpc_cidr" {
 value = aws_vpc.vpc.cidr_block  
}