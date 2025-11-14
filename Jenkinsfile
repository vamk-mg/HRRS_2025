pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'goshtaspm'                   // Your Docker Hub username
        IMAGE_NAME = "${DOCKER_REGISTRY}/roomapp"       // Full image name
        IMAGE_TAG = "latest"
        DOCKER_COMPOSE = '/usr/local/bin/docker-compose' // Path to docker-compose on the agent
    }

    stages {

        stage('Build Spring Boot App') {
            steps {
                script {
                    echo "Building Spring Boot app with Maven..."
                    sh 'mvn clean package -DskipTests -B'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    echo "Building Docker image..."
                    sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    echo "Logging in to Docker Hub and pushing image..."
                    withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                    }
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                script {
                    echo "Deploying application using Docker Compose..."
                    sh "$DOCKER_COMPOSE down || true"
                    sh "$DOCKER_COMPOSE up -d --build"
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up: stopping containers if any left..."
            sh "$DOCKER_COMPOSE down || true"
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}