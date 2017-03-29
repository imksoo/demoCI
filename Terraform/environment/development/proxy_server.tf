resource "aws_iam_role" "role" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "instance_profile" {
  roles = ["${aws_iam_role.role.id}"]
}

resource "aws_iam_role_policy" "role_policy_cloudwatch_logs" {
  role = "${aws_iam_role.role.id}"

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

resource "aws_iam_role_policy" "role_policy_s3" {
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListAllMyBuckets",
        "s3:ListBucket",
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:*MultipartUpload*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "role_policy_ec2" {
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:*Tags",
        "ec2:Describe*",
        "ec2:Run*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_security_group" "proxy_server" {
  vpc_id = "${module.vpc_subnet.vpc_id}"

  tags {
    Name = "proxy_server"
  }

  # Inbound HTTP (Proxy Service)
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    from_port   = 80
    to_port     = 80
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

data "aws_ami" "ami_proxy_server" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Ubuntu-16.04-ApacheForwardProxy-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["322934909423"] # MyAccount
}

resource "aws_instance" "proxy_server" {
  ami                         = "${data.aws_ami.ami_proxy_server.id}"
  instance_type               = "t2.nano"
  associate_public_ip_address = "true"

  //  key_name                    = "${aws_key_pair.keypair.key_name}"
  iam_instance_profile   = "${aws_iam_instance_profile.instance_profile.name}"
  vpc_security_group_ids = ["${aws_security_group.proxy_server.id}", "${module.vpc_subnet.default_security_group_linux}"]
  subnet_id              = "${element(module.vpc_subnet.vpc_subnet_id_list, count.index)}"
  count                  = 4

  tags {
    Name = "Proxy#${count.index+1}"
    Role = "Proxy"
  }
}

resource "aws_security_group" "elb_proxy_server" {
  vpc_id = "${module.vpc_subnet.vpc_id}"

  tags {
    Name = "elb_proxy_server"
  }

  # Inbound HTTP (Proxy Service)
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "0.0.0.0/0"]
    from_port   = 8080
    to_port     = 8080
  }

  # Outbound HTTP
  egress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
    from_port   = 80
    to_port     = 80
  }
}

/*
resource "aws_elb" "elb_proxy_server" {
  name            = "elb-proxy-server"
  subnets         = ["${module.vpc_subnet.vpc_subnet_id_list}"]
  security_groups = ["${aws_security_group.elb_proxy_server.id}"]

  cross_zone_load_balancing   = true
  idle_timeout                = 600
  connection_draining         = true
  connection_draining_timeout = 300

  tags {
    Name = "elb-proxy-server"
  }

  listener {
    instance_port     = 80
    instance_protocol = "TCP"
    lb_port           = 8080
    lb_protocol       = "TCP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 2
    interval            = 5
    target              = "TCP:80"
  }
}

resource "aws_elb_attachment" "elb_attachment_proxy_server" {
  elb      = "${aws_elb.elb_proxy_server.id}"
  count    = "${length(aws_instance.proxy_server.*.id)}"
  instance = "${element(aws_instance.proxy_server.*.id, count.index)}"
}
*/

