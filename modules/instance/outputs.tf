output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.this.id
}

output "private_ip" {
  description = "Private IP address."
  value       = aws_instance.this.private_ip
}

output "iam_role_arn" {
  description = "IAM role ARN attached to the instance."
  value       = aws_iam_role.this.arn
}

output "iam_role_name" {
  description = "IAM role name."
  value       = aws_iam_role.this.name
}

output "instance_profile_name" {
  description = "IAM instance profile name."
  value       = aws_iam_instance_profile.this.name
}
