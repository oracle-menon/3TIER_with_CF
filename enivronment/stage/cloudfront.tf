resource "aws_wafv2_web_acl" "project" {
  provider    = aws.global
  name        = "Project-WAF-ACL"
  description = "ACL for WAF for CloudFront"
  scope       = "CLOUDFRONT"
  default_action {
    allow {}
  }

  rule {
    name     = "Project_ALC_Rule"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAdminProtectionRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "Project_ACL_1"
      sampled_requests_enabled   = false
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "Project_ACL_2"
    sampled_requests_enabled   = false
  }
}

resource "aws_cloudfront_distribution" "project" {
  enabled    = true
  aliases    = ["cf-${aws_route53_record.project.fqdn}"]
  web_acl_id = aws_wafv2_web_acl.project.arn
  origin {
    domain_name = aws_lb.project.dns_name
    origin_id   = "ALBOrigin"
    custom_origin_config {
      http_port              = "80"
      https_port             = "443"
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  origin {
    domain_name = aws_s3_bucket.static_content.bucket_regional_domain_name
    origin_id   = "S3Origin"

  }
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id        = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad"
    target_origin_id       = "ALBOrigin"
    viewer_protocol_policy = "redirect-to-https"
  }

  ordered_cache_behavior {
    path_pattern           = "/static/*"
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD", "OPTIONS"]
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6"
    target_origin_id       = "S3Origin"
    viewer_protocol_policy = "redirect-to-https"

  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE", "BG"]
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.project_global.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2018"
  }
}
