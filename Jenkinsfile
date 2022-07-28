def gv
pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
    }

    stages {
        stage('init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('plan') {
            steps {
                sh 'terraform plan --var-file dev.tfvars'
            }
        }
        stage('apply') {
            steps {
                sh 'terraform apply --var-file dev.tfvars --auto-approve -no-color'
            }
        }
        stage('ping') {
            steps {
                sh 'ansible webserver -m ping'
            }
        }
        stage('slave config') {
            steps {
                sh 'ansible-playbook jenkins_slave.yaml'
            }
        }
        stage('start') {
            steps {
                script {
                     gv = load 'script.groovy'
                }
            }
        }
        stage('build image') {
            steps {
                script {
                    gv.BuildImage()
                }
                
            }
        }
        stage('deploy') {
            agent { node { label 'ec2-slave' } }
            steps {
                script {
                    gv.Deploy()
                }
                
            }
        }
    }

}
