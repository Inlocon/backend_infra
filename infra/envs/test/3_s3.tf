module "s3" {
  source      = "../../modules/3_s3"
  bucket_name = "${var.env}-backend-inlocon"
}
