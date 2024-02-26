terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.66.1"
    }
  }

  backend "s3" {
    bucket         = "metabase-tfstate-null-bucket"
    key            = "fargate/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "metabase-tfstate-null-state-locking"
    encrypt        = true
  }

}