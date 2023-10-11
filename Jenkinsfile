pipeline {
    agent {label 'maven' }

    stages {
        stage('clone') {
            steps {
                git branch: 'main', url: 'https://github.com/Karthikpatelgp1/tweet-trend-new.git'
                }
        }
    }
}

environment {
    PATH = "/opt/apache-maven-3.9.4/bin:$PATH"
}
    stages {
        stage('Build') {
            steps {
                sh 'mvn clean deploy'
            }
        }
    }
}