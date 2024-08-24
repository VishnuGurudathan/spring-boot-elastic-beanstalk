##################################################
## VPC config
##################################################
# module "network" {
# source = "./modules/aws/network/vpc"

#   cidr = var.cidr
#   public_subnet_tags = {
#   }

#   private_subnet_tags = {}

#   tags = merge(
#     var.tags,
#     {
#       Description = "Managed by Terraform for ${var.tags["Project"]} in ${var.tags["Environment"]} environment."
#     }
#   )
# }
##################################################
## Subnet config
##################################################

################################################################################
# SSH Key pair
################################################################################
# module "sshkey" {
#   source      = "./modules/aws/sshkey"
#   ec2_ssh_key = var.ec2_ssh_key_path

#   tags = merge(
#     var.tags,
#     {
#       Description = "Managed by Terraform for ${var.tags["Project"]} in ${var.tags["Environment"]} environment."
#     }
#   )
# }
##################################################
## Elastic Beanstalk config
##################################################
module "elastic_beanstalk_application" {
  source  = "./modules/aws/elastic-beanstalk"
  enabled = true
  description = "Test Elastic Beanstalk application"
}
module "elastic_beanstalk_environment" {
  source = "./modules/aws/elastic-beanstalk/environment"
  description                = var.description_env
  vpc_id              = "vpc-0a21554b9a980d04c"
  enabled = true
  cname_prefix = var.cname_prefix
  tier = var.tier
  public_subnets     = ["subnet-0cf096faf533ffe8f", "subnet-09daf4c268ae3e6f1", "subnet-0dfc3cbea6f2dd9dd"] # Service Subnet
  elb_subnets = ["subnet-0cf096faf533ffe8f", "subnet-09daf4c268ae3e6f1", "subnet-0dfc3cbea6f2dd9dd"]
  solution_stack_name= var.solution_stack_name
  elastic_beanstalk_application_name = module.elastic_beanstalk_application.elastic_beanstalk_application_name
  security_groups = var.security_groups
  ssh_key_name = var.ssh_key_name
  associate_public_ip_address = var.associate_public_ip_address
  env_vars = var.env_vars

}
