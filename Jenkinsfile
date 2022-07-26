pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
        TF_IN_AUTOMATION      = '1'
    }

    stages {
        stage('init') {
            steps {
                sh 'terraform init'
            }
        }
        stage('plan') {
            steps {
                sh 'terraform plan --var-file dev.tfvars --auto-approve'
            }
        }
    }
}