output "alb_dns_name" {
  value       = aws_lb.project.dns_name
  description = "The domain name of the load balancer"
}

output "aws_efs_file_system" {
  description = "The EFS file system name"
  value       = aws_efs_file_system.project.dns_name
}

output "aws_cloudfront_distribution" {
  description = "The CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.project.domain_name # module.cdn.cloudfront_distribution_domain_name
}