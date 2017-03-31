resource "aws_vpc_peering_connection" "piano-infra-dev01" {
  vpc_id        = "${module.vpc.vpc_id}"
  peer_owner_id = "528598000004"
  peer_vpc_id   = "vpc-2a34604d"
  auto_accept   = false

  tags = {
    Name = "piano-infra-dev01"
  }
}
