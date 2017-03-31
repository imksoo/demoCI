resource "aws_vpc_peering_connection" "piano-infra-dev01" {
  vpc_id        = "${module.vpc.vpc_id}"
  peer_owner_id = "528598000004"
  peer_vpc_id   = "vpc-942f7bf3"
  auto_accept   = false

  tags = {
    Name = "piano-infra-dev01"
  }
}

resource "aws_route" "piano-infra-dev01" {
  route_table_id            = "${module.vpc.route_table}"
  destination_cidr_block    = "10.23.12.0/22"
  vpc_peering_connection_id = "${aws_vpc_peering_connection_accepter.piano-infra-dev01.id}"
}
