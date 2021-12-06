#!/bin/bash -xe
# stop service to tell CodeDeploy how to stop our application

source /home/ec2-user/.bash_profile
[ -d "/home/ec2-user/app/release"] && \
cd /home/ec2-user/app/release && \
npm stop