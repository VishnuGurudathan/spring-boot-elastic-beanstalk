################################################################################
# General
################################################################################
variable "aws_region" {
  description = "AWS region where resources will be created."
}

variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "description" {
  type        = string
  default     = ""
  description = "Elastic Beanstalk Application description"
}

variable "enabled" {
  type        = bool
  default     = null
  description = "Set to false to prevent the module from creating any resources"
}

variable "environment" {
  type        = string
  default     = null
  description = "ID element. Usually used for region e.g. 'uw2', 'us-west-2', OR role 'prod', 'staging', 'dev', 'UAT'"
}

variable "stage" {
  type        = string
  default     = null
  description = "ID element. Usually used to indicate role, e.g. 'prod', 'staging', 'source', 'build', 'test', 'deploy', 'release'"
}

variable "tier" {
  type        = string
  default     = "WebServer"
  description = "Elastic Beanstalk Environment tier, 'WebServer' or 'Worker'"
}
variable "ssh_key_name" {
  type    = string
  default = null
  description = "The EC2 SSH KeyPair Name"
}

variable "associate_public_ip_address" {
  type = bool
  default = false
  description = "Whether to associate public IP addresses to the instances (true | false)"
}

variable "env_vars" {
  type        = map(string)
  default     = {}
  description = "Map of custom ENV variables to be provided to the application running on Elastic Beanstalk, e.g. env_vars = { DB_USER = 'admin' DB_PASS = 'xxxxxx' }"
}
variable "security_groups" {
  type    = string
  default = "elasticbeanstalk-default"
  description = "Lists the Amazon EC2 security groups to assign to the EC2 instances in the Auto Scaling group in order to define firewall rules for the instances."
}
#--------
variable "availability_zones" {
  type        = list(string)
  default = [ "" ]
  description = "List of availability zones"
}

variable "description_env" {
  type        = string
  description = "Short description of the Environment"
}

variable "environment_type" {
  type        = string
  description = "Environment type, e.g. 'LoadBalanced' or 'SingleInstance'.  If setting to 'SingleInstance', `rolling_update_type` must be set to 'Time', `updating_min_in_service` must be set to 0, and `loadbalancer_subnets` will be unused (it applies to the ELB, which does not exist in SingleInstance environments)"
}

variable "loadbalancer_type" {
  type        = string
  description = "Load Balancer type, e.g. 'application' or 'classic'"
}

variable "cname_prefix" {
  type        = string
  description = "cname prefix"
}

variable "solution_stack_name" {
  type        = string
  description = "Elastic Beanstalk stack, e.g. Docker, Go, Node, Java, IIS. For more info, see https://docs.aws.amazon.com/elasticbeanstalk/latest/platforms/platforms-supported.html"
}