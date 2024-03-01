data "aws_ami" "image" {
  most_recent = true
  name_regex  = "DevOps-LabImage-Centos-8"
  owners      = ["355449129696"] 
}

# Data Source to fetch the information from the VPC Remote Statefile
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "adnan-tf-state-bucket"
    key     = "vpc/${var.ENV}/terraform.tfstate"
    region  = "us-east-1"
  }
}

# Data Source to fetch the information from the ALB Remote Statefile
data "terraform_remote_state" "alb" {
  backend = "s3"
  config = {
    bucket  = "adnan-tf-state-bucket"
    key     = "alb/${var.ENV}/terraform.tfstate"
    region  = "us-east-1"
  }
}

# Extracting the Information of the secret from the AWS Secret Manager
data "aws_secretsmanager_secret" "roboshop_secrets" {
  name = "roboshop/secrets"
}

# Exctracting the Secret Version from the AWS Secret Manager
data "aws_secretsmanager_secret_version" "secret_version" {
  secret_id = data.aws_secretsmanager_secret.roboshop_secrets.id
}

data "terraform_remote_state" "db" {
  backend = "s3"
  config = {
    bucket  = "adnan-tf-state-bucket"
    key     = "databases/${var.ENV}/terraform.tfstate"
    region  = "us-east-1"
     }
}