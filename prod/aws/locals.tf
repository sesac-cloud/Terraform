# locals {
#   use_az = [
#     "${var.use_region}a",
#     "${var.use_region}c"
#   ]
# }

locals {
  resource_tags = {
    ProjectEnv = var.project_env
  }
  suffix_name = var.project_env
}

locals {
  containers = [
    "mask-api",
    "mailsender",
    "frontend",
    "api"
  ]
}



# locals {
#   account_id = data.aws_caller_identity.current.account_id
# }