module "sshkey" {
  source = "../../common/aws/sshkey"

  key_name = "${var.key_name}"
}

resource "aws_security_group" "open_website" {
  name        = "open_website"
  description = "Allow traffic on 8080"
  vpc_id      = var.vpc_id
 
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "instances-frontend" {
  source        = "../../common/aws/ec2"
  instance_name = "frontend"

  subnets_id  = var.public_subnets_id
  nb_instance = var.nb_instance
  sg_id       = aws_security_group.open_website.id

  key_name = var.key_name
}

module "elb_http" {
  source = "terraform-aws-modules/elb/aws"
  name   = "elb-front"

  subnets         = var.public_subnets_id
  security_groups = [aws_security_group.open_website.id]
  internal        = false

  listener = [
    {
      instance_port     = 8080
      instance_protocol = "HTTP"
      lb_port           = 80
      lb_protocol       = "HTTP"
    }
  ]

  health_check = {
    target              = "HTTP:8080/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  number_of_instances = var.nb_instance
  instances           = module.instances-frontend.instances_ids
}