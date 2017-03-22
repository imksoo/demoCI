variable "vpc_name" {
    default = "testvpc"
}
variable "vpc_cidr" {
    default = "10.0.0.0/8"
}
variable "vpc_subnet_cidr_list" {
    default = ["10.1.0.0/16","10.2.0.0/16","10.3.0.0/16"]
}
variable "vpc_az_list" {
    default = ["us-west-2a", "us-west-2b", "us-west-2c"]
}
variable "assign_public_ip" {
    default = "true"
}
variable "assign_public_ipv6" {
    default = "false"
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