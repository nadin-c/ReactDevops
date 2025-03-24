pipeline {
    agent any

    environment {
        IMAGE_NAME = "nadinc/guvi_final_prj"
        TAG = "${BUILD_NUMBER}-${sh(script: 'date +%Y%m%d-%H%M%S', returnStdout: true).trim()}"
        CONTAINER_NAME = "jenkins-docker-container"
        PORT = "8080"
        DOCKER_CREDENTIALS = credentials('docker-hub-creds')
        NODE_ENV = 'production'
        BUILD_OUTPUT_DIR = 'build'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git url: 'https://github.com/nadin-c/ReactDevops.git', branch: 'main'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t $DOCKER_HUB_REPO:latest .'
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh 'docker push $DOCKER_HUB_REPO:latest'
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline succeeded!'
            echo 'Docker image pushed to Docker Hub!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
