variable "vpc_name" {
  default = "testvpc"
}

variable "vpc_cidr" {
  default = "10.123.0.0/16"
}

variable "vpc_subnet_cidr_list" {
  default = ["10.123.1.0/24", "10.123.2.0/24", "10.123.99.0/24"]
}

variable "vpc_az_list" {
  default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "assign_public_ip" {
  default = "true"
}

variable "create_internet_gateway" {
  default = "true"
}

variable "create_vpc_s3_endpoint" {
  default = "true"
}

variable "create_vpn_gateway" {
  default = "true"
}

variable "vpc_flow_log_retention_days" {
  default = "7"
}
