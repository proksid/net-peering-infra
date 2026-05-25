variable "name" {
  description = "Base name used as a prefix for network resources."
  type        = string
}

variable "environment" {
  description = "Environment name, for example dev, qa, or prod."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}

variable "availability_zone" {
  description = "Availability Zone for the single-zone deployment."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
}