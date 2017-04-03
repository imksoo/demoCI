output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "default_security_group_linux" {
  value = "${aws_security_group.sg_linux_default.id}"
}

output "default_security_group_windows" {
  value = "${aws_security_group.sg_windows_default.id}"
}

output "vpc_subnet_id_list" {
  value = ["${aws_subnet.subnet.*.id}"]
}

output "vpn_gateway_id" {
  value = "${aws_vpn_gateway.vpn_gw.id}"
}

output "vpc_flow_log_group_arn" {
  value = "${aws_cloudwatch_log_group.vpc_flow_log_group.arn}"
}

output "route_table" {
  value = "${aws_route_table.route_table.id}"
}
