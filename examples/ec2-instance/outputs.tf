output "private_node_ip" {
  description = "pribate ip of EC2 instance"
  value       = aws_instance.private_node.private_ip
}