#!/bin/bash
cd /home/ec2-user/app/app
echo "PORT=3000" >> .env
echo "MONGO_URL=mongodb://localhost/money" >> .env
echo "JWT_SECRET=omar" >> .env
