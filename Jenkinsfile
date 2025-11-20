pipeline {
    agent any

    environment {
        DOCKER_HUB_USER = credentials('docker-hub-username')
        DOCKER_HUB_PSW  = credentials('docker-hub-password')
        IMAGE_NAME      = "${DOCKER_HUB_USER}/room-app"
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Verify Docker Installation') {
            steps {
                echo 'Checking Docker and Docker Compose availability...'
                sh '''
                    docker --version
                    docker compose version
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image using Docker Compose v2...'
                sh '''
                    export DOCKER_BUILDKIT=1
                    docker compose build
                '''
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo 'Logging in to Docker Hub...'
                sh """
                    echo "$DOCKER_HUB_PSW" | docker login -u "$DOCKER_HUB_USER" --password-stdin
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Tagging and pushing Docker image...'
                sh """
                    docker tag room-app:latest ${IMAGE_NAME}:latest
                    docker push ${IMAGE_NAME}:latest
                """
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace and logging out...'
            sh 'docker logout || true'
            cleanWs()
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
