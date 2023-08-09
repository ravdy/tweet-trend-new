pipeline {
    agent any

    stages {
        stage('CLONE-CODE') {
            steps {
                
                git branch: 'main', url: 'https://github.com/venkat44488/tweet-trend-new.git'
                  }
        }


         stage('build') {
            steps {
                echo " welcoem to build"
                  }
        }
    }
}
