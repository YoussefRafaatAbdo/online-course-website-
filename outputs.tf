# ============================================
# outputs.tf - Values printed after terraform apply
# ============================================

output "instance_public_ip" {
  description = "Public IP of your EC2 instance — paste into browser to see your site"
  value       = aws_instance.ecourses_server.public_ip
}

output "instance_public_dns" {
  description = "Public DNS name (alternative to IP)"
  value       = aws_instance.ecourses_server.public_dns
}

output "website_url" {
  description = "Direct link to your deployed website"
  value       = "http://${aws_instance.ecourses_server.public_ip}"
}

output "ssh_command" {
  description = "SSH command to connect to your server"
  value       = "ssh -i ~/.ssh/${var.key_name}.pem ec2-user@${aws_instance.ecourses_server.public_ip}"
}

output "instance_id" {
  description = "EC2 instance ID (use in AWS Console)"
  value       = aws_instance.ecourses_server.id
}
