resource "aws_security_group" "this" {
  count       = var.create ? 1 : 0
  name        = ""
  description = var.tags["Environment"]
  vpc_id      = var.vpc_id

  ingress = [for i in var.ingress : merge({
    description      = try(i.description, null)
    ipv6_cidr_blocks = try(i.ipv6_cidr_blocks, null)
    prefix_list_ids  = try(i.prefix_list_ids, [])
    security_groups  = try(i.security_groups, [])
    self             = try(i.self, false)
  }, i)]

  egress = [for e in var.egress : merge({
    description      = try(e.description, null)
    ipv6_cidr_blocks = try(e.ipv6_cidr_blocks, null)
    prefix_list_ids  = try(e.prefix_list_ids, [])
    security_groups  = try(e.security_groups, [])
    self             = try(e.self, false)
  }, e)]

  tags = var.tags
}