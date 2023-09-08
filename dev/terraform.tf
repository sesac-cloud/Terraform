terraform {
  required_version = "~> 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket         = "tf-state-sesac"
    key            = "terraform/remote"
    region         = "ap-northeast-2"
    dynamodb_table = "tfstate_lock"
  }
}


