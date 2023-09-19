pipeline {
 agent {
     node {
         label 'Maven'
     }
 }
    
    
    stages {
        stage('clone-code') {
            steps {
              git branch: 'main', url: 'https://github.com/Boaz-code-max/tweet-trend-boaz.git'  
            }
        }
    }
}