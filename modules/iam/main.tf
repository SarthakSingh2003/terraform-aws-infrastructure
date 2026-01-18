# IAM Role for EC2 Instances (Legacy/Bastion)
resource "aws_iam_role" "ec2_role" {
  name               = "${var.environment}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-ec2-role"
    }
  )
}

# EC2 Assume Role Policy
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_execution_role" {
  name               = "${var.environment}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-ecs-execution-role"
    }
  )
}

# IAM Role for ECS Task
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.environment}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role.json

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-ecs-task-role"
    }
  )
}

# ECS Assume Role Policy (used by both Task and Execution roles)
data "aws_iam_policy_document" "ecs_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Attach AWS Managed Policy for ECS Task Execution
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# IAM Policy for S3 Access
resource "aws_iam_policy" "s3_access" {
  count       = var.enable_s3_access ? 1 : 0
  name        = "${var.environment}-s3-access-policy"
  description = "Policy for S3 bucket access"
  policy      = data.aws_iam_policy_document.s3_access[0].json

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-s3-access-policy"
    }
  )
}

# S3 Access Policy Document
data "aws_iam_policy_document" "s3_access" {
  count = var.enable_s3_access ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = var.s3_bucket_arns
  }
}

# IAM Policy for CloudWatch Logs
resource "aws_iam_policy" "cloudwatch_logs" {
  count       = var.enable_cloudwatch_logs ? 1 : 0
  name        = "${var.environment}-cloudwatch-logs-policy"
  description = "Policy for CloudWatch Logs access"
  policy      = data.aws_iam_policy_document.cloudwatch_logs[0].json

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-cloudwatch-logs-policy"
    }
  )
}

# CloudWatch Logs Policy Document
data "aws_iam_policy_document" "cloudwatch_logs" {
  count = var.enable_cloudwatch_logs ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

# Attach S3 Access Policy to Role
resource "aws_iam_role_policy_attachment" "s3_access" {
  count      = var.enable_s3_access ? 1 : 0
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_access[0].arn
}

# Attach CloudWatch Logs Policy to Role
resource "aws_iam_role_policy_attachment" "cloudwatch_logs" {
  count      = var.enable_cloudwatch_logs ? 1 : 0
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs[0].arn
}

# Attach SSM Managed Policy to Role
resource "aws_iam_role_policy_attachment" "ssm_managed_instance" {
  count      = var.enable_ssm ? 1 : 0
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2_role.name

  tags = merge(
    var.common_tags,
    {
      Name = "${var.environment}-ec2-instance-profile"
    }
  )
}
