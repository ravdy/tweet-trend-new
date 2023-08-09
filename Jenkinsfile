pipeline {
    agent any
environment {
  PATH = "/usr/share/maven:$PATH"
}
    stages {
            stage('build') {
            steps {
                mvn clean deploy
                  }
        }
    }
}
