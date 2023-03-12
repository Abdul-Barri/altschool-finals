# # Route 53 and sub-domain name setup

# resource "aws_route53_zone" "portfolio-domain-name" {
#   name = "portfolio.abdulbarri.online"
# }

# resource "aws_route53_zone" "socks-domain-name" {
#   name = "socks.abdulbarri.online"
# }


# resource "aws_route53_record" "portfolio-record" {
#   zone_id = aws_route53_zone.portfolio-domain-name.zone_id
#   name    = "portfolio.abdulbarri.online"
#   type    = "A"

#   alias {
#     name                   = aws_lb.terraform-load-balancer.dns_name
#     zone_id                = aws_lb.terraform-load-balancer.zone_id
#     evaluate_target_health = true
#   }
#   depends_on = [
#     aws_lb.terraform-load-balancer
#   ]
# }

# resource "aws_route53_record" "socks-record" {
#   zone_id = aws_route53_zone.socks-domain-name.zone_id
#   name    = "socks.abdulbarri.online"
#   type    = "A"

#   alias {
#     name                   = aws_lb.terraform-load-balancer.dns_name
#     zone_id                = aws_lb.terraform-load-balancer.zone_id
#     evaluate_target_health = true
#   }
#   depends_on = [
#     aws_lb.terraform-load-balancer
#   ]
# }