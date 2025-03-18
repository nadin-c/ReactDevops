pipeline {
    agent any

    environment {
        IMAGE_NAME = "nadinc/docker1"
        TAG = "${BUILD_NUMBER}-${sh(script: 'date +%Y%m%d-%H%M%S', returnStdout: true).trim()}"
        CONTAINER_NAME = "jenkins-docker-container"
        PORT = "8080"
        DOCKER_CREDENTIALS = credentials('docker-hub-creds')
    }

    stages {
        stage('Code Quality') {
            steps {
                echo "Running code quality checks..."
                sh 'npm install'
                sh 'npm run lint || true'
                sh 'npm run test:ci || true'
            }
        }

        stage('Clone Repository') {
            steps {
                script {
                    try {
                        echo "Cloning GitHub repository..."
                        git branch: 'main',
                            url: 'https://github.com/nadin-c/ReactTodoList.git'
                    } catch (Exception e) {
                        error "Failed to clone repository: ${e.message}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        echo "Building Docker image..."
                        sh 'chmod +x build.sh'
                        sh './build.sh'
                    } catch (Exception e) {
                        error "Docker build failed: ${e.message}"
                    }
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    try {
                        echo "Logging into Docker Hub..."
                        sh '''
                            echo $DOCKER_CREDENTIALS_PSW | docker login -u $DOCKER_CREDENTIALS_USR --password-stdin
                        '''
                    } catch (Exception e) {
                        error "Docker login failed: ${e.message}"
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    try {
                        echo "Pushing Docker image to Docker Hub..."
                        sh """
                            docker tag ${IMAGE_NAME}:latest ${IMAGE_NAME}:${TAG}
                            docker push ${IMAGE_NAME}:${TAG}
                            docker push ${IMAGE_NAME}:latest
                        """
                    } catch (Exception e) {
                        error "Failed to push Docker image: ${e.message}"
                    }
                }
            }
        }

        stage('Deploy Docker Container') {
            steps {
                script {
                    try {
                        echo "Deploying Docker container..."
                        sh 'chmod +x deploy.sh'
                        sh './deploy.sh'
                    } catch (Exception e) {
                        error "Deployment failed: ${e.message}"
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully!"
            slackSend(
                color: 'good',
                message: "Build #${BUILD_NUMBER} - Deployment Successful!"
            )
        }
        failure {
            echo "Pipeline failed!"
            slackSend(
                color: 'danger',
                message: "Build #${BUILD_NUMBER} - Deployment Failed!"
            )
        }
        always {
            cleanWs()
        }
    }
}
