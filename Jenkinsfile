pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                set -e
 
                ls -lah 

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
                  -i ../ansible/inventories/aws_ec2.yml \
                  kafka.yml \
                  --private-key ~/.ssh/ninja_key.pem \
                  -u ubuntu
                '''
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished'
        }
        failure {
            echo 'Pipeline failed'
        }
    }
}
