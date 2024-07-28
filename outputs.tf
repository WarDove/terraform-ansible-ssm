output "Instance_id" {
  value = aws_instance.main.id
}

output "Instance_public_dns" {
  value = aws_instance.main.public_dns
}