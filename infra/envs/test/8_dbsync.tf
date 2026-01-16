# locals {
#   dbsynctags = { resourceGroup = "dbsync" }
# }
#
# resource "aws_cloudwatch_log_group" "dbsync" {
#   name              = "/${var.env}/ecs/dbsync"
#   retention_in_days = 30
#   tags              = local.dbsynctags
# }
#
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
#   cluster_name     = aws_ecs_cluster.this.name # from 7_webservice
#
#   # container
#   container_image    = "${module.dbsync_ecr_repo.repository_url}:latest"
#   container_name     = "dbsync"
#   container_port     = 8000
#   cpu                = 512
#   memory             = 1024
#   env_s3_bucket_name = module.s3.bucket_name
#   env_s3_bucket_key  = "${var.env}.dbsync.env"
#
#   # load balancer integration
#   target_group_arn = module.alb.target_group_arn
#
#   #logs
#   log_group_name = aws_cloudwatch_log_group.dbsync.name
#
#   tags = local.dbsynctags
# }