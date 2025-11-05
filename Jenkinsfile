pipeline {
    agent any

    environment {
        DOCKER_HOST = 'npipe:////./pipe/docker_engine'
        DOCKER_CLI_EXPERIMENTAL = 'enabled'
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
                bat '''
                    cd terraform
                    terraform init
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "☁ Deploying via Terraform..."
                bat '''
                    cd terraform
                    terraform apply -auto-approve
                '''
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Build failed! Check Docker connection or Terraform.'
        }
    }
}
