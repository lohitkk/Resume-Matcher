pipeline {
    agent any

    environment {
        NODE_HOME = "C:\\Program Files\\nodejs"
        PATH = "${env.NODE_HOME};${env.PATH}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                echo "Cloning repository..."
                git branch: 'main', url: 'https://github.com/lohitkk/Resume-Matcher.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "Installing npm packages..."
                bat 'npm install'
            }
        }

        stage('Build Project') {
            steps {
                echo "Building Next.js app..."
                bat 'npm run build'
            }
        }

        stage('Run Project') {
            steps {
                echo "Starting server..."
                bat 'npm start'
            }
        }
    }

    post {
        success {
            echo "✅ Build completed successfully!"
        }
        failure {
            echo "❌ Build failed! Check console output for errors."
        }
    }
}
