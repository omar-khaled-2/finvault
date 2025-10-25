#!/bin/bash
yum update -y
yum install -y nodejs git
yum install -y ruby
yum install -y wget
cd /home/ec2-user
wget https://aws-codedeploy-us-east-1.s3.us-east-1.amazonaws.com/latest/install
chmod +x ./install
./install auto