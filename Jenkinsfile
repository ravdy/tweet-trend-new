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
                echo "-------------build started------------------"
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                echo "------------buildc completed------------------"
            }
        }

        stage("test"){
            steps{
                echo "-------------Start Unit test-------------------"
                sh 'mvn surefire-report:report'
                echo "-------------End test Compiled----------------"
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
        stage("Quality Gate"){
            steps {
                script {
                    timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
            def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
            if (qg.status != 'OK') {
            error "Pipeline aborted due to quality gate failure: ${qg.status}"
            }
                }

                }
            }
  
}
    }
}
