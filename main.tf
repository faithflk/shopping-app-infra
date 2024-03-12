# -----------------------------------------------------
# Webserver SecurityGroup
# -----------------------------------------------------

resource "aws_security_group" "frontend" {

  name        = "${var.project_name}-${var.project_env}-frontend"
  description = "${var.project_name}-${var.project_env}-frontend"


  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

 ingress {
    from_port        = 9090
    to_port          = 9090
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }


  ingress {
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name    = "${var.project_name}-${var.project_env}-frontend"
    project = var.project_name
    env     = var.project_env
  }
}


# -----------------------------------------------------
# Creating Ec2 Instance
# -----------------------------------------------------

resource "aws_instance" "frontend" {

  ami                    = data.aws_ami.latest.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.shopping.key_name
  vpc_security_group_ids = [aws_security_group.frontend.id]
  tags = {
    Name    = "${var.project_name}-${var.project_env}-frontend"
    project = var.project_name
    env     = var.project_env
  }

  lifecycle {
    create_before_destroy = true
  }
}

# -----------------------------------------------------
# keypair creation
# -----------------------------------------------------


resource "aws_key_pair" "shopping" {
  key_name   = "${var.project_name}-${var.project_env}-key"
  public_key = file("mykey.pub")

    tags = {
    Name    = "${var.project_name}-${var.project_env}"
    Project = var.project_name
    Env = var.project_env
    }
}


#-----------------------------------
# creating records 
#-----------------------------------

resource "aws_route53_record" "frontend" {
  zone_id = data.aws_route53_zone.mydomain.zone_id
  name    = "${var.hostname}.${var.domain_name}"
  type    = "A"
  ttl     = 60
  records = [aws_instance.frontend.public_ip]  
}


