#!/usr/bin/env groovy

def TerraformInit() {
    sh 'terraform init'
}

def TerraformPlan() {
    sh 'terraform plan --var-file dev.tfvars -no-color'
}

def TerraformApply() {
    sh 'terraform apply --var-file dev.tfvars --auto-approve -no-color'
}

def TerraformDestroy() {
    sh 'terraform destroy --var-file dev.tfvars --auto-approve -no-color'
}

def AnsibleSlaveConfig() {
    sh 'ansible-playbook jenkins_slave.yaml'
}

def AnsiblePing() {
    sh 'ansible webserver -m ping'
}

def BuildImage() {
    withCredentials([usernamePassword(credentialsId :'DockerHub',usernameVariable :'USER',passwordVariable :'PASSWORD')]){
       sh 'docker build -t amagdi888/my-repo:NodeJS-rds-redis -f dockerfile .'
       sh 'echo $PASSWORD | docker login -u $USER --password-stdin'
       sh 'docker push amagdi888/my-repo:NodeJS-rds-redis'
    }

}


def Deploy() {
    sh 'docker run -p 3000:3000 -d amagdi888/my-repo:NodeJS-rds-redis'
}

return this