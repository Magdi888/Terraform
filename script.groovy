#!/usr/bin/env groovy

def TerraformInit() {
    sh 'terraform -chdir=Terraform init'
}

def TerraformPlan() {
    sh 'terraform -chdir=Terraform plan --var-file dev.tfvars -no-color'
}

def TerraformApply() {
    sh 'terraform -chdir=Terraform apply --var-file dev.tfvars --auto-approve -no-color'
}

def WaitbeforeConfig() {
    sh 'sleep 90'
}

def TerraformDestroy() {
    sh 'terraform -chdir=Terraform destroy --var-file dev.tfvars --auto-approve -no-color'
}

def AnsibleSlaveConfig() {
    sh 'ansible-playbook jenkins_slave_playbook.yaml'
}

def AnsiblePing() {
    sh 'ansible webserver -m ping'
}



return this