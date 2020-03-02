resource "aws_instance" "frontend" {
  ami           = "${var.ami_ec2}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_name}"

  subnet_id       = "${var.subnets_id["${count.index}"]}"
  security_groups = list("${var.sg_id}")

  user_data = <<-EOF
            #!/bin/bash
            echo "Ping from instance" > index.html
            nohup busybox httpd -f -p 8080 &
            EOF

  tags = {
    Name  = "${var.instance_name}"
    Index = "${count.index}"
  }

  count = "${var.nb_instance}"
}
