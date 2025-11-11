module "s3" {
  source            = "../../modules/s3"
  bucket_name       = "test-backend-inlocon-3"
  # force_destroy     = true - default
  tags = { Env = "test" }
}
