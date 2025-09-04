pipeline {
    agent any
    tools {
        maven 'npd-mvn'
    }
    environment {
        BUILD_SERVER = 'ec2-user@172.31.18.58' // Update with the actual IP
        DEPLOY_SERVER = 'ec2-user@172.31.16.228' // Update with the actual IP
        IMAGE_NAME = "npdas/nprabhu:${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo '✅ Checked out code'
            }
        }

        stage('Compile') {
            steps {
                script {
                    echo '🛠 Compiling the code'
                    sh 'mvn clean compile -Dmaven.test.skip=true'
                }
            }
        }

        stage('Code Quality - SonarQube') {
            environment {
                // Inject SonarQube token from Jenkins credentials
                SONARQUBE_TOKEN = credentials('sonar-token')
            }
            steps {
                withSonarQubeEnv('npd-sonar-sys') {
                    sh "mvn sonar:sonar -Dsonar.projectKey=npd-project -Dsonar.login=$SONARQUBE_TOKEN"
                }
            }
        }

        // 🔄 UPDATED: Combined Unit Test + Code Coverage stage
        stage('Unit Test & Code Coverage') {
            steps {
                script {
                    echo '🔍 Running Unit Tests & JaCoCo Coverage'

                    // Run unit tests and generate JaCoCo report
                    // Added "verify" to include integration with JaCoCo plugin
                    sh 'mvn test verify -Dmaven.test.failure.ignore=false'

                    // Publish JUnit test results
                    junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'

                    // Archive JaCoCo HTML report (since pipeline jacoco step caused previous failures)
                    // ✅ MODIFIED: Archive artifacts for WAR project instead of *.jar
                    archiveArtifacts artifacts: '**/target/site/jacoco/index.html', fingerprint: true
                }
            }
            post {
                unsuccessful {
                    echo '❌ Unit Tests failed or Coverage below threshold'
                }
                success {
                    echo '✅ Unit Tests passed & Coverage report generated'
                }
            }
        }
        // 🔄 END OF UPDATED STAGE

        stage('Containerize the Application') {
            agent any
            steps {
                script {
                    echo '📦 Packaging the WAR file'
                    sh 'mvn package -Dmaven.test.skip=true'

                    // ✅ MODIFIED: Archive WAR instead of JAR
                    archiveArtifacts artifacts: 'target/*.war', fingerprint: true
                }

                sshagent(['agent01-id']) {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'docker_password', usernameVariable: 'docker_username')]) {
                        // Copy deployment script to remote build server
                        sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user/"
                        sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} bash /home/ec2-user/server-script.sh ${IMAGE_NAME}"
                        sh "ssh ${BUILD_SERVER} sudo docker login -u ${docker_username} -p ${docker_password}"
                        sh "ssh ${BUILD_SERVER} sudo docker push ${IMAGE_NAME}"
                    }
                }
            }
        }

        stage('Deploy the Application') {
            agent any
            steps {
                script {
                    echo '🚀 Deploying the WAR Docker image'
                    sh 'mvn package -Dmaven.test.skip=true'
                    archiveArtifacts artifacts: 'target/*.war', fingerprint: true
                }

                sshagent(['agent02-id']) {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'docker_password', usernameVariable: 'docker_username')]) {
                        sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} sudo yum install -y docker"
                        sh "ssh ${DEPLOY_SERVER} sudo systemctl start docker"
                        sh "ssh ${DEPLOY_SERVER} sudo docker login -u ${docker_username} -p ${docker_password}"
                        sh "ssh ${DEPLOY_SERVER} sudo docker run -itd -P ${IMAGE_NAME}"
                    }
                }
            }
        }

        stage('Security Scan') {
            steps {
                sh 'mvn org.owasp:dependency-check-maven:check'
            }
        }

        stage('Publish to Nexus/Artifactory') {
            steps {
                sh 'mvn deploy -DskipTests'
            }
        }
    }

    post {
        always {
            cleanWs()
        }
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed. Check the logs for details.'
        }
    }
}