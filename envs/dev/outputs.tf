# -------------------------
# Network outputs
# -------------------------
output "vpc_id" {
  description = "VPC ID."
  value       = module.network.vpc_id
}

output "vpc_cidr" {
  description = "VPC CIDR block."
  value       = module.network.vpc_cidr
}

output "public_subnet_id" {
  description = "Public subnet ID."
  value       = module.network.public_subnet_id
}

output "private_app_subnet_id" {
  description = "Private app subnet ID."
  value       = module.network.private_app_subnet_id
}

output "private_db_subnet_id" {
  description = "Private DB subnet ID."
  value       = module.network.private_db_subnet_id
}

output "app_security_group_id" {
  description = "App security group ID."
  value       = module.network.app_security_group_id
}

output "db_security_group_id" {
  description = "DB security group ID."
  value       = module.network.db_security_group_id
}

output "nat_gateway_id" {
  description = "NAT Gateway ID, if created."
  value       = module.network.nat_gateway_id
}

# -------------------------
# App instance outputs
# -------------------------
output "app_instance_id" {
  description = "App EC2 instance ID."
  value       = module.app_instance.instance_id
}

output "app_instance_private_ip" {
  description = "App EC2 private IP address."
  value       = module.app_instance.private_ip
}

output "app_iam_role_arn" {
  description = "IAM role ARN attached to the app instance."
  value       = module.app_instance.iam_role_arn
}