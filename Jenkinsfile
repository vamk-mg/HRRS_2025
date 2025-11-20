pipeline {
    agent any

    environment {
        IMAGE_NAME = "room-app" // base image name
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
                    docker compose version || true
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
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-username',
                    usernameVariable: 'DOCKER_HUB_USER',
                    passwordVariable: 'DOCKER_HUB_PSW'
                )]) {
                    echo 'Logging in to Docker Hub securely...'
                    sh 'echo $DOCKER_HUB_PSW | docker login -u $DOCKER_HUB_USER --password-stdin'
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'docker-hub-username',
                    usernameVariable: 'DOCKER_HUB_USER',
                    passwordVariable: 'DOCKER_HUB_PSW'
                )]) {
                    echo 'Tagging and pushing Docker image...'
                    sh '''
                        docker tag room-app:latest $DOCKER_HUB_USER/room-app:latest
                        docker push $DOCKER_HUB_USER/room-app:latest
                    '''
                }
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
