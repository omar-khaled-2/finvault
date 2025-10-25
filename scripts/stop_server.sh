#!/bin/bash
cd /home/ec2-user/app/app
rm -f .env
pm2 stop app || echo "App not running"
pm2 delete app || echo "App not running"