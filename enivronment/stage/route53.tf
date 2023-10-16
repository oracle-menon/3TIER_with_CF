data "aws_route53_zone" "project" {
  name = "envcloud.link"
}

resource "aws_route53_record" "project" {
  zone_id = data.aws_route53_zone.project.zone_id
  name    = "project"
  type    = "CNAME"
  ttl     = 60
  records = [aws_lb.project.dns_name]
}

resource "aws_route53_record" "project_validate" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.project.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.project.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.project.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.project.zone_id
  ttl             = 60
}

resource "aws_route53_record" "project_validate_global" {
  allow_overwrite = true
  name            = tolist(aws_acm_certificate.project_global.domain_validation_options)[0].resource_record_name
  records         = [tolist(aws_acm_certificate.project_global.domain_validation_options)[0].resource_record_value]
  type            = tolist(aws_acm_certificate.project_global.domain_validation_options)[0].resource_record_type
  zone_id         = data.aws_route53_zone.project.zone_id
  ttl             = 60
}

resource "aws_route53_record" "project_cloudfront" {
  zone_id = data.aws_route53_zone.project.zone_id
  name    = "cf-project"
  type    = "CNAME"
  ttl     = 60

  records = [aws_cloudfront_distribution.project.domain_name] # [module.cdn.cloudfront_distribution_domain_name]
}

# data "aws_route53_zone" "project_vpn_server" {
#   name = "vpn.s.sevc.link"
# }


# resource "aws_route53_record" "project_vpn_server" {
#   zone_id = data.aws_route53_zone.project_vpn_server.zone_id
#   name    = "vpn"
#   type    = "CNAME"
#   ttl     = 60

# }

# resource "aws_route53_record" "project_vpn_server_validate" {
#   allow_overwrite = true
#   name            = tolist(aws_acm_certificate.project_vpn_server.domain_validation_options)[0].resource_record_name
#   records         = [tolist(aws_acm_certificate.project_vpn_server.domain_validation_options)[0].resource_record_value]
#   type            = tolist(aws_acm_certificate.project_vpn_server.domain_validation_options)[0].resource_record_type
#   zone_id         = data.aws_route53_zone.project_vpn_server.zone_id
#   ttl             = 60
# }
