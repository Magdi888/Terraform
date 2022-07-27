resource "local_file" "inventory" {
    filename = "./hosts"
    content = <<EOF
[webserver]
${aws_instance.application.private_ip}
EOF
}