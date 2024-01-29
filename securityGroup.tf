# Creates Security Group For Backend Components

resource "aws_security_group" "allows_app" {
    name        = "roboshop-${var.COMPONENT}-${var.ENV}-security-group"
    description = "roboshop-${var.COMPONENT}-${var.ENV}-security-group"
    vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID 

    ingress {
        description = "SSH From Default and Roboshop VPC"
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = [data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR, data.terraform_remote_state.vpc.outputs.VPC_CIDR]
    }
    ingress {
        description = "App Only Traffic"
        from_port   = var.APP_PORT
        to_port     = var.APP_PORT
        protocol    = "tcp"
        cidr_blocks = [data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR, data.terraform_remote_state.vpc.outputs.VPC_CIDR]
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "roboshop-${var.COMPONENT}-${var.ENV}-security-group"
    }
}
