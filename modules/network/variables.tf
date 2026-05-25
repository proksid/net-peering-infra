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

variable "private_app_subnet_cidr" {
  description = "CIDR block for the private application subnet."
  type        = string
}

variable "private_db_subnet_cidr" {
  description = "CIDR block for the private database subnet."
  type        = string
}

variable "app_subnet_has_nat_route" {
  description = "Whether the private app subnet should have a default route to the NAT Gateway for outbound internet access."
  type        = bool
  default     = true
}

variable "db_subnet_has_nat_route" {
  description = "Whether the private DB subnet should have a default route to the NAT Gateway for outbound internet access."
  type        = bool
  default     = false
}


