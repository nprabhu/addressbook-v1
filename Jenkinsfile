pipeline {
    agent any

    stages {
        stage('Compile') {
            steps {
                echo 'Compiling The Code'
            }
        }
        stage('CodeReview') {
            steps {
                echo 'Reviewing The Code With pmd'
            }
        }
        stage('UnitTest') {
            steps {
                echo 'Testing The Code with JUnit'
            }
        }
        stage('CoverageAnalysis') {
            steps {
                echo 'Static Code Coverage with jacoco'
            }
        }
        stage('Package') {
            steps {
                echo 'Packaging The Code'
            }
        }
        stage('Publish') {
            steps {
                echo 'Publishing the artifact to JFrog-NPD'
            }
        }
    }
}
