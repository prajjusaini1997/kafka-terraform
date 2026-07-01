pipeline {
    agent any

    stages {

        stage('Checkout Terraform Repo') {
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

                echo "[tag_kafka]" > ansible/inventory.ini

                terraform output -json kafka_private_ips | jq -r '.[]' >> ansible/inventory.ini

                echo "===== Inventory ====="
                cat ansible/inventory.ini
                '''
            }
        }

        stage('Checkout Ansible Repo') {
            steps {
                sh '''
                rm -rf kafka-role

                git clone https://github.com/prajjusaini1997/kafka-role.git

                echo "===== Ansible Repo ====="
                ls -R kafka-role
                '''
            }
        }

        stage('Run Ansible (Kafka Setup)') {
            steps {
                sh '''
                cd kafka-role

                echo "===== Current Directory ====="
                pwd

                echo "===== Files ====="
                ls -la

                echo "===== ansible.cfg ====="
                cat ansible.cfg

                ansible-playbook \
                  -i ../ansible/inventory.ini \
                  playbooks/kafka.yml
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

        always {
            cleanWs()
        }
    }
}
