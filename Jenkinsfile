pipeline {

    agent any
     environment {
            DOCKER_COMPOSE_FILE = 'docker-compose.yml'
        }
    triggers{
    pollSCM '*1/* * * * *'
    }
    stages {

        stage('Check Java Version') {
                steps {
                    sh 'java -version'
                    echo 'java version is'
                }
            }
        stage('Checkout') {
            steps {
                // Récupérer le code source depuis le dépôt Git
                git credentialsId: '637388a3-3aca-451c-9ae2-01393e38768e', url: 'git@github.com:https://github.com/Arwa601/Backend_Jenkins',git branch: 'main'
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
                                  // Start the services defined in the Docker Compose file
                                  sh 'docker-compose -f $DOCKER_COMPOSE_FILE up -d'
                              }
                          }
                      }


        stage('Docker Push') {
            steps {
                script {
                    // Se connecter au registre Docker et pousser l'image
                    withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                        sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                        sh 'docker tag ${DOCKER_IMAGE}:${BRANCH} ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${BRANCH}'
                        sh 'docker push ${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${BRANCH}'
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                script {
                    // Déploiement (ex: via Docker Compose ou Kubernetes)
                    sh 'docker-compose down'
                    sh 'docker-compose up -d'
                }
            }
        }
    }
    stage('Clean Up') {
            steps {
                script {
                    // Stop and remove the services after the tests
                    sh 'docker-compose -f $DOCKER_COMPOSE_FILE down'
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
