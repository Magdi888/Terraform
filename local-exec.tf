resource "local_file" "inventory" {
    filename = "./hosts"
    content = <<EOF
[webserver]
${aws_instance.application.private_ip}
EOF
}


resource "local_file" "private_key" {
    filename = "./key.pem"
    file_permission = 0400
    content = <<EOF
${tls_private_key.mykey.private_key_pem}
EOF
}


resource "local_file" "sshconfig" {
    filename = "/root/.ssh/config"
    depends_on = [local_file.private_key]
    content = <<EOF
Host bastion
    User ubuntu
    HostName ${aws_instance.bastion.public_ip}
    IdentityFile "./key.pem"

Host ${aws_instance.application.private_ip}
    Port 22
    User ubuntu
    ProxyCommand ssh -o StrictHostKeyChecking=no -A -W %h:%p -q bastion
    StrictHostKeyChecking no
    IdentityFile "./key.pem"
EOF
}


