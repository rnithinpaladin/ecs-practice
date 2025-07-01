provider "aws" {
  region = local.region
}

data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
    vpc_name = var.vpc_name
    cluster_name = var.cluster_name
    cidr = var.vpc_cidr
    azs =  slice(data.aws_availability_zones.available.names, 0, 3)
    private_subnets = [for k, v in local.azs : cidrsubnet(local.cidr, 8, k)]
    public_subnets = [for k, v in local.azs : cidrsubnet(local.cidr, 8, k + 4)]
    environment = var.environment
    tags = {
      "Environment" = var.environment
      "Name"        = "${var.vpc_name}-vpc"
      "CreatedBy"   = "Terraform"
    }
    region = "us-east-1" # Adjust as needed
    desired_capacity = var.desired_capacity
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity
    ecr_backend_repository_name = var.ecr_backend_repository_name
    ecr_repositories = {
      backend = {
        name = var.ecr_backend_repository_name
        tags = local.tags
      }
      frontend = {
        name = var.ecr_frontend_repository_name
        tags = local.tags
      }
    }
}
