resource "aws_route_table" "route_table" {
  vpc_id           = "${aws_vpc.vpc.id}"
  propagating_vgws = ["${aws_vpn_gateway.vpn_gw.id}"]

  tags {
    Name = "RT-${var.vpc_name}"
  }
}
