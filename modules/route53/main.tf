data "aws_route53_zone" "hosted_zone" {
  name = var.zone-name
}

resource "aws_route53_record" "site_domain" {
  zone_id = data.aws_route53_zone.hosted_zone.zone_id
  name    = var.record-name
  type    = "A"

  alias {
    name                   = var.alb-zone-name
    zone_id                = var.alb-zone-id
    evaluate_target_health = true
  }
}