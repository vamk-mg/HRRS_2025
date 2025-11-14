pipeline {
    agent any

    environment {
        DOCKER_REGISTRY = 'goshtaspm'                   // Your Docker Hub username
        IMAGE_NAME = "${DOCKER_REGISTRY}/roomapp"       // Full image name
        IMAGE_TAG = "latest"
    }

    stages {

        stage('Build Spring Boot App') {
            agent {
                // Use Maven Docker image to build the app
                docker {
                    image 'maven:3.9.6-openjdk-17'
                    args '-v /root/.m2:/root/.m2 -v $WORKSPACE:/app'
                }
            }
            steps {
                dir('/app') {
                    echo "Building Spring Boot app with Maven inside Docker..."
                    sh 'mvn clean package -DskipTests -B'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Logging in to Docker Hub and pushing image..."
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                script {
                    // Use docker compose on host
                    def compose = sh(script: 'which docker-compose || which docker', returnStdout: true).trim()
                    sh "${compose} down || true"
                    sh "${compose} up -d --build"
                }
            }
        }
    }

    post {
        always {
            echo "Cleaning up: stopping containers if any left..."
            def compose = sh(script: 'which docker-compose || which docker', returnStdout: true).trim()
            sh "${compose} down || true"
        }
        success {
            echo "Pipeline completed successfully!"
        }
        failure {
            echo "Pipeline failed!"
        }
    }
}
