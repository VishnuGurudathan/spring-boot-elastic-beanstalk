locals {
  len_public_subnets = max(length(var.public_subnets), length(var.public_subnet_ipv6_prefixes))
  # len_private_subnets     = max(length(var.private_subnets), length(var.private_subnet_ipv6_prefixes))

  create_vpc              = var.create_vpc
  create_public_subnets   = true
  subnet_bits             = cidrsubnet(var.cidr, 0, 0) # Change the second argument based on your requirement
  public_route_cidr_block = "0.0.0.0/0"
  resource_name_prefix    = replace(lower("${var.tags["Project"]}-${var.tags["Environment"]}"), " ", "-")
}