variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "environment" {
  description = "Environment for the resources (e.g., dev, staging, prod)"
  type        = string
}

variable "desired_capacity" {
  description = "Desired number of nodes in the EKS cluster"
  type        = number
  default     = 1
}

variable "min_capacity" {
  description = "Minimum number of nodes in the EKS cluster"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of nodes in the EKS cluster"
  type        = number
  default     = 3
}

variable "ecr_backend_repository_name" {
  description = "Name of the ECR repository for the backend application"
  type        = string
  default     = "demo-flask-backend"
}

variable "ecr_frontend_repository_name" {
  description = "Name of the ECR repository for the frontend application"
  type        = string
  default     = "demo-flask-frontend"
}