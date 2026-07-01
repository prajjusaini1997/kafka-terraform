pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Create tfvars') {
            steps {
                sh '''
                cat > terraform.tfvars <<EOF
aws_region = "us-east-1"
vpc_cidr = "10.0.0.0/16"
public_subnet_cidr = "10.0.1.0/24"
availability_zone = "us-east-1a"
instance_type = "t3.micro"
ami_id = "ami-0b6d9d3d33ba97d99"
key_name = "ninja_key"
EOF
                '''
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
    }
}
