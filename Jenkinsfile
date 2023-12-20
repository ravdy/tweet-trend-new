pipeline {
    agent {
        node {
            label  'Maven'
        }
    }

    stages {
        stage('clone-code') {
            steps {
                git branch: 'main', url: 'https://github.com/ajuzajay/tweet-trend-new.git'
            }
        }
    }
}
