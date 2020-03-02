output instances_ids {
  value = aws_instance.frontend.*.id
}