pipeline {
    agent any

    environment {
        WESTUS_VM = "azureuser@<WEST-US2-VM-IP>"
        KOREA_VM  = "azureuser@<KOREA-CENTRAL-VM-IP>"
        TOMCAT_DIR = "/opt/tomcat/webapps"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                cd terraform
                terraform init
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                cd terraform
                terraform plan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                cd terraform
                terraform apply -auto-approve
                '''
            }
        }

        stage('Deploy DateTime App') {
            steps {
                sh '''
                scp app/index.jsp ${KOREA_VM}:${TOMCAT_DIR}/datetime-app/index.jsp
                scp app/index.jsp ${WESTUS_VM}:${TOMCAT_DIR}/datetime-app/index.jsp
                '''
            }
        }
    }
}
