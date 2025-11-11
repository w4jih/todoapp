pipeline {
  agent any

  options {
    timestamps()
  }

  environment {
    DOCKER_IMAGE = 'wajih20032002/todolist'
    MAVEN_REPO_LOCAL = "${WORKSPACE}/.m2/repository"
  }

  stages {

    stage('Checkout') {
      steps {
        git branch: 'main',
            url: 'https://github.com/Macktireh/SpringBootTodolist.git'
      }
    }

    stage('Env') {
      steps {
        sh 'java -version || true'
        sh 'mvn -version || true'
        sh 'docker --version || true'
        sh 'minikube version || true'
        sh 'kubectl version --client || true'
      }
    }

    stage('Build & Test') {
      steps {
        sh 'mvn -B -Dmaven.repo.local=$MAVEN_REPO_LOCAL clean package'
      }
      post {
        always {
          junit testResults: 'target/surefire-reports/*.xml', allowEmptyResults: true
        }
      }
    }

    stage('Docker Build (local)') {
      steps {
        sh '''
          set -e
          ARTIFACT=$(ls target/*.jar | head -n1)
          echo "[INFO] Using artifact: $ARTIFACT"
          docker build --build-arg JAR_FILE=$ARTIFACT -t ${DOCKER_IMAGE}:latest .
        '''
      }
    }

    stage('Load image into Minikube') {
      steps {
        sh '''
          echo "[INFO] Loading image into Minikube..."
          minikube image load ${DOCKER_IMAGE}:latest
        '''
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        sh '''
          echo "[INFO] Applying Kubernetes manifests..."
          kubectl apply -f k8s/postgres.yaml
          kubectl apply -f k8s/deployment.yaml
          kubectl apply -f k8s/service.yaml

          echo "[INFO] Current pods:"
          kubectl get pods

          echo "[INFO] Current services:"
          kubectl get svc
        '''
      }
    }
  }

  post {
    always {
      cleanWs()
    }
  }
}
