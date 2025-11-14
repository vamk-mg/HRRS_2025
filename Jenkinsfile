pipeline {
    agent {
        // Use Maven container for build stage
        docker { image 'maven:3.9.6-openjdk-17' }
    }

    environment {
        DOCKER_REGISTRY = 'goshtaspm'
        IMAGE_NAME = "${DOCKER_REGISTRY}/roomapp"
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "Checking out code..."
                git branch: 'jenkins-ci-cd', url: 'https://github.com/vamk-mg/HRRS_2025.git', credentialsId: 'github-creds'
            }
        }

        stage('Build Spring Boot App') {
            steps {
                echo "Building Spring Boot app with Maven..."
                sh 'mvn clean package -DskipTests -B'
            }
        }

        stage('Build Docker Image') {
            agent any // run on host to access Docker
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            agent any
            steps {
                echo "Logging in to Docker Hub and pushing image..."
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy with Docker Compose') {
            agent any
            steps {
                echo "Deploying application using Docker Compose..."
                sh "docker-compose down || true"
                sh "docker-compose up -d --build"
            }
        }
    }

    post {
        always {
            echo "Cleaning up: stopping containers if any left..."
            sh "docker-compose down || true"
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
