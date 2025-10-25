# 🏗️ FinVault Infrastructure - Terraform

<div align="center">

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Infrastructure as Code](https://img.shields.io/badge/IaC-100%25-success?style=for-the-badge)

**Complete AWS infrastructure automation for a production-ready digital wallet platform**

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Architecture](#-architecture)
- [Resources Provisioned](#-resources-provisioned)
- [Prerequisites](#-prerequisites)
- [Quick Start](#-quick-start)
- [Infrastructure Details](#-infrastructure-details)
- [Variables](#-variables)
- [Outputs](#-outputs)
- [Cost Estimation](#-cost-estimation)
- [Security](#-security)
- [Troubleshooting](#-troubleshooting)

---

## 🎯 Overview

This Terraform configuration provisions a **complete, production-ready AWS infrastructure** for the FinVault digital wallet application. The infrastructure is designed with **high availability, security, and scalability** in mind.

### Key Highlights

✅ **100% Infrastructure as Code** - Every resource is version-controlled and reproducible  
✅ **Single File Deployment** - Simplified `main.tf` for easy management  
✅ **Multi-AZ Architecture** - Resources span 2 availability zones for high availability  
✅ **Auto-Scaling** - Automatically scales from 1 to 4 instances based on load  
✅ **Secure Networking** - VPC with public/private subnets, NAT Gateway  
✅ **Managed Database** - AWS DocumentDB for MongoDB compatibility  
✅ **Complete CI/CD** - Integrated CodePipeline for automated deployments  
✅ **Secrets Management** - AWS Systems Manager Parameter Store for credentials  

---

## 🏗 Architecture

### High-Level Infrastructure Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                              AWS Cloud                                   │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                    VPC (10.0.0.0/16)                              │  │
│  │                                                                   │  │
│  │  ┌─────────────────────────────────────────────────────────────┐ │  │
│  │  │                   Public Subnets                            │ │  │
│  │  │  ┌──────────────┐              ┌──────────────┐            │ │  │
│  │  │  │ 10.0.0.0/24  │              │ 10.0.1.0/24  │            │ │  │
│  │  │  │    AZ-1      │              │    AZ-2      │            │ │  │
│  │  │  └──────┬───────┘              └──────┬───────┘            │ │  │
│  │  │         │                             │                     │ │  │
│  │  │    ┌────▼─────────────────────────────▼────┐               │ │  │
│  │  │    │  Application Load Balancer (ALB)      │               │ │  │
│  │  │    │  - Health checks                      │               │ │  │
│  │  │    │  - SSL/TLS termination ready          │               │ │  │
│  │  │    └────┬─────────────────────────────┬────┘               │ │  │
│  │  │         │                             │                     │ │  │
│  │  │    ┌────▼─────┐                  ┌────▼─────┐              │ │  │
│  │  │    │    NAT   │                  │ Internet │              │ │  │
│  │  │    │  Gateway │                  │ Gateway  │              │ │  │
│  │  │    └────┬─────┘                  └──────────┘              │ │  │
│  │  └─────────┼────────────────────────────────────────────────┘ │  │
│  │            │                                                    │  │
│  │  ┌─────────▼──────────────────────────────────────────────────┐ │  │
│  │  │                   Private Subnets                          │ │  │
│  │  │  ┌──────────────┐              ┌──────────────┐            │ │  │
│  │  │  │ 10.0.2.0/24  │              │ 10.0.3.0/24  │            │ │  │
│  │  │  │    AZ-1      │              │    AZ-2      │            │ │  │
│  │  │  └──────┬───────┘              └──────┬───────┘            │ │  │
│  │  │         │                             │                     │ │  │
│  │  │    ┌────▼─────────────────────────────▼────┐               │ │  │
│  │  │    │      Auto Scaling Group (1-4)         │               │ │  │
│  │  │    │  ┌─────────┐ ┌─────────┐ ┌─────────┐ │               │ │  │
│  │  │    │  │ EC2     │ │ EC2     │ │ EC2     │ │               │ │  │
│  │  │    │  │ NestJS  │ │ NestJS  │ │ NestJS  │ │               │ │  │
│  │  │    │  └─────────┘ └─────────┘ └─────────┘ │               │ │  │
│  │  │    └────┬─────────────────────────────┬────┘               │ │  │
│  │  │         │                             │                     │ │  │
│  │  │    ┌────▼─────────────────────────────▼────┐               │ │  │
│  │  │    │    AWS DocumentDB Cluster             │               │ │  │
│  │  │    │    (MongoDB-compatible)                │               │ │  │
│  │  │    │  - Multi-AZ                            │               │ │  │
│  │  │    │  - Automatic backups                   │               │ │  │
│  │  │    └────────────────────────────────────────┘               │ │  │
│  │  └────────────────────────────────────────────────────────────┘ │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                                                           │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                        CI/CD Pipeline                             │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌──────────┐         │  │
│  │  │ GitHub   │─▶│CodeBuild │─▶│CodeDeploy│─▶│   S3     │         │  │
│  │  │ Source   │  │          │  │          │  │Artifacts │         │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └──────────┘         │  │
│  └───────────────────────────────────────────────────────────────────┘  │
│                                                                           │
│  ┌───────────────────────────────────────────────────────────────────┐  │
│  │                   Supporting Services                             │  │
│  │  - Systems Manager (SSM) Parameter Store                          │  │
│  │  - IAM Roles & Policies                                           │  │
│  │  - CloudWatch Logs & Metrics                                      │  │
│  │  - SNS for SMS notifications                                      │  │
│  └───────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────┘
```

### Network Flow

```
Internet → IGW → ALB (Public) → EC2 (Private) → NAT Gateway → Internet
                                      ↓
                              DocumentDB (Private)
```

---

## 📦 Resources Provisioned

### Networking Resources (VPC)

| Resource | Count | Purpose |
|----------|-------|---------|
| **VPC** | 1 | Isolated network environment (10.0.0.0/16) |
| **Internet Gateway** | 1 | Public internet access |
| **Public Subnets** | 2 | Load balancer and NAT Gateway (AZ redundancy) |
| **Private Subnets** | 2 | Application and database (secure, isolated) |
| **NAT Gateway** | 1 | Outbound internet for private resources |
| **Elastic IP** | 1 | Static IP for NAT Gateway |
| **Route Tables** | 2 | Public and private routing |
| **Security Groups** | 2 | EC2 and DocumentDB firewall rules |

### Compute Resources (EC2)

| Resource | Count | Purpose |
|----------|-------|---------|
| **Launch Template** | 1 | EC2 instance configuration (t3.medium, user data) |
| **Auto Scaling Group** | 1 | Manages 1-4 EC2 instances |
| **Scaling Policy** | 1 | CPU-based target tracking (50% target) |
| **Application Load Balancer** | 1 | Distributes traffic across instances |
| **Target Group** | 1 | Health checks and routing |
| **IAM Role** | 1 | EC2 instance permissions |
| **Instance Profile** | 1 | Attaches IAM role to instances |

### Database Resources (DocumentDB)

| Resource | Count | Purpose |
|----------|-------|---------|
| **DocumentDB Cluster** | 1 | MongoDB-compatible database |
| **DocumentDB Instance** | 1 | Database compute (db.t3.medium) |
| **DB Subnet Group** | 1 | Multi-AZ database placement |
| **Parameter Group** | 1 | Database configuration (TLS disabled) |
| **Security Group** | 1 | Database firewall (port 27017) |

### Storage Resources (S3)

| Resource | Count | Purpose |
|----------|-------|---------|
| **S3 Bucket** | 1 | CodePipeline artifact storage |

### CI/CD Resources (CodePipeline)

| Resource | Count | Purpose |
|----------|-------|---------|
| **CodePipeline** | 1 | Orchestrates Source → Build → Deploy |
| **CodeBuild Project** | 1 | Builds application artifacts |
| **CodeDeploy Application** | 1 | Manages deployments |
| **CodeDeploy Deployment Group** | 1 | Targets Auto Scaling Group |
| **IAM Roles** | 3 | CodePipeline, CodeBuild, CodeDeploy |

### Secrets & Configuration

| Resource | Count | Purpose |
|----------|-------|---------|
| **SSM Parameters** | 2 | JWT_SECRET, MONGO_URL (encrypted) |
| **Random String** | 1 | Generates JWT secret |

---

## 🚀 Prerequisites

### Required Tools

- **Terraform** (v1.0 or later)
  ```bash
  # Install on macOS
  brew install terraform
  
  # Install on Linux
  wget https://releases.hashicorp.com/terraform/1.6.0/terraform_1.6.0_linux_amd64.zip
  unzip terraform_1.6.0_linux_amd64.zip
  sudo mv terraform /usr/local/bin/
  ```

- **AWS CLI** (configured with credentials)
  ```bash
  # Install
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  
  # Configure
  aws configure
  ```

### AWS Requirements

- **AWS Account** with admin or sufficient permissions
- **IAM Permissions** for:
  - VPC, EC2, AutoScaling, ELB
  - DocumentDB, S3
  - CodePipeline, CodeBuild, CodeDeploy
  - IAM roles and policies
  - Systems Manager Parameter Store

- **GitHub Connection**:
  - CodeStar Connection to your GitHub repository
  - Update `github_connection_arn` in `main.tf`

---

## 🏁 Quick Start

### Step 1: Clone Repository

```bash
git clone https://github.com/omar-khaled-2/finvault.git
cd finvault/terraform
```

### Step 2: Configure Variables (Optional)

Edit `main.tf` to customize:

```hcl
variable "aws_region" {
  default = "us-east-1"  # Change region if needed
}

variable "github_connection_arn" {
  default = "arn:aws:codeconnections:us-east-1:..."  # Update with your ARN
}

variable "documentdb_username" {
  default = "admin"  # Change if needed
}

variable "documentdb_password" {
  default = "SecurePassword123!"  # CHANGE THIS!
}
```

### Step 3: Initialize Terraform

```bash
terraform init
```

**Expected output:**
```
Initializing the backend...
Initializing provider plugins...
Terraform has been successfully initialized!
```

### Step 4: Plan Infrastructure

```bash
terraform plan -out=tfplan
```

This will show all resources to be created. Review carefully!

### Step 5: Apply Infrastructure

```bash
terraform apply tfplan
```

**Deployment time:** ~15-20 minutes

**What's happening:**
- ✅ VPC and networking setup (2 min)
- ✅ DocumentDB cluster creation (10-12 min)
- ✅ EC2 Auto Scaling Group (2-3 min)
- ✅ Load Balancer and Target Groups (1-2 min)
- ✅ CI/CD pipeline setup (1 min)

### Step 6: Get Outputs

```bash
terraform output
```

**Expected outputs:**
```
load_balancer_dns = "web-lb-1234567890.us-east-1.elb.amazonaws.com"
vpc_id = "vpc-0123456789abcdef0"
documentdb_endpoint = "docdb-cluster.cluster-xyz.us-east-1.docdb.amazonaws.com"
```

### Step 7: Test Deployment

```bash
# Get the load balancer DNS
ALB_DNS=$(terraform output -raw load_balancer_dns)

# Wait for instances to be healthy (~5 minutes)
# Then test the health endpoint
curl http://$ALB_DNS/health
```

---

## 🔧 Infrastructure Details

### VPC Configuration

```hcl
CIDR Block: 10.0.0.0/16
Public Subnets:
  - 10.0.0.0/24 (us-east-1a)
  - 10.0.1.0/24 (us-east-1b)
Private Subnets:
  - 10.0.2.0/24 (us-east-1a)
  - 10.0.3.0/24 (us-east-1b)
```

### Auto Scaling Configuration

```hcl
Desired Capacity: 2 instances
Minimum: 1 instance
Maximum: 4 instances
Instance Type: t3.medium
Scaling Metric: CPU Utilization (target 50%)
Health Check: ALB health check (/health endpoint)
```

### Load Balancer Configuration

```hcl
Type: Application Load Balancer
Scheme: Internet-facing
Subnets: Public subnets (2 AZs)
Health Check Path: /health
Health Check Interval: 30 seconds
Healthy Threshold: 2
Unhealthy Threshold: 3
```

### DocumentDB Configuration

```hcl
Engine: docdb
Instance Class: db.t3.medium
Multi-AZ: Yes (via subnet group)
TLS: Disabled (for development)
Backup Retention: 1 day (default)
```

### Security Groups

**EC2 Security Group:**
- Inbound: Port 80 (HTTP) from 0.0.0.0/0
- Outbound: All traffic

**DocumentDB Security Group:**
- Inbound: Port 27017 from 0.0.0.0/0 (restrict to EC2 SG in production)
- Outbound: All traffic

---

## 🔧 Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `aws_region` | string | `us-east-1` | AWS region for resource deployment |
| `github_connection_arn` | string | (ARN) | CodeStar connection ARN for GitHub |
| `documentdb_username` | string | `omar` | DocumentDB master username |
| `documentdb_password` | string | `12345678` | DocumentDB master password |

### Customizing Variables

Create a `terraform.tfvars` file:

```hcl
aws_region             = "us-west-2"
documentdb_username    = "admin"
documentdb_password    = "SuperSecurePassword123!"
github_connection_arn  = "arn:aws:codeconnections:us-west-2:123456789:connection/abc"
```

Then apply:

```bash
terraform apply -var-file="terraform.tfvars"
```

---

## 📤 Outputs

After deployment, Terraform provides the following outputs:

| Output | Description | Usage |
|--------|-------------|-------|
| `vpc_id` | VPC identifier | Networking reference |
| `public_subnet_ids` | List of public subnet IDs | Load balancer placement |
| `private_subnet_ids` | List of private subnet IDs | App/DB placement |
| `load_balancer_dns` | ALB DNS name | **Access your application** |
| `documentdb_endpoint` | DocumentDB cluster endpoint | Database connection |
| `documentdb_username` | DB master username | (Sensitive) |
| `documentdb_password` | DB master password | (Sensitive) |
| `artifacts_bucket_name` | S3 bucket name | Pipeline artifacts |
| `autoscaling_group_name` | ASG name | Deployment target |
| `codepipeline_name` | Pipeline name | CI/CD monitoring |

### Accessing Outputs

```bash
# Get all outputs
terraform output

# Get specific output
terraform output load_balancer_dns

# Get raw output (no quotes)
terraform output -raw load_balancer_dns

# Get sensitive outputs
terraform output documentdb_password
```

---

## 💰 Cost Estimation

### Monthly Cost Breakdown (us-east-1)

| Service | Configuration | Est. Monthly Cost |
|---------|--------------|-------------------|
| **EC2 Instances** | 2x t3.medium (on-demand) | ~$60 |
| **Application Load Balancer** | 1 ALB + data processing | ~$25 |
| **NAT Gateway** | 1 NAT + data transfer | ~$35 |
| **DocumentDB** | 1x db.t3.medium | ~$100 |
| **S3** | Artifact storage (<1GB) | ~$1 |
| **CodePipeline** | 1 active pipeline | $1 |
| **Data Transfer** | Outbound data | ~$10 |
| **CloudWatch** | Logs and metrics | ~$5 |

**Total Estimated Cost: ~$237/month**

### Cost Optimization Tips

💡 **Development Environment:**
- Use t3.micro instances: $15/month savings
- Use 1 instance (no ASG): $30/month savings
- DocumentDB db.t3.small: $50/month savings

💡 **Reserved Instances:**
- 1-year Reserved Instances: ~30% savings
- 3-year Reserved Instances: ~50% savings

💡 **Spot Instances:**
- Use Spot for non-prod: up to 90% savings

💡 **Shut down when not in use:**
```bash
# Stop instances at night
terraform destroy -target=aws_autoscaling_group.autoscaling_group
```

---

## 🔒 Security

### Best Practices Implemented

✅ **Network Segmentation**
- Public subnets for internet-facing resources
- Private subnets for application and database
- NAT Gateway for secure outbound access

✅ **Security Groups**
- Principle of least privilege
- Port-specific rules (80, 27017)
- No SSH access (use SSM Session Manager)

✅ **Secrets Management**
- SSM Parameter Store for sensitive data
- Encrypted SecureString parameters
- No hardcoded credentials

✅ **IAM Roles**
- Service-specific IAM roles
- Instance profiles for EC2
- Least privilege policies

✅ **Database Security**
- No public accessibility
- Private subnet placement
- Security group restrictions

### Security Improvements for Production

🔐 **Enable TLS on DocumentDB:**
```hcl
parameter {
  name  = "tls"
  value = "enabled"
}
```

🔐 **Restrict Security Groups:**
```hcl
# EC2 SG: Allow only from ALB
cidr_blocks = [aws_vpc.main.cidr_block]

# DocumentDB SG: Allow only from EC2 SG
security_groups = [aws_security_group.ec2_sg.id]
```

🔐 **Enable VPC Flow Logs:**
```hcl
resource "aws_flow_log" "main" {
  vpc_id = aws_vpc.main.id
  # ... additional configuration
}
```

🔐 **Add AWS WAF:**
```hcl
resource "aws_wafv2_web_acl" "main" {
  # ... WAF rules
}
```

---

## 🐛 Troubleshooting

### Common Issues

#### Issue: Terraform Init Fails

```bash
Error: Failed to query available provider packages
```

**Solution:**
```bash
# Clear Terraform cache
rm -rf .terraform .terraform.lock.hcl

# Re-initialize
terraform init
```

#### Issue: AWS Credentials Error

```bash
Error: error configuring Terraform AWS Provider
```

**Solution:**
```bash
# Verify AWS credentials
aws sts get-caller-identity

# Reconfigure if needed
aws configure
```

#### Issue: GitHub Connection Not Found

```bash
Error: CodeStar Connection not found
```

**Solution:**
1. Create CodeStar Connection in AWS Console
2. Authenticate with GitHub
3. Update `github_connection_arn` in `main.tf`

#### Issue: DocumentDB Takes Too Long

DocumentDB cluster creation takes 10-15 minutes. This is normal.

```bash
# Monitor progress
aws docdb describe-db-clusters --db-cluster-identifier <cluster-id>
```

#### Issue: Health Checks Failing

```bash
# Check EC2 instance logs
aws logs tail /aws/ec2/user-data --follow

# Check ALB target health
aws elbv2 describe-target-health \
  --target-group-arn <target-group-arn>
```

**Common causes:**
- Application not started
- Port 80 not listening
- Health endpoint not responding
- Security group misconfiguration

#### Issue: CodeDeploy Failure

```bash
# View deployment logs
aws deploy get-deployment --deployment-id <deployment-id>

# Check deployment events
aws deploy list-deployment-instances --deployment-id <deployment-id>
```

### Terraform State Issues

#### Corrupted State

```bash
# Pull current state
terraform state pull > backup.tfstate

# Manual recovery if needed
terraform state push backup.tfstate
```

#### Resource Drift

```bash
# Detect drift
terraform plan

# Refresh state
terraform refresh
```

### Cleaning Up

#### Destroy All Resources

```bash
# Preview destruction
terraform plan -destroy

# Destroy all resources
terraform destroy
```

⚠️ **Warning:** This will delete:
- All EC2 instances
- DocumentDB cluster (data loss!)
- S3 bucket and artifacts
- All networking resources

#### Destroy Specific Resources

```bash
# Destroy only EC2 instances
terraform destroy -target=aws_autoscaling_group.autoscaling_group

# Destroy only DocumentDB
terraform destroy -target=aws_docdb_cluster.docdb_cluster
```

---

## 📚 Additional Resources

### Terraform Documentation
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/index.html)

### AWS Documentation
- [VPC Design](https://docs.aws.amazon.com/vpc/latest/userguide/what-is-amazon-vpc.html)
- [Auto Scaling](https://docs.aws.amazon.com/autoscaling/ec2/userguide/what-is-amazon-ec2-auto-scaling.html)
- [DocumentDB](https://docs.aws.amazon.com/documentdb/latest/developerguide/what-is.html)
- [CodePipeline](https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html)

### Useful Commands

```bash
# Validate configuration
terraform validate

# Format code
terraform fmt

# Show resource graph
terraform graph | dot -Tsvg > graph.svg

# List all resources
terraform state list

# Show specific resource
terraform state show aws_vpc.main

# Import existing resource
terraform import aws_vpc.main vpc-0123456789abcdef0
```

---

## 🎓 Learning Outcomes

By studying this Terraform configuration, you'll learn:

✅ VPC design with public/private subnet architecture  
✅ Auto Scaling Group configuration with target tracking  
✅ Application Load Balancer setup with health checks  
✅ Managed database provisioning (DocumentDB)  
✅ Complete CI/CD pipeline infrastructure  
✅ IAM roles and policies for AWS services  
✅ Security group management  
✅ Secrets management with SSM Parameter Store  
✅ Terraform best practices and organization  
✅ Infrastructure dependencies and resource ordering  

---

## 📞 Support

For issues or questions:

1. **Check logs**: CloudWatch Logs for application/deployment logs
2. **Review documentation**: AWS and Terraform docs
3. **Terraform plan**: Always review before applying
4. **State backup**: Keep backups of terraform.tfstate

---

<div align="center">

**🚀 Infrastructure as Code Excellence with Terraform 🚀**

[⬆ Back to Top](#️-finvault-infrastructure---terraform)

</div>
