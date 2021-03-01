def dockerTag = 'eoepca/ubuntu-pde'
def dockerNewVersion = 0.8



pipeline {
    
    parameters {
        string(defaultValue: 'https://registry.hub.docker.com', description: 'Set the docker repository URL', name: 'dockerrepo')
    }
    
    
    agent any
    stages {
        stage('Build & Publish Docker') {
            steps {
                script {
                    def app = docker.build(dockerTag, "-f ./ubuntu/Dockerfile .")
                    def mType=getTypeOfVersion(env.BRANCH_NAME)
                    docker.withRegistry("${dockerrepo}", 'docker-repo-creds') {
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
