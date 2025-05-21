pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'devops'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Checking out the code...'
            }
        }

        stage('Build') {
            steps {
                script {
                    sh 'dotnet restore'
                    sh 'dotnet build --configuration Release -p:Version=1.0.0'
                    echo 'Building the application...'
                }
            }
        }

        stage('Test') {
            steps {
                script {
                    sh 'dotnet test --no-restore --configuration Release'
                    echo 'Testing the application...'
                }
            }
        }

        stage('Dockerize') {
            steps {
                script {
                    def port = '5051'
                    if (env.BRANCH_NAME == 'main') {
                        port = '5000'
                    } else if (env.BRANCH_NAME == 'staging') {
                        port = '5050'
                    }

                    sh 'docker build -t ${DOCKER_IMAGE} .'
                    sh 'docker run -d -p ${port}:${port} ${DOCKER_IMAGE} --name ${DOCKER_IMAGE}-${env.BRANCH_NAME} ${DOCKER_IMAGE}:${env.BRANCH_NAME}'
                    echo 'Dockerizing the application...'
                }
            }
        }
    }

    post {
        always {
            echo 'Build, Test, and Publish completed.'
        }
    }
}

