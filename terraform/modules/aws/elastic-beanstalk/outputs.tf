output "elastic_beanstalk_application_name" {
  value       = try(aws_elastic_beanstalk_application.default[0].name, null)
  description = "Elastic Beanstalk Application name"
}

output "elastic_beanstalk_application_arn" {
  value       = try(aws_elastic_beanstalk_application.default[0].arn, null)
  description = "Elastic Beanstalk Application Arn"
}