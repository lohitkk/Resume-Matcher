pipeline {
    agent any

    parameters {
        booleanParam(name: 'RUN_TERRAFORM_APPLY', defaultValue: false, description: 'Run Terraform Apply stage?')
    }

    environment {
        DOCKER_HOST = 'npipe:////./pipe/docker_engine'
    }

    stages {
        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image..."
                bat 'docker build -t resume-matcher:latest .'
            }
        }

        stage('Run Docker Container') {
            steps {
                echo "🚀 Running Docker container..."
                bat '''
                    docker rm -f resume-matcher-container || echo "No old container"
                    docker run -d -p 3000:3000 --name resume-matcher-container resume-matcher:latest
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                echo "🧩 Initializing Terraform..."
                dir('terraform') {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "🧠 Generating Terraform plan..."
                dir('terraform') {
                    bat 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            when {
                expression { return params.RUN_TERRAFORM_APPLY }
            }
            steps {
                echo "☁ Deploying with Terraform..."
                dir('terraform') {
                    bat 'terraform apply -auto-approve'
                }
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully.'
        }
        failure {
            echo '❌ Build failed.'
        }
    }
}
