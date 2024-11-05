#!/bin/bash
# Update and install Node.js
sudo yum update -y
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum install -y nodejs git

# Clone your application repository
git clone https://github.com/yourusername/recipes-app.git /home/ec2-user/recipes-app

# Install dependencies and start the application
cd /home/ec2-user/recipes-app
npm install
# Run the app using pm2 to keep it running in the background
npm install -g pm2
pm2 start index.js
pm2 startup
pm2 save
