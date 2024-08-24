locals {
    enabled                               = var.enabled
    tags = { for t in keys(var.tags) : t => var.tags[t] if t != "Name" && t != "Namespace" }
    s3_bucket_access_log_name = var.s3_bucket_access_log_bucket_name != "" ? var.s3_bucket_access_log_bucket_name : "${aws_elastic_beanstalk_environment.this[0].name}-alb-logs-${random_string.elb_logs_suffix.result}"


  }

resource "random_string" "elb_logs_suffix" {
  length  = 5
  special = false
  upper   = false
}

##################################################
## Elastic Beanstalk
##################################################
resource "aws_elastic_beanstalk_environment" "this" {

  count = local.enabled ? 1 : 0

  application = var.elastic_beanstalk_application_name
  name                   = "${var.elastic_beanstalk_application_name}-${var.environment}" 
  description            = var.description
  tier                   = var.tier
  solution_stack_name    = var.solution_stack_name
  wait_for_ready_timeout = var.wait_for_ready_timeout
  version_label          = var.version_label
  tags                   = local.tags
  cname_prefix           = var.cname_prefix


#
  setting {
    namespace = "aws:ec2:instances"
    name      = "SupportedArchitectures"
    value     = "x86_64"
  }
  # Configure your environment's architecture and service role.
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "${var.environment_type}"
  }

  # Configure your environment to launch resources in a custom VPC
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.vpc_id}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = join(",", sort(var.public_subnets))
    resource  = ""
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = join(",", var.elb_subnets)
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "AssociatePublicIpAddress"
    value     = var.associate_public_ip_address
  }

  # Configure your environment's EC2 instances.
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "${var.instance_type}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeType"
    value     = "${var.instance_volume_type}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "RootVolumeSize"
    value     = "${var.instance_volume_size}"
  }
  # setting {
  #   namespace = "aws:autoscaling:launchconfiguration"
  #   name      = "RootVolumeIOPS"
  #   value     = "${var.instance_volume_iops}"
  # }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "${var.ssh_key_name}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = "${var.security_groups}"
  }
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    #   value     = join("", aws_iam_instance_profile.ec2[*].name)
    value     =  "aws-elasticbeanstalk-ec2-role"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    #value     = join("", aws_iam_role.service[*].name)
    #value     = "${aws_iam_role.beanstalk_service.name}"
    value     = "aws-elasticbeanstalk-service-role"
  }

 # Configure your environment's Auto Scaling group.
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "${var.autoscale_min}"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "${var.autoscale_max}"
  }

  # setting {
  #   namespace = "aws:autoscaling:asg"
  #   name      = "EnableCapacityRebalancing"
  #   value     = var.enable_capacity_rebalancing
  #   resource  = ""
  # }

  #----
  # Configure scaling triggers for your environment's Auto Scaling group.
  setting {
    namespace = "${var.environment_type == "LoadBalanced" ? "aws:autoscaling:trigger" : "aws:elasticbeanstalk:environment"}"
    name      = "${var.environment_type == "LoadBalanced" ? "BreachDuration" : "EnvironmentType"}"
    value     = "${var.environment_type == "LoadBalanced" ? var.autoscale_breach_duration : var.environment_type}"
  }
  setting {
    namespace = "${var.environment_type == "LoadBalanced" ? "aws:autoscaling:trigger" : "aws:elasticbeanstalk:environment"}"
    name      = "${var.environment_type == "LoadBalanced" ? "LowerBreachScaleIncrement" : "EnvironmentType"}"
    value     = "${var.environment_type == "LoadBalanced" ? var.autoscale_lower_increment : var.environment_type}"
  }
  setting {
    namespace = "${var.environment_type == "LoadBalanced" ? "aws:autoscaling:trigger" : "aws:elasticbeanstalk:environment"}"
    name      = "${var.environment_type == "LoadBalanced" ? "LowerThreshold" : "EnvironmentType"}"
    value     = "${var.environment_type == "LoadBalanced" ? var.autoscale_lower_bound : var.environment_type}"
  }
  setting {
    namespace = "${var.environment_type == "LoadBalanced" ? "aws:autoscaling:trigger" : "aws:elasticbeanstalk:environment"}"
    name      = "${var.environment_type == "LoadBalanced" ? "MeasureName" : "EnvironmentType"}"
    value     = "${var.environment_type == "LoadBalanced" ? var.autoscale_measure_name : var.environment_type}"
  }
  setting {
    namespace = "${var.environment_type == "LoadBalanced" ? "aws:autoscaling:trigger" : "aws:elasticbeanstalk:environment"}"
    name      = "${var.environment_type == "LoadBalanced" ? "Period" : "EnvironmentType"}"
    value     = "${var.environment_type == "LoadBalanced" ? var.autoscale_period : var.environment_type}"
  }
  setting {
    namespace = "${var.environment_type == "LoadBalanced" ? "aws:autoscaling:trigger" : "aws:elasticbeanstalk:environment"}"
    name      = "${var.environment_type == "LoadBalanced" ? "Statistic" : "EnvironmentType"}"
    value     = "${var.environment_type == "LoadBalanced" ? var.autoscale_statistic : var.environment_type}"
  }
  setting {
    namespace = "${var.environment_type == "LoadBalanced" ? "aws:autoscaling:trigger" : "aws:elasticbeanstalk:environment"}"
    name      = "${var.environment_type == "LoadBalanced" ? "Unit" : "EnvironmentType"}"
    value     = "${var.environment_type == "LoadBalanced" ? var.autoscale_unit : var.environment_type}"
  }
  setting {
    namespace = "${var.environment_type == "LoadBalanced" ? "aws:autoscaling:trigger" : "aws:elasticbeanstalk:environment"}"
    name      = "${var.environment_type == "LoadBalanced" ? "UpperBreachScaleIncrement" : "EnvironmentType"}"
    value     = "${var.environment_type == "LoadBalanced" ? var.autoscale_upper_increment : var.environment_type}"
  }
  setting {
    namespace = "${var.environment_type == "LoadBalanced" ? "aws:autoscaling:trigger" : "aws:elasticbeanstalk:environment"}"
    name      = "${var.environment_type == "LoadBalanced" ? "UpperThreshold" : "EnvironmentType"}"
    value     = "${var.environment_type == "LoadBalanced" ? var.autoscale_upper_bound : var.environment_type}"
  }

  # Configure rolling deployments for your application code.
    setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = "${var.deployment_policy}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "IgnoreHealthCheck"
    value     = "${var.ignore_healthcheck}"
  }
  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = "${var.healthreporting}"
  }

#----
# Loadbalancer configuration
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     =  var.loadbalancer_type
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBScheme"
    value     = var.elb_scheme
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "StickinessEnabled"
    value     = var.elb_stickiness_enabled
  }
  #-- need to check if it will work without this
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "StickinessType"
    value     = var.elb_stickiness_type
  }
   setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "StickinessLBCookieDuration"
    value     = var.elb_stickiness_cookie_duration
  }

  #---
 # Configure Environment Varibles
 # need to check if any oe of this is enough
  # setting {
  #   namespace = "aws:cloudformation:template:parameter"
  #   name = "EnvironmentVariables"
  #   value = "SERVER_PORT=5000,M2=/usr/local/apache-maven/bin,M2_HOME=/usr/local/apache-maven,GRADLE_HOME=/usr/local/gradle"
  # }
  # setting {
  #   namespace = "aws:elasticbeanstalk:application:environment"
  #   name = "M2_HOME"
  #   value = "/usr/local/apache-maven"
  # }
  # setting {
  #   namespace = "aws:elasticbeanstalk:application:environment"
  #   name = "M2"
  #   value = "/usr/local/apache-maven/bin"
  # }
  # setting {
  #   namespace = "aws:elasticbeanstalk:application:environment"
  #   name = "SERVER_PORT"
  #   value = "5000"
  # }
  # setting {
  #   namespace = "aws:elasticbeanstalk:application:environment"
  #   name = "RDS_USERNAME"
  #   value = "admin"
  # }
  # setting {
  #   namespace = "aws:elasticbeanstalk:application:environment"
  #   name = "RDS_PASSWORD"
  #   value = "yHwno$26nKrJ!Nn%D3"
  # }
  # Add environment variables if provided
  dynamic "setting" {
    for_each = var.env_vars
    content {
      namespace = "aws:elasticbeanstalk:application:environment"
      name      = setting.key
      value     = setting.value
      resource  = ""
    }
  }
# Configure S3 Log [enable only if needed and should give a s3 bucket name; possibly add condetion]
  # setting {
  #   namespace = "aws:elbv2:loadbalancer"
  #   name = "AccessLogsS3Enabled"
  #   value = "false"
  # }
  # setting {
  #   namespace = "aws:elbv2:loadbalancer"
  #   name = "AccessLogsS3Bucket"
  #   value = ""
  # }
  # setting {
  #   namespace = "aws:elbv2:loadbalancer"
  #   name = "AccessLogsS3Prefix"
  #   value = ""
  # }

  setting {
    namespace = "aws:elasticbeanstalk:healthreporting:system"
    name      = "SystemType"
    value     = var.enhanced_reporting_enabled ? "enhanced" : "basic"
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = var.availability_zone_selector
    resource  = ""
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateEnabled"
    value     = var.rolling_update_enabled
    
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "RollingUpdateType"
    value     = var.rolling_update_type
    
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MinInstancesInService"
    value     = var.updating_min_in_service
    
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "DeploymentPolicy"
    value     = var.deployment_policy
    
  }

  setting {
    namespace = "aws:autoscaling:updatepolicy:rollingupdate"
    name      = "MaxBatchSize"
    value     = var.updating_max_batch
    
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSizeType"
    value     = "Percentage"
    
  }

  setting {
    namespace = "aws:elasticbeanstalk:command"
    name      = "BatchSize"
    value     = 30
    
  }
}