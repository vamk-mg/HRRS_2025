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
                git branch: 'jenkins-ci-cd', url: 'https://github.com/vamk-mg/HRRS_2025.git', credentialsId: 'github-creds'
            }
        }

        stage('Build Spring Boot App') {
            steps {
                echo "Building Spring Boot app using Maven Docker container..."
                sh '''
                docker run --rm \
                    -v "$PWD":/app \
                    -w /app \
                    maven:3.9.6-openjdk-17 \
                    mvn clean package -DskipTests -B
                '''
            }
        }

        stage('Build & Push Docker Image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    echo "Building and pushing Docker image..."
                    sh '''
                    # Use a Docker-in-Docker container with host Docker socket
                    docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD":/app -w /app docker:24.0.5 \
                        sh -c "
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin &&
                        docker build -t ${IMAGE_NAME}:${IMAGE_TAG} . &&
                        docker push ${IMAGE_NAME}:${IMAGE_TAG}
                        "
                    '''
                }
            }
        }

        stage('Deploy with Docker Compose') {
            steps {
                echo "Deploying containers via docker-compose..."
                sh '''
                docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD":/app -w /app docker/compose:2.17.3 \
                    up -d
                '''
            }
        }
    }

    post {
        always {
            echo "Cleaning up containers..."
            sh '''
            docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD":/app -w /app docker/compose:2.17.3 \
                down || true
            '''
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
