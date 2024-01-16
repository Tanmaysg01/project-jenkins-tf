pipeline {
    agent any
    
    stages {
        stage('checkout') {
            steps {
                script {
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/Tanmaysg01/project-jenkins-tf.git']])
                }
            }
        }
        stage('init') {
            steps {
                sh "terraform init"
            }
        }
        
        stage('plan') {
            steps {
                sh "terraform plan"
            }
        }
        stage('apply') {
            steps {
                sh "terraform apply --auto-approve"
            }
        }
    }
}