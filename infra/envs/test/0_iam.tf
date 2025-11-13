module "iam" {
  source = "../../modules/iam"
  env = "test"
  secret_name_db_credentials = "test_db_credentials"
  ec2_loader_s3_bucket_name = "backend-inlocon"
}
