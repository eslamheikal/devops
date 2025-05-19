pipeline {
    agent any

    environment {
        GITHUB_REPO = 'https://github.com/eslamheikal/devops.git'
    }

    stages {
        stage('Clone Repository') {
            steps {
                withCredentials([string(credentialsId: 'github-token', variable: 'GITHUB_TOKEN')]) {
                    sh 'git clone https://$GITHUB_TOKEN@github.com/eslamheikal/devops.git'
                    dir('devops') {
                        echo "Code cloned"
                    }
                }
            }
        }

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
    }

    post {
        always {
            echo 'Pipeline completed.'
        }
    }
}
