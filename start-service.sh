#!/bin/bash -xe
# start service for CodeDeploy to know how to start application
source /home/ec2-user/.bash-profile
cd /home/ec2-user/app/release
npm run start