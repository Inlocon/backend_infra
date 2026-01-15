module "iam" {
  source                     = "../../modules/iam"
  env                        = "test"
  secret_name_db_credentials = "${var.env}_db_credentials"
  bucket_name                = "${var.env}-backend-inlocon"
}
