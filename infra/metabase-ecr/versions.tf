terraform {
  required_version = ">= 0.13.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.22"
    }
  }

  backend "s3" {
    bucket         = "metabase-tfstate-bucket"
    key            = "ecr/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "metabase-tfstate-state-locking"
    encrypt        = true
  }

}