output "public_subnets_id" {
    value = "${module.vpc.public_subnets}"
}
#
#output "private_subnets" {
#    value = "${module.vpc.private_subnets}"
#}
output frontend_sg_id {
    value = "${aws_security_group.open_website.id}"
}