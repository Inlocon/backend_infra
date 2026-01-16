# module "ec2_loader" {
#   source        = "../../modules/4_ec2_loader"
#   ami_id        = "ami-09361b64d009bc090"
#   env           = var.env
#   iam_role_name = module.iam.ec2_loader_role_name # "ec2-migration"
#   instance_type = "t2.micro"
#   name          = "ec2-db-connector"
#   # put in public subnet
#   # a) much simpler (and cheaper) - avoids creation of unnecessary vpc endpoints and/or NAT gateway in the private subnet(s)
#   # b) still secure enough (as long as ... not the the associated sg is messed up AND a webserver or similar
#   # shannanigangs are installed on the instance AT THE SAME TIME)
#   subnet_id = module.network.public_subnet_ids[0]
#   # volume_size_gb = 20
# }