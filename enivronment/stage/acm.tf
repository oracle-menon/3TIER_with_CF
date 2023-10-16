resource "aws_acm_certificate" "project" {
  domain_name       = "*.envcloud.link"
  validation_method = "DNS"

  tags = {
    Name = "Project Certificate"
  }
}

resource "aws_acm_certificate_validation" "project" {
  certificate_arn         = aws_acm_certificate.project.arn
  validation_record_fqdns = [aws_route53_record.project_validate.fqdn]
}

resource "aws_acm_certificate" "project_global" {
  provider          = aws.global
  domain_name       = "*.envcloud.link"
  validation_method = "DNS"

  tags = {
    Name = "Project Certificate"
  }
}

resource "aws_acm_certificate_validation" "project_global" {
  provider                = aws.global
  certificate_arn         = aws_acm_certificate.project_global.arn
  validation_record_fqdns = [aws_route53_record.project_validate_global.fqdn]
}
