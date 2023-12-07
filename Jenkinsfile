pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    stages {
        stage('clone-code') {
         steps {
            git branch: 'main', url: 'https://github.com/yogeshv08/tweet-trend-new.git' 
               }    
            }
    
        }
    
}