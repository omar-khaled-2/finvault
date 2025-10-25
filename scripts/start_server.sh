#!/bin/bash

cd /home/ec2-user/app/app
pm2 start npm --name app -- run start:prod