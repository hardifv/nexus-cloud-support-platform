pipeline {
    agent any

    options {
        timestamps()
        disableConcurrentBuilds()
    }

    parameters {
        string(name: 'AWS_REGION', defaultValue: 'us-east-1', description: 'AWS region')
        string(name: 'PROJECT_NAME', defaultValue: 'nexus-support', description: 'Project name')
        string(name: 'ENVIRONMENT', defaultValue: 'dev', description: 'Environment name')
        string(name: 'VPC_CIDR', defaultValue: '10.10.0.0/16', description: 'VPC CIDR')
        string(name: 'NEXUS_AMI_ID', defaultValue: 'ami-02fe376e6ac9632c8', description: 'Pinned AMI ID for Nexus EC2')
        string(name: 'ALARM_EMAIL', defaultValue: 'hardif01@gmail.com', description: 'SNS alarm email')
    }

    environment {
        TF_IN_AUTOMATION = 'true'

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

        stage('Terraform Format Check') {
            steps {
                dir('infra/envs/dev') {
                    sh 'terraform fmt -check -recursive'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('infra/envs/dev') {
                    sh 'terraform init'
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
                dir('infra/envs/dev') {
                    sh 'terraform plan -out=tfplan'
                }
            }
        }

        stage('Manual Approval') {
            steps {
                input message: 'Review the Terraform plan. Apply changes?', ok: 'Apply'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('infra/envs/dev') {
                    sh 'terraform apply -auto-approve tfplan'
                }
            }
        }

        stage('Smoke Test') {
            steps {
                dir('infra/envs/dev') {
                    sh '''
                    ALB_DNS=$(terraform output -raw alb_dns_name)
                    echo "Testing Nexus through ALB: http://${ALB_DNS}"
                    curl -I --fail --max-time 30 http://${ALB_DNS}
                    '''
                }
            }
        }
    }

    post {
        success {
            echo 'Pipeline completed successfully. Infrastructure is applied and Nexus smoke test passed.'
        }

        failure {
            echo 'Pipeline failed. Check Terraform logs, AWS connectivity, credentials, or Nexus health.'
        }

        always {
            archiveArtifacts artifacts: 'infra/envs/dev/tfplan', fingerprint: true, allowEmptyArchive: true
        }
    }
}
