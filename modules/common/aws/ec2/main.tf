data "local_file" "frontkey" {
    filename = pathexpand("~/.ssh/frontkey")
}

resource "aws_key_pair" "frontkey" {
    key_name = "frontkey"
    public_key = file("~/.ssh/frontkey.pub")
}

resource "aws_instance" "frontend" {
  ami           = "${var.ami_ec2}"
  instance_type = "${var.instance_type}"
  subnet_id     = "${var.public_subnets_id["${count.index}"]}"
  key_name = "${aws_key_pair.frontkey.key_name}"
  tags = {
      Name = "${var.instance_name}"
      Index = "${count.index}"
  }

  count = "${var.nb_instance}"
}
