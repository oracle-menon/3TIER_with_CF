resource "aws_s3_bucket" "static_content" {
  bucket = "${var.bucket-name}-st"
}

resource "aws_s3_bucket_ownership_controls" "static_content" {
  bucket = aws_s3_bucket.static_content.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "static_content" {
  depends_on = [aws_s3_bucket_ownership_controls.static_content]

  bucket = aws_s3_bucket.static_content.id
  acl    = "private"
}

resource "aws_vpc_endpoint" "s3_project" {
  vpc_id       = module.vpc.vpc_id
  service_name = "com.amazonaws.eu-west-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "s3_project" {
  route_table_id  = module.vpc.default_route_table_id
  vpc_endpoint_id = aws_vpc_endpoint.s3_project.id
}

