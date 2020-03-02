module "sshkey" {
  source = "../../common/aws/sshkey"

  key_name = var.key_name
}

resource "aws_security_group" "open_backend" {
  name        = "open_backend"
  description = "Allow traffic on 3000"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"

    # should be this (with a NAT GATEWAY to communicate over internet)
    # cidr_blocks = var.public_subnets_cidr
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

module "instances-backend" {
  source        = "../../common/aws/ec2"

  instance_name = "backend"
  key_name = var.key_name
  
  subnets_id  = var.private_subnets_id
  sg_id       = aws_security_group.open_backend.id
  nb_instance = var.nb_instance
}

module "elb_back" {
  source = "terraform-aws-modules/elb/aws"
  name   = "elb-back"

  subnets         = var.private_subnets_id
  security_groups = [aws_security_group.open_backend.id]

  # Should be true, but not in this PoC
  internal        = false

  listener = [
    {
      instance_port     = 3000
      instance_protocol = "HTTP"
      lb_port           = 3000
      lb_protocol       = "HTTP"
    }
  ]

  health_check = {
    target              = "HTTP:3000/"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
  }

  number_of_instances = var.nb_instance
  instances           = module.instances-backend.instances_ids
}