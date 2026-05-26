variable "name" {
  description = "Base name used as a prefix for all resources."
  type        = string
  default     = "net-peering"
}

variable "environment" {
  description = "Environment name, e.g. dev, qa, prod."
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

variable "aws_region" {
  description = "AWS region for the deployment, e.g. ca-central-1."
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the deployment, e.g. ca-central-1a."
  type        = string
}

variable "app_subnet_has_nat_route" {
  description = "Whether the private app subnet should route outbound traffic through the NAT Gateway."
  type        = bool
  default     = true
}

variable "db_subnet_has_nat_route" {
  description = "Whether the private DB subnet should route outbound traffic through the NAT Gateway."
  type        = bool
  default     = false
}

variable "app_port" {
  description = "Application port."
  type        = number
  default     = 8000
}

variable "db_port" {
  description = "PostgreSQL port."
  type        = number
  default     = 5432
}

variable "ssh_allowed_cidr" {
  description = "Optional CIDR allowed to SSH into app instances. Use null to disable."
  type        = string
  default     = null
}

variable "app_allowed_cidr" {
  description = "Optional CIDR allowed to access the app port directly. Use null to disable."
  type        = string
  default     = null
}

variable "db_ssh_allowed_cidr" {
  description = "Optional CIDR allowed to SSH into DB instances. Use null to disable."
  type        = string
  default     = null
}

variable "db_port_allowed_cidr" {
  description = "Optional CIDR allowed to access the DB port directly. Use null to disable."
  type        = string
  default     = null
}

variable "app_instance_type" {
    description = "EC2 instance type for app instances."
    type        = string
    default     = "t3.micro"
}
