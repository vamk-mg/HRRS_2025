pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'goshtaspm'
        IMAGE_NAME = "${DOCKER_REGISTRY}/roomapp"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out Jenkins branch...'
                git branch: 'jenkins-ci-cd', url: 'https://github.com/vamk-mg/HRRS_2025.git'
            }
        }

        stage('Build Docker Image using Docker Compose') {
            steps {
                echo 'Building Docker image using Docker Compose...'
                // Ensure docker-compose.yml is in your repo root
                sh '''
                    docker-compose build
                '''
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker-compose push
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline finished successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
