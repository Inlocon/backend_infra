# resource "aws_cloudwatch_log_group" "dbsync" {
#   name              = "/${var.env}/ecs/dbsync"
#   retention_in_days = 30
#   tags              = local.tags.dbsync
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
#   webservice_execution_role_arn = module.iam.dbsync_execution_role_arn
#   webservice_task_role_arn      = module.iam.dbsync_task_role_arn
#
#   # networking (public tasks, single-AZ OK)
#   vpc_id           = module.network.vpc_id
#   subnet_ids       = module.network.public_subnet_ids
#   assign_public_ip = true
#   cluster_name     = aws_ecs_cluster.this.name
#
#   # container
#   container_image    = "${module.webservice_ecr_repo.repository_url}:latest"
#   container_name     = "webservice"
#   container_port     = 8000
#   cpu                = 512
#   memory             = 1024
#   env_s3_bucket_name = module.s3.bucket_name
#   env_s3_bucket_key  = "prod.env"
#
#
#   # load balancer integration
#   target_group_arn = module.alb.target_group_arn
#
#   # scaling
#   desired_count      = 1
#   autoscaling_min    = 1
#   autoscaling_max    = 1
#   cpu_target_percent = 60
#
#   #logs
#   log_group_name = aws_cloudwatch_log_group.webservice.name
#
#   tags = local.tags
# }