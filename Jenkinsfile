pipeline {
  agent any

  options {
    timestamps()
  }

  environment {
    DOCKER_IMAGE = 'wajih20032002/todolist'
    MAVEN_REPO_LOCAL = "${WORKSPACE}\\.m2\\repository"
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
        bat '''
          echo [INFO] Java version:
          java -version

          echo [INFO] Maven version:
          mvn -version

          echo [INFO] Docker version:
          docker --version

          echo [INFO] Minikube version:
          minikube version

          echo [INFO] Kubectl version:
          kubectl version --client
        '''
      }
    }

    stage('Build & Test') {
      steps {
        bat '''
          echo [INFO] Building with Maven...
          mvn -B -Dmaven.repo.local=%MAVEN_REPO_LOCAL% clean package
        '''
      }
      post {
        always {
          junit testResults: 'target/surefire-reports/*.xml', allowEmptyResults: true
        }
      }
    }

    stage('Docker Build (local)') {
      steps {
        bat '''
          echo [INFO] Looking for JAR in target\\...

          REM Find first JAR in target\\
          for %%F in (target\\*.jar) do (
            set "ARTIFACT=%%F"
            goto foundJar
          )

          echo [ERROR] No JAR found in target\\
          exit /b 1

          :foundJar
          echo [INFO] Using artifact: %ARTIFACT%

          echo [INFO] Building Docker image %DOCKER_IMAGE%:latest ...
          docker build --build-arg JAR_FILE=%ARTIFACT% -t %DOCKER_IMAGE%:latest .
        '''
      }
    }

    stage('Load image into Minikube') {
      steps {
        bat '''
          echo [INFO] Loading image into Minikube...
          minikube image load %DOCKER_IMAGE%:latest
        '''
      }
    }

    stage('Deploy to Kubernetes') {
      steps {
        bat '''
          echo [INFO] Applying Kubernetes manifests...

          kubectl apply -f k8s\\postgres.yaml
          kubectl apply -f k8s\\deployment.yaml
          kubectl apply -f k8s\\service.yaml

          echo [INFO] Current pods:
          kubectl get pods

          echo [INFO] Current services:
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
