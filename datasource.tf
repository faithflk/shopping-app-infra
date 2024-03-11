
data "aws_route53_zone" "mydomain" {
  name         = var.domain_name
  private_zone = false
}

