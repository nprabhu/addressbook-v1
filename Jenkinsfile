pipeline {
    agent none
    tools {
        // Define tools required for the pipeline
        maven 'npd-maven'
    }

    parameters {
        string(name: 'env', defaultValue: 'Test', description: 'Verstion to Deploy')
        booleanParam(name: 'UTest', defaultValue: true, description: 'Decide whether to execute tests or not')
        choice(name: 'AppVersion', choices: ['1.1', '1.2', '1.3'], description: 'Choose the App Version')
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                echo 'Compile the Code'
            }
        }
        stage('CodeReiew') {
            agent any
            when {
                expression {
                    params.AppVersion == '1.2'
                }
            }
            steps {
                echo 'Review the Code'
            }
        }
        stage('UnitTest') {
            agent any
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
            agent any
            steps {
                echo 'Static Analysis'
            }
        }
        stage('Package') {
            agent { label 'mpd-lab' }
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
