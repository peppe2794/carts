pipeline {
  environment {
    registry = "peppe2794/carts"
    registryCredential = 'dockerhub'
    dockerImage = ''
    DOCKER_TAG = getVersion().trim()
    IMAGE="carts"
  }
  agent any
  stages {
    stage('Build'){
      agent {
        docker {
          image 'maven:3.6-jdk-11' 
          args '-v /var/lib/jenkins/workspace/carts:/usr/src/mymaven:rw -w /usr/src/mymaven -w /var/lib/jenkins/workspace/carts -v /var/lib/jenkins/workspace/carts:/var/lib/jenkins/workspace/carts:rw,z -v /var/lib/jenkins/workspace/carts@tmp:/var/lib/jenkins/workspace/carts@tmp:rw,z' 
          reuseNode true
        }
      }
      steps{
         sh 'mvn -q -DskipTests package'
      }
    }
    stage('SonarQube analysis'){
      steps{
        withSonarQubeEnv(installationName: 'Sonarqube2', credentialsId: 'Sonarqube2') {
          sh "${tool("sonar_scanner")}/bin/sonar-scanner"
        }
      }
    }
 }
}

def getVersion(){
  def commitHash = sh returnStdout: true, script: 'git rev-parse --short HEAD'
  return commitHash
}
