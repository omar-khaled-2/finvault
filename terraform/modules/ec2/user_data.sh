#!/bin/bash
yum update -y
yum install -y nodejs git
npm install -g pm2 
cd /home/ec2-user
git clone https://github.com/omar-khaled-2/money.git ./app
cd app/api
npm install
echo PORT=80 >> .env
echo JWT_SECRET=${jwt_secret} >> .env
echo "MONGO_URL=${mongo_url}" >> .env
npm run build
npm run start:prod

