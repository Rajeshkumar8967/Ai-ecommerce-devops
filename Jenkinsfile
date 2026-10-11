pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
        timestamps()
    }

    environment {
        IMAGE_NAME = 'nexvion-ecoomerce'
        IMAGE_TAG = '1.0'
        DOCKER_CONTEXT = 'desktop-linux'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out NEXVION source code from GitHub'
                checkout scm
            }
        }

        stage('Validate Application') {
            steps {
                echo 'Validating application files'

                bat '''
                    if not exist index.html exit /b 1
                    if not exist products.html exit /b 1
                    if not exist payment.html exit /b 1
                    if not exist Dockerfile exit /b 1
                    if not exist compose.yaml exit /b 1

                    echo Application files validated successfully.
                '''
            }
        }

        stage('Docker Engine Check') {
            steps {
                echo 'Checking Docker Desktop connectivity'

                bat '''
                    docker --context %DOCKER_CONTEXT% version
                    if errorlevel 1 exit /b 1
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building the NEXVION Docker image'

                bat '''
                    docker --context %DOCKER_CONTEXT% build -t %IMAGE_NAME%:%IMAGE_TAG% .
                    if errorlevel 1 exit /b 1
                '''
            }
        }

        stage('Verify Docker Image') {
            steps {
                echo 'Verifying the built Docker image'

                bat '''
                    docker --context %DOCKER_CONTEXT% image inspect %IMAGE_NAME%:%IMAGE_TAG%
                    if errorlevel 1 exit /b 1
                '''
            }
        }
    }

    post {
        success {
            echo 'NEXVION CI pipeline completed successfully.'
        }

        failure {
            echo 'NEXVION CI pipeline failed. Review the stage logs.'
        }

        always {
            echo 'Pipeline execution finished.'
        }
    }
}
