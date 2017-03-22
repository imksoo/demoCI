resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr}"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"

  tags {
    Name = "VPC-${var.vpc_name}"
  }
}

resource "aws_network_acl" "acl" {
  vpc_id = "${aws_vpc.vpc.id}"

  ingress {
    rule_no    = 100
    protocol   = -1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 100
    protocol   = -1
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags {
    Name = "ACL-${var.vpc_name}"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                          = "${aws_vpc.vpc.id}"
  count                           = "${length(var.vpc_subnet_cidr_list)}"
  availability_zone               = "${var.vpc_az_list[count.index]}"
  cidr_block                      = "${var.vpc_subnet_cidr_list[count.index]}"
  map_public_ip_on_launch         = "${var.assign_public_ip}"
  assign_ipv6_address_on_creation = false

  tags {
    Name = "SUBNET-${var.vpc_name}-${var.vpc_subnet_cidr_list[count.index]}"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = "${aws_vpc.vpc.id}"

  tags {
    Name = "RT-${var.vpc_name}"
  }
}

resource "aws_route_table_association" "rt_assoc" {
  count          = "${length(var.vpc_subnet_cidr_list)}"
  route_table_id = "${aws_route_table.rt.id}"
  subnet_id      = "${element(aws_subnet.subnet.*.id, count.index)}"
}

resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  count  = "${lookup(map(var.create_internet_gateway, 1), "true", 0)}"

  tags {
    Name = "IGW-${var.vpc_name}"
  }
}

resource "aws_route" "rt-igw" {
  route_table_id         = "${aws_route_table.rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  depends_on             = ["aws_internet_gateway.igw"]
}

data "aws_vpc_endpoint_service" "s3" {
  service = "s3"
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = "${aws_vpc.vpc.id}"
  service_name = "${data.aws_vpc_endpoint_service.s3.service_name}"
}

resource "aws_vpc_endpoint_route_table_association" "s3_endpoint" {
  vpc_endpoint_id = "${aws_vpc_endpoint.s3_endpoint.id}"
  route_table_id  = "${aws_route_table.rt.id}"
}

resource "aws_vpn_gateway" "vpn-gw" {
  vpc_id = "${aws_vpc.vpc.id}"
  count  = "${lookup(map(var.create_vpn_gateway, 1), "true", 0)}"

  tags {
    Name = "VPNGW-${var.vpc_name}"
  }
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_logs_role_policy" {
  role = "${aws_iam_role.vpc_flow_logs_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name              = "VPCFlowLogs-${var.vpc_name}"
  retention_in_days = "${var.vpc_flow_log_retention_days}"
}

resource "aws_flow_log" "vpc_flow_log" {
  vpc_id         = "${aws_vpc.vpc.id}"
  iam_role_arn   = "${aws_iam_role.vpc_flow_logs_role.arn}"
  log_group_name = "${aws_cloudwatch_log_group.vpc_flow_log_group.name}"
  traffic_type   = "ALL"
}
