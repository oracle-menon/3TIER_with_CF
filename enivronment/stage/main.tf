provider "aws" {
  region = var.region
  default_tags {
    tags = {
      environment  = "stage"
      created_with = "terraform"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  alias  = "global"
  default_tags {
    tags = {
      environment  = "stage"
      created_with = "terraform"
    }
  }
}

locals {
  tags = merge(
    var.tags,
    { Environment = "${var.env}" }
  )
}

