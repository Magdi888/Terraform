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
        
        stage('build image') {
            steps {
                script {
                    gv.BuildImage()
                }
                
            }
        }
        // stage('deploy') {
        //     agent { node { label 'ec2-slave' } }
        //     steps {
        //         script {
        //             gv.Deploy()
        //         }
                
        //     }
        // }
        // stage('destroy') {
        //     steps {
        //         script {
        //             gv.TerraformDestroy()
        //         }
        //     }
        // }
    }

}
