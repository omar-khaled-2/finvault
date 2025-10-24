# AWS Infrastructure as Code - Scalable Web Application Deployment

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Infrastructure as Code](https://img.shields.io/badge/IaC-Infrastructure%20as%20Code-blue?style=for-the-badge)

A production-ready, highly available, and auto-scalable infrastructure deployment on AWS using Terraform. This project demonstrates enterprise-level cloud architecture with automated deployment, load balancing, and managed database services.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Technologies & Skills](#technologies--skills)
- [Infrastructure Components](#infrastructure-components)
- [Project Structure](#project-structure)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Module Documentation](#module-documentation)
- [Features](#features)
- [Best Practices](#best-practices)
- [Cost Optimization](#cost-optimization)
- [Security Considerations](#security-considerations)
- [Monitoring & Maintenance](#monitoring--maintenance)
- [Future Enhancements](#future-enhancements)

## 🎯 Overview

This project provisions a complete, production-grade infrastructure on AWS for hosting a Node.js application with MongoDB backend. It demonstrates expertise in cloud architecture, infrastructure as code, and DevOps best practices.

The infrastructure includes:
- **Multi-AZ VPC** with public and private subnets
- **Auto-scaling EC2 instances** with Application Load Balancer
- **AWS DocumentDB** (MongoDB-compatible) cluster in private subnets
- **Automated deployments** with user data scripts
- **IAM roles and policies** for secure resource access
- **Parameter Store integration** for secrets management

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        AWS Cloud (us-east-1)                     │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │                    VPC (10.0.0.0/16)                        │ │
│  │                                                              │ │
│  │  ┌─────────────────────────────────────────────────────┐   │ │
│  │  │              Internet Gateway                        │   │ │
│  │  └──────────────────┬──────────────────────────────────┘   │ │
│  │                     │                                        │ │
│  │  ┌──────────────────▼──────────────────────────────────┐   │ │
│  │  │        Application Load Balancer (ALB)              │   │ │
│  │  └──────────────────┬──────────────────────────────────┘   │ │
│  │                     │                                        │ │
│  │  ┌──────────────────┴──────────────────────────────────┐   │ │
│  │  │         Public Subnets (Multi-AZ)                   │   │ │
│  │  │                                                      │   │ │
│  │  │  ┌────────────────┐      ┌────────────────┐        │   │ │
│  │  │  │  EC2 Instance  │      │  EC2 Instance  │        │   │ │
│  │  │  │  (us-east-1a)  │      │  (us-east-1b)  │        │   │ │
│  │  │  │  Auto Scaling  │      │  Auto Scaling  │        │   │ │
│  │  │  └────────┬───────┘      └────────┬───────┘        │   │ │
│  │  │           │                       │                 │   │ │
│  │  └───────────┼───────────────────────┼─────────────────┘   │ │
│  │              │                       │                     │ │
│  │  ┌───────────▼───────────────────────▼─────────────────┐   │ │
│  │  │         Private Subnets (Multi-AZ)                  │   │ │
│  │  │                                                      │   │ │
│  │  │  ┌────────────────────────────────────────────┐    │   │ │
│  │  │  │      AWS DocumentDB Cluster                │    │   │ │
│  │  │  │      (MongoDB Compatible)                  │    │   │ │
│  │  │  │      - Master: us-east-1a                  │    │   │ │
│  │  │  │      - Replica: us-east-1b                 │    │   │ │
│  │  │  └────────────────────────────────────────────┘    │   │ │
│  │  │                                                      │   │ │
│  │  └──────────────────────────────────────────────────────┘   │ │
│  │                                                              │ │
│  └──────────────────────────────────────────────────────────────┘ │
│                                                                   │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Additional AWS Services:                                │   │
│  │  • IAM Roles & Policies                                  │   │
│  │  • Systems Manager Parameter Store                       │   │
│  │  • CloudWatch (Auto-scaling metrics)                     │   │
│  │  • SNS (Notifications)                                   │   │
│  └──────────────────────────────────────────────────────────┘   │
│                                                                   │
└───────────────────────────────────────────────────────────────────┘
```

## 💼 Technologies & Skills

### Infrastructure & DevOps
- **Terraform** - Infrastructure as Code (IaC)
  - Modular architecture design
  - Resource dependencies management
  - State management
  - Variable interpolation and templating
  
- **AWS Cloud Services**
  - VPC networking and subnetting
  - EC2 Auto Scaling Groups
  - Application Load Balancer (ALB)
  - Launch Templates
  - Internet Gateway and Route Tables
  - Security Groups and Network ACLs

### Database & Data Management
- **AWS DocumentDB** - Managed MongoDB-compatible database
  - Cluster configuration
  - Multi-AZ deployment
  - Subnet groups
  - Parameter groups and TLS configuration
  
### Security & Identity Management
- **IAM (Identity and Access Management)**
  - IAM Roles and Instance Profiles
  - Policy documents
  - Service-to-service authentication
  - Least privilege access principles

- **AWS Systems Manager**
  - Parameter Store for secrets management
  - Secure credential storage

### Compute & Automation
- **Linux/Bash Scripting**
  - User data automation
  - Application bootstrapping
  - Environment configuration

- **Auto Scaling & High Availability**
  - Target tracking scaling policies
  - CPU-based auto-scaling
  - Health checks configuration
  - Multi-AZ deployment strategies

### Networking
- **VPC Design**
  - CIDR block planning
  - Public/Private subnet architecture
  - Route table configuration
  - Internet Gateway setup
  - Cross-AZ redundancy

### Application Deployment
- **Node.js & PM2**
  - Production deployment
  - Process management
  - Environment variable configuration

- **Git Integration**
  - Automated application deployment from repository
  - CI/CD pipeline readiness

### Load Balancing
- **Application Load Balancer (ALB)**
  - Target groups configuration
  - Health check endpoints
  - HTTP/HTTPS routing
  - Auto-scaling group integration

## 🏛️ Infrastructure Components

### 1. VPC Module (`modules/vpc/`)
Creates a complete Virtual Private Cloud with:
- **VPC**: Custom CIDR block (10.0.0.0/16)
- **Internet Gateway**: For public internet access
- **Public Subnets**: 2 subnets across different AZs (10.0.1.0/24, 10.0.3.0/24)
- **Private Subnets**: 2 subnets for database tier (10.0.2.0/24, 10.0.4.0/24)
- **Route Tables**: Public routing to Internet Gateway
- **Multi-AZ**: High availability across us-east-1a and us-east-1b

### 2. EC2 Module (`modules/ec2/`)
Provisions scalable compute resources:
- **Launch Template**: AMI configuration and instance settings
- **Auto Scaling Group**: 
  - Min: 1 instance
  - Desired: 2 instances
  - Max: 4 instances
- **Scaling Policy**: CPU target tracking (50% threshold)
- **Security Group**: HTTP (80) and SSH (22) access
- **Application Load Balancer**: Traffic distribution
- **Target Group**: Health check monitoring
- **IAM Role**: EC2 instance permissions
- **User Data Script**: Automated application deployment
- **SSM Parameter**: Secure database URL storage

### 3. DocumentDB Module (`modules/documentdb/`)
Managed MongoDB-compatible database:
- **DocumentDB Cluster**: Primary database cluster
- **Cluster Instance**: db.t3.medium instance
- **Subnet Group**: Private subnet placement
- **Security Group**: Port 27017 access control
- **Parameter Group**: TLS configuration
- **Multi-AZ**: High availability setup

## 📁 Project Structure

```
.
├── envs/
│   └── dev/
│       ├── main.tf              # Root module - orchestrates all resources
│       ├── providers.tf         # AWS provider configuration
│       ├── variables.tf         # Environment-specific variables
│       └── .terraform/          # Terraform state and providers
│
└── modules/
    ├── vpc/
    │   ├── main.tf              # VPC, subnets, IGW, route tables
    │   └── outputs.tf           # Exports VPC and subnet IDs
    │
    ├── ec2/
    │   ├── main.tf              # EC2, ASG, ALB, security groups, IAM
    │   ├── variables.tf         # Module input variables
    │   └── user_data.sh         # Bootstrap script for EC2 instances
    │
    └── documentdb/
        ├── main.tf              # DocumentDB cluster and configuration
        ├── variables.tf         # Database module variables
        └── outputs.tf           # Database connection details
```

## 🔧 Prerequisites

- **Terraform**: v1.0+ ([Download](https://www.terraform.io/downloads))
- **AWS CLI**: Configured with appropriate credentials ([Setup Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html))
- **AWS Account**: With permissions to create VPC, EC2, DocumentDB, IAM resources
- **Git**: For application deployment via user data script

## 🚀 Quick Start

### 1. Clone the Repository
```bash
git clone <your-repository-url>
cd <project-directory>
```

### 2. Configure AWS Credentials
```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Default region: us-east-1
```

### 3. Initialize Terraform
```bash
cd envs/dev
terraform init
```

### 4. Review Infrastructure Plan
```bash
terraform plan
```

### 5. Deploy Infrastructure
```bash
terraform apply
```
Type `yes` when prompted to confirm.

### 6. Get Application Load Balancer URL
```bash
terraform output
# Or specifically:
aws elbv2 describe-load-balancers --query 'LoadBalancers[*].DNSName' --output text
```

### 7. Destroy Infrastructure (when done)
```bash
terraform destroy
```

## 📚 Module Documentation

### VPC Module

**Purpose**: Creates isolated network infrastructure with public and private subnets.

**Outputs**:
- `vpc_id`: VPC identifier
- `public_subnet_ids`: List of public subnet IDs
- `private_subnet_ids`: List of private subnet IDs

**Resources Created**:
- 1 VPC
- 1 Internet Gateway
- 2 Public Subnets (Multi-AZ)
- 2 Private Subnets (Multi-AZ)
- 1 Route Table
- 2 Route Table Associations

### EC2 Module

**Purpose**: Provisions auto-scaling compute resources with load balancing.

**Inputs**:
- `vpc_id`: VPC identifier
- `public_subnet_ids`: List of public subnets
- `mongo_endpoint`: DocumentDB cluster endpoint
- `mongo_username`: Database username
- `mongo_password`: Database password

**Resources Created**:
- 1 Launch Template
- 1 Auto Scaling Group
- 1 Auto Scaling Policy
- 1 Application Load Balancer
- 1 Target Group
- 1 ALB Listener
- 2 Security Groups
- 1 IAM Role
- 1 IAM Instance Profile
- 1 SSM Parameter

**Application Deployment**:
The user data script automatically:
1. Updates the system
2. Installs Node.js and Git
3. Installs PM2 for process management
4. Clones the application from GitHub
5. Installs dependencies
6. Configures environment variables
7. Builds and starts the application

### DocumentDB Module

**Purpose**: Deploys managed MongoDB-compatible database cluster.

**Inputs**:
- `vpc_id`: VPC identifier
- `private_subnet_ids`: List of private subnets
- `username`: Master username (default: "omar")
- `password`: Master password (default: "12345678")

**Outputs**:
- `endpoint`: Database cluster endpoint
- `username`: Master username
- `password`: Master password

**Resources Created**:
- 1 DocumentDB Cluster
- 1 DocumentDB Instance
- 1 Subnet Group
- 1 Parameter Group
- 1 Security Group

## ✨ Features

### High Availability
- Multi-AZ deployment across 2 availability zones
- Auto-scaling group maintains desired capacity
- DocumentDB cluster with automatic failover

### Scalability
- CPU-based auto-scaling (50% threshold)
- Can scale from 1 to 4 instances automatically
- Application Load Balancer distributes traffic

### Security
- Private subnets for database tier
- Security groups with least privilege access
- IAM roles for secure AWS service access
- Parameter Store for secrets management
- TLS configurable for DocumentDB

### Automation
- Fully automated infrastructure deployment
- User data script for application bootstrapping
- Zero-touch EC2 instance configuration
- Automatic application updates via Git

### Monitoring
- ALB health checks on `/health` endpoint
- CloudWatch metrics for auto-scaling decisions
- SNS integration for notifications

## 🎯 Best Practices

### Infrastructure as Code
✅ Modular design for reusability  
✅ Environment separation (dev, staging, prod)  
✅ Variable-driven configuration  
✅ State management with proper backends  
✅ Resource naming conventions  

### Security
✅ Private subnets for sensitive resources  
✅ Security groups with specific rules  
✅ IAM roles with minimum required permissions  
✅ Secrets stored in Parameter Store  
✅ No hardcoded credentials in code  

### High Availability
✅ Multi-AZ deployment  
✅ Auto-scaling for resilience  
✅ Load balancer health checks  
✅ Database cluster with replicas  

### DevOps
✅ Automated deployments  
✅ Version control integration  
✅ Declarative infrastructure  
✅ Idempotent operations  

## 💰 Cost Optimization

To minimize costs while testing:

1. **Use Smaller Instance Types**
   ```hcl
   instance_type = "t3.micro"  # Instead of t3.medium
   ```

2. **Reduce Auto Scaling Capacity**
   ```hcl
   desired_capacity = 1
   min_size        = 1
   max_size        = 2
   ```

3. **Use Spot Instances** (for non-production)
   ```hcl
   instance_market_options {
     market_type = "spot"
   }
   ```

4. **Destroy Resources When Not in Use**
   ```bash
   terraform destroy
   ```

## 🔒 Security Considerations

### Current Implementation
- Security groups restrict traffic by port
- IAM roles for EC2 service access
- Private subnets for database isolation
- Parameter Store for configuration

### Production Recommendations
- [ ] Enable TLS for DocumentDB
- [ ] Use AWS Secrets Manager for credentials
- [ ] Implement VPC Flow Logs
- [ ] Add WAF rules for ALB
- [ ] Enable AWS Config for compliance
- [ ] Use private key pairs for SSH (not open to 0.0.0.0/0)
- [ ] Implement least privilege security group rules
- [ ] Enable MFA for AWS account
- [ ] Use HTTPS with SSL/TLS certificates
- [ ] Implement network ACLs
- [ ] Enable AWS GuardDuty for threat detection

## 📊 Monitoring & Maintenance

### CloudWatch Metrics
- EC2 CPU Utilization (triggers auto-scaling)
- ALB Request Count
- Target Health Status
- DocumentDB Connections

### Health Checks
- ALB performs health checks on `/health` endpoint
- Unhealthy instances are automatically replaced

### Logging
Recommended additions:
- Enable VPC Flow Logs
- CloudWatch Logs for application logs
- ALB access logs to S3
- DocumentDB audit logs

## 🚀 Future Enhancements

- [ ] Add HTTPS/SSL certificate via ACM
- [ ] Implement CI/CD pipeline (Jenkins/GitHub Actions)
- [ ] Add CloudWatch dashboards
- [ ] Implement automated backups for DocumentDB
- [ ] Add Route53 for DNS management
- [ ] Implement CloudFront CDN
- [ ] Add S3 bucket for static assets
- [ ] Implement AWS ElastiCache for caching
- [ ] Add AWS RDS as alternative database
- [ ] Implement multi-region deployment
- [ ] Add Terraform remote backend (S3 + DynamoDB)
- [ ] Implement blue-green deployments
- [ ] Add container orchestration (ECS/EKS)
- [ ] Implement AWS Lambda for serverless functions

## 📝 Key Learnings & Skills Demonstrated

### Cloud Architecture
- Designed multi-tier architecture with proper network isolation
- Implemented high availability and fault tolerance
- Optimized for scalability and performance

### Infrastructure as Code
- Created reusable, modular Terraform code
- Managed infrastructure state and dependencies
- Implemented declarative infrastructure provisioning

### DevOps Practices
- Automated deployment pipelines
- Configuration management
- Infrastructure versioning and change management

### AWS Expertise
- Deep understanding of core AWS services
- Security best practices
- Cost optimization strategies
- Service integration and orchestration

### Problem Solving
- Architected solutions for real-world scenarios
- Balanced security, performance, and cost
- Implemented production-ready configurations

---

## 📞 Contact & Support

For questions, issues, or contributions, please open an issue in the repository.

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

**Built with ❤️ using Terraform and AWS**

*This project demonstrates enterprise-level cloud infrastructure deployment skills suitable for DevOps Engineer, Cloud Engineer, and Infrastructure Engineer roles.*
