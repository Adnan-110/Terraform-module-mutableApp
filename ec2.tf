
# Request a spot instance at $0.03
resource "aws_spot_instance_request" "spot" {
  count                     = var.SPOT_INSTANCE_COUNT
  ami                       = data.aws_ami.image.id
  spot_price                = "0.03"
  instance_type             = var.SPOT_INSTANCE
  vpc_security_group_ids    = [aws_security_group.allows_app.id]
  wait_for_fulfillment      = true
  subnet_id                 = var.INTERNAL ? element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS, count.index) : element(data.terraform_remote_state.vpc.outputs.PUBLIC_SUBNET_IDS, count.index)
  iam_instance_profile      = "B56-Admin"

   tags = {
    Name                        = "${var.COMPONENT}-${var.ENV}"
  }
}

# Creates On-Demand Instance 
resource "aws_instance" "od" {
  count                     = var.OD_INSTANCE_COUNT
  ami                       = data.aws_ami.image.id
  instance_type             = var.OD_INSTANCE
  subnet_id                 =  var.INTERNAL ? element(data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS, count.index) : element(data.terraform_remote_state.vpc.outputs.PUBLIC_SUBNET_IDS, count.index)
  vpc_security_group_ids    = [aws_security_group.allows_app.id]
  iam_instance_profile      = "B56-Admin"

   tags = {
    Name                        = "${var.COMPONENT}-${var.ENV}"
  }
}

#Creates EC2 Tags 
resource "aws_ec2_tag" "app_tags" {
  count         = local.TOTAL_INSTANCE_COUNT
  resource_id   = element(local.INSTANCE_IDS, count.index)
  key           = "Name"
  value         = "${var.COMPONENT}-${var.ENV}"
}