locals {
  services = {
    ec2 = "ec2.amazonaws.com"
    ecsservice = "ecs-tasks.amazonaws.com"
  }
  tags = {
    ec2loader = { resourceGroup = "ec2-loader" }
    webservice = { resourceGroup = "webservice"}
    dbsync = { resourceGroup = "dbsync"}
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
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy["ecsservice"].json
  tags               = local.tags.webservice
}

resource "aws_iam_role" "webservice_task" {
  name               = "${var.env}-webservice-task"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy["ecsservice"].json
  tags               = local.tags.webservice
}

resource "aws_iam_role" "dbsync_execution" {
  name               = "${var.env}-dbsync-execution"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy["ecsservice"].json
  tags               = local.tags.dbsync
}

resource "aws_iam_role" "dbsync_task" {
  name               = "${var.env}-dbsync-task"
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy["ecsservice"].json
  tags               = local.tags.dbsync
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
    resources = ["arn:aws:s3:::${var.bucket_name_config}/*"]
  }
  statement {
    actions = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.bucket_name_config}"]
  }
  statement {
    actions = ["secretsmanager:GetSecretValue"]
    resources = [
      "arn:aws:secretsmanager:eu-central-1:${local.account_id}:secret:${var.secret_name_db_credentials}*",
      "arn:aws:secretsmanager:eu-central-1:${local.account_id}:secret:inlocontest_credentials*", # old smoketest db secret
    ]
  }
  statement {
    actions = ["rds:DescribeDBInstances"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ec2_loader" {
  name   = "${var.env}-ec2-loader"
  policy = data.aws_iam_policy_document.ec2_loader.json
  tags = local.tags.ec2loader
}

resource "aws_iam_role_policy_attachment" "ec2_loader" {
  role       = aws_iam_role.ec2_loader.name
  policy_arn = aws_iam_policy.ec2_loader.arn
}


###################################
# webbservice and dbsync execution
###################################

data "aws_iam_policy_document" "webservice_execution" {
  statement {
    actions = ["s3:GetBucketLocation", "s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name_config}", "arn:aws:s3:::${var.bucket_name_config}/*"]
  }
}

resource "aws_iam_policy" "webservice_execution" {
  name = "${var.env}-webservice-execution"
  policy = data.aws_iam_policy_document.webservice_execution.json
  tags = local.tags.webservice
}

resource "aws_iam_role_policy_attachment" "webservice_execution_managed_task_execution_role" {
  role       = aws_iam_role.webservice_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "webservice_execution_custom_role" {
  role       = aws_iam_role.webservice_execution.name
  policy_arn = aws_iam_policy.webservice_execution.arn
}

# just give the dbsync the same rights for now - will be deleted in a few month anway ...
resource "aws_iam_role_policy_attachment" "dbsync_execution_managed_task_execution_role" {
  role       = aws_iam_role.dbsync_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "dbsync_execution_custom_role" {
  role       = aws_iam_role.dbsync_execution.name
  policy_arn = aws_iam_policy.webservice_execution.arn
}
##################
# webservice task
##################

data "aws_iam_policy_document" "webservice_task" {
  # TODO: check, whether the s3 permissions are really necessary
  # (env files are fetched by the execution role)
  statement {
    actions = ["s3:GetObject"]
    resources = ["arn:aws:s3:::${var.bucket_name_config}/*"]
  }
  statement {
    actions = ["s3:GetBucketLocation"]
    resources = ["arn:aws:s3:::${var.bucket_name_config}"]
  }
  statement {
    actions = ["s3:GetObject", "s3:PutObject"]
    resources = ["arn:aws:s3:::${var.bucket_name_files}/*"]
  }
  statement {
    actions = ["s3:GetBucketLocation"]
    resources = ["arn:aws:s3:::${var.bucket_name_files}"]
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

resource "aws_iam_policy" "webservice_task" {
  name = "${var.env}-webservice-task"
  policy = data.aws_iam_policy_document.webservice_task.json
  tags = local.tags.webservice
}

resource "aws_iam_role_policy_attachment" "webservice_task" {
  role = aws_iam_role.webservice_task.name
  policy_arn = aws_iam_policy.webservice_task.arn
}

##################
# dbsync task
##################

data "aws_iam_policy_document" "dbsync_task" {
  # TODO: check, whether the s3 permissions are really necessary
  # (env files are fetched by the execution role)
#   statement {
#     actions = ["s3:GetObject"]
#     resources = ["arn:aws:s3:::${var.bucket_name_config}/*"]
#   }
#   statement {
#     actions = ["s3:GetBucketLocation"]
#     resources = ["arn:aws:s3:::${var.bucket_name_config}"]
#   }
  statement {
    actions = ["secretsmanager:DescribeSecret", "secretsmanager:GetSecretValue"]
    resources = ["arn:aws:secretsmanager:eu-central-1:${local.account_id}:secret:${var.secret_name_db_credentials}*",
    "arn:aws:secretsmanager:eu-central-1:${local.account_id}:secret:apiKey_fuer_DB_Synchro*"]
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

resource "aws_iam_policy" "dbsync_task" {
  name = "${var.env}-dbsync-task"
  policy = data.aws_iam_policy_document.dbsync_task.json
  tags = local.tags.dbsync
}

resource "aws_iam_role_policy_attachment" "dbsync_task" {
  role = aws_iam_role.dbsync_task.name
  policy_arn = aws_iam_policy.dbsync_task.arn
}




