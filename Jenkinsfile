pipeline {
    agent any

    environment {
        ANSIBLE_HOST_KEY_CHECKING = "False"
    }

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init') {
            steps {
                sh 'terraform init -upgrade'
            }
        }

        stage('Terraform Validate') {
            steps {
                sh 'terraform validate'
            }
        }

        stage('Terraform Plan') {
            steps {
                sh 'terraform plan'
            }
        }

        stage('Terraform Apply') {
            steps {
                sh 'terraform apply -auto-approve'
            }
        }

        stage('Generate Dynamic Inventory') {
            steps {
                sh '''
                mkdir -p ansible

                echo "[broker]" > ansible/inventory.ini

                echo "10.0.2.98" >> ansible/inventory.ini
                echo "10.0.3.55" >> ansible/inventory.ini
                echo "10.0.4.42" >> ansible/inventory.ini

                echo "[kafka:children]" >> ansible/inventory.ini
                echo "broker" >> ansible/inventory.ini

                echo "Final Inventory:"
                cat ansible/inventory.ini
                '''
            }
        }

        stage('Run Ansible (Kafka Setup)') {
    steps {
        sh '''
        ansible-playbook -i ansible/inventory.ini ../kafka-role/playbook.yml
        '''
    }
}
    post {
        success {
            echo "🚀 Kafka Cluster Deployed Successfully (Terraform + Ansible)"
        }
        failure {
            echo "❌ Pipeline Failed - Check logs"
        }
    }
}
