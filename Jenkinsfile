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
                bat "docker build -t %DOCKER_IMAGE% ."
            }
        }

        stage('Run Docker Container') {
            steps {
                echo "🚀 Running Docker container..."
                bat '''
                for /f "tokens=5" %%a in ('netstat -ano ^| find ":3000"') do taskkill /PID %%a /F
                echo No process found on port 3000 (if none were killed)
                docker rm -f resume-matcher-container || echo "No old container to remove"
                docker run -d -p 3000:3000 --name resume-matcher-container resume-matcher:latest
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                echo "🧩 Initializing Terraform..."
                dir("%TERRAFORM_DIR%") {
                    bat 'terraform init'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                echo "🧮 Running Terraform plan..."
                dir("%TERRAFORM_DIR%") {
                    bat '''
                    terraform plan ^
                      -var="aws_access_key=%AWS_ACCESS_KEY%" ^
                      -var="aws_secret_key=%AWS_SECRET_KEY%" ^
                      -var="instance_type=t3.micro" ^
                      -out=tfplan
                    '''
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                echo "🌍 Applying Terraform configuration..."
                dir("%TERRAFORM_DIR%") {
                    bat '''
                    terraform apply ^
                      -var="aws_access_key=%AWS_ACCESS_KEY%" ^
                      -var="aws_secret_key=%AWS_SECRET_KEY%" ^
                      -var="instance_type=t3.micro" ^
                      -auto-approve tfplan
                    '''
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
