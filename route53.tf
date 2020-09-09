# ------------------------------------------------------------
# ホストゾーンの参照
# ------------------------------------------------------------
data "aws_route53_zone" "main" {
  name = "kurashinolog.net"
}

# ------------------------------------------------------------
# レコードの作成とALBとの関連付け
# ------------------------------------------------------------
resource "aws_route53_record" "main" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = data.aws_route53_zone.main.name
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
resource "aws_acm_certificate" "main" {
  domain_name               = data.aws_route53_zone.main.name
  subject_alternative_names = []
  validation_method         = "DNS"
}

# ------------------------------------------------------------
# SSL証明書の検証
# ------------------------------------------------------------
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.main.id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}
