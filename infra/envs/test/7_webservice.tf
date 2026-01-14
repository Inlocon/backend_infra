locals {
  tags = {
    resourceGroup = "webservice"
  }
}

resource "aws_ecs_cluster" "this" {
  name = "${var.env}-backend-cluster"
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/${var.env}/ecs/webservice"
  retention_in_days = 30
  tags = local.tags
}

# module "webservice" {
#   source = "../../modules/web_service"
#
#   # Identity & basics
#   name = "webservice"
#   env = var.env
#
#   # Networking (public tasks, single-AZ OK)
#   vpc_id = module.network.vpc_id
#   subnet_ids = module.network.public_subnet_ids
#   assign_public_ip = true
#   cluster_name = ecs_cluster.this.name
#
#   # container image & runtime
#   container_image = "${module.ecr_backend.repository_url}:latest"
#   container_name = "backend"
#   container_port = 8000
#   cpu = 512
#   memory = 1024
#
#   # Load balancer integration
#   target_group_arn = module.alb.target_group_arn
#
#   # Scaling
#   desired_count = 1
#   autoscaling_min = 1
#   autoscaling_max = 1
#   cpu_target_percent = 60
#
#   # logs
#   log_group_name = aws_cloudwatch_log_group.this.name
#
#   # env-file
#   env_s3_bucket_name = "${var.env}-backend-inlocon"
#   env_s3_bucket_key = "prod.env"
#
#   tags = local.tags
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
