pipeline {
    agent {
        node {
            label 'maven'
        }
    }

    stages {
        stage('clone -code') {
            steps {
                git branch: 'main', credentialsId: 'maven-server', url: 'https://github.com/balli-krishna786/tweet-trend-new.git'
            }
        }
    }
}
