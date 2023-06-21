resource "aws_security_group" "public" {
  name        = "foocompany-dev-public"
  description = "Allow public inbound traffic to ALB"
  vpc_id      = module.networking.vpc_id

  ingress {
    description      = "TLS"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
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
    Name = "Public"
    Tier = "Public"
  }
}

resource "aws_security_group" "private" {
  name        = "foocompany-dev-private"
  description = "Allow inbound traffic from vpc"
  vpc_id      = module.networking.vpc_id

  ingress {
    description = "TLS"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [module.networking.vpc_cidr_block]
    # ipv6_cidr_blocks = module.networking.vpc_ipv6_cidr_block
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "Private"
    Tier = "Private"
  }
}
