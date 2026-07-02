pipeline {
    agent any

    environment {
        TF_IN_AUTOMATION = "true"
    }

    stages {

        stage('Checkout Terraform Repo') {
            steps {
                checkout scm
            }
        }

        stage('Debug Workspace') {
            steps {
                sh '''
                echo "===== WORKSPACE ====="
                pwd
                ls -la
                ls -la $WORKSPACE
                '''
            }
        }

        stage('Debug TF Files') {
            steps {
                sh '''
                echo "===== TF FILE DEBUG ====="
                ls -la
                find . -name "*.tfvars"

                echo "===== TFVARS CONTENT ====="
                cat terraform.tfvars || true

                echo "===== TERRAFORM WORKSPACE ====="
                terraform workspace show || true
                '''
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                terraform init -upgrade
                '''
            }
        }

        stage('Terraform Validate') {
            steps {
                sh '''
                terraform validate
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                terraform plan -input=false -no-color -var-file=terraform.tfvars
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                terraform apply -input=false -auto-approve -no-color -var-file=terraform.tfvars
                '''
            }
        }

        stage('Generate Dynamic Inventory') {
            steps {
                sh '''
                set -e

                mkdir -p ansible

                echo "[tag_kafka]" > ansible/inventory.ini

                terraform output -json kafka_private_ips | jq -r '.[]' >> ansible/inventory.ini

                echo "===== INVENTORY ====="
                cat ansible/inventory.ini
                '''
            }
        }

        stage('Checkout Ansible Repo') {
            steps {
                sh '''
                set -e

                rm -rf kafka-role

                git clone https://github.com/prajjusaini1997/kafka-role.git

                echo "===== ANSIBLE REPO ====="
                ls -R kafka-role
                '''
            }
        }

        stage('Run Ansible (Kafka Setup)') {
            steps {
                sh '''
                set -e

                cd kafka-role

                echo "===== START ANSIBLE ====="

                ansible-playbook \
                  -i ../ansible/inventory.ini \
                  playbooks/kafka.yml
                '''
            }
        }

    }

    post {
        success {
            echo "✅ PIPELINE SUCCESS - Kafka Infra Ready"
        }

        failure {
            echo "❌ PIPELINE FAILED - Check logs"
        }

        always {
            cleanWs()
        }
    }
}
