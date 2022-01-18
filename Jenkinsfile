pipeline {
   agent any
   stages {
        stage('Checkout') {
            steps {
            git branch: 'main', url: 'https://github.com/robertasolimandonofreo/ecs-terraform-nginx.git'
                }
            }
        stage('Build DockerHub') {
            steps {
            dir("nginx"){  
                sh "chmod +x -R push.sh" 
                sh "./push.sh"
                }
            }
        }
        stage('Terraform Apply') {
            steps {
            dir("terraform"){  
                sh """
                    terraform init
                    terraform plan
                    terraform apply --auto-approve
                """
                    }               
                }
            }   
        stage('Grafana UP') {
            steps {
            dir("grafana"){  
                sh "docker-compose up"
                    }               
                }
            } 
        }
    }   
