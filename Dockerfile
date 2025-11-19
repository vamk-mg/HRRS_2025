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
                git branch: 'jenkins-ci-cd', url: 'https://github.com/vamk-mg/HRRS_2025.git'
            }
        }

        stage('Debug Workspace') {
            steps {
                echo 'Listing workspace files'
                sh 'ls -al'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image...'
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    '''
                }
            }
        }
    }

    post {
        success { echo 'Pipeline finished successfully!' }
        failure { echo 'Pipeline failed!' }
    }
}
