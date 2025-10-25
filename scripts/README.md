# 🚀 Deployment Scripts

<div align="center">

![AWS CodeDeploy](https://img.shields.io/badge/AWS_CodeDeploy-FF9900?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Bash](https://img.shields.io/badge/Bash-4EAA25?style=for-the-badge&logo=gnu-bash&logoColor=white)
![PM2](https://img.shields.io/badge/PM2-2B037A?style=for-the-badge&logo=pm2&logoColor=white)

**Automated deployment lifecycle hooks for AWS CodeDeploy**

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Script Execution Flow](#-script-execution-flow)
- [Script Details](#-script-details)
- [AWS CodeDeploy Lifecycle](#-aws-codedeploy-lifecycle)
- [Environment Configuration](#-environment-configuration)
- [Process Management with PM2](#-process-management-with-pm2)
- [Troubleshooting](#-troubleshooting)
- [Best Practices](#-best-practices)

---

## 🎯 Overview

This directory contains the **deployment lifecycle scripts** used by AWS CodeDeploy to manage the application deployment on EC2 instances. These scripts handle:

- Stopping the running application
- Installing dependencies and configuring the environment
- Starting the application with process management

### Scripts Included

| Script | Hook | Purpose |
|--------|------|---------|
| `stop_server.sh` | **BeforeInstall** | Gracefully stop the running application |
| `install_dependencies.sh` | **AfterInstall** | Install PM2, configure environment variables |
| `start_server.sh` | **ApplicationStart** | Start the application using PM2 |

---

## 🔄 Script Execution Flow

### Complete Deployment Lifecycle

```
┌─────────────────────────────────────────────────────────────────┐
│                    CodeDeploy Deployment                         │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  1. BeforeInstall - stop_server.sh                              │
├─────────────────────────────────────────────────────────────────┤
│  ✓ Stop PM2 application (app)                                   │
│  ✓ Delete PM2 process                                           │
│  ✓ Remove old .env file                                         │
│  ✓ Prepare for new deployment                                   │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  2. Install Phase (CodeDeploy)                                  │
├─────────────────────────────────────────────────────────────────┤
│  ✓ Copy files to /home/ec2-user/app                            │
│  ✓ Set file permissions                                         │
│  ✓ Extract artifacts                                            │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  3. AfterInstall - install_dependencies.sh                      │
├─────────────────────────────────────────────────────────────────┤
│  ✓ Install PM2 globally (if not installed)                      │
│  ✓ Fetch JWT_SECRET from AWS SSM Parameter Store               │
│  ✓ Fetch MONGO_URL from AWS SSM Parameter Store                │
│  ✓ Create .env file with environment variables                  │
│  ✓ Set PORT=80                                                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  4. ApplicationStart - start_server.sh                          │
├─────────────────────────────────────────────────────────────────┤
│  ✓ Navigate to application directory                            │
│  ✓ Start application with PM2                                   │
│  ✓ Run: pm2 start npm --name app -- run start:prod             │
│  ✓ Application listens on port 80                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│  5. ValidateService (CodeDeploy)                                │
├─────────────────────────────────────────────────────────────────┤
│  ✓ ALB health checks (/health endpoint)                         │
│  ✓ Verify application is responding                             │
│  ✓ Mark instance as healthy                                     │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    🎉 Deployment Complete!
```

---

## 📜 Script Details

### 1. stop_server.sh

**Hook:** `BeforeInstall`  
**Purpose:** Gracefully stop the running application before deploying new code

```bash
#!/bin/bash
cd /home/ec2-user/app/app
rm -f .env
pm2 stop app || echo "App not running"
pm2 delete app || echo "App not running"
```

#### What it does:

1. **Navigate to app directory**
   ```bash
   cd /home/ec2-user/app/app
   ```

2. **Remove old environment file**
   ```bash
   rm -f .env
   ```
   - Ensures no stale environment variables
   - Forces fresh configuration on each deployment

3. **Stop PM2 process**
   ```bash
   pm2 stop app || echo "App not running"
   ```
   - Gracefully stops the application
   - `|| echo` prevents script failure if app not running
   - Important for first deployment

4. **Delete PM2 process**
   ```bash
   pm2 delete app || echo "App not running"
   ```
   - Removes process from PM2 list
   - Cleans up process registry
   - Prevents process ID conflicts

#### Exit Codes:

- **0**: Success (app stopped or wasn't running)
- **Non-zero**: Only if directory doesn't exist

#### Error Handling:

The script uses `|| echo "App not running"` to handle cases where:
- First deployment (no running app)
- Previous deployment failed
- Manual process termination

---

### 2. install_dependencies.sh

**Hook:** `AfterInstall`  
**Purpose:** Configure the environment and prepare for application start

```bash
#!/bin/bash
npm install -g pm2
cd /home/ec2-user/app/app
echo "PORT=80" >> .env
echo JWT_SECRET=$(aws ssm get-parameter --name "/finvault/JWT_SECRET" --with-decryption --query "Parameter.Value" --output text) >> .env
echo MONGO_URL=$(aws ssm get-parameter --name "/finvault/MONGO_URL" --with-decryption --query "Parameter.Value" --output text) >> .env
```

#### What it does:

1. **Install PM2 globally**
   ```bash
   npm install -g pm2
   ```
   - **PM2**: Advanced Node.js process manager
   - Features: Auto-restart, load balancing, log management
   - `-g`: Global installation (available system-wide)
   - Idempotent: Safe to run multiple times

2. **Navigate to application directory**
   ```bash
   cd /home/ec2-user/app/app
   ```
   - Application code location
   - Contains `package.json` and `dist/`

3. **Create environment file**
   ```bash
   echo "PORT=80" >> .env
   ```
   - Sets application port to 80 (HTTP)
   - Required for ALB health checks
   - `>>` appends to .env file

4. **Fetch JWT_SECRET from AWS SSM**
   ```bash
   echo JWT_SECRET=$(aws ssm get-parameter \
     --name "/finvault/JWT_SECRET" \
     --with-decryption \
     --query "Parameter.Value" \
     --output text) >> .env
   ```
   - **SSM Parameter Store**: Secure secret storage
   - `--with-decryption`: Decrypt SecureString parameter
   - `--query "Parameter.Value"`: Extract only the value
   - `--output text`: Plain text output (no JSON)

5. **Fetch MONGO_URL from AWS SSM**
   ```bash
   echo MONGO_URL=$(aws ssm get-parameter \
     --name "/finvault/MONGO_URL" \
     --with-decryption \
     --query "Parameter.Value" \
     --output text) >> .env
   ```
   - DocumentDB connection string
   - Includes username, password, endpoint
   - Format: `mongodb://user:pass@endpoint/?options`

#### Final .env File:

```env
PORT=80
JWT_SECRET=randomly_generated_20_char_secret
MONGO_URL=mongodb://omar:12345678@docdb-cluster.xyz.us-east-1.docdb.amazonaws.com/?replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false&authMechanism=SCRAM-SHA-1
```

#### IAM Permissions Required:

The EC2 instance role must have:
```json
{
  "Effect": "Allow",
  "Action": [
    "ssm:GetParameter",
    "ssm:GetParameters"
  ],
  "Resource": [
    "arn:aws:ssm:*:*:parameter/finvault/*"
  ]
}
```

This is provided by the `AmazonSSMReadOnlyAccess` policy attached in Terraform.

---

### 3. start_server.sh

**Hook:** `ApplicationStart`  
**Purpose:** Start the application using PM2 process manager

```bash
#!/bin/bash

cd /home/ec2-user/app/app
pm2 start npm --name app -- run start:prod
```

#### What it does:

1. **Navigate to application directory**
   ```bash
   cd /home/ec2-user/app/app
   ```

2. **Start application with PM2**
   ```bash
   pm2 start npm --name app -- run start:prod
   ```
   - `pm2 start npm`: Start Node.js via npm
   - `--name app`: Process name for management
   - `-- run start:prod`: Pass command to npm
   - Equivalent to: `npm run start:prod`

#### What happens:

```
PM2 Process Manager
│
├─ Process Name: app
├─ Command: npm run start:prod
├─ Working Directory: /home/ec2-user/app/app
├─ Environment: .env variables loaded
│
└─ NestJS Application
   ├─ Compiled from dist/
   ├─ Listens on PORT 80
   ├─ Connects to DocumentDB
   └─ Serves API endpoints
```

#### PM2 Features Utilized:

✅ **Auto-restart** - Restarts on crashes  
✅ **Log management** - Captures stdout/stderr  
✅ **Process monitoring** - CPU, memory usage  
✅ **Graceful reload** - Zero-downtime restarts  

#### Verify Application Started:

```bash
# Check PM2 processes
pm2 list

# View logs
pm2 logs app

# Monitor in real-time
pm2 monit

# Process details
pm2 show app
```

---

## 🎯 AWS CodeDeploy Lifecycle

### Complete Lifecycle Hooks

```
┌─────────────────────────────────────────────────────────────┐
│                  CodeDeploy Lifecycle Events                 │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ApplicationStop        [Optional - Not used]                │
│  DownloadBundle        [Automatic - CodeDeploy]              │
│  BeforeInstall         [✓ stop_server.sh]                   │
│  Install               [Automatic - CodeDeploy]              │
│  AfterInstall          [✓ install_dependencies.sh]          │
│  ApplicationStart      [✓ start_server.sh]                  │
│  ValidateService       [Automatic - ALB Health Check]        │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

### Hook Timing

| Hook | When | Duration | Can Fail? |
|------|------|----------|-----------|
| **BeforeInstall** | Before files copied | ~5 seconds | Yes |
| **Install** | File copy operation | ~10 seconds | Yes |
| **AfterInstall** | After files copied | ~30 seconds | Yes |
| **ApplicationStart** | Start application | ~5 seconds | Yes |
| **ValidateService** | Health check validation | ~60 seconds | Yes |

### Failure Handling

If any hook fails:
1. **Deployment marked as failed**
2. **Instance marked as unhealthy**
3. **Automatic rollback** (if configured)
4. **Previous version restored**

---

## ⚙️ Environment Configuration

### Environment Variables Set

| Variable | Source | Value | Purpose |
|----------|--------|-------|---------|
| `PORT` | Hardcoded | `80` | Application port |
| `JWT_SECRET` | SSM | Random string | JWT signing key |
| `MONGO_URL` | SSM | Connection string | Database connection |

### Adding New Environment Variables

To add new environment variables:

1. **Create SSM Parameter:**
   ```bash
   aws ssm put-parameter \
     --name "/finvault/NEW_VAR" \
     --type "SecureString" \
     --value "secret_value"
   ```

2. **Update install_dependencies.sh:**
   ```bash
   echo NEW_VAR=$(aws ssm get-parameter \
     --name "/finvault/NEW_VAR" \
     --with-decryption \
     --query "Parameter.Value" \
     --output text) >> .env
   ```

3. **Update Terraform (optional):**
   ```hcl
   resource "aws_ssm_parameter" "new_var" {
     name  = "/finvault/NEW_VAR"
     type  = "SecureString"
     value = var.new_var
   }
   ```

---

## 🔧 Process Management with PM2

### Why PM2?

PM2 is a production-grade process manager for Node.js with:

✅ **Auto-restart** on crashes  
✅ **Load balancing** across CPU cores  
✅ **Log management** with rotation  
✅ **Process monitoring** and metrics  
✅ **Zero-downtime reloads**  
✅ **Startup script generation**  

### PM2 Commands

```bash
# List all processes
pm2 list

# View logs (live)
pm2 logs app

# View last 100 lines
pm2 logs app --lines 100

# Monitor processes
pm2 monit

# Restart application
pm2 restart app

# Stop application
pm2 stop app

# Delete process
pm2 delete app

# Show process details
pm2 show app

# Flush logs
pm2 flush

# Save process list
pm2 save

# Resurrect saved processes
pm2 resurrect
```

### PM2 Process Information

```bash
$ pm2 list
┌─────┬──────┬─────────┬──────┬───────┬────────┬─────────┬────────┬──────┬───────────┬──────────┬──────────┐
│ id  │ name │ mode    │ ↺    │ status│ cpu    │ memory  │ user   │ ...  │           │          │          │
├─────┼──────┼─────────┼──────┼───────┼────────┼─────────┼────────┼──────┼───────────┼──────────┼──────────┤
│ 0   │ app  │ fork    │ 0    │ online│ 0%     │ 150 MB  │ ec2-u..│ ...  │           │          │          │
└─────┴──────┴─────────┴──────┴───────┴────────┴─────────┴────────┴──────┴───────────┴──────────┴──────────┘
```

### Advanced PM2 Configuration (ecosystem.config.js)

For more advanced setups, create `ecosystem.config.js`:

```javascript
module.exports = {
  apps: [{
    name: 'finvault-api',
    script: 'npm',
    args: 'run start:prod',
    instances: 'max',  // Use all CPU cores
    exec_mode: 'cluster',
    watch: false,
    max_memory_restart: '500M',
    env: {
      NODE_ENV: 'production',
      PORT: 80
    },
    error_file: '/var/log/finvault/error.log',
    out_file: '/var/log/finvault/out.log',
    log_date_format: 'YYYY-MM-DD HH:mm:ss Z'
  }]
};
```

Then start with:
```bash
pm2 start ecosystem.config.js
```

---

## 🐛 Troubleshooting

### Common Issues

#### Issue 1: PM2 Command Not Found

**Error:**
```
-bash: pm2: command not found
```

**Solution:**
```bash
# Install PM2 globally
npm install -g pm2

# Verify installation
pm2 --version

# Check npm global bin directory
npm bin -g
```

#### Issue 2: AWS CLI Permissions Error

**Error:**
```
An error occurred (AccessDeniedException) when calling the GetParameter operation
```

**Solution:**
1. **Verify IAM role attached to EC2:**
   ```bash
   aws sts get-caller-identity
   ```

2. **Check IAM policies:**
   - Navigate to IAM Console
   - Find instance profile role
   - Verify `AmazonSSMReadOnlyAccess` policy attached

3. **Test SSM access:**
   ```bash
   aws ssm get-parameter --name "/finvault/JWT_SECRET"
   ```

#### Issue 3: Application Won't Start

**Error:**
```
PM2 process exited immediately
```

**Diagnosis:**
```bash
# Check PM2 logs
pm2 logs app

# Check recent logs
pm2 logs app --lines 50

# Check process status
pm2 show app
```

**Common causes:**
- Missing environment variables
- Port 80 already in use
- Database connection failure
- Missing node_modules

**Solutions:**
```bash
# Verify .env file exists
cat /home/ec2-user/app/app/.env

# Check if port 80 is available
sudo netstat -tulpn | grep :80

# Test database connection
nc -zv <documentdb-endpoint> 27017

# Verify dependencies installed
ls /home/ec2-user/app/app/node_modules
```

#### Issue 4: Deployment Fails at BeforeInstall

**Error:**
```
LifecycleEvent - BeforeInstall failed
```

**Diagnosis:**
```bash
# Check CodeDeploy agent logs
sudo tail -f /var/log/aws/codedeploy-agent/codedeploy-agent.log

# Check script execution logs
sudo cat /opt/codedeploy-agent/deployment-root/*/logs/scripts.log
```

**Solutions:**
```bash
# Make scripts executable
chmod +x scripts/*.sh

# Verify script syntax
bash -n scripts/stop_server.sh

# Run script manually
cd /home/ec2-user/app
bash scripts/stop_server.sh
```

#### Issue 5: Health Checks Failing

**Error:**
```
Target health check failed - instance marked unhealthy
```

**Diagnosis:**
```bash
# Check if application is running
pm2 list

# Check if port 80 is listening
sudo netstat -tulpn | grep :80

# Test health endpoint locally
curl http://localhost/health

# Check security group rules
aws ec2 describe-security-groups --group-ids <sg-id>
```

**Solutions:**
```bash
# Restart application
pm2 restart app

# Check application logs
pm2 logs app

# Verify health endpoint works
curl -v http://localhost/health

# Check ALB target group health
aws elbv2 describe-target-health --target-group-arn <arn>
```

### Debug Mode

Enable verbose logging:

1. **PM2 Debug Mode:**
   ```bash
   pm2 start npm --name app -- run start:prod -- --trace-warnings
   ```

2. **Application Debug Logs:**
   ```bash
   # Set in .env
   echo "LOG_LEVEL=debug" >> .env
   pm2 restart app
   ```

3. **CodeDeploy Agent Debug:**
   ```bash
   # Edit agent config
   sudo vim /etc/codedeploy-agent/conf/codedeployagent.yml
   # Set :verbose: true
   
   # Restart agent
   sudo service codedeploy-agent restart
   ```

---

## ✅ Best Practices

### Script Best Practices

1. **Always use `#!/bin/bash` shebang**
   ```bash
   #!/bin/bash
   # Ensures script runs with bash
   ```

2. **Make scripts executable**
   ```bash
   chmod +x scripts/*.sh
   ```

3. **Use absolute paths**
   ```bash
   cd /home/ec2-user/app/app  # Not ~/app or ../app
   ```

4. **Handle errors gracefully**
   ```bash
   pm2 stop app || echo "App not running"  # Don't fail if app not running
   ```

5. **Test scripts locally before deployment**
   ```bash
   # SSH into EC2 instance
   cd /home/ec2-user/app
   bash scripts/install_dependencies.sh
   ```

### Security Best Practices

1. **Never hardcode secrets**
   ❌ Bad:
   ```bash
   echo "JWT_SECRET=mysecret123" >> .env
   ```
   
   ✅ Good:
   ```bash
   echo JWT_SECRET=$(aws ssm get-parameter --name "/finvault/JWT_SECRET" ...) >> .env
   ```

2. **Use SecureString for SSM parameters**
   ```bash
   aws ssm put-parameter \
     --name "/finvault/SECRET" \
     --type "SecureString" \  # Encrypted at rest
     --value "secret"
   ```

3. **Limit IAM permissions**
   - Only grant `ssm:GetParameter` (not `ssm:PutParameter`)
   - Restrict to specific parameter paths

4. **Rotate secrets regularly**
   ```bash
   # Update SSM parameter
   aws ssm put-parameter \
     --name "/finvault/JWT_SECRET" \
     --value "new_secret" \
     --overwrite
   
   # Redeploy to pick up new secret
   ```

### PM2 Best Practices

1. **Use named processes**
   ```bash
   pm2 start npm --name finvault-api -- run start:prod
   ```

2. **Save PM2 process list**
   ```bash
   pm2 save
   ```

3. **Enable startup script (survives reboots)**
   ```bash
   pm2 startup
   # Run the command it outputs
   pm2 save
   ```

4. **Monitor resource usage**
   ```bash
   pm2 monit  # Real-time monitoring
   ```

5. **Set up log rotation**
   ```bash
   pm2 install pm2-logrotate
   pm2 set pm2-logrotate:max_size 10M
   pm2 set pm2-logrotate:retain 7
   ```

---

## 📚 References

### Documentation

- [AWS CodeDeploy Hooks](https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file-structure-hooks.html)
- [PM2 Documentation](https://pm2.keymetrics.io/docs/usage/quick-start/)
- [AWS SSM Parameter Store](https://docs.aws.amazon.com/systems-manager/latest/userguide/systems-manager-parameter-store.html)
- [AWS CodeDeploy Agent](https://docs.aws.amazon.com/codedeploy/latest/userguide/codedeploy-agent.html)

### Useful Commands

```bash
# Check CodeDeploy agent status
sudo service codedeploy-agent status

# View CodeDeploy logs
sudo tail -f /var/log/aws/codedeploy-agent/codedeploy-agent.log

# List PM2 processes
pm2 list

# Application logs
pm2 logs app --lines 100

# Monitor processes
pm2 monit

# Restart application
pm2 restart app

# Delete all PM2 processes
pm2 delete all
```

---

<div align="center">

**🚀 Automated Deployment Excellence with AWS CodeDeploy 🚀**

[⬆ Back to Top](#-deployment-scripts)

</div>
