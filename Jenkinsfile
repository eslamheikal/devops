pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/eslamheikal/devops.git'
        DOCKER_IMAGE = 'devops-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
    }

    stages {
        stage('Restore') {
            steps {
                dir('devops') {
                    sh 'dotnet restore'
                }
            }
        }

        stage('Build') {
            steps {
                dir('devops') {
                    sh 'dotnet build --configuration Release'
                }
            }
        }

        stage('Test') {
            steps {
                dir('devops') {
                    sh 'dotnet test --no-build --verbosity normal'
                }
            }
        }

        stage('Publish') {
            steps {
                dir('devops') {
                    sh 'dotnet publish -c Release -o ./publish'
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                dir('devops') {
                    script {
                        docker.build("${DOCKER_IMAGE}:${DOCKER_TAG}")
                    }
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh "docker login -u ${DOCKER_USER} -p ${DOCKER_PASS}"
                        sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_USER}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                        sh "docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_USER}/${DOCKER_IMAGE}:latest"
                        sh "docker push ${DOCKER_USER}/${DOCKER_IMAGE}:${DOCKER_TAG}"
                        sh "docker push ${DOCKER_USER}/${DOCKER_IMAGE}:latest"
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
            cleanWs()
        }
        success {
            echo 'Pipeline succeeded!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
