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

  tags {
    Name = "SG-default-vpc-sg-${var.vpc_name}"
  }
}
