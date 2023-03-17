# ACME provider configuration

provider "acme" {
  server_url = "https://acme-staging-v02.api.letsencrypt.org/directory"
  #server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

# Retrieve AWS route 53 zones

data "aws_route53_zone" "portfolio-domain-name" {
  name = "portfolio.abdulbarri.online" # TODO put your own DNS in here!
}

data "aws_route53_zone" "socks-domain-name" {
  name = "socks.abdulbarri.online" # TODO put your own DNS in here!
}

# private keys

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

# SSL registrations

resource "acme_registration" "registration" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "lawalabdulbarri@gmail.com" # TODO put your own email in here!
}

# SSL certificates

resource "acme_certificate" "certificate-portfolio" {
  account_key_pem           = acme_registration.registration.account_key_pem
  common_name               = data.aws_route53_zone.portfolio-domain-name.name
  subject_alternative_names = ["*.${data.aws_route53_zone.portfolio-domain-name.name}"]

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID = data.aws_route53_zone.portfolio-domain-name.zone_id
    }
  }

  depends_on = [acme_registration.registration]
}

resource "acme_certificate" "certificate-socks" {
  account_key_pem           = acme_registration.registration.account_key_pem
  common_name               = data.aws_route53_zone.socks-domain-name.name
  subject_alternative_names = ["*.${data.aws_route53_zone.socks-domain-name.name}"]

  dns_challenge {
    provider = "route53"

    config = {
      AWS_HOSTED_ZONE_ID = data.aws_route53_zone.socks-domain-name.zone_id
    }
  }

  depends_on = [acme_registration.registration]
}