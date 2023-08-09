pipeline {
    agent any
 
    stages {
          stage('CLONE-CODE') {
            steps {
                
                git branch: 'main', url: 'https://github.com/venkat44488/tweet-trend-new.git'
                sh 'pwd'
                sh 'ls -l'
                  }
        }
            stage('build') {
            steps {
                sh 'pwd'
                sh 'ls -l'
                sh 'mvn clean deploy'
                  }
        }
    }
}
