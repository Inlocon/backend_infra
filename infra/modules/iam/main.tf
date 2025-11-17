locals {
  tags = {resourceGroup = "IAM"}
}

#######################################
# Trust policies (data-only)
#######################################

data "aws_iam_policy_document" "ec2_trust" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

##################
# EC2 loader role
##################

resource "aws_iam_role" "ec2_loader" {
  name               = "${var.env}-ec2-loader"
  assume_role_policy = data.aws_iam_policy_document.ec2_trust.json
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_core" {
  role       = aws_iam_role.ec2_loader.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy" "ec2_loader_secrets" {
  name = "${var.env}-ec2-loader-secrets"
  role = aws_iam_role.ec2_loader.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:ListSecrets",
        ]
        Resource = [
          "arn:aws:secretsmanager:eu-central-1:864981740157:secret:${var.secret_name_db_credentials}*",
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy" "ec2_loader_rds_describe" {
  name = "${var.env}-ec2-loader-rds-describe"
  role = aws_iam_role.ec2_loader.id

  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": "rds:DescribeDBInstances",
			"Resource": "*"
		}
	]
  })
}

resource "aws_iam_role_policy" "ec2_loader_s3_read" {
  name = "${var.env}-ec2-loader-s3-read"
  role = aws_iam_role.ec2_loader.id

  policy = jsonencode({
	"Version": "2012-10-17",
	"Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"s3:GetObject",
				"s3:ListBucket"
			],
			"Resource": [
				"arn:aws:s3:::${var.ec2_loader_s3_bucket_name}",
				"arn:aws:s3:::${var.ec2_loader_s3_bucket_name}/*"
			]
		}
	]
  })
}

