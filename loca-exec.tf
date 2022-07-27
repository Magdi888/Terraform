resource "null_resource" "example1" {
  provisioner "local-exec" {
    command = "echo ${application_ip} >> ./hosts"
  }
}

