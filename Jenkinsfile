pipeline {
    agent any
    tools {
        maven 'npd-mvn'
    }
    environment {
        BUILD_SERVER_AGENT02 = 'ec2-user@172.31.38.138' // Update with the actual IP
        DEPLOY_SERVER = 'ec2-user@172.31.46.141' // Update with the actual IP
        IMAGE_NAME = "npdas/nprabhu: ${BUILD_NUMBER}"
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
                echo 'Checked out code'
            }
        }
        stage('compile') {
            steps {
                script {
                    echo 'compile the code'
                    sh 'mvn clean compile -Dmaven.test.skip=true'
                }
            }
        }
        stage('Code Quality - SonarQube') {
            environment {
                // Inject your SonarQube token from Jenkins credentials
                SONARQUBE_TOKEN = credentials('sonar-token')
            }
            steps {
                // Use the configured SonarQube server in Jenkins
                withSonarQubeEnv('npd-sonar-sys') {
                    // Run Maven with SonarQube analysis
                    sh "mvn sonar:sonar -Dsonar.projectKey=npd-project -Dsonar.login=$SONARQUBE_TOKEN"
                }
            }
        }

        // 🔄 NEW UPDATED STAGE: Combined Unit Test + Code Coverage
        stage('Unit Test & Code Coverage') {
            steps {
                script {
                    echo '🔍 Running Unit Tests & Code Coverage Analysis'

                    // Run unit tests and generate JaCoCo report
                    sh 'mvn test verify -Dmaven.test.failure.ignore=false'

                    // Publish JUnit test results
                    junit allowEmptyResults: true, testResults: '**/target/surefire-reports/*.xml'

                    // Publish JaCoCo coverage report with thresholds
                    jacoco(
                        execPattern: '**/target/jacoco.exec',
                        classPattern: '**/target/classes',
                        sourcePattern: '**/src/main/java',
                        inclusionPattern: '**/*.class',
                        exclusionPattern: '**/*Test*.class',
                        changeBuildStatus: true,
                        maximumInstructionCoverage: '80',
                        maximumBranchCoverage: '70',
                        maximumComplexityCoverage: '70',
                        maximumLineCoverage: '80'
                    )
                }
            }
            post {
                always {
                    // Archive HTML coverage report
                    archiveArtifacts artifacts: '**/target/site/jacoco/index.html', fingerprint: true
                }
                unsuccessful {
                    echo '❌ Unit Tests failed or Coverage below threshold'
                }
                success {
                    echo '✅ Unit Tests passed & Coverage thresholds met'
                }
            }
        }
        // 🔄 END OF NEW UPDATE

        stage('Containerize the Application') {
            agent any
            steps {
                script {
                    echo 'Packaging the application'
                    sh 'mvn package'
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
                // sshagent block for remote server
                sshagent(['agent02-id']) {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'docker_password', usernameVariable: 'docker_username')]) {
                        // Copy the script to the remote server
                        sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER_AGENT02}:/home/ec2-user/"
                        // Execute the script on the remote server with the image name
                        sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER_AGENT02} bash /home/ec2-user/server-script.sh ${IMAGE_NAME}"
                        // Login to Docker docker password store in jenkins credentials 
                        sh "ssh ${BUILD_SERVER_AGENT02} sudo docker login -u ${docker_username} -p ${docker_password}"
                        // Push the Docker image
                        sh "ssh ${BUILD_SERVER_AGENT02} docker push ${IMAGE_NAME}"
                    }
                }
            }
        }
        stage('Deploy the Application') {
            agent any
            steps {
                script {
                    echo 'Packaging the application'
                    sh 'mvn package'
                    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
                }
                // sshagent block for remote server
                sshagent(['agent02-id']) {
                    // Install Docker on the remote server
                    sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} sudo yum install -y docker"
                    // Start Docker service
                    sh "ssh ${DEPLOY_SERVER} sudo systemctl start docker"
                    // Login to Docker docker password store in jenkins credentials 
                    sh "ssh ${DEPLOY_SERVER} sudo docker login -u ${docker_username} -p ${docker_password}"
                    // Run the Docker container
                    sh "ssh ${DEPLOY_SERVER} sudo docker run -itd -P ${IMAGE_NAME}"
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
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Please check the logs.'
        }
    }
}
