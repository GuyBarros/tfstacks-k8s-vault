variable "cluster_name" {
  type = string
}

variable "region" {
  type = string
  default = "eu-west-1"
}

variable "role_arn" {
  type = string
}

variable "identity_token" {
  type      = string
  ephemeral = true
}
variable "cidr_block" {
  type      = string
}
variable "default_tags" {
  description = "A map of default tags to apply to all AWS resources"
  type        = map(string)
  default     = {}
}

variable "deploy_vault" {
  type = string
  default = "false"
  
}
variable "public_subnets" {
  type = list(string)  
  
}
variable "private_subnets" {
  type = list(string)
  
}