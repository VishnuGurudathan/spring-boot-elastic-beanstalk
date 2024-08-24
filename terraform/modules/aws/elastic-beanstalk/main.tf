locals {
  # Remove `Name` tag from the map of tags because Elastic Beanstalk generates the `Name` tag automatically
  # and if it is provided, terraform tries to recreate the application on each `plan/apply`
  # `Namespace` should be removed as well since any string that contains `Name` forces recreation
  # https://github.com/terraform-providers/terraform-provider-aws/issues/3963
  tags                                  = { for t in keys(var.tags) : t => var.tags[t] if t != "Name" && t != "Namespace" }
  enabled                               = var.enabled
  }

resource "aws_elastic_beanstalk_application" "default" {
  count       = local.enabled ? 1 : 0
  # need to check
  name        = "testing"
  description = var.description
  tags        = local.tags
}