module "s3" {
  env = var.env
  source      = "../../modules/3_s3"
  bucket_name = "${var.env}-backend-inlocon"
}

module "s3_files" {
  env = var.env
  source      = "../../modules/3_s3"
  bucket_name = "${var.env}-files-inlocon"
}

resource "aws_s3_bucket_lifecycle_configuration" "files_bots_expiration" {
  bucket = module.s3_files.bucket_id

  rule {
    id     = "expire-bots"
    status = "Enabled"

    filter {
      prefix = "bots/"
    }

    expiration {
      days = 60
    }
  }
}