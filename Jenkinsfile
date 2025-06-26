pipeline {
    agent any

    parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Branch to build')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Deside To Run Tests or Not')
        choice(name: 'APP_VERSION', choices: ['1.1', '2.1', '3.0', '4.0'], description: 'Build Tool to use')

    }

    stages {
        stage('Compile') {
            steps {
                echo "Compiling The Code in ${params.Env} Environment"
            }
        }
        stage('CodeReview') {
            steps {
                echo 'Reviewing The Code With pmd'
            }
        }
        stage('UnitTest') {
            when {
                expression { return params.executeTests == true }
            }
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
                echo "Packaging The Code with Maven ${params.APP_VERSION} Version Tool"
            }
        }
        stage('Publish') {
            steps {
                echo 'Publishing the artifact to JFrog-NPD'
            }
        }
    }
}
