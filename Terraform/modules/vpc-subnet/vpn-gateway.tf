resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = "${aws_vpc.vpc.id}"
  count  = "${lookup(map(var.create_vpn_gateway, 1), "true", 0)}"

  tags {
    Name = "VPNGW-${var.vpc_name}"
  }
}
