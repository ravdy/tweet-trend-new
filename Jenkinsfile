pipeline {
    agent {
        label 'maven'
    }

    stages {
        stage('Clone Repository') {
            steps {
                git 'https://github.com/EngrAdewale/tweet-trend-new.git'
            }
        }

        // Add more stages for your build and deployment steps here
    }
}
