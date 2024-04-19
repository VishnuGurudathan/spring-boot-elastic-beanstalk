variable "tags" {
  description = "A mapping of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC id where the load balancer and other resources will be deployed."
  type        = string
}

variable "ingress" {
  description = "Ingress values to assign to the resources."
  type        = any
  default     = []
}

variable "egress" {
  description = "Egress values to assign to the resources."
  type        = any
  default     = []
}

variable "create" {
  description = "Controls if security group should be created"
  type        = bool
  default     = true
}