output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "kafka_private_ips" {
  value = [
    aws_instance.kafka1.private_ip,
    aws_instance.kafka2.private_ip,
    aws_instance.kafka3.private_ip
  ]
}
