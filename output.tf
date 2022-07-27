output "bastion_ip" {
    value = aws_instance.bastion.public_ip
}

output "application_ip" {
    value = aws_instance.application.private_ip
}