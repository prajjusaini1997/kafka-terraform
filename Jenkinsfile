pipeline {
    agent any

    environment {
        ANSIBLE_HOST_KEY_CHECKING = "False"
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
                    terraform init
                    terraform apply -auto-approve
                '''
            }
        }

        stage('Wait for EC2 Ready') {
            steps {
                sh '''
                    echo "Waiting 60 seconds for instances to be ready..."
                    sleep 60
                '''
            }
        }

        stage('Generate Dynamic Inventory') {
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

                    ansible-playbook -i inventories/aws_ec2.yml playbooks/kafka.yml \
                    --private-key /var/lib/jenkins/.ssh/ninja_key.pem \
                    -u ubuntu
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline SUCCESS ✅"
        }
        failure {
            echo "Pipeline FAILED ❌"
        }
    }
}
