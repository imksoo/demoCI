/* AWS ALB(Application Load Balancer) cannot contains forward proxy servers.
resource "aws_security_group" "alb_proxy_server" {
  vpc_id = "${module.vpc.vpc_id}"

  tags {
    Name = "alb_proxy_server"
  }

  # Inbound HTTP (Proxy Service)
  ingress {
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
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

resource "aws_alb" "alb_proxy_server" {
  internal        = false
  name            = "alb-proxy-server"
  subnets         = ["${module.vpc.vpc_id_list}"]
  security_groups = ["${aws_security_group.alb_proxy_server.id}"]

  tags {
    Name = "alb-proxy-server"
  }
}

resource "aws_alb_listener" "alb_listener_proxy_server" {
  load_balancer_arn = "${aws_alb.alb_proxy_server.arn}"
  port              = 8080
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.alb_target_group_proxy_server.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "alb_target_group_proxy_server" {
  name     = "alb-tg-proxy-server"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${module.vpc.vpc_id}"
}

resource "aws_alb_target_group_attachment" "alb_target_group_attachement_proxy_server" {
  count            = "${length(aws_instance.proxy_server.*.id)}"
  target_group_arn = "${aws_alb_target_group.alb_target_group_proxy_server.arn}"
  target_id        = "${element(aws_instance.proxy_server.*.id, count.index)}"
  port             = 80
}
*/

