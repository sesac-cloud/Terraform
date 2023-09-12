
resource "aws_security_group" "mq_sg" {
  name        = "mq-sg"
  description = "Allow for mq"
  vpc_id      = var.vpc.id

  dynamic "ingress" {
    for_each = {
      "broker" = 5671
      "https"  = 443
    }

    content {
      cidr_blocks = ["172.16.0.0/16"]
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
    }

  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  //tags = local.resource_tags
}

resource "aws_mq_broker" "mq_borker" {
  broker_name = "${var.project_env}-broker"

  engine_type        = "RabbitMQ"
  engine_version     = "3.11.16"
  host_instance_type = "mq.m5.large"
  security_groups    = [aws_security_group.mq_sg.id]

  deployment_mode     = "CLUSTER_MULTI_AZ"
  publicly_accessible = false
  subnet_ids          = [var.mq_subnet[*].id]

  user {
    username = var.mquser
    password = var.mqpw
  }
//  tags = local.resource_tags

}

