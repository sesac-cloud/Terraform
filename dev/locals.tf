locals  {

  use_az = [
    "${var.use_region}a",
    "${var.use_region}b"
  ]
}




locals {
  resource_tags = {
    ProjectEnv = var.project_env
  }
  suffix_name = var.project_env

}

locals {
  containers = [
    "backend" ,
    "frontend" ,
    "api"
  ]
}