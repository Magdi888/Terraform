#!/usr/bin/env groovy

def BuildImage() {
    withCredentials([usernamePassword(credentialsId :'DockerHub',usernameVariable :'USER',passwordVariable :'PASSWORD')]){
       sh 'docker build -t amagdi888/my-repo:NodeJS-rds-redis -f dockerfile .'
       sh 'echo $PASSWORD | docker login -u $USER --password-stdin'
       sh 'docker push amagdi888/my-repo:NodeJS-rds-redis'
    }

}


def Deploy() {
    sh 'docker run -p 3000:3000 -d amagdi888/my-repo:NodeJS-rds-redis'
}

return this