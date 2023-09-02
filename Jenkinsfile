pipeline {
    agent {
        node {
            label "maven"
        }
    }

    stages {
        stage('Clone-code') {
            steps {
                git branch: 'main', url: 'https://github.com/rajivsiddiqui/shankar-p2-code.git'
            }
        }
    }
}