# ------------------------------------------------------------
# ホストゾーンの参照
# ------------------------------------------------------------
data "aws_route53_zone" "example" {
  name = "studyawsbookexample.com"
}

# ------------------------------------------------------------
# レコードの作成とALBとの関連付け
# ------------------------------------------------------------
resource "aws_route53_record" "example" {
  zone_id = data.aws_route53_zone.example.zone_id
  name    = data.aws_route53_zone.example.name
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

# ------------------------------------------------------------
# SSL証明書の発行
# ------------------------------------------------------------
resource "aws_acm_certificate" "example" {
  domain_name               = data.aws_route53_zone.example.name
  subject_alternative_names = []
  validation_method         = "DNS"
}

# ------------------------------------------------------------
# SSL証明書の検証
# ------------------------------------------------------------
resource "aws_route53_record" "example_certificate" {
  zone_id = data.aws_route53_zone.example.id
  name    = aws_acm_certificate.example.domain_validation_options[0].resource_record_name
  type    = aws_acm_certificate.example.domain_validation_options[0].resource_record_type
  records = [aws_acm_certificate.example.domain_validation_options[0].resource_record_value]
  ttl     = 60
}
