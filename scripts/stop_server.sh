#!/bin/bash
cd /home/ec2-user/app/app
pm2 stop app || echo "App not running"
pm2 delete app || echo "App not running"
rm -f .env