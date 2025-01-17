# tfstacks-k8s-vault

This repository contains Terraform configurations for deploying a Kubernetes cluster on AWS. All of that in Terraform Stacks. The project leverages Terraform stacks to manage and provision the necessary AWS infrastructure and Kubernetes resources efficiently.

## Overview

The goal of this project is to show how can Terraform Stacks allows you to generate different deployments with different configurations. In this example, we are going to create an eks cluster with a PostgresSQL Database. In the Dev enviroment the access to the database is straight forward but for our production environment we want to use Vault to protect our credentials during the process.

![Diagram](images/tfstacks-diagram.png)

- VPC, subnets, and networking configurations
- EKS (Elastic Kubernetes Service) cluster
- Security groups and IAM roles
- Kubernetes services and deployments

By using Terraform stacks, the project ensures modularity, reusability, and ease of management for the infrastructure components.

## Prerequisites

- AWS account with necessary permissions
- HCP Terraform account 
- kubectl installed

## Usage

#### 1. Using template in GitHub, create a new repository:

![Diagram](images/create-template.png)

#### 2. You need to configure the deployment variables:
    cidr_block          = "10.1.0.0/16"
    cluster_name        = "eks-prod"
    region              = "eu-west-1"
    role_arn            = "ARN role "
    identity_token      = identity_token.aws.jwt
    default_tags        = { environment = "production" }
    deploy_vault        = "true" #By default is set to 'false'
    private_subnets     = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
    public_subnets      = ["10.1.4.0/24", "10.1.5.0/24", "10.1.6.0/24"]
For the role ARN, you need to follow this steps: [Create role ARN for deployments](https://github.com/hashicorp-education/learn-terraform-stacks-identity-tokens/tree/main/aws)

#### 3. Now we are going to create our Terraform Stack, so we will create a project in HCP:
   
Once on our [HCP Terraform](https://app.terraform.io/) dashboard, go to create project:

![create-project](images/create-project-0.png)

Then follow the steps and add the name and description you want for that project:

![create-project](images/create-project.png)

After that, you are ready to create a Terraform Stack inside your new project!

#### 4. Now we are going to create our Stack. For this part we will use the repository we cloned previously:

![create-project](images/create-project2.png)

On the next view, we will need to add our VCS Account:

![create-project](images/new-stack.png)

Then our repository where we have the files for the Stack:

![create-project](images/new-stack2.png)

And finally, we clic on "Create Stack":
    
![create-project](images/new-stack3.png)

#### 5. Once clicked, it will start running our first deployment:
    
![create-project2](images/first-deploy.png)


#### 6. The apply process takes several minutes(~ 20 mins aprox.) due to the creation of EKS clusters but once is ready we can check that the eks-dev doesn't have Vault deployed but the eks-prod has Vault installed and configured.

![create-project2](images/once-deployed.png)



#### 7. Look at the Development deployment: 

![create-project2](images/stack-dev-vault.png)

#### 8. And now the Production deployment:

![create-project2](images/stack-prod-vault.png)

#### 9. In the outputs of the production deployment we can see the Vault service URL hosted in the EKS:

![create-project2](images/vault-url.png)

#### 10. Go to that URL, login using the password configured in the helm component. Currently set as "root". Then go to database engines and generate new credentials for our postgresql:

![create-project2](images/login-vault.png)

Once logged in, go secrets engines and select Mydb > Roles > Admin-Role > Generate Credentials:

![create-project2](images/generated-credentials.png)


#### 11. Log into postgreSQL using credentials generated by Vault:

Remember we get the postgreSQL from the output of the deployment, same as Vault.

    psql postgres://USER:PASSWORD@HOST_URL:5432/DATABASE

In our case, with the data retrieved is:

    psql postgres://v-token-admin-ro-fBMPmoy54zwaXKsRMEic-1737039292:w819mG-hQ5krCfTqc7c2@a772c8ebcb5e645e5849595febd75cf0-1713333522.eu-west-1.elb.amazonaws.com:5432/mydb

#### 12. If we exec that command, we will log into our postgreSQL:

![create-project2](images/postgreSQL-cli.png)
