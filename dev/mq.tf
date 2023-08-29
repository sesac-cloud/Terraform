
resource "aws_security_group" "mq_sg" {
  name        = "http-sg"
  description = "Allow all http"
  vpc_id      = aws_vpc.vpc.id
  ingress = {

      cidr_blocks = ["172.16.0.0/23"]
      from_port   = 8080
      to_port     = 8080
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

resource "aws_mq_broker" "mq_borker" {
  broker_name = "${var.project_env}broker"


  engine_type        = "RabbitMQ"
  engine_version     = "3.11.16"
  host_instance_type = "mq.t3.micro"
  security_groups    = [aws_security_group.[0].id]

  deployment_mode = "SINGLE_INSTANCE"
  publicly_accessible = true
  subnet_ids = [aws_subnet.bastion_subnet[0].id]

  user {
    username = "test"
    password = "testtesttest1234"
  }

}

