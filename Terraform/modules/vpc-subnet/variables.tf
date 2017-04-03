variable "vpc_name" {}

variable "vpc_cidr" {}

variable "vpc_subnet_cidr_list" {
  type = "list"
}

variable "availability_zone_list" {
  type = "list"
}

variable "vpc_global_network_cidr" {
  default = "0.0.0.0/0"
}

variable "vpc_private_network_cidr" {}

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
