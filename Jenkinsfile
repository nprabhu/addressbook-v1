pipeline {
    agent any

    stages {
        stage('Compile') {
            steps {
                echo 'Compile the Code'
            }
        }
        stage('CodeReiew') {
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
                echo 'Static Analysis'
            }
        }
        stage('Package') {
            steps {
                echo 'Package the Code'
            }
        }
        stage('PublishtoJFrog') {
            steps {
                echo 'Publish the Artifacts to JFrog'
            }
        }
    }
}
