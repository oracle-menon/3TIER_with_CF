#!/bin/bash
sudo yum update -y
sudo yum -y install nfs-utils
sudo mkdir -p /usr/share/nginx/html
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_fqdn}:/  /usr/share/nginx/html
sudo yum install nginx -y
sudo systemctl start nginx.service
sudo systemctl enable nginx.service
sudo usermod -a -G nginx ec2-user
newgrp nginx
sudo chown -R ec2-user:nginx /usr/share/nginx/html
sudo chmod 2775 /usr/share/nginx/html
find /usr/share/nginx/html -type d -exec sudo chmod 2775 {} \;
find /usr/share/nginx/html -type f -exec sudo chmod 0664 {} \;
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN"  http://169.254.169.254/latest/meta-data/instance-id)
PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN"  http://169.254.169.254/latest/meta-data/public-ipv4)
AVAILABILITY_ZONE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN"  http://169.254.169.254/latest/meta-data/placement/availability-zone)
echo "<h1>Hello World from Instance ID: $INSTANCE_ID</h1>" > /usr/share/nginx/html/index.html
# echo "<p>This is the web App1 served from Public IP: $PUBLIC_IP</p>" >> /usr/share/nginx/html/index.html
echo "<p>Running in Availability Zone: $AVAILABILITY_ZONE</p>" >> /usr/share/nginx/html/index.html