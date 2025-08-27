pipeline {
    agent none
    tools{
        maven 'npd-mvn'
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                echo 'Compile the Code'
            }
        }
        stage('CodeReview') {
            steps {
                echo 'Review the Code'
            }
        }
        stage('UnitTest') {
            agent any
            steps {
                echo 'Test the Code'
            }
        }
        stage('CoverageAnalysis') {
            agent { label 'npd-lab'}
            steps {
                echo 'StaticCodeCoverage'
            }
        }
        stage('Package') {
            agent any
            steps {
                echo 'Packaging the code'
            }
        }
        stage('PublishToJFrog') {
            agent { label 'npd-lab' }
            steps {
                echo 'Publish the Code to JFrog'
            }
        }
    }
}
