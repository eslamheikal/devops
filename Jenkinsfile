pipeline {
    agent any

    stages {
        stage('Build Docker Image') {
            steps {
                sh 'docker build -t my-dotnet-app .'
            }
        }
        stage('Run Tests') {
            steps {
                sh 'docker run --rm my-dotnet-app dotnet test --no-build'
            }
        }
    }
}
