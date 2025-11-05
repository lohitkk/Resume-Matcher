pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'resume-matcher:latest'
        CONTAINER_NAME = 'resume-matcher-container'
        TERRAFORM_DIR = 'terraform'
    }

    stages {
        stage('Checkout Repository') {
            steps {
                echo "🔄 Checking out repository..."
                git branch: 'main', url: 'https://github.com/lohitkk/Resume-Matcher.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image..."
                bat "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Run Docker Container') {
            steps {
                echo "🚀 Running Docker container..."
                // Stop and remove any old container on the same name or port
                bat 'for /f "tokens=5" %a in (\'netstat -ano ^| findstr :3000\') do taskkill /PID %a /F || echo No process found on port 3000'
                bat "docker rm -f ${CONTAINER_NAME} || echo No existing container found."
                bat "docker run -d -p 3000:3000 --name ${CONTAINER_NAME} ${DOCKER_IMAGE}"
            }
        }

        stage('Terraform Init') {
            steps {
                echo "🧩 Initializing Terraform..."
                dir("${TERRAFORM_DIR}") {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "🧮 Running Terraform plan..."
                dir("${TERRAFORM_DIR}") {
                    bat 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "🌍 Applying Terraform configuration..."
                dir("${TERRAFORM_DIR}") {
                    bat 'terraform apply -auto-approve tfplan'
                }
            }
        }
    }

    post {
        success {
            echo "✅ CI/CD pipeline completed successfully!"
        }
        failure {
            echo "❌ Build failed. Check Jenkins logs for details."
        }
        always {
            echo "🧹 Cleaning up workspace..."
        }
    }
}
