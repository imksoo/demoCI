resource "aws_iam_role" "vpc_flow_logs_role" {
  name_prefix = "ROLE-flow-log-${var.vpc_name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "vpc_flow_logs_role_policy" {
  role        = "${aws_iam_role.vpc_flow_logs_role.id}"
  name_prefix = "POLICY-flow-log-${var.vpc_name}"

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

resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name              = "VPCFLOWLOG-${var.vpc_name}"
  retention_in_days = "${var.vpc_flow_log_retention_days}"
}

resource "aws_flow_log" "vpc_flow_log" {
  vpc_id         = "${aws_vpc.vpc.id}"
  iam_role_arn   = "${aws_iam_role.vpc_flow_logs_role.arn}"
  log_group_name = "${aws_cloudwatch_log_group.vpc_flow_log_group.name}"
  traffic_type   = "ALL"
}
