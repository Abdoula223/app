//
# FICHIER FINAL : Jenkinsfile (Version personnalisée pour abdoul223)
#
pipeline {
    agent any

    environment {
        // ✅ Ton username Docker Hub
        DOCKERHUB_USERNAME = 'abdoul223' 

        // ✅ Tes noms d'images sur Docker Hub
        IMAGE_NAME_BACKEND = 'backend'
        IMAGE_NAME_FRONTEND = 'frontend'
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Récupération du code..."
                checkout scm
            }
        }

        stage('Build & Push Images') {
            parallel {
                stage('Backend') {
                    steps {
                        script {
                            def imageName = "${DOCKERHUB_USERNAME}/${IMAGE_NAME_BACKEND}:build-${env.BUILD_NUMBER}"
                            def backendImage = docker.build(imageName, './backend')
                            docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                                backendImage.push()
                            }
                        }
                    }
                }
                stage('Frontend') {
                    steps {
                        script {
                            def imageName = "${DOCKERHUB_USERNAME}/${IMAGE_NAME_FRONTEND}:build-${env.BUILD_NUMBER}"
                            def frontendImage = docker.build(imageName, '.')
                            docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-credentials') {
                                frontendImage.push()
                            }
                        }
                    }
                }
            }
        }

        stage('Deploy') {
            steps {
                withCredentials([string(credentialsId: 'backend-env-file', variable: 'ENV_FILE_CONTENT')]) {
                    script {
                        sh 'echo "$ENV_FILE_CONTENT" > ./.env.backend'
                        echo 'Déploiement de la stack complète...'
                        sh """
                            export IMAGE_BACKEND=${DOCKERHUB_USERNAME}/${IMAGE_NAME_BACKEND}:build-${env.BUILD_NUMBER}
                            export IMAGE_FRONTEND=${DOCKERHUB_USERNAME}/${IMAGE_NAME_FRONTEND}:build-${env.BUILD_NUMBER}

                            docker-compose pull backend frontend
                            docker-compose up -d --remove-orphans
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Nettoyage du workspace...'
            sh 'rm -f ./.env.backend'
        }
    }
}
