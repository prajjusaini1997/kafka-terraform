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

        stage('Debug Ansible Inventory') {
            steps {
                sh '''
                set -e

                cd kafka-role

                echo "==============================="
                echo "CURRENT DIRECTORY"
                pwd

                echo "==============================="
                echo "FILES"
                ls -la

                echo "==============================="
                echo "AWS ID"
                aws sts get-caller-identity

                echo "==============================="
                echo "ANSIBLE VERSION"
                ansible --version

                echo "==============================="
                echo "INSTALLED COLLECTIONS"
                ansible-galaxy collection list

                echo "==============================="
                echo "INVENTORY FILE"
                cat inventories/aws_ec2.yml

                echo "==============================="
                echo "INVENTORY GRAPH"
                ansible-inventory -i inventories/aws_ec2.yml --graph

                echo "==============================="
                echo "INVENTORY LIST"
                ansible-inventory -i inventories/aws_ec2.yml --list
                '''
            }
        }
    }

    post {
        success {
            echo "DEBUG PIPELINE COMPLETED"
        }

        failure {
            echo "PIPELINE FAILED - CHECK LOGS"
        }
    }
}
