terraform {
  backend "s3" {
    bucket = "piano-proxy-dev01-tfstate"
    key    = ""
    region = "us-west-2"
    lock_table = "TerraformStateLockTable"
  }
}