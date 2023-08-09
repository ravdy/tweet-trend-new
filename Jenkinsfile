pipeline {
    agent any
 
    stages {
            stage('build') {
            steps {
                sh 'pwd'
                sh 'ls -l'
                sh 'mvn clean deploy'
                  }
        }
    }
}
