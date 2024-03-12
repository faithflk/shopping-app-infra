

data "aws_ami" "latest" {
  most_recent      = true
  owners           = ["self"]


  filter {
    name   = "tag:env"
    values = ["${var.project_env}"]
  }
}


data "aws_route53_zone" "mydomain" {
  name         = var.domain_name
  private_zone = false
}

