pipeline {
    agent any

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


        // Terraform Apply stage removed or disabled
    }

    post {
        success {
            echo '✅ Pipeline completed successfully (Terraform apply skipped).'
        }
        failure {
            echo '❌ Build failed — check logs.'
        }
    }
}
