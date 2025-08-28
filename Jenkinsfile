pipeline {
    agent none
    tools {
        maven 'npd-mvn'
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                script {
                    sshagent(['agent02-id']) {
                        echo 'Compile the Code'
                        // sh "mvn compile"
                        sh 'scp -o StrictHostKeyChecking=no server-script.sh ec2-user@172.31.17.188:/home/ec2-user/'
                        sh 'ssh -o StrictHostKeyChecking=no ec2-user@172.31.17.188 "bash server-script.sh"'
                    }
                }
            }
        }
        stage('CodeReview') {
            agent any
            steps {
                script {
                    echo 'Review the Code'
                    sh 'mvn pmd:pmd'
                }
            }
        }
        stage('UnitTest') {
            agent any
            steps {
                script {
                    echo 'Test the Code'
                    sh 'mvn test'
                }
            }
        }
        stage('CoverageAnalysis') {
            agent { label 'npd-lab' }
            steps {
                script {
                    echo 'StaticCodeCoverage'
                    sh 'mvn verify'
                }
            }
        }
        stage('Package') {
            agent any
            steps {
                script {
                    echo 'Packaging the code'
                    sh 'mvn package'
                }
            }
        }
        stage('PublishToJFrog') {
            agent { label 'npd-lab' }
            input {
                message 'Please approve to publish the artifact to JFrog'
                ok 'Publish'
            }
            steps {
                script {
                    echo 'Publish the Code to JFrog'
                    sh 'mvn -U deploy -s settings.xml'
                }
            }
        }
    }
}
