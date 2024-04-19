output "security_group_id" {
  description = "The ID of the Security Group"
  value       = try(aws_security_group.this[0].id, null)
}