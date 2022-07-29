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
    filename = "./env.sh"
    file_permission = 0777
    content = <<EOF
#!/bin/bash
export RDS_HOSTNAME=${aws_db_instance.myrds.endpoint}
export RDS_USERNAME=${aws_db_instance.myrds.username}
export RDS_PASSWORD=${aws_db_instance.myrds.password}
export RDS_PORT=${aws_db_instance.myrds.port}
export REDIS_HOSTNAME=${aws_elasticache_replication_group.elasticache_cluster_group.configuration_endpoint_address}
export REDIS_PORT=${aws_elasticache_replication_group.elasticache_cluster_group.port}
EOF
}

