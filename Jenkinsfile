pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'resume-matcher:latest'
        TERRAFORM_DIR = 'terraform'  // folder containing terraform .tf files
    }

    stages {
        stage('Checkout Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/lohitkk/Resume-Matcher.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                bat "docker build -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Run Docker Container') {
            steps {
                echo "Running Docker container..."
                // Stop old container if exists
                bat 'docker rm -f resume-matcher-container || echo "No existing container found."'
                // Run new one
                bat 'docker run -d -p 3000:3000 --name resume-matcher-container resume-matcher:latest'
            }
        }

        stage('Terraform Init') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir("${TERRAFORM_DIR}") {
                    bat 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
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
            echo "❌ Build failed. Check the logs for details."
        }
    }
}
