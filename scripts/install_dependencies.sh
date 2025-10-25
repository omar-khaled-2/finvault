#!/bin/bash
npm install -g pm2
cd /home/ec2-user/app/app
echo "PORT=3000" >> .env
echo "JWT_SECRET=omar" >> .env
echo "MONGO_URL=mongodb://localhost/money" >> .env