#!/bin/bash
sudo yum install httpd -y
sudo mkdir -p /var/www/html
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_fqdn}:/  /var/www/html/
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
sudo usermod -a -G apache ec2-user
sudo newgrp apache
sudo chown -R ec2-user:apache /var/www/html
sudo chmod 2775 /var/www/html
find /var/www/html -type d -exec sudo chmod 2775 {} \;
find /var/www/html -type f -exec sudo chmod 0664 {} \;
TOKEN=`curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
INSTANCE_ID=$(curl -H "X-aws-ec2-metadata-token: $TOKEN"  http://169.254.169.254/latest/meta-data/instance-id)
PUBLIC_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN"  http://169.254.169.254/latest/meta-data/public-ipv4)
AVAILABILITY_ZONE=$(curl -H "X-aws-ec2-metadata-token: $TOKEN"  http://169.254.169.254/latest/meta-data/placement/availability-zone)
echo "<h1>Hello World from Instance ID: $INSTANCE_ID</h1>" > /var/www/html/index.html
# echo "<p>This is the web App1 served from Public IP: $PUBLIC_IP</p>" >> /var/www/html/index.html
echo "<p>Running in Availability Zone: $AVAILABILITY_ZONE</p>" >> /var/www/html/index.html
