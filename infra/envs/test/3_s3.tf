module "s3" {
  source            = "../../modules/s3"
  bucket_name       = "test-backend-inlocon-1"
  # force_destroy     = true - default
  tags = { Env = "test" }
}
