provider "aws" {
  region = var.region
}

# ## uncomment this after you create the bucket; run terraform init once again
# terraform {
#   backend "s3" {
#     bucket = "demo-set-tfstate-environment-stage"
#     key    = "global/s3_state/terraform.tfstate"
#     region = "eu-west-1"
#   }
# }
