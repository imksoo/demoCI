resource "aws_security_group" "sg_linux_default" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "linux-default"
  description = "linux-default"

  tags {
    Name = "linux-default"
  }

  # Inbound ICMP (ping, traceroute, etc / only private networks)
  ingress {
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = -1
    to_port     = -1
  }

  # Inbound SSH
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_global_network_cidr}", "${var.vpc_private_network_cidr}"]
    from_port   = 22
    to_port     = 22
  }

  # Outbound ICMP (ping, traceroute, etc)
  egress {
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_global_network_cidr}"]
    from_port   = -1
    to_port     = -1
  }

  # Outbound SSH
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_global_network_cidr}"]
    from_port   = 22
    to_port     = 22
  }

  # Outbound DNS (udp)
  egress {
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_global_network_cidr}"]
    from_port   = 53
    to_port     = 53
  }

  # Outbound DNS (tcp)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_global_network_cidr}"]
    from_port   = 53
    to_port     = 53
  }

  # Outbound NTP
  egress {
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_global_network_cidr}"]
    from_port   = 123
    to_port     = 123
  }

  # Outbound HTTP
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_global_network_cidr}"]
    from_port   = 80
    to_port     = 80
  }

  # Outbound HTTPS
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_global_network_cidr}"]
    from_port   = 443
    to_port     = 443
  }
}

resource "aws_security_group" "sg_windows_default" {
  vpc_id      = "${aws_vpc.vpc.id}"
  name        = "windows-default"
  description = "windows-default"

  tags {
    Name = "windows-default"
  }

  # Inbound ICMP (ping, traceroute, etc / only private networks)
  ingress {
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = -1
    to_port     = -1
  }

  # Inbound WinRM (5985=Over HTTP, 5986=Over HTTPS / only private networks)
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 5985
    to_port     = 5986
  }

  # Inbound RDP
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_global_network_cidr}", "${var.vpc_private_network_cidr}"]
    from_port   = 3389
    to_port     = 3389
  }

  # Outbound ICMP (ping, traceroute, etc)
  egress {
    protocol    = "icmp"
    cidr_blocks = ["${var.vpc_global_network_cidr}"]
    from_port   = -1
    to_port     = -1
  }

  # Outbound Ports
  # Active Directory and Active Directory Domain Services Port Requirements
  # ref: https://technet.microsoft.com/en-us/library/8daead2d-35c1-4b58-b123-d32a26b1f1dd

  # Outbound DNS (udp)
  egress {
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_global_network_cidr}"]
    from_port   = 53
    to_port     = 53
  }
  # Outbound DNS (tcp)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_global_network_cidr}"]
    from_port   = 53
    to_port     = 53
  }
  # Outbound NTP
  egress {
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_global_network_cidr}"]
    from_port   = 123
    to_port     = 123
  }
  # Outbound HTTP
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_global_network_cidr}"]
    from_port   = 80
    to_port     = 80
  }
  # Outbound HTTPS
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_global_network_cidr}"]
    from_port   = 443
    to_port     = 443
  }
  # Outbound LDAP (tcp)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 389
    to_port     = 389
  }
  # Outbound LDAP (udp)
  egress {
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 389
    to_port     = 389
  }
  # Outbound LDAP SSL
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 636
    to_port     = 636
  }
  # Outbound LDAP GC / LDAP GC SSL
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 3268
    to_port     = 3269
  }
  # Outbound Kerberos (tcp)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 88
    to_port     = 88
  }
  # Outbound Kerberos (udp)
  egress {
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 88
    to_port     = 88
  }
  # Outbound SMB,CIFS,DFSN,LSARPC,NbtSS,NetLogonR,SamR,SrvSvc (tcp)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 445
    to_port     = 445
  }
  # Outbound SMB,CIFS,DFSN,LSARPC,NbtSS,NetLogonR,SamR,SrvSvc (udp)
  egress {
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 445
    to_port     = 445
  }
  # Outbound SMTP(Replication)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 25
    to_port     = 25
  }
  # Outbound TCP dynamic ports (1024-65535)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 1024
    to_port     = 65535
  }
  # Outbound Kerberos change/set password (tcp)
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 464
    to_port     = 464
  }
  # Outbound Kerberos change/set password (udp)
  egress {
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 464
    to_port     = 464
  }
  # Outbound UDP dynamic ports (1024-65535)
  egress {
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 1024
    to_port     = 65535
  }
  # Outbound DFS, Group Policy
  egress {
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 138
    to_port     = 138
  }
  # Outbound SOAP
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 9389
    to_port     = 9389
  }
  # Outbound NetLogon,NetBIOS,Name Resolution
  egress {
    protocol    = "udp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 137
    to_port     = 137
  }
  # Outbound DFSN,NetBIOS Session Service,NetLogon
  egress {
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_private_network_cidr}"]
    from_port   = 139
    to_port     = 139
  }
}
