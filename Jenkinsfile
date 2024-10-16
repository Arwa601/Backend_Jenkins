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
                git credentialsId: '7e0241bc-abaf-4496-a531-a767cdcfb1fd', url: 'https://github.com/Arwa601/Backend_Jenkins', branch: 'main'
            }
        }

        stage('Build Docker Images') {

                       steps {
                            dockerComposeBuild(
                                yamlPath: '${DOCKER_COMPOSE_FILE}',
                                services: ['app','dbmongo','jenkins'],
                                options: ''
                            )
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
