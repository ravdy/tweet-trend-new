pipeline {
    agent {
        node {
            label 'maven'
        }   
    }
    environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
        JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64"
    }
    stages {
        stage("Build") {
            steps { 
                sh 'mvn clean deploy'
            }
        }

        stage('SonarQube Analysis') {
            environment {
                scannerHome = tool 'valaxy-sonar-scanner'
            }
            steps {
                withSonarQubeEnv('valaxy-sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}
