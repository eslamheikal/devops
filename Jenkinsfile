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
                    def branchName = env.BRANCH_NAME.replace('origin/', '')
                    
                    def portMapping = '5051:5000'
                    if (branchName == 'main') {
                        portMapping = '5000:5000'
                    } else if (branchName == 'staging') {
                        portMapping = '5050:5000'
                    }
                    // Build and run commands
                    sh """
                        docker build -t ${DOCKER_IMAGE}:${branchName} .
                        docker stop ${DOCKER_IMAGE}-${branchName} || true
                        docker rm ${DOCKER_IMAGE}-${branchName} || true
                        docker run -d \\
                            -p ${portMapping} \\
                            --name ${DOCKER_IMAGE}-${branchName} \\
                            ${DOCKER_IMAGE}:${branchName}
                    """
                    echo "Dockerized application running on port ${portMapping.split(':')[0]}"
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