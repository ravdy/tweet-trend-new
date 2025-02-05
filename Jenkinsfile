def registry = 'https://balli1910.jfrog.io/'
def imageName = 'balli1910.jfrog.io/valaxy-docker-local/ttrend'
def version   = '2.1.2'
pipeline{
    agent{
      node{
           label 'maven'
    }
  }
  environment  {
        PATH= "/opt/apache-maven-3.9.9/bin:$PATH"
  }
   stages{
      stage("build stage"){
        steps {
          echo "build started........"
            sh 'mvn clean deploy'
          echo "build  complete"  
        }
      }
      
      stage("Jar Publish") {
            steps {
                script {
                        echo '<--------------- Jar Publish Started --------------->'
                         def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"jfrog-cred"
                         def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                         def uploadSpec = """{
                              "files": [
                                {
                                  "pattern": "jarstaging/(*)",
                                  "target": "krishna-libs-release-local/{}",
                                  "flat": "false",
                                  "props" : "${properties}",
                                  "exclusions": [ "*.sha1", "*.md5"]
                                }
                             ]
                         }"""
                         def buildInfo = server.upload(uploadSpec)
                         buildInfo.env.collect()
                         server.publishBuildInfo(buildInfo)
                         echo '<--------------- Jar Publish Ended --------------->'  
                
                }
            }   
        }

      stage(" Docker Build ") {
          steps {
            script {
               echo '<--------------- Docker Build Started --------------->'
               app = docker.build(imageName+":"+version)
               echo '<--------------- Docker Build Ends --------------->'
            }
          }
        }

                stage (" Docker Publish "){
            steps {
                script {
                   echo '<--------------- Docker Publish Started --------------->'  
                    docker.withRegistry(registry, 'jfrog-cred'){
                        app.push()
                    }    
                   echo '<--------------- Docker Publish Ended --------------->'  
                }
            }
        }  
             stage ("deploy"){
              steps{
                script{
                  echo "deploy application over EKS"
                    sh './deploy.sh'
                 }
              }
             }
   }
}
