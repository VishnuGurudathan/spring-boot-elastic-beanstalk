output "vpc_id" {
  description = "The ID of the VPC"
  value       = try(aws_vpc.this[0].id, null)
}

output "vpc_arn" {
  description = "The ARN of the VPC"
  value       = try(aws_vpc.this[0].arn, null)
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = try(aws_vpc.this[0].cidr_block, null)
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}

output "db_subnet_ids" {
  value = aws_subnet.db_subnets[*].id
}

output "redis_subnet_ids" {
  value = aws_subnet.redis_subnets[*].id
}

output "azs" {
  value       = data.aws_availability_zones.available.names
  description = "List of available availability zones in this region"
}