pipeline {
    agent {
        node {
            label "maven"
        }
    }

    environment {
        PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
        MAVEN_OPTS = "-Xmx256m -Xms128m -XX:+UseSerialGC"
        registry = "https://trialvl2jw6.jfrog.io"
        version = "2.0.2"
    }

    stages {
        stage("Build & Unit Test with Coverage") {
            steps {
                echo "-------- Build & Test Started --------"
                sh 'mvn clean verify -Dmaven.compiler.fork=false'
                echo "-------- Build & Test Completed --------"
                slackSend(channel: 'jenkins-alerts', color: 'good',
                    message: "✅ Maven Build & Unit Test completed for *${env.JOB_NAME}* #${env.BUILD_NUMBER}")
            }
        }

        stage("SonarQube Analysis") {
            environment {
                scannerHome = tool 'sagar171414-sonar-scanner'
            }
            steps {
                withSonarQubeEnv('sagar171414-sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner"
                    slackSend(channel: 'jenkins-alerts', color: '#439FE0',
                        message: "🔍 SonarQube scan submitted for *${env.JOB_NAME}* #${env.BUILD_NUMBER}")
                }
            }
        }

        stage("SonarQube Quality Gate") {
            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    script {
                        echo "⏳ Waiting for SonarQube Quality Gate result..."
                        sleep(time: 10, unit: 'SECONDS')

                        def qg = waitForQualityGate()
                        echo "🔍 SonarQube Quality Gate status: ${qg.status}"

                        if (qg.status != 'OK') {
                            echo "⚠️ Quality Gate failed: ${qg.status} — Ignoring for now."
                            slackSend(channel: 'jenkins-alerts', color: 'warning',
                                message: "⚠️ SonarQube Quality Gate *failed* for *${env.JOB_NAME}* #${env.BUILD_NUMBER}: ${qg.status}")
                        } else {
                            echo "✅ Quality Gate passed."
                            slackSend(channel: 'jenkins-alerts', color: 'good',
                                message: "✅ SonarQube Quality Gate *passed* for *${env.JOB_NAME}* #${env.BUILD_NUMBER}")
                        }
                    }
                }
            }
        }

        stage("Jar Publish") {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'
                    sh 'ls -lh target/*.jar || echo "❌ No JAR found!"'

                    def server = Artifactory.newServer(
                        url: "${env.registry}/artifactory",
                        credentialsId: "artifact-cred"
                    )

                    def commitId = sh(script: "git rev-parse HEAD", returnStdout: true).trim()
                    def properties = "buildid=${env.BUILD_ID},commitid=${commitId}"

                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "target/*.jar",
                                "target": "devops-libs-release-local/",
                                "flat": true,
                                "props": "${properties}",
                                "exclusions": ["*.sha1", "*.md5"]
                            }
                        ]
                    }"""

                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)

                    echo '<--------------- Jar Publish Ended --------------->'
                    slackSend(channel: 'jenkins-alerts', color: '#36a64f',
                        message: "📦 JAR uploaded to Artifactory for *${env.JOB_NAME}* #${env.BUILD_NUMBER}")
                }
            }
        }

        stage("Docker Build") {
            steps {
                script {
                    echo "<--------------- Docker Build Started --------------->"
                    def tag = "${env.BUILD_NUMBER ?: '0'}-manual"
                    def imageFullPath = "trialvl2jw6.jfrog.io/devops-docker-local/ttrend:${tag}"

                    app = docker.build("${imageFullPath}", "--memory=512m .")
                    env.DOCKER_IMAGE_TAG = tag
                    env.DOCKER_IMAGE_NAME = imageFullPath
                    echo "<--------------- Docker Build Ended --------------->"
                    slackSend(channel: 'jenkins-alerts', color: '#38a64f',
                        message: "🐳 Docker image *${env.DOCKER_IMAGE_NAME}* built for *${env.JOB_NAME}*")
                }
            }
        }

        stage("Docker Image Scan by Trivy") {
            steps {
                script {
                    def image = env.DOCKER_IMAGE_NAME
                    echo "<--------------- Docker Scan Started [Trivy] --------------->"

                    def trivyExitCode = sh(
                        script: """
                            trivy image \
                              --severity HIGH,CRITICAL \
                              --exit-code 1 \
                              --no-progress \
                              --ignore-unfixed \
                              ${image}
                        """,
                        returnStatus: true
                    )

                    if (trivyExitCode == 1) {
                        echo "⚠️ Trivy found HIGH or CRITICAL vulnerabilities (ignored for now)."
                        slackSend(channel: 'jenkins-alerts', color: 'warning',
                            message: "⚠️ Trivy found HIGH/CRITICAL vulnerabilities in *${env.DOCKER_IMAGE_NAME}*")
                    } else if (trivyExitCode == 2) {
                        error "❌ Trivy failed to execute properly (exit code 2)."
                    } else {
                        echo "✅ No critical vulnerabilities found by Trivy."
                        slackSend(channel: 'jenkins-alerts', color: 'good',
                            message: "✅ Trivy scan clean for *${env.DOCKER_IMAGE_NAME}*")
                    }

                    echo "<--------------- Docker Scan Completed --------------->"
                }
            }
        }

        stage("Docker Publish") {
            steps {
                script {
                    echo "<--------------- Docker Publish Started --------------->"
                    docker.withRegistry("${registry}", "artifact-cred") {
                        app.push()
                    }
                    echo "<--------------- Docker Publish Ended --------------->"
                    slackSend(channel: 'jenkins-alerts', color: '#439FE0',
                        message: "🚀 Docker image *${env.DOCKER_IMAGE_NAME}* pushed to Artifactory")
                }
            }
        }

        stage("Docker Run on Host") {
            steps {
                script {
                    echo "<--------------- Docker Run Started --------------->"
                    def containerName = "ttrend-container-${env.BUILD_NUMBER}"

                    sh """
                        docker rm -f ${containerName} || true
                        docker run -d --name ${containerName} -p 8000:8000 ${env.DOCKER_IMAGE_NAME}
                        sleep 10
                        docker ps | grep ${containerName}
                    """

                    def publicIP = sh(script: "curl -s http://checkip.amazonaws.com", returnStdout: true).trim()
                    def accessUrl = "http://${publicIP}:8000"

                    echo "🌐 App is running at: ${accessUrl}"
                    slackSend(channel: 'jenkins-alerts', color: '#439FE0',
                        message: "🌐 App container is running on: ${accessUrl}")
                    env.RUNNING_APP_URL = accessUrl
                }
            }
        }

        stage("Cleanup") {
            steps {
                cleanWs()
                sh 'sync; echo 3 > /proc/sys/vm/drop_caches || true'
                slackSend(channel: 'jenkins-alerts', color: '#cccccc',
                    message: "🧹 Workspace cleaned after build *${env.JOB_NAME}* #${env.BUILD_NUMBER}")
            }
        }
    }

    post {
        success {
            slackSend(channel: 'jenkins-alerts', color: 'good',
                message: "✅ *${env.JOB_NAME}* #${env.BUILD_NUMBER} succeeded!\n🔗 ${env.BUILD_URL}")
            mail to: 'sagarsaswade31@gmail.com',
                subject: "✅ SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Build succeeded!\n\n🔗 ${env.BUILD_URL}"
        }

        failure {
            slackSend(channel: 'jenkins-alerts', color: 'danger',
                message: "❌ *${env.JOB_NAME}* #${env.BUILD_NUMBER} failed!\n🔗 ${env.BUILD_URL}")
            mail to: 'sagarsaswade31@gmail.com',
                subject: "❌ FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Build failed.\n\n🔗 ${env.BUILD_URL}"
        }

        unstable {
            slackSend(channel: 'jenkins-alerts', color: 'warning',
                message: "⚠️ *${env.JOB_NAME}* #${env.BUILD_NUMBER} is UNSTABLE (vulnerabilities or quality gate).\n🔗 ${env.BUILD_URL}")
            mail to: 'sagarsaswade31@gmail.com',
                subject: "⚠️ UNSTABLE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: "Build marked as UNSTABLE.\nLikely reasons: vulnerabilities or SonarQube quality gate failure.\n\n🔗 ${env.BUILD_URL}"
        }
    }
}
