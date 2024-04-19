output "elastic_beanstalk_application_name" {
  value       = try(module.elastic_beanstalk_application.elastic_beanstalk_application_name, null)
  description = "Elastic Beanstalk Application name"
}

output "elastic_beanstalk_application_arn" {
  value       = try(module.elastic_beanstalk_application.elastic_beanstalk_application_arn, null)
  description = "Elastic Beanstalk Application Arn"
}

output "elastic_beanstalk_environment_name" {
  value       = try(module.elastic_beanstalk_environment.elastic_beanstalk_environment_name, null)
  description = "Elastic Beanstalk Environment name"
}

output "elastic_beanstalk_environmnet_arn" {
  value       = try(module.elastic_beanstalk_environment.elastic_beanstalk_environmnet_arn, null)
  description = "Elastic Beanstalk Application Arn"
}

output "elastic_beanstalk_environmnet_cname" {
  value       = try(module.elastic_beanstalk_environment.elastic_beanstalk_environmnet_cname, null)
  description = "Elastic Beanstalk Application Arn"
}