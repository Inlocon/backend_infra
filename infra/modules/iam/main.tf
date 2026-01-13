locals {
  services = {
    ec2 = "ec2.amazonaws.com"
    webservice = "ecs-tasks.amazonaws.com"
  }
  tags = {
    ec2loader = { resourceGroup = "ec2-loader" }
    webservice = { resourceGroup = "webservice"}
  }
  account_id = data.aws_caller_identity.current.account_id
}

data "aws_caller_identity" "current" {}

#################
# Trust policies
#################

data "aws_iam_policy_document" "assume_role_policy" {
  for_each = local.services
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = [each.value]
    }
  }
}

########
# roles
########

resource "aws_iam_role" "ec2_loader" {
  name               = "${var.env}-ec2-loader"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy["ec2"].json
  tags               = local.tags.ec2loader
}

resource "aws_iam_role" "webservice_execution" {
  name               = "${var.env}-webservice-execution"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy["webservice"].json
  tags               = local.tags.webservice
}

resource "aws_iam_role" "webservice_task" {
  name               = "${var.env}-webservice-task"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy["webservice"].json
  tags               = local.tags.webservice
}

######################
# permission policies
######################

#############
# ec2 loader
#############
resource "aws_iam_role_policy_attachment" "ec2_ssm" {
  role       = aws_iam_role.ec2_loader.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "ec2_loader" {
  statement {
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
  }
  statement {
    actions = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.bucket_name}"]
  }
  statement {
    actions = ["secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:eu-central-1:${local.account_id}:secret:${var.secret_name_db_credentials}*"]
  }
  statement {
    actions = ["rds:DescribeDBInstances"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_loader" {
  name   = "${var.env}-ec2-loader"
  policy = data.aws_iam_policy_document.ec2_loader.json
}

resource "aws_iam_role_policy_attachment" "ec2_loader" {
  role       = aws_iam_role.ec2_loader.name
  policy_arn = aws_iam_policy.ec2_loader.arn
}


########################
# webbservice execution
########################

resource "aws_iam_role_policy_attachment" "webservice_execution" {
  role       = aws_iam_role.webservice_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "webservice_execution" {
  statement {
    actions = ["s3:GetBucketLocation", "s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}", "arn:aws:s3:::${var.bucket_name}/*"]
  }
}

resource "aws_iam_role_policy" "webservice_execution" {
  policy = data.aws_iam_policy_document.webservice_execution.json
  role   = aws_iam_role.webservice_execution.name
}


##################
# webservice task
##################

data "aws_iam_policy_document" "webservice_task" {
  # TODO: check, whether the s3 permissions are really necessary
  # (env files are fetched by the execution role)
  statement {
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name}/*"]
  }
  statement {
    actions = ["s3:GetBucketLocation"]
    resources = ["arn:aws:s3:::${var.bucket_name}"]
  }
  statement {
    actions = ["secretsmanager:DescribeSecret", "secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:eu-central-1:${local.account_id}:secret:${var.secret_name_db_credentials}*"]
  }
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "webservice_task" {
  policy = data.aws_iam_policy_document.webservice_task.json
  role   = aws_iam_role.webservice_task.name
}





