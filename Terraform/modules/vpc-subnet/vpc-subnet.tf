resource "aws_subnet" "subnet" {
  vpc_id                          = "${aws_vpc.vpc.id}"
  count                           = "${length(var.vpc_subnet_cidr_list)}"
  availability_zone               = "${var.availability_zone_list[count.index]}"
  cidr_block                      = "${var.vpc_subnet_cidr_list[count.index]}"
  map_public_ip_on_launch         = "${var.assign_public_ip}"
  assign_ipv6_address_on_creation = false

  tags {
    Name = "SUBNET-${var.vpc_name}-${var.vpc_subnet_cidr_list[count.index]}"
  }
}

resource "aws_route_table_association" "subnet_route_table_assoc" {
  count          = "${length(var.vpc_subnet_cidr_list)}"
  route_table_id = "${aws_route_table.route_table.id}"
  subnet_id      = "${element(aws_subnet.subnet.*.id, count.index)}"
}
