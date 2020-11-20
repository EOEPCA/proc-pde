def dockerTag = 'eoepca/ubuntu-pde'
def dockerNewVersion = 0.8

pipeline {
    agent any
    stages {
        stage('Build & Publish Docker') {
            steps {
                script {
                    def app = docker.build("-f", "ubuntu/Dockerfile", dockerTag, ".")
                    def mType=getTypeOfVersion(env.BRANCH_NAME)
                    docker.withRegistry('https://registry.hub.docker.com', 'dockerhub-fabricebrito') {
                      app.push("${mType}${dockerNewVersion}")
                      app.push("${mType}latest")
                    }
                }
            }
        }
    }
}

def getTypeOfVersion(branchName) {
  
  def matcher = (env.BRANCH_NAME =~ /master/)
  if (matcher.matches())
    return ""
  
  return "dev"
}
