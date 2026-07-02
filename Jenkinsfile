pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = "us-east-1"
        SSH_KEY = "/var/lib/jenkins/.ssh/ninja_key.pem"
    }

    stages {

        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Init & Apply') {
            steps {
                sh '''
                    set -e
                     # IMPORTANT: go to repo root where .tf files exist

                    terraform init
                    terraform apply -auto-approve
                '''
            }
        }

        stage('Generate Ansible Inventory') {
            steps {
                sh '''
                    set -e
                    cd kafka-role

                    ansible-inventory -i inventories/aws_ec2.yml --graph
                '''
            }
        }

        stage('Run Ansible Playbook') {
            steps {
                sh '''
                    set -e
                    cd kafka-role

                    ansible-playbook \
                        -i inventories/aws_ec2.yml \
                        playbooks/kafka.yml \
                        --private-key /var/lib/jenkins/.ssh/ninja_key.pem \
                        -u ubuntu
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline SUCCESS 🚀"
        }
        failure {
            echo "Pipeline FAILED ❌"
        }
    }
}
