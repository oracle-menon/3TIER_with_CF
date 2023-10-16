module "s3_state" {
  source      = "../../../../modules/s3_state"
  bucket_name = var.bucket_name
  env_name    = var.env_name
  s3_locking  = var.s3_locking
  region      = var.region
}





