data "aws_iam_policy_document" "vpc_flow_logs_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "vpc_flow_logs_role" {
  name_prefix        = "ROLE-flow-log-${var.vpc_name}"
  assume_role_policy = "${data.aws_iam_policy_document.vpc_flow_logs_role.json}"
}

data "aws_iam_policy_document" "vpc_flow_logs_role_policy" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "vpc_flow_logs_role_policy" {
  role        = "${aws_iam_role.vpc_flow_logs_role.id}"
  name_prefix = "POLICY-flow-log-${var.vpc_name}"

  policy = "${data.aws_iam_policy_document.vpc_flow_logs_role_policy.json}"
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
