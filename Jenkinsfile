pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    environment {
        PATH="$PATH:/home/ubuntu/apache-maven-3.9.4/bin"
    }
    stages {
        stage("build") {
            steps {
                sh 'mvn clean deploy'
            }
        }
    }
}
