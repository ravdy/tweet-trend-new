pipeline {
    agent {
        node {
            label "maven"
        }
    }
environment {
    PATH = "/opt/apache-maven-3.9.4/bin:$PATH"
}
  

    stages {
        stage('build') {
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage('SonarQube analysis') {
        environment{
            scannerHome = tool 'rajiv1-sonar-scanner'
        }
            steps{
            withSonarQubeEnv('rajiv1-sonarqube-server') { // If you have configured more than one global server connection, you can specify its name
                sh "${scannerHome}/bin/sonar-scanner"
            }
    }
  }
    }
}
