pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    parameters {
        booleanParam(name: 'APPLY_CHANGES', defaultValue: false, description: 'Apply Terraform changes after manual approval')
        string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS region')
        string(name: 'PROJECT_NAME', defaultValue: 'nexus-support', description: 'Project name')
        string(name: 'ENVIRONMENT', defaultValue: 'dev', description: 'Environment name')
        string(name: 'VPC_CIDR', defaultValue: '10.10.0.0/16', description: 'VPC CIDR')
        string(name: 'NEXUS_AMI_ID', defaultValue: 'ami-02fe376e6ac9632c8', description: 'Pinned AMI ID for Nexus EC2')
        string(name: 'ALARM_EMAIL', defaultValue: 'hardif01@gmail.com', description: 'SNS alarm email')
        string(name: 'ALB_DNS_NAME', defaultValue: 'nexus-support-dev-alb-729888973.us-east-1.elb.amazonaws.com', description: 'ALB DNS name for smoke test')
    }

    environment {
        TF_IN_AUTOMATION = 'true'
        AWS_DEFAULT_REGION = "${params.AWS_REGION}"

        TF_VAR_aws_region   = "${params.AWS_REGION}"
        TF_VAR_project_name = "${params.PROJECT_NAME}"
        TF_VAR_environment  = "${params.ENVIRONMENT}"
        TF_VAR_vpc_cidr     = "${params.VPC_CIDR}"

        TF_VAR_public_subnet_cidrs  = '["10.10.1.0/24", "10.10.2.0/24"]'
        TF_VAR_private_subnet_cidrs = '["10.10.11.0/24", "10.10.12.0/24"]'

        TF_VAR_nexus_ami_id = "${params.NEXUS_AMI_ID}"
        TF_VAR_alarm_email  = "${params.ALARM_EMAIL}"
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

        stage('Terraform Format Check') {
            steps {
                dir('infra/envs/dev') {
                    sh 'terraform fmt -check -recursive'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('infra/envs/dev') {
                        sh 'terraform init'
                    }
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

        stage('Terraform Plan') {
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('infra/envs/dev') {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Manual Approval') {
            when {
                expression {
                    return params.APPLY_CHANGES == true
                }
            }
            steps {
                input message: 'Review the Terraform plan. Apply changes?', ok: 'Apply'
            }
        }

        stage('Terraform Apply') {
            when {
                expression {
                    return params.APPLY_CHANGES == true
                }
            }
            steps {
                withCredentials([
                    string(credentialsId: 'aws-access-key-id', variable: 'AWS_ACCESS_KEY_ID'),
                    string(credentialsId: 'aws-secret-access-key', variable: 'AWS_SECRET_ACCESS_KEY')
                ]) {
                    dir('infra/envs/dev') {
                        sh 'terraform apply -auto-approve tfplan'
                    }
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
            echo 'Pipeline completed successfully.'
        }

        failure {
            echo 'Pipeline failed. Check Terraform logs, AWS credentials, state backend, or Nexus health.'
        }

        always {
            archiveArtifacts artifacts: 'infra/envs/dev/tfplan', fingerprint: true, allowEmptyArchive: true
        }
    }
}
