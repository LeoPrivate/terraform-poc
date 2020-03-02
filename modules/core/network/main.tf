module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-poc-iac"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  
  # Should not be concatenate, should be separate like this:
  # private_subnets = var.private_subnets
  # public_subnets  = var.public_subnets

  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  tags = {
    environement = var.env
  }
}