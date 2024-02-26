provider "aws" {
  region = local.region
}

locals {
  region = "us-east-1"
  name   = "desafio-sre"

  tags = {
    Name       = local.name

  }
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

################################################################################
# ECR Repository
################################################################################

module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "ecr-${local.name}"

  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  repository_image_tag_mutability   = "MUTABLE"
  create_lifecycle_policy           = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 10 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  repository_force_delete = true

  tags = local.tags
}