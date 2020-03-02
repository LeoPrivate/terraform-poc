provider "aws" {
  region = "eu-west-1"
}

module "network" {
  source = "../../modules/core/network"

  private_subnets = "${var.private_subnets}"
  public_subnets  = "${var.public_subnets}"

  env = "dev"
}

module "frontend" {
  source = "../../modules/core/frontend"

  public_subnets_id = "${module.network.public_subnets_id}"
  nb_instance       = "${var.nb_instance}"

  key_name = "${var.key_name_front}"

  vpc_id = "${module.network.vpc_id}"

}

module "backend" {
  source = "../../modules/core/backend"

  private_subnets_id = "${module.network.private_subnets_id}"
  nb_instance        = "${var.nb_instance}"

  key_name = "${var.key_name_back}"

  vpc_id = "${module.network.vpc_id}"

  public_subnets_cidr = "${var.public_subnets}"
}
