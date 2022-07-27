output "bastion_ip" {
    value = aws_instance.bastion.public_ip
}

output "application_ip" {
    value = aws_instance.application.private_ip
}

output "private_key" {
    value = aws_secretsmanager_secret_version.e.secret_string
}