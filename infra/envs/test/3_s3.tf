module "s3" {
  source            = "../../modules/s3"
  bucket_name       = "test-backend-inlocon"
  tags = { Env = "test" }
}
