resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.vpc.id}"
  count  = "${lookup(map(var.create_internet_gateway, 1), "true", 0)}"

  tags {
    Name = "IGW-${var.vpc_name}"
  }
}

resource "aws_route" "route_table_igw" {
  route_table_id         = "${aws_route_table.route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
  depends_on             = ["aws_internet_gateway.igw"]
}
