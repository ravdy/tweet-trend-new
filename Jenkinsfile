pipeline {
    agent {
        node{
            label 'maven'
        }
        
    }

    stages {
        stage('build') {
            steps {
                sh 'mvn clean deploy -Dmaven.test.skip=true'
                }
            }

        stage{
            steps('unit test') {
                echo "--------unit test started-----------"
                sh 'mvn surefire-report:report'
                echo "--------unit test completed-----------"
                }
            }

        stage('SonarQube analysis') {
            environment{
                scannerHome = tool 'sonar-scanner';
            }
            steps{
                withSonarQubeEnv('sonarqube-server') { // If you have configured more than one global server connection, you can specify its name
                sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }

        stage("Quality Gate"){
            steps{
                script{
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