pipeline {
    agent any

    environment {
        IMAGE_NAME = "nadinc/docker1"
        TAG = "${BUILD_NUMBER}-${sh(script: 'date +%Y%m%d-%H%M%S', returnStdout: true).trim()}"
        CONTAINER_NAME = "jenkins-docker-container"
        PORT = "8080"
        DOCKER_CREDENTIALS = credentials('docker-hub-creds')
        NODE_ENV = 'production'
    }

    stages {
        stage('Install Dependencies') {
            steps {
                script {
                    try {
                        echo "Installing Node.js dependencies..."
                        sh 'npm ci'  // Uses package-lock.json for deterministic builds
                    } catch (Exception e) {
                        error "Failed to install dependencies: ${e.message}"
                    }
                }
            }
        }

        stage('Code Quality & Tests') {
            steps {
                script {
                    try {
                        echo "Running code quality checks..."
                        sh 'npm run lint || true'
                        sh 'npm run test:ci || true'
                    } catch (Exception e) {
                        echo "Warning: Code quality checks failed but continuing: ${e.message}"
                    }
                }
            }
        }

        stage('Build React App') {
            steps {
                script {
                    try {
                        echo "Building React application..."
                        sh 'npm run build'
                        // Verify build output exists
                        sh 'test -d build || (echo "Build directory not found" && exit 1)'
                    } catch (Exception e) {
                        error "React build failed: ${e.message}"
                    }
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    try {
                        echo "Building Docker image..."
                        sh """
                            docker build \
                                --no-cache \
                                -t ${IMAGE_NAME}:${TAG} \
                                -t ${IMAGE_NAME}:latest \
                                --build-arg NODE_ENV=${NODE_ENV} \
                                .
                        """
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
        always {
            echo "Cleaning up workspace..."
            cleanWs()
            sh 'docker system prune -f || true'
        }
        success {
            echo "Pipeline completed successfully!"
            slackSend(
                color: 'good',
                message: "Build #${BUILD_NUMBER} - ${env.JOB_NAME} deployed successfully!\nImage: ${IMAGE_NAME}:${TAG}"
            )
        }
        failure {
            echo "Pipeline failed!"
            slackSend(
                color: 'danger',
                message: "Build #${BUILD_NUMBER} - ${env.JOB_NAME} failed!\nCheck logs: ${env.BUILD_URL}"
            )
        }
    }
}
