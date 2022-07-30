def gv
pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('aws_access_key_id')
        AWS_SECRET_ACCESS_KEY = credentials('aws_secret_access_key')
    }

    stages {
        stage('start') {
            steps {
                script {
                     gv = load 'script.groovy'
                }
            }
        }
        stage('init') {
            steps {
                script {
                    gv.TerraformInit()
                }
            }
        }
        stage('plan') {
            steps {
                script {
                    gv.TerraformPlan()
                }
            }
        }
        stage('apply') {
            steps {
                script {
                    gv.TerraformApply()
                }
            }
        }
        stage('wait for start up infrastructure') {
            steps {
                script {
                    gv.WaitbeforeConfig()
                }
            }
        }
        stage('ping') {
            steps {
                script {
                    gv.AnsiblePing()
                }
            }
        }
        stage('slave config') {
            steps {
                script {
                    gv.AnsibleSlaveConfig()
                }
            }
        }
        
        
    }

}
