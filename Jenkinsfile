pipeline {
    agent any

    options {
        skipDefaultCheckout(true)
        timestamps()
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    environment {
        IMAGE_NAME = 'nexvion-ecommerce'
        IMAGE_TAG = '1.0'
        DOCKER_HOST = 'npipe:////./pipe/dockerDesktopLinuxEngine'
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
                echo 'Validating NEXVION application files'

                bat '''
                    @echo off

                    if not exist index.html (
                        echo ERROR: index.html is missing
                        exit /b 1
                    )

                    if not exist products.html (
                        echo ERROR: products.html is missing
                        exit /b 1
                    )

                    if not exist payment.html (
                        echo ERROR: payment.html is missing
                        exit /b 1
                    )

                    if not exist script.js (
                        echo ERROR: script.js is missing
                        exit /b 1
                    )

                    if not exist payment.js (
                        echo ERROR: payment.js is missing
                        exit /b 1
                    )

                    if not exist Dockerfile (
                        echo ERROR: Dockerfile is missing
                        exit /b 1
                    )

                    if not exist compose.yaml (
                        echo ERROR: compose.yaml is missing
                        exit /b 1
                    )

                    echo All required application files are present.
                '''
            }
        }

        stage('Docker Environment Diagnostics') {
            steps {
                echo 'Checking Jenkins Docker environment'

                bat '''
                    @echo off

                    echo Jenkins service identity:
                    whoami

                    echo Docker CLI:
                    where.exe docker

                    docker --version
                    if errorlevel 1 exit /b 1
                '''
            }
        }

        stage('Docker Engine Check') {
            steps {
                echo 'Checking Docker Desktop connectivity'

                bat '''
                    @echo off

                    docker -H %DOCKER_HOST% version
                    if errorlevel 1 exit /b 1

                    echo Docker Engine connection successful.
                '''
            }
        }

        stage('Build Docker Image') {
            steps {
                echo 'Building NEXVION Docker image'

                bat '''
                    @echo off

                    docker -H %DOCKER_HOST% build ^
                        --pull ^
                        -t %IMAGE_NAME%:%IMAGE_TAG% .

                    if errorlevel 1 exit /b 1

                    echo Docker image build completed.
                '''
            }
        }

        stage('Verify Docker Image') {
            steps {
                echo 'Verifying the Docker image'

                bat '''
                    @echo off

                    docker -H %DOCKER_HOST% image inspect %IMAGE_NAME%:%IMAGE_TAG%

                    if errorlevel 1 exit /b 1

                    echo Docker image verification successful.
                '''
            }
        }

        stage('Deploy Application') {
            steps {
                echo 'Deploying NEXVION application'

                bat '''
                    @echo off

                    docker rm -f nexvion-container-c 2>nul
                    
                    docker run -d --name nexvion-container-c -p 8081:80 --restart unless-stopped nexvion-ecommerce:1.0
                    if errorlevel 1 exit /b 1
                '''
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Waiting for NEXVION to become healthy'

                bat '''
                    @echo off

                    powershell -NoProfile -NonInteractive -ExecutionPolicy Bypass -Command "$ErrorActionPreference = 'Stop'; Start-Sleep -Seconds 10; $status = docker inspect --format='{{.State.Status}}' nexvion-container-c; if ($status -ne 'running') { Write-Error 'Container is not running'; exit 1 }; $health = docker inspect --format='{{.State.Health.Status}}' nexvion-container-c; Write-Output ('Container status: ' + $status); Write-Output ('Health status: ' + $health); if ($health -ne 'healthy') { Write-Error 'Container is not healthy'; exit 1 }; $response = Invoke-WebRequest -Uri 'http://localhost:8081/' -UseBasicParsing; Write-Output ('HTTP status: ' + [int]$response.StatusCode); if ([int]$response.StatusCode -ne 200) { exit 1 }"

                    if errorlevel 1 exit /b 1
                '''
            }
        }
    }

    post {
        success {
            echo 'SUCCESS: NEXVION CI pipeline completed.'
            echo 'Source checkout, validation, Docker connection, image build, and image verification passed.'
        }

        failure {
            echo 'FAILURE: NEXVION CI pipeline failed.'
            echo 'Inspect the Console Output to identify the failing stage.'
        }

        always {
            echo 'Pipeline execution finished.'
        }
    }
}
