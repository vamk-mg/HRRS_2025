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

        stage('Debug Workspace') {
            steps {
                echo 'Listing workspace files to verify pom.xml exists'
                sh 'ls -al $WORKSPACE'
            }
        }

        stage('Build Spring Boot App') {
            steps {
                echo 'Building Spring Boot app using Maven Docker container...'
                sh """
                    docker run --rm \
                        -v \$WORKSPACE:/app \
                        -w /app \
                        maven:3.9.6-eclipse-temurin-17 \
                        mvn clean package -DskipTests -B
                """
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building Docker image using Docker-in-Docker...'
                sh """
                    docker run --rm \
                        -v /var/run/docker.sock:/var/run/docker.sock \
                        -v \$WORKSPACE:/app \
                        -w /app \
                        docker:24.0.5 build -t ${IMAGE_NAME}:${IMAGE_TAG} .
                """
            }
        }

        stage('Push Docker Image') {
            steps {
                echo 'Pushing Docker image to Docker Hub...'
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh """
                        docker run --rm \
                            -v /var/run/docker.sock:/var/run/docker.sock \
                            docker:24.0.5 sh -c \"
                            echo \$DOCKER_PASS | docker login -u \$DOCKER_USER --password-stdin
                            docker push ${IMAGE_NAME}:${IMAGE_TAG}
                            \"
                    """
                }
            }
        }
    }

    post {
        success { echo 'Pipeline finished successfully!' }
        failure { echo 'Pipeline failed!' }
    }
}
