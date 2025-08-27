pipeline {
    agent any

    stages {
        stage('Compile') {
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
            steps {
                echo 'Test the Code'
            }
        }
        stage('CoverageAnalysis') {
            steps {
                echo 'StaticCodeCoverage'
            }
        }
        stage('Package') {
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
