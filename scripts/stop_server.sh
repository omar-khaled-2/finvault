#!/bin/bash

# Stop and remove the PM2 process
pm2 stop app || echo "App not running"