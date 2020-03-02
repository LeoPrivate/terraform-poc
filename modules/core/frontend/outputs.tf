#output "url" {
#  value = "http://${aws_instance.first_instance.id}:${var.port}"
#}
output frontend_sg_id {
  value = "${aws_security_group.open_website.id}"
}