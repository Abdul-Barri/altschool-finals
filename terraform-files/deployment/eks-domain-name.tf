# Route 53 and sub-domain name setup

resource "aws_route53_zone" "portfolio-domain-name" {
  name = "portfolio.abdulbarri.online"
}

resource "aws_route53_zone" "socks-domain-name" {
  name = "socks.abdulbarri.online"
}

# Get the zone_id for the load balancer

data "aws_elb_hosted_zone_id" "elb_zone_id" {
  depends_on = [
    kubernetes_service.kube-service-portfolio, kubernetes_service.kube-service-socks
  ]
}

# DNS record for portfolio

resource "aws_route53_record" "portfolio-record" {
  zone_id = aws_route53_zone.portfolio-domain-name.zone_id
  name    = "portfolio.abdulbarri.online"
  type    = "A"

  alias {
    name                   = kubernetes_service.kube-service-portfolio.status.0.load_balancer.0.ingress.0.hostname
    zone_id                = data.aws_elb_hosted_zone_id.elb_zone_id.id
    evaluate_target_health = true
  }
}

# DNS record for socks

resource "aws_route53_record" "socks-record" {
  zone_id = aws_route53_zone.socks-domain-name.zone_id
  name    = "socks.abdulbarri.online"
  type    = "A"

  alias {
    name                   = kubernetes_service.kube-service-socks.status.0.load_balancer.0.ingress.0.hostname
    zone_id                = data.aws_elb_hosted_zone_id.elb_zone_id.id
    evaluate_target_health = true
  }
}