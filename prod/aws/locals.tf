

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



