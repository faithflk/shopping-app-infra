output "instance_region" {
  value = aws_instance.frontend.availability_zone
}

output "instance_id" {
  value = aws_instance.frontend.id
}
