def getBranchName() {
    return env.BRANCH_NAME.replace('origin/', '')
}

def getPort(branchName) {
    def portMapping = '5051:5000'

    if (branchName == 'main') {
        portMapping = '5000:5000'
    } else if (branchName == 'staging') {
        portMapping = '5050:5000'
    }

    return portMapping;             
}

pipeline {
    agent any

    environment {
        DOCKER_IMAGE = 'devops'
    }

    parameters {
        string(name: 'DEPLOY_ENV', defaultValue: 'develop', description: 'Deployment environment')
    }

    stages {
        stage('Parameters Test') {
            steps {
                echo "Deploying to environment: ${params.DEPLOY_ENV}"
                script {
                    if (params.DEPLOY_ENV == 'staging') {
                        echo "Performing staging deployment test"
                    }
                }
            }
        }

        stage('Run in Stage Only') {
            when {
                branch 'staging'
            }
            steps {
                echo "Running in stage only..."
            }
        }

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
                    def branchName = getBranchName()
                    
                    echo "Branch Name is ${branchName}"

                    def portMapping = getPort(branchName)
                    
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