pipeline {
    agent any

    environment {
        IMAGE_NAME = "goshtaspm/roomapp"
        TAG        = "${env.BUILD_NUMBER}"
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
                echo 'Verifying Docker and Docker Compose inside Jenkins container...'
                sh '''
                    docker --version
                    docker compose version || true
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building room-app Docker image using Docker Compose...'
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
                    echo 'Tagging and pushing room-app Docker image...'
                    sh '''
                        docker tag room-app:latest $DOCKER_HUB_USER/roomapp:${TAG}
                        docker tag room-app:latest $DOCKER_HUB_USER/roomapp:latest

                        docker push $DOCKER_HUB_USER/roomapp:${TAG}
                        docker push $DOCKER_HUB_USER/roomapp:latest
                    '''
                }
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace and logging out from Docker...'
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
