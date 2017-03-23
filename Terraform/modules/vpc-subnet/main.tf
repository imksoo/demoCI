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

resource "aws_default_security_group" "vpc_default_sg" {
  vpc_id = "${aws_vpc.vpc.id}"

  # Inbound Rules (AWS Default Policy)
  ingress {
    protocol  = -1
    self      = "true"
    from_port = 0
    to_port   = 0
  }

  # Outbound Rules (AWS Default Policy)
  egress {
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }
}

resource "aws_security_group" "sg_linux_default" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "sg-linux-default"
  description = "sg-linux-default"

  tag {
    Name = "sg-linux-default"
  }

  # Inbound ICMP (ping, traceroute, etc / only private networks)
  ingress {
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 0
    to_port     = 0
  }

  # Inbound SSH
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", "0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  # Outbound ICMP (ping, traceroute, etc)
  egress {
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  # Outbound SSH
  egress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
  }

  # Outbound DNS (udp)
  egress {
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 53
    to_port     = 53
  }

  # Outbound DNS (tcp)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 53
    to_port     = 53
  }

  # Outbound NTP
  egress {
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 123
    to_port     = 123
  }

  # Outbound HTTP
  egress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
  }

  # Outbound HTTPS
  egress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
  }
}

resource "aws_security_group" "sg_windows_default" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "sg-windows-default"
  description = "sg-windows-default"

  tag {
    Name = "sg-windows-default"
  }

  # Inbound ICMP (ping, traceroute, etc / only private networks)
  ingress {
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 0
    to_port     = 0
  }

  # Inbound WinRM (5985=Over HTTP, 5986=Over HTTPS / only private networks)
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 5985
    to_port     = 5986
  }

  # Inbound RDP
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16", "0.0.0.0/0"]
    from_port   = 3389
    to_port     = 3389
  }

  # Outbound ICMP (ping, traceroute, etc)
  egress {
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
  }

  # Outbound Ports
  # Active Directory and Active Directory Domain Services Port Requirements
  # ref: https://technet.microsoft.com/en-us/library/8daead2d-35c1-4b58-b123-d32a26b1f1dd

  # Outbound DNS (udp)
  egress {
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 53
    to_port     = 53
  }
  # Outbound DNS (tcp)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 53
    to_port     = 53
  }
  # Outbound NTP
  egress {
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 123
    to_port     = 123
  }
  # Outbound HTTP
  egress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
  }
  # Outbound HTTPS
  egress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
  }
  # Outbound HTTPS
  egress {
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 443
    to_port     = 443
  }
  # Outbound LDAP (tcp)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 389
    to_port     = 389
  }
  # Outbound LDAP (udp)
  egress {
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 389
    to_port     = 389
  }
  # Outbound LDAP SSL
  egress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 636
    to_port     = 636
  }
  # Outbound LDAP GC / LDAP GC SSL
  egress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 3268
    to_port     = 3269
  }
  # Outbound Kerberos (tcp)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 88
    to_port     = 88
  }
  # Outbound Kerberos (udp)
  egress {
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 88
    to_port     = 88
  }
  # Outbound SMB,CIFS,DFSN,LSARPC,NbtSS,NetLogonR,SamR,SrvSvc (tcp)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 445
    to_port     = 445
  }
  # Outbound SMB,CIFS,DFSN,LSARPC,NbtSS,NetLogonR,SamR,SrvSvc (udp)
  egress {
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 445
    to_port     = 445
  }
  # Outbound SMTP(Replication)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 25
    to_port     = 25
  }
  # Outbound TCP dynamic ports (1024-65535)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 1024
    to_port     = 65535
  }
  # Outbound Kerberos change/set password (tcp)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 464
    to_port     = 464
  }
  # Outbound Kerberos change/set password (udp)
  egress {
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 464
    to_port     = 464
  }
  # Outbound UDP dynamic ports (1024-65535)
  egress {
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 1024
    to_port     = 65535
  }
  # Outbound DFS, Group Policy
  egress {
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 138
    to_port     = 138
  }
  # Outbound SOAP
  egress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 9389
    to_port     = 9389
  }
  # Outbound NetLogon,NetBIOS,Name Resolution
  egress {
    protocol    = "udp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 137
    to_port     = 137
  }
  # Outbound DFSN,NetBIOS Session Service,NetLogon
  egress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
    from_port   = 139
    to_port     = 139
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
  vpc_id           = "${aws_vpc.vpc.id}"
  propagating_vgws = ["${aws_vpn_gateway.vpn-gw.id}"]

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
