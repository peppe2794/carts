pipeline {
  environment {
    registry = "peppe2794/carts"
    registryCredential = 'dockerhub'
    dockerImage = ''
    DOCKER_TAG = getVersion().trim()
    IMAGE="carts:"
  }
  agent any
  stages {
    stage('Build'){
      agent {
        docker {
          image 'maven:3.6-jdk-11' 
          args '-v /root/.m2:/root/.m2 -v .:/usr/src/mymaven' 
        }
      }
      steps{
         sh 'mvn -B -DskipTests clean package'
      }
    }
    stage('SonarQube analysis'){
      steps{
        withSonarQubeEnv(installationName: 'Sonarqube', credentialsId: 'Sonarqube') {
          sh "${tool("sonar_scanner")}/bin/sonar-scanner"
        }
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build("$registry:$DOCKER_TAG")
        }
      }
    }
    stage('Push Image') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
 }
}

def getVersion(){
  def commitHash = sh returnStdout: true, script: 'git rev-parse --short HEAD'
  return commitHash
}
