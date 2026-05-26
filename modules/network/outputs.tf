output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "vpc_cidr" {
  description = "VPC CIDR block."
  value       = aws_vpc.this.cidr_block
}

output "public_subnet_id" {
  description = "Public subnet ID."
  value       = aws_subnet.public.id
}

output "private_app_subnet_id" {
  description = "Private application subnet ID."
  value       = aws_subnet.private_app.id
}

output "private_db_subnet_id" {
  description = "Private database subnet ID."
  value       = aws_subnet.private_db.id
}

output "app_security_group_id" {
  description = "Security group ID for application instances."
  value       = aws_security_group.app.id
}

output "db_security_group_id" {
  description = "Security group ID for database instances."
  value       = aws_security_group.db.id
}

# output "postgres_db_subnet_group_name" {
#   description = "DB subnet group name for DB."
#   value       = aws_db_subnet_group.postgres.name
# }

output "nat_gateway_id" {
  description = "NAT Gateway ID, if created."
  value       = try(aws_nat_gateway.this[0].id, null)
}

output "app_route_table_id" {
  description = "Private app route table ID."
  value       = aws_route_table.private_app.id
}

output "db_route_table_id" {
  description = "Private DB route table ID."
  value       = aws_route_table.private_db.id
}
