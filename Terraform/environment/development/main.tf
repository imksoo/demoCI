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
}

/*
resource "aws_key_pair" "keypair" {
  key_name   = "KEY-piano-proxy-dev01"
  public_key = "${file("key-pair.pem.pub")}"
}
*/

