resource "aws_route53_record" "nameservers" {
  allow_overwrite = true
  name            = var.domain_name
  type            = "A"
  zone_id         = var.zone_id
  alias {
    name                   = var.elb_dns_name
    zone_id                = var.elb_zone
    evaluate_target_health = true
  }
}