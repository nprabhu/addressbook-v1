pipeline {
    agent none
    tools{
        maven 'npd-mvn'
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                script{
                echo 'Compile the Code'
                sh "mvn compile"
                }
            }
        }
        stage('CodeReview') {
            agent any
            steps {
                script{
                echo 'Review the Code'
                sh "mvn pmd:pmd"
                }
            }
        }
        stage('UnitTest') {
            agent any
            steps {
                script{
                echo 'Test the Code'
                sh "mvn test"
                }
            }
        }
        stage('CoverageAnalysis') {
            agent { label 'npd-lab'}
            steps {
                script{
                echo 'StaticCodeCoverage'
                sh "mvn verify"
                }
            }
        }
        stage('Package') {
            agent any
            steps {
                script{
                echo 'Packaging the code'
                sh "mvn package"
                }
            }
        }
        stage('PublishToJFrog') {
            agent { label 'npd-lab' }
            steps {
                script{
                echo 'Publish the Code to JFrog'
                sh "mvn -U deploy -s settings.xml"
                }
            }
        }
    }
}
