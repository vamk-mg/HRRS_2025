pipeline {
    agent {
        // Use Maven Docker image for building the Spring Boot app
        docker {
            image 'maven:3.9.6-openjdk-17'
            args '-v /var/run/docker.sock:/var/run/docker.sock' // allow Docker commands inside container
        }
    }

    environment {
        DOCKER_REGISTRY = 'goshtaspm'
        IMAGE_NAME = "${DOCKER_REGISTRY}/roomapp"
        IMAGE_TAG = "latest"
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'jenkins-ci-cd', 
                    url: 'https://github.com/vamk-mg/HRRS_2025.git',
                    credentialsId: 'github-creds'
            }
        }

        stage('Build Spring Boot App') {
            steps {
                echo 'Building Spring Boot app with Maven...'
                sh 'mvn clean package -DskipTests -B'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image ${IMAGE_NAME}:${IMAGE_TAG}..."
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                echo "Pushing Docker image to Docker Hub..."
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', 
                                                 usernameVariable: 'DOCKER_USER', 
                                                 passwordVariable: 'DOCKER_PASS')]) {
                    sh "echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin"
                    sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                echo "Deploying containers using docker-compose..."
                // Ensure docker-compose is used with proper path
                sh 'docker-compose up -d --build'
            }
        }
    }

    post {
        always {
            node {
                echo "Cleaning up: stopping containers if any left..."
                sh 'docker-compose down || true'
            }
        }
        success { echo 'Pipeline completed successfully!' }
        failure { echo 'Pipeline failed!' }
    }
}
