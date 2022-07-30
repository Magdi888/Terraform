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
    IdentityFile "/var/jenkins_home/workspace/Terraform/key.pem"

Host ${aws_instance.application.private_ip}
    Port 22
    User ubuntu
    ProxyCommand ssh -o StrictHostKeyChecking=no -A -W %h:%p -q bastion
    StrictHostKeyChecking no
    IdentityFile "/var/jenkins_home/workspace/Terraform/key.pem"
EOF
}

resource "local_file" "docker_env" {
    filename = "./env"
    file_permission = 0777
    depends_on = [
      aws_elasticache_replication_group.elasticache_cluster
    ]
    content = <<EOF
RDS_HOSTNAME=${aws_db_instance.myrds.address}
RDS_USERNAME=${aws_db_instance.myrds.username}
RDS_PASSWORD=${aws_db_instance.myrds.password}
RDS_PORT=${aws_db_instance.myrds.port}
REDIS_HOSTNAME=${aws_elasticache_replication_group.elasticache_cluster_group.configuration_endpoint_address}
REDIS_PORT=${aws_elasticache_replication_group.elasticache_cluster_group.port}
EOF
}

