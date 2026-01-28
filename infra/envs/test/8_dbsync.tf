locals {
  dbsynctags = { resourceGroup = "dbsync" }
}

resource "aws_cloudwatch_log_group" "dbsync" {
  name              = "/${var.env}/ecs/dbsync"
  retention_in_days = 30
  tags              = local.dbsynctags
}

# module "dbsync" {
#   source = "../../modules/8_dbsync"
#
#   # descriptive labels
#   name = "dbsync"
#   env  = var.env
#
#   # iam
#   dbsync_execution_role_arn = module.iam.dbsync_execution_role_arn
#   dbsync_task_role_arn      = module.iam.dbsync_task_role_arn
#
#   # networking (public tasks, single-AZ OK)
#   vpc_id           = module.network.vpc_id
#   subnet_ids       = module.network.public_subnet_ids
#   assign_public_ip = true
#   cluster_arn     = aws_ecs_cluster.this.arn # from 7_webservice
#
#   # container
#   container_image    = "${module.dbsync_ecr_repo.repository_url}:latest"
#   container_name     = "dbsync"
#   cpu                = 512
#   memory             = 1024
#   env_s3_bucket_name = module.s3.bucket_name
#   env_s3_bucket_key  = "${var.env}.dbsync.env"
#
#   #logs
#   log_group_name = aws_cloudwatch_log_group.dbsync.name
#
#   tags = local.dbsynctags
# }
#
# resource "aws_security_group_rule" "dbsync_egress_all" {
#   type              = "egress"
#   security_group_id = module.dbsync.task_sg_id
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"]
# }