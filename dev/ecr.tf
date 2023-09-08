resource "aws_ecr_repository" "ecr_repo" {
  for_each     = toset(local.containers)
  name         = "${var.project_env}-${each.key}"
  tags         = local.resource_tags
  force_delete = true
}
