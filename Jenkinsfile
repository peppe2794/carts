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
          args '-v /var/lib/jenkins/workspace/carts:/usr/src/mymaven -w /usr/src/mymaven -w /var/lib/jenkins/workspace/carts -v /var/lib/jenkins/workspace/carts:/var/lib/jenkins/workspace/carts:rw,z -v /var/lib/jenkins/workspace/carts@tmp:/var/lib/jenkins/workspace/carts@tmp:rw,z' 
          reuseNode true
        }
      }
      steps{
         sh 'mvn -B -DskipTests clean package'
      }
    }
    stage('SonarQube analysis'){
      steps{
        withSonarQubeEnv(installationName: 'Sonarqube2', credentialsId: 'Sonarqube2') {
          sh "${tool("sonar_scanner")}/bin/sonar-scanner"
        }
      }
    }
    stage('Building image') {
      steps{
        script {
          sh 'pwd'
          sh 'cp ./target/*.jar .'
          dockerImage = docker.build("$registry:$DOCKER_TAG")
        }
      }
    }
    stage('Static Security Assesment'){
      steps{
      sh 'docker run --name ${IMAGE} -t -d $registry:${DOCKER_TAG}'
      sh 'inspec exec https://github.com/dev-sec/linux-baseline -t docker://${IMAGE} --chef-license=accept || true'
      sh 'docker stop ${IMAGE}'
      sh 'docker container rm $ {IMAGE}'
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
