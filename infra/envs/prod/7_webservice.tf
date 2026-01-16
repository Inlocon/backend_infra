# locals {
#   webservicetags = { resourceGroup = "webservice" }
# }
#
# resource "aws_ecs_cluster" "this" {
#   name = "${var.env}-backend-cluster"
# }
#
# resource "aws_cloudwatch_log_group" "webservice" {
#   name              = "/${var.env}/ecs/webservice"
#   retention_in_days = 30
#   tags              = local.webservicetags
# }
#
# module "webservice" {
#   source = "../../modules/7_webservice"
#
#   # descriptive labels
#   name = "webservice"
#   env  = var.env
#
#   # iam
#   webservice_execution_role_arn = module.iam.webservice_execution_role_arn
#   webservice_task_role_arn      = module.iam.webservice_task_role_arn
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
#   env_s3_bucket_key  = "${var.env}.webservice.env"
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
#   tags = local.webservicetags
# }
#
# resource "aws_security_group_rule" "alb_to_tasks" {
#   type                     = "ingress"
#   from_port                = 8000
#   to_port                  = 8000
#   protocol                 = "tcp"
#   security_group_id        = module.webservice.task_sg_id
#   source_security_group_id = module.alb.alb_sg_id
# }
#
# resource "aws_security_group_rule" "task_egress_all" {
#   type              = "egress"
#   security_group_id = module.webservice.task_sg_id
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   cidr_blocks       = ["0.0.0.0/0"] # ipv4 is enough for now
# }