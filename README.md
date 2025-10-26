# 🏦 FinVault - Enterprise Digital Wallet & Money Transfer Platform

<div align="center">

![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![NestJS](https://img.shields.io/badge/NestJS-E0234E?style=for-the-badge&logo=nestjs&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=for-the-badge&logo=typescript&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=for-the-badge&logo=mongodb&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

**A production-ready, cloud-native digital wallet platform with enterprise-grade infrastructure**

[Features](#-key-features) • [Architecture](#-architecture) • [Infrastructure](#-infrastructure-as-code) • [Getting Started](#-getting-started) • [CI/CD](#-cicd-pipeline)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Key Features](#-key-features)
- [Architecture](#-architecture)
- [Technology Stack](#-technology-stack)
- [Infrastructure as Code](#-infrastructure-as-code)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Getting Started](#-getting-started)
- [Project Structure](#-project-structure)
- [Skills Demonstrated](#-skills-demonstrated)
- [Monitoring & Observability](#-monitoring--observability)
- [Security](#-security)

---

## 🎯 Overview

**FinVault** is a comprehensive, production-ready digital wallet and money transfer platform built with modern cloud-native technologies. This project demonstrates **end-to-end DevOps and software engineering practices**, from application development to cloud infrastructure automation and continuous deployment.

### What Makes This Project Stand Out

✨ **Full-Stack Cloud Engineering**
- Complete infrastructure automation using Terraform
- Production-grade AWS architecture with high availability
- Automated CI/CD pipeline with AWS CodePipeline
- Infrastructure as Code following best practices

🏗️ **Enterprise Architecture**
- Microservices-based NestJS backend
- Auto-scaling infrastructure with load balancing
- Secure networking with VPC, public/private subnets, and NAT Gateway
- Managed DocumentDB for data persistence

🔒 **Security First**
- Multi-layer security (JWT, OTP, SMS verification)
- Secrets management with AWS Systems Manager Parameter Store
- Security groups and network ACLs
- Encrypted database connections

🚀 **DevOps Excellence**
- Complete CI/CD automation
- Infrastructure provisioning with Terraform
- Zero-downtime deployments with AWS CodeDeploy
- Automated testing and builds

---

## ✨ Key Features

### Application Features

- 🔐 **Secure Authentication**: Phone-based registration with SMS OTP verification
- 💰 **Digital Wallet**: Individual wallet management with real-time balance tracking
- 💸 **Money Transfers**: Peer-to-peer money transfers with two-factor verification
- 📊 **Transaction History**: Complete audit trail of all financial operations
- 🛡️ **Security**: JWT authentication, OTP verification, cryptographic hashing
- 📱 **SMS Integration**: AWS SNS for reliable SMS delivery

### Infrastructure Features

- ☁️ **Cloud-Native**: Deployed on AWS with managed services
- 🔄 **Auto-Scaling**: Automatic scaling based on CPU utilization (1-4 instances)
- ⚖️ **Load Balancing**: Application Load Balancer for traffic distribution
- 🌐 **High Availability**: Multi-AZ deployment across 2 availability zones
- 🗄️ **Managed Database**: AWS DocumentDB (MongoDB-compatible)
- 📦 **Artifact Management**: S3 bucket for build artifacts
- 🔧 **Infrastructure as Code**: 100% Terraform-managed infrastructure
- 🚀 **CI/CD**: Automated deployment pipeline with AWS CodePipeline

---

## 🏗 Architecture

### High-Level Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         Internet                                 │
└────────────────────────────────┬────────────────────────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   Application Load      │
                    │      Balancer           │
                    │   (Public Subnets)      │
                    └────────────┬────────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
┌───────▼────────┐      ┌───────▼────────┐      ┌───────▼────────┐
│   EC2 Instance │      │   EC2 Instance │      │   EC2 Instance │
│   (NestJS API) │      │   (NestJS API) │      │   (NestJS API) │
│ Private Subnet │      │ Private Subnet │      │ Private Subnet │
└───────┬────────┘      └───────┬────────┘      └───────┬────────┘
        │                       │                        │
        └───────────────────────┼────────────────────────┘
                                │
                    ┌───────────▼────────────┐
                    │    DocumentDB Cluster  │
                    │  (MongoDB Compatible)  │
                    │   (Private Subnets)    │
                    └────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│                      CI/CD Pipeline                              │
├─────────────────────────────────────────────────────────────────┤
│  GitHub → CodePipeline → CodeBuild → CodeDeploy → EC2 Fleet     │
└─────────────────────────────────────────────────────────────────┘
```

### Network Architecture

```
VPC (10.0.0.0/16)
│
├── Public Subnets (Internet-facing)
│   ├── 10.0.0.0/24 (AZ-1) - Application Load Balancer
│   ├── 10.0.1.0/24 (AZ-2) - Application Load Balancer
│   └── NAT Gateway (for private subnet internet access)
│
└── Private Subnets (Internal)
    ├── 10.0.2.0/24 (AZ-1) - EC2 Instances, DocumentDB
    └── 10.0.3.0/24 (AZ-2) - EC2 Instances, DocumentDB
```

### Security Architecture

```
┌─────────────────────────────────────────────────────────┐
│                    Security Layers                       │
├─────────────────────────────────────────────────────────┤
│ 1. Network Security                                      │
│    - VPC Isolation                                       │
│    - Security Groups (Port 80, 27017)                    │
│    - Private/Public Subnet Separation                    │
│    - NAT Gateway for outbound traffic                    │
│                                                           │
│ 2. Application Security                                  │
│    - JWT Authentication                                  │
│    - OTP Verification (SMS)                              │
│    - Input Validation (DTOs)                             │
│    - Cryptographic Hashing                               │
│                                                           │
│ 3. Data Security                                         │
│    - AWS Systems Manager Parameter Store (Secrets)      │
│    - Encrypted database connections                      │
│    - Secure environment variable management              │
│                                                           │
│ 4. IAM Security                                          │
│    - Least privilege access                              │
│    - Service-specific IAM roles                          │
│    - Instance profiles for EC2                           │
└─────────────────────────────────────────────────────────┘
```

---

## 🛠 Technology Stack

### Backend Application

| Technology | Purpose | Why Chosen |
|------------|---------|------------|
| **NestJS** | Application Framework | Enterprise-grade, modular architecture, TypeScript-first |
| **TypeScript** | Programming Language | Type safety, better tooling, reduced runtime errors |
| **MongoDB/DocumentDB** | Database | Flexible schema, high performance, AWS-managed |
| **JWT** | Authentication | Stateless, scalable authentication |
| **AWS SNS** | SMS Service | Reliable SMS delivery, global reach |
| **Mongoose** | ODM | Schema validation, middleware, type safety |
| **class-validator** | Validation | Decorator-based validation |

### Infrastructure & DevOps

| Technology | Purpose | Why Chosen |
|------------|---------|------------|
| **Terraform** | IaC Tool | Declarative, version-controlled infrastructure |
| **AWS VPC** | Networking | Isolated network environment |
| **AWS EC2** | Compute | Flexible, scalable compute instances |
| **AWS ALB** | Load Balancing | Layer 7 load balancing, health checks |
| **Auto Scaling** | Scalability | Automatic capacity adjustment |
| **DocumentDB** | Database | Managed MongoDB-compatible database |
| **AWS CodePipeline** | CI/CD Orchestration | Native AWS integration |
| **AWS CodeBuild** | Build Service | Managed build environment |
| **AWS CodeDeploy** | Deployment | Blue-green, rolling deployments |
| **AWS S3** | Artifact Storage | Reliable artifact repository |
| **AWS SSM** | Secrets Management | Secure parameter storage |
| **AWS SNS** | Notifications | SMS OTP delivery |

---

## 🏗 Infrastructure as Code

### Terraform Architecture

This project uses **Terraform** to provision and manage 100% of the infrastructure. The entire cloud environment is codified and version-controlled.

#### Resources Managed by Terraform

**Networking (VPC Module)**
- VPC with custom CIDR (10.0.0.0/16)
- Internet Gateway for public internet access
- 2 Public Subnets across 2 AZs
- 2 Private Subnets across 2 AZs
- NAT Gateway with Elastic IP
- Route Tables and Associations
- Security Groups

**Compute (EC2 Module)**
- Launch Template with custom AMI
- Auto Scaling Group (1-4 instances)
- Target Tracking Scaling Policy (CPU-based)
- Application Load Balancer
- Target Groups with health checks
- IAM Roles and Instance Profiles
- Security Groups (HTTP ingress)

**Database (DocumentDB Module)**
- DocumentDB Cluster
- DocumentDB Instance (db.t3.medium)
- DB Subnet Group
- Parameter Group (TLS disabled)
- Security Group (port 27017)

**Storage (S3 Module)**
- S3 Bucket for CodePipeline artifacts
- Versioning and lifecycle policies

**CI/CD (CodePipeline Module)**
- CodePipeline (Source → Build → Deploy)
- CodeBuild Project
- CodeDeploy Application
- CodeDeploy Deployment Group
- IAM Roles for services
- GitHub integration via CodeStar Connection

**Secrets Management**
- SSM Parameters for JWT_SECRET
- SSM Parameters for MONGO_URL
- Secure string encryption

### Infrastructure Deployment

```bash
# Navigate to terraform directory
cd terraform

# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Apply infrastructure
terraform apply

# Destroy infrastructure (when needed)
terraform destroy
```

### Key Infrastructure Features

✅ **Multi-AZ Deployment** - High availability across 2 availability zones  
✅ **Auto-Scaling** - Scales from 1 to 4 instances based on CPU (target: 50%)  
✅ **Load Balancing** - Application Load Balancer distributes traffic  
✅ **Private Networking** - EC2 and DocumentDB in private subnets  
✅ **NAT Gateway** - Secure outbound internet access for private resources  
✅ **Managed Database** - AWS DocumentDB for MongoDB compatibility  
✅ **Secrets Management** - AWS Systems Manager Parameter Store  
✅ **Infrastructure as Code** - 100% Terraform-managed, version-controlled  

---

## 🚀 CI/CD Pipeline

### Pipeline Architecture

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Source     │────▶│    Build     │────▶│   Deploy     │────▶│   Running    │
│   (GitHub)   │     │ (CodeBuild)  │     │(CodeDeploy)  │     │   (EC2)      │
└──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
       │                     │                     │                    │
       │                     │                     │                    │
   Push Code          Compile & Test        Deploy to ASG         App Running
  to main branch      Build Artifacts      Zero-downtime         Health Checks
                      Run Tests            Rolling Update        Load Balanced
```

### Pipeline Stages

#### 1️⃣ **Source Stage (GitHub)**
- Triggered on push to `main` branch
- AWS CodeStar Connection integrates with GitHub
- Fetches latest source code
- Outputs: `source_output` artifact

#### 2️⃣ **Build Stage (CodeBuild)**
- **Environment**: Amazon Linux 2, Node.js 18
- **Actions**:
  - Install dependencies (`npm install`)
  - Build TypeScript application (`npm run build`)
  - Package application with dependencies
  - Create deployment artifacts
- **Outputs**: `build_output` artifact with compiled code
- **Artifact Contents**:
  - `dist/` - Compiled JavaScript
  - `node_modules/` - Production dependencies
  - `package.json` - Package manifest
  - `appspec.yml` - Deployment specification
  - `scripts/` - Deployment scripts

#### 3️⃣ **Deploy Stage (CodeDeploy)**
- **Deployment Type**: Rolling deployment
- **Strategy**: `CodeDeployDefault.OneAtATime`
- **Process**:
  1. **BeforeInstall**: Stop running application
  2. **Install**: Copy files to `/home/ec2-user/app`
  3. **AfterInstall**: Install dependencies, configure environment
  4. **ApplicationStart**: Start application with PM2
  5. **ValidateService**: Health checks via ALB

### Deployment Lifecycle Hooks

```bash
# 1. BeforeInstall (stop_server.sh)
- Stop PM2 application
- Clean up old .env file
- Prepare for new deployment

# 2. AfterInstall (install_dependencies.sh)
- Install PM2 globally
- Fetch secrets from AWS SSM Parameter Store
- Create .env file with JWT_SECRET and MONGO_URL
- Set PORT to 80

# 3. ApplicationStart (start_server.sh)
- Start application using PM2
- Run in production mode
- Application name: 'app'
```

### Zero-Downtime Deployment

The pipeline ensures **zero-downtime** through:
- Rolling deployments (one instance at a time)
- Health checks via Application Load Balancer
- Automatic rollback on failure
- Target group draining during updates

### Secrets Management in Pipeline

```bash
# Secrets are fetched from AWS Systems Manager Parameter Store
JWT_SECRET=$(aws ssm get-parameter --name "/finvault/JWT_SECRET" --with-decryption)
MONGO_URL=$(aws ssm get-parameter --name "/finvault/MONGO_URL" --with-decryption)
```

---

## 🚦 Getting Started

### Prerequisites

- **AWS Account** with appropriate permissions
- **Terraform** (v1.0+)
- **AWS CLI** configured with credentials
- **Node.js** (v18+) and npm/pnpm
- **Git** for version control

### Step 1: Clone the Repository

```bash
git clone https://github.com/omar-khaled-2/finvault.git
cd finvault
```

### Step 2: Configure AWS Credentials

```bash
aws configure
# Enter your AWS Access Key ID
# Enter your AWS Secret Access Key
# Set region to us-east-1
```

### Step 3: Set Up GitHub Connection

Create a CodeStar Connection for GitHub integration:

```bash
# Via AWS Console:
# 1. Navigate to Developer Tools > Connections
# 2. Create a new connection to GitHub
# 3. Authorize the connection
# 4. Copy the Connection ARN

# Update the connection ARN in terraform/main.tf:
variable "github_connection_arn" {
  default = "your-connection-arn-here"
}
```

### Step 4: Deploy Infrastructure

```bash
cd terraform

# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Deploy infrastructure (takes ~15-20 minutes)
terraform apply -auto-approve

# Note the outputs (ALB DNS, DB endpoint, etc.)
```

### Step 5: Trigger First Deployment

```bash
# Push code to main branch
git add .
git commit -m "Initial deployment"
git push origin main

# Monitor pipeline in AWS Console:
# CodePipeline > finvault-pipeline
```

### Step 6: Access the Application

```bash
# Get the Load Balancer DNS from Terraform output
terraform output load_balancer_dns

# Test the health endpoint
curl http://<alb-dns>/health

# Test the API
curl -X POST http://<alb-dns>/auth/register \
  -H "Content-Type: application/json" \
  -d '{"fullName": "John Doe", "phone": "+1234567890"}'
```

---

## 📁 Project Structure

```
finvault/
├── app/                          # NestJS Application
│   ├── src/
│   │   ├── auth/                 # Authentication module
│   │   ├── user/                 # User management
│   │   ├── wallet/               # Wallet operations
│   │   ├── transfer/             # Money transfer logic
│   │   ├── transaction/          # Transaction tracking
│   │   ├── otp/                  # OTP management
│   │   └── main.ts               # Application entry point
│   ├── package.json
│   └── README.md                 # Application documentation
│
├── terraform/                    # Infrastructure as Code
│   ├── main.tf                   # Consolidated Terraform config
│   ├── modules/                  # Legacy modular structure
│   │   ├── vpc/                  # VPC resources
│   │   ├── ec2/                  # Compute resources
│   │   ├── documentdb/           # Database resources
│   │   ├── s3/                   # Storage resources
│   │   └── codepipeline/         # CI/CD resources
│   └── README.md                 # Infrastructure documentation
│
├── scripts/                      # Deployment scripts
│   ├── install_dependencies.sh   # Install and configure
│   ├── start_server.sh           # Start application
│   └── stop_server.sh            # Stop application
│
├── buildspec.yml                 # CodeBuild configuration
├── appspec.yml                   # CodeDeploy configuration
├── .gitignore                    # Git ignore rules
└── README.md                     # This file
```

---

## 💡 Skills Demonstrated

### Cloud & DevOps (AWS)

✅ **Infrastructure as Code**
- Terraform for complete infrastructure automation
- Modular, reusable infrastructure components
- State management and variable configuration

✅ **AWS Services**
- VPC (networking and subnets)
- EC2 (compute instances)
- Auto Scaling Groups
- Application Load Balancer
- DocumentDB (managed database)
- CodePipeline, CodeBuild, CodeDeploy (CI/CD)
- S3 (artifact storage)
- Systems Manager Parameter Store (secrets)
- SNS (SMS notifications)
- IAM (roles, policies, instance profiles)

✅ **Networking**
- VPC design with public/private subnets
- Internet Gateway and NAT Gateway
- Route tables and security groups
- Multi-AZ architecture

✅ **CI/CD**
- Automated build and deployment pipeline
- Rolling deployments with zero downtime
- Artifact management
- Deployment lifecycle hooks

✅ **High Availability & Scalability**
- Auto Scaling with target tracking
- Load balancing across multiple AZs
- Health checks and self-healing
- Fault-tolerant architecture

### Backend Development

✅ **NestJS Framework**
- Modular architecture
- Dependency injection
- Guards and middleware
- RESTful API design

✅ **TypeScript**
- Advanced type system usage
- Decorators and metadata
- Async/await patterns
- Interface and type definitions

✅ **Database**
- MongoDB/DocumentDB integration
- Schema design with Mongoose
- Data validation and relationships
- Query optimization

✅ **Authentication & Security**
- JWT implementation
- OTP generation and verification
- Cryptographic hashing
- Input validation and sanitization

### Software Engineering

✅ **Design Patterns**
- Repository pattern
- Dependency injection
- Guard pattern
- Module pattern
- DTO pattern

✅ **Best Practices**
- SOLID principles
- Clean code architecture
- Error handling
- Logging and monitoring
- Code organization

✅ **Testing**
- Unit test structure
- E2E testing setup
- Test coverage tools

---

## 📊 Monitoring & Observability

### Application Monitoring

- **Health Checks**: `/health` endpoint monitored by ALB
- **PM2 Process Manager**: Application lifecycle management
- **ALB Metrics**: Request count, latency, error rates
- **Auto Scaling Metrics**: CPU utilization, instance count

### Infrastructure Monitoring

- **EC2 CloudWatch Metrics**: CPU, network, disk I/O
- **DocumentDB Metrics**: Connection count, queries, latency
- **CodePipeline Execution**: Build and deployment status
- **CloudWatch Logs**: Application and system logs

### Key Performance Indicators

| Metric | Target | Monitoring |
|--------|--------|------------|
| API Response Time | < 500ms | ALB Metrics |
| CPU Utilization | 50% (scaling trigger) | CloudWatch |
| Database Connections | < 100 | DocumentDB Metrics |
| Deployment Time | < 10 minutes | CodePipeline |
| Instance Health | 100% healthy | Target Group |

---

## 🔒 Security

### Network Security

✅ **VPC Isolation** - Resources deployed in isolated VPC  
✅ **Private Subnets** - Application and database in private network  
✅ **Security Groups** - Firewall rules (ports 80, 27017)  
✅ **NAT Gateway** - Secure outbound internet access  
✅ **No Public IPs** - EC2 instances not directly accessible  

### Application Security

✅ **JWT Authentication** - Stateless token-based auth  
✅ **OTP Verification** - Two-factor authentication via SMS  
✅ **Input Validation** - DTO-based request validation  
✅ **Cryptographic Hashing** - HMAC-SHA256 for OTP  
✅ **Timing-Safe Comparison** - Prevents timing attacks  

### Secrets Management

✅ **AWS Systems Manager** - Centralized secret storage  
✅ **Encrypted Parameters** - SecureString type parameters  
✅ **No Hardcoded Secrets** - Secrets fetched at runtime  
✅ **Least Privilege IAM** - Minimal required permissions  

### IAM Security

✅ **Service Roles** - Dedicated roles per service  
✅ **Instance Profiles** - EC2 instance role attachment  
✅ **Policy Boundaries** - Restricted permission scopes  
✅ **Assumed Roles** - Service-to-service authentication  

---

## 🎓 Learning Outcomes

This project demonstrates comprehensive knowledge in:

1. **Cloud Architecture** - Designing scalable, highly available systems on AWS
2. **Infrastructure as Code** - Automating infrastructure with Terraform
3. **DevOps Practices** - Building complete CI/CD pipelines
4. **Backend Development** - Creating production-ready APIs with NestJS
5. **Security Engineering** - Implementing multi-layer security measures
6. **Database Design** - NoSQL schema design and optimization
7. **Networking** - VPC design, subnets, routing, and security
8. **Monitoring & Operations** - Application and infrastructure observability
9. **Deployment Strategies** - Zero-downtime deployments
10. **Best Practices** - Following industry standards and patterns

---

## 📈 Future Enhancements

### Application Features
- [ ] WebSocket support for real-time notifications
- [ ] Transaction analytics and reporting
- [ ] Multi-currency support
- [ ] Scheduled/recurring transfers
- [ ] Transaction limits and fraud detection
- [ ] API rate limiting with Redis

### Infrastructure Improvements
- [ ] Multi-region deployment for disaster recovery
- [ ] Amazon RDS Read Replicas for improved read performance
- [ ] ElastiCache Redis for caching and session management
- [ ] AWS WAF for web application firewall
- [ ] Amazon CloudFront for global content delivery
- [ ] AWS X-Ray for distributed tracing
- [ ] Prometheus and Grafana for advanced monitoring
- [ ] ECS/EKS migration for container orchestration
- [ ] Automated infrastructure testing with Terratest

### DevOps Enhancements
- [ ] Blue-green deployments
- [ ] Canary deployments with gradual traffic shifting
- [ ] Automated rollback on error thresholds
- [ ] Infrastructure drift detection
- [ ] Automated security scanning (Snyk, Trivy)
- [ ] Performance testing in pipeline
- [ ] Slack/Teams notifications for deployments

---

## 📞 Contact & Support

### Author

**Omar Elsetouy**

A passionate Cloud DevOps Engineer and Backend Developer specializing in AWS, Terraform, and Node.js. This project showcases comprehensive expertise in building production-ready, cloud-native applications with enterprise-grade infrastructure.


## 📄 License

This project is licensed under the UNLICENSED license.

---

## 🙏 Acknowledgments

- AWS for comprehensive cloud services
- HashiCorp for Terraform
- NestJS team for the powerful framework
- MongoDB for the database solution
- The open-source community

---

<div align="center">

**🚀 Built with passion to demonstrate cloud engineering excellence 🚀**

**Stack**: AWS • Terraform • NestJS • TypeScript • MongoDB • Docker • CI/CD

[⬆ Back to Top](#-finvault---enterprise-digital-wallet--money-transfer-platform)

</div>
