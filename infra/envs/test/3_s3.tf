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
