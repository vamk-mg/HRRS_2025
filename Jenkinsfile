pipeline {
    agent any

    environment {
        DOCKER_HUB_CREDENTIALS = credentials('docker-hub-creds')
        IMAGE_NAME = "goshtaspm/roomapp"
        IMAGE_TAG = "latest"
        DOCKER_BUILDKIT = "1" // Enable BuildKit for docker-compose
    }

    stages {
        stage('Checkout SCM') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image using Docker Compose...'
                sh '''
                    export DOCKER_BUILDKIT=1
                    docker-compose build
                '''
            }
        }

        stage('Login to Docker Hub') {
            steps {
                echo 'Logging in to Docker Hub...'
                sh '''
                    echo $DOCKER_HUB_CREDENTIALS_PSW | docker login -u $DOCKER_HUB_CREDENTIALS_USR --password-stdin
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                sh '''
                    docker tag room-app $IMAGE_NAME:$IMAGE_TAG
                    docker push $IMAGE_NAME:$IMAGE_TAG
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            sh 'docker logout || true'
        }

        success {
            echo 'Pipeline completed successfully!'
        }

        failure {
            echo 'Pipeline failed!'
        }
    }
}
