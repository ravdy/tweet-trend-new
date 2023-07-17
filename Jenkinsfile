pipeline{
    agent {
        node {
            label 'maven'
        }
    }
    
    stages{
        stage('cloning-code'){
            steps{
                git branch: 'main', url: 'https://github.com/arshadkhan098/tweet-trend.git'
            }
        }
    }
}