resource "aws_s3_bucket" "appbucket" {
  bucket = "sesac-app-bucket"

  tags = local.resource_tags
}