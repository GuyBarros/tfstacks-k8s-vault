variable "cluster_name" {
    description = "The name of the EKS cluster"
    type        = string
}

variable "cidr_block" {
    description = "The CIDR block for the VPC"
    type        = string
  
}
variable "public_subnets" {
    description = "The public subnets for the VPC"
    type        = list(string)
  
}

variable "private_subnets" {
    description = "The private subnets for the VPC"
    type        = list(string)
  
}