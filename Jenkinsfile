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
                script {
                    echo 'Compile the Code'
                    sh 'mvn clean compile'
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
            when {
                expression {
                    params.UTest == true
                }
            }
            steps {
                script {
                    echo 'Test the Code'
                    sh 'mvn test'
                }
            }
        }
        stage('CoverageAnalysis') {
            agent any
            steps {
                script {
                    echo 'Static Analysis'
                    sh 'mvn verify'
                }
            }
        }
        stage('Package') {
            agent { label 'mpd-lab' }
            steps {
                script {
                    echo 'Package the Code'
                    echo "Deploying to ${params.env} environment with version ${params.AppVersion}"
                    sh 'mvn package'
                }
            }
        }
        stage('PublishtoJFrog') {
            agent any
            steps {
                script {
                    echo 'Publish the Artifacts to JFrog'
                    sh 'mvn -U deploy -s settings.xml'
                }
            }
        }
    }
}
