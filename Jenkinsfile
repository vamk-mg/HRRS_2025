pipeline {
    agent any
    environment {
        DOCKER_REGISTRY = 'goshtaspm'
        IMAGE_NAME = "${DOCKER_REGISTRY}/room-app"
        IMAGE_TAG = "latest"
        SWARM_STACK_NAME = 'room-stack'
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'jenkins-ci-cd2', url: 'https://github.com/vamk-mg/HRRS_2025.git'
            }
        }
        stage('Build') {
            steps {
                sh './mvnw clean package -DskipTests'
            }
        }
        stage('Build Docker Image') {
            steps {
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }
        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }
        stage('Deploy to Swarm') {
            steps {
                sh "docker stack deploy -c docker-compose.yml ${SWARM_STACK_NAME}"
            }
        }
    }
    post {
        success { echo 'Deployment successful!' }
        failure { echo 'Pipeline failed!' }
    }
}