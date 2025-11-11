terraform import 'aws_s3_bucket.this' test-backend-inlocon
terraform import 'aws_s3_bucket_ownership_controls.this' test-backend-inlocon
terraform import 'aws_s3_bucket_public_access_block.this' test-backend-inlocon
terraform import 'aws_s3_bucket_policy.this' test-backend-inlocon
  
module "s3" {
  source            = "../../modules/s3"
  bucket_name       = "test-backend-inlocon"
  # force_destroy     = true - default
  tags = { Env = "test" }
}
