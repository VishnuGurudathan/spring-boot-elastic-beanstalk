locals {
  resource_name_prefix = replace(lower("${var.tags["Project"]}-${var.tags["Environment"]}"), " ", "-")
}

################################################################################
# Key Pair
################################################################################

resource "aws_key_pair" "this" {
  key_name   = format("%s-%s", local.resource_name_prefix, "sshkey")
  public_key = file(var.ec2_ssh_key)
  tags       = var.tags
}