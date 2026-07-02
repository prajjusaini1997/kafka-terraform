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

                ansible-playbook -i inventories/aws_ec2.yml playbooks/kafka.yml
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
    }
}
