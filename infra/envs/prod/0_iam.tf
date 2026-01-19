module "iam" {
  source                     = "../../modules/0_iam"
  env                        = var.env
  secret_name_db_credentials = local.secret_name_db_credentials
  bucket_name                = "${var.env}-backend-inlocon"
}
