module "vpc" {
    source = "terraform-aws-modules/vpc/aws"

    name = "vpc-poc-iac"
    cidr = "10.0.0.0/16"

    azs = ["eu-west-1a", "eu-west-1b"]
    private_subnets = "${var.private_subnets}"
    public_subnets = "${var.public_subnets}"

    tags = {
        environement = "${var.env}"
    }
}

resource "aws_security_group" "open_website" {
    name = "open_website"
    description = "Allow traffic against 8080"
    vpc_id = "${module.vpc.vpc_id}"

    ingress {   
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {   
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}