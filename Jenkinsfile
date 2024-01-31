pipeline {
    agent {
        node{
            label 'maven'
        }
        
    }

    stages {
        stage('git clone') {
            steps {
                git branch: 'main', url: 'https://github.com/shiva2devops/java-project.git'
            }
        }
    }
}
