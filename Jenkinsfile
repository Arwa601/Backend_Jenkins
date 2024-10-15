pipeline {
    agent any
    environment {
        DOCKER_COMPOSE_FILE = 'docker-compose.yml'
    }
    triggers {
        pollSCM '*/1 * * * *'
    }
    stages {

        stage('Check Java Version') {
            steps {
                sh 'java -version'
                echo 'java version is checked'
            }
        }

        stage('Checkout') {  //pull changes
            steps {

                git credentialsId: '637388a3-3aca-451c-9ae2-01393e38768e', url: 'https://github.com/Arwa601/Backend_Jenkins', branch: 'main'
            }
        }

        stage('Build Docker Images') {
            steps {
                script {
                    sh 'docker-compose -f $DOCKER_COMPOSE_FILE build'
                }
            }
        }

        stage('Run Services') {
            steps {
                script {
                    sh 'docker-compose -f $DOCKER_COMPOSE_FILE up -d'
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    sh 'docker-compose down'
                    sh 'docker-compose up -d'
                }
            }
        }

        stage('Clean Up') {
            steps {
                script {
                    sh 'docker-compose -f $DOCKER_COMPOSE_FILE down'
                }
            }
        }
    }

    post {
        always {
            sh 'docker rmi ${DOCKER_IMAGE}:${BRANCH}'
            cleanWs()
        }
    }
}
