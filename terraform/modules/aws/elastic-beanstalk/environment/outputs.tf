output "elastic_beanstalk_environment_name" {
  value       = try(aws_elastic_beanstalk_environment.this[0].name, null)
  description = "Elastic Beanstalk Application name"
}

output "elastic_beanstalk_environmnet_arn" {
  value       = try(aws_elastic_beanstalk_environment.this[0].arn, null)
  description = "Elastic Beanstalk Application Arn"
}

output "elastic_beanstalk_environmnet_cname" {
  value       = try(aws_elastic_beanstalk_environment.this[0].cname, null)
  description = "Elastic Beanstalk Application Arn"
}