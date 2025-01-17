identity_token "aws" {
  audience = ["aws.workload.identity"]
}

deployment "development" {
  inputs = {
    cidr_block          = "10.0.0.0/16"
    cluster_name        = "eks-dev"
    region         = "eu-west-2"
    role_arn       = "arn:aws:iam::958215610051:role/tfc-wif-guybarros"
    identity_token      = identity_token.aws.jwt
    default_tags        = { environment = "development" }
    deploy_vault        = "false"
    private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
    public_subnets  = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  }
}

deployment "production" {
  inputs = {
    cidr_block          = "10.1.0.0/16"
    cluster_name        = "eks-prod"
    region         = "eu-west-2"
    role_arn       = "arn:aws:iam::958215610051:role/tfc-wif-guybarros"
    identity_token      = identity_token.aws.jwt
    default_tags        = { environment = "production" }
    deploy_vault        = "true"
    private_subnets     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
    public_subnets      = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
  }
}


orchestrate "auto_approve" "name" {
  check {
        # Check that the pet component has no changes
        condition = context.plan.component_changes["component.eks"].total == 0
        reason = "Not automatically approved because changes proposed to eks component."
    }
}







