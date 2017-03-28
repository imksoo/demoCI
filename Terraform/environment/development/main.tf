terraform {
  backend "s3" {
    profile    = "piano-proxy-dev01"
    bucket     = "piano-proxy-dev01-tfstate"
    key        = "terraform.tfstate"
    region     = "us-west-2"
    lock       = "true"
    lock_table = "TerraformStateLockTable"
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "piano-proxy-dev01"
}

module "vpc_subnet" {
  source = "../../modules/vpc-subnet"

  vpc_name                 = "piano-proxy-dev01"
  vpc_cidr                 = "10.123.0.0/16"
  vpc_subnet_cidr_list     = ["10.123.1.0/24", "10.123.2.0/24", "10.123.3.0/24"]
  availability_zone_list   = ["us-west-2a", "us-west-2b", "us-west-2c"]
  vpc_private_network_cidr = "10.0.0.0/8"
}
