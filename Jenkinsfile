pipeline {
    agent any

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

                terraform output -json kafka_private_ips | jq -r '.[]' >> ansible/inventory.ini

                echo "[kafka:children]" >> ansible/inventory.ini
                echo "broker" >> ansible/inventory.ini
                '''
            }
        }

        stage('Run Ansible (Kafka Setup)') {
            steps {
                sh '''
                ansible-playbook -i ansible/inventory.ini kafka-role/playbooks/kafka.yml
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline Success"
        }
        failure {
            echo "❌ Pipeline Failed - Check logs"
        }
    }
}
