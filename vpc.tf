module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

# VPC name/ IP
  name = "ALBvpc"
  cidr = "10.0.0.0/16"

# AZ- Subnets
  azs             = ["us-east-1a","us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

#Gateways

  enable_nat_gateway = true
  enable_vpn_gateway = false
  single_nat_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}