module "instances-frontend" {
  source = "../../common/aws/ec2"
  instance_name = "frontend"
  
  public_subnets_id = "${var.public_subnets_id}"
  nb_instance = "${var.nb_instance}"
  frontend_sg_id = "${var.frontend_sg_id}"
}