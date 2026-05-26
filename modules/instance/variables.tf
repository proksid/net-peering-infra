variable "name" {
  description = "Base name used for resources created by this module."
  type        = string
}

variable "environment" {
  description = "Environment name, for example dev, qa, or prod."
  type        = string
}

variable "ami_id" {
  description = "AMI ID used to launch the instance."
  type        = string
}

variable "role" {
  description = "Purpose of the instance, used in resource naming. e.g. app, db, bastion."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t3.micro"
}

variable "subnet_id" {
  description = "Subnet ID where the instance will be launched."
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs attached to the instance."
  type        = list(string)
}

variable "key_name" {
  description = "Optional EC2 key pair name for SSH access."
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script rendered by the root module."
  type        = string
  default     = null
}

variable "root_volume_size" {
  description = "Root EBS volume size in GiB."
  type        = number
  default     = 20
}

variable "enable_ssm" {
  description = "Attach AmazonSSMManagedInstanceCore policy to allow SSM access."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}