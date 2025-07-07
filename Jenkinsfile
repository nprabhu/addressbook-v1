pipeline {
    agent any

    parameters {
        string(name: 'env', defaultValue: 'Test', description: 'Verstion to Deploy')
        booleanParam(name: 'UTest', defaultValue: true, description: 'Decide whether to execute tests or not')
        choice(name: 'AppVersion', choices: ['1.1', '1.2', '1.3'], description: 'Choose the App Version')
    }

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
            when {
                expression {
                    params.UTest == true
                }
            }
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
                echo "Deploying to ${params.env} environment with version ${params.AppVersion}"
            }
        }
        stage('PublishtoJFrog') {
            steps {
                echo 'Publish the Artifacts to JFrog'
            }
        }
    }
}
