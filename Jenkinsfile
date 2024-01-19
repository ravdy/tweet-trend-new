pipeline {
    agent {
        node {
            label 'maven'
        }   
    }
    environment {
        PATH = "/opt/apache-maven-3.9.6/bin:$PATH"
        JAVA_HOME = "/usr/lib/jvm/java-11-openjdk-amd64"  // Adjust the path based on your system
    }
    stages {
        stage("Build") {
            steps { 
                script {
                    sh 'mvn clean deploy'
                }
            }
        }

        // stage('SonarQube Analysis') {
        //     environment {
        //         scannerHome = tool 'valaxy-sonar-scanner'
        //     }
        //     steps {
        //         script {
        //             withSonarQubeEnv('valaxy-sonarqube-server') {
        //                 sh "${scannerHome}/bin/sonar-scanner"
        //             }
        //         }
        //     }
        // }
    }
}
