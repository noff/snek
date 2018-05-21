pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                sh 'bin/prepare_for_jenkins'
            }
        }
        stage('Testing') {
            steps {
                sh 'bin/testing'
            }
        }
        stage('Deploy') {
            steps {
                sh 'bin/deploy'
            }
        }

    }
}