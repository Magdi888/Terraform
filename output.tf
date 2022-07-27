output "bastion_ip" {
    value = aws_instance.bastion.public_ip
}

output "application_ip" {
    value = aws_instance.application.private_ip
}

output "private_key" {
    value = tls_private_key.mykey.private_key_pem
    sensitive = true
}