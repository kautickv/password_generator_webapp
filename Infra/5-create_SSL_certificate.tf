# Create a new SSL certificate
resource "aws_acm_certificate" "ssl_certificate" {
  domain_name               = var.domain_name
  validation_method         = "DNS"
}

# Create new record in route53
resource "aws_route53_record" "cert_records" {
  for_each = {
    for dvo in aws_acm_certificate.ssl_certificate.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }

  name    = each.value.name
  type    = each.value.type
  zone_id = aws_route53_zone.hosted_zone.zone_id
  records = [each.value.resource_record_value]
  ttl     = 60
}

# Validate the certificate
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.ssl_certificate.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_records : record.fqdn]
}
