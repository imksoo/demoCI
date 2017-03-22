resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_support = "true"
    enable_dns_hostnames = "true"
    instance_tenancy = "default"
    tags {
        Name = "VPC-${var.vpc_name}"
    }
}

resource "aws_default_network_acl" "network_acl" {
    default_network_acl_id = "${aws_vpc.vpc.default_network_acl_id}"
    ingress {
        rule_no = 100
        protocol = -1
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    egress {
        rule_no = 100
        protocol = -1
        action = "allow"
        cidr_block = "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    tags {
        Name = "ACL-${var.vpc_name}"
    }
}

resource "aws_subnet" "subnet" {
    vpc_id = "${aws_vpc.vpc.id}"
    cidr_block = "${var.vpc_cidr[count.index]}"
    availability_zone = "${var.vpc_az_list[count.index]}"
    count = "${length(var.vpc_subnet_cidr_list)}"
    map_public_ip_on_launch = "${var.assign_public_ip}"
    assign_ipv6_address_on_creation = "${var.assign_public_ipv6}"
    tags {
        Name = "Subnet-${var.name}-${var.vpc_az_list[count.index]}"
    }
}