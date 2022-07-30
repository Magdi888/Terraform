# AWS Infrastructure Pipeline

## Description:
 Using Jenkins pipeline, Provision infrastructure consist of  VPC with public and private subnets.
 The public subnet has a bastion VM and the private subnets has a private VM, configured with Ansible to be a Jenkins Slave.
 Deploy a Node.js app on it which connects to an RDS and an ElastiCache Redis instances in another private subnet.
 Expose the NodeJS application using application load balancer.
 
 
 
 # Steps:
 
 ## Setup Jenkins Server:
 
 - Run the following:
 ```
  # Docker image fom jenkins with docker and terraform and ansible
   docker build -f ./jenkins_with_tools -t jenkins_with_tools
  # Run docker container
   docker run -d  -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock -v jenkins_home:/var/jenkins_home jenkins_with_tools
 ```
 - Visit the Jenkins web page:
 ```
  http://localhost:8080
 ```
 ## Add AWS credentials to Jenkins server:
 - Create two credentials with type secret text:
   - One for AWS_ACCESS_KEY_ID and set it with your account access key id
   - The other one AWS_SECRET_ACCESS_KEY and set it with your account secret access key 
 ## Define AWS credentials in the pipeline:
  Define them as environmental variables in the pipeline, Terraform will use them.
   ```
    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
    }
   ```
 ## Provision infrastructure on AWS with Terraform.

 - Create Bucket to save Terraform state file.
 - Set the bucket name in backend.tf file.
 - Create DynamoDB table to lock terraform state.
 - Create Pipeline and attach this github to it
 ![image](https://user-images.githubusercontent.com/91858017/181934216-9e98e425-74e2-449d-b85d-41cf7b970d2a.png)
 
 ### Infrastructure
 
 ![Untitled Diagram](https://user-images.githubusercontent.com/91858017/181926385-7f7e9f78-67a9-4250-b623-5431e721887b.jpg)
 
 
 ### Extract ssh private key:
  By terraform extract ssh private key by creating local_file resource:
   ```
   resource "local_file" "private_key" {
    filename = "/var/jenkins_home/workspace/Terraform/key.pem"
    file_permission = 0400
    content = <<EOF
${tls_private_key.mykey.private_key_pem}
EOF
}
   ```
   
 ### Configure ssh jump server on Jenkins Server:
  By creating local_file resource to configure the bastion host as a jump server,
  So i can run ansible configuration on the application VM (Private VM)
  
   ```
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
   ```
 
 ### Creating Inventory file for ansible:
  By creating local_file resource and extract the privateIp of application vm
   ```
   resource "local_file" "inventory" {
    filename = "/var/jenkins_home/workspace/Terraform/hosts"
    content = <<EOF
[application]
${aws_instance.application.private_ip}
EOF
}
   ```
   
 ### Creating ENV file for the NodeJS App:
  By creating local_file resource and extract the environmental variables used in NodeJs App.
   ```
   resource "local_file" "docker_env" {
    filename = "/var/jenkins_home/workspace/Terraform/env"
    file_permission = 0777
    depends_on = [
      aws_elasticache_replication_group.elasticache_cluster
    ]
    content = <<EOF
RDS_HOSTNAME=${aws_db_instance.myrds.address}
RDS_USERNAME=${aws_db_instance.myrds.username}
RDS_PASSWORD=${aws_db_instance.myrds.password}
RDS_PORT=${aws_db_instance.myrds.port}
REDIS_HOSTNAME=${aws_elasticache_replication_group.elasticache_cluster.primary_endpoint_address}
REDIS_PORT=${aws_elasticache_replication_group.elasticache_cluster.port}
EOF
}
   ```
  And copy that file by ansible to slave node
   ```
   - name: Copy ENV file
     ansible.builtin.copy:
      src: /var/jenkins_home/workspace/Terraform/env
      dest: /home/ubuntu/env
      owner: ubuntu
      group: ubuntu
      mode: '0744'
   ```
 
 ## Configure Private VM as Jenkins slave node:
  - The pipeline used ansible to set the configuration on the Private VM to act as slave node [Ansible Playbook](https://github.com/Magdi888/Terraform/blob/master/jenkins_slave_playbook.yaml).
  - From Jenkins server console go to (Manage Jenkins -> Manage nodes and clouds -> New node)
     - File the fields: 
       - In Remote root directory write the directory you create with ansible to work as jenkins directory.
       - Set Label to the node.
       - In Usage select (Only build jobs with label expressions matching this node).
       - In Launch method select(Launch agent via execution of command on the controller),
       - In Launch command: ssh [private host name] java -jar /path/to/agent.jar [agent.jar](https://github.com/Magdi888/Terraform/tree/master/slaveAgent)

 ## Sent notification to slack after the success of the pipeline:
  ```
   post {
            success {
                slackSend (message:"Infrastucture provisioned successfully - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
            }
            failure {
                slackSend (message:"Infrastucture provisioned  - ${env.JOB_NAME} ${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)")
            }
        }
  ```
  
### Triger another pipleline to build and deploy the code on the slave jenkins node [CI/CD Pipeline](https://github.com/Magdi888/AWS-CI-CD-Pipeline-Nodejs_app)
