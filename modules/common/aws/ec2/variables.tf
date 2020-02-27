variable "ami_ec2" {
  default = "ami-0f630a3f40b1eb0b8"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "instance_name" {}

variable "public_subnets_id" {}

variable "nb_instance" {}

variable frontend_sg_id {}