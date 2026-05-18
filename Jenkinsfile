pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    parameters {
        string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS region')
        string(name: 'ALB_DNS_NAME', defaultValue: 'REPLACE_WITH_ALB_DNS', description: 'ALB DNS name for Nexus smoke test')
    }

    environment {
        TF_IN_AUTOMATION = 'true'
        AWS_DEFAULT_REGION = "${params.AWS_REGION}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Tool Versions') {
            steps {
                sh '''
                terraform version
                aws --version
                curl --version
                '''
            }
        }

        stage('Terraform Format Check') {
            steps {
                dir('infra/envs/dev') {
                    sh 'terraform fmt -check -recursive'
                }
            }
        }

        stage('Terraform Init Without Backend') {
            steps {
                dir('infra/envs/dev') {
                    sh 'terraform init -backend=false'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('infra/envs/dev') {
                    sh 'terraform validate'
                }
            }
        }

        stage('AWS Identity Check') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    sh 'aws sts get-caller-identity'
                }
            }
        }

        stage('Nexus Smoke Test') {
            steps {
                sh '''
                echo "Testing Nexus through ALB: http://${ALB_DNS_NAME}"
                curl -I --fail --max-time 30 http://${ALB_DNS_NAME}
                '''
            }
        }
    }

    post {
        success {
            echo 'Local Jenkins pipeline test completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Check tools, AWS credentials, Terraform validation, or ALB connectivity.'
        }
    }
}
