#!/bin/bash
npm install -g pm2
cd /home/ec2-user/app/app
echo "PORT=80" >> .env
echo JWT_SECRET=$(aws ssm get-parameter --name "/finvault/JWT_SECRET" --with-decryption --query "Parameter.Value" --output text) >> .env
echo MONGO_URL=$(aws ssm get-parameter --name "/finvault/MONGO_URL" --with-decryption --query "Parameter.Value" --output text) >> .env