#!/bin/sh
sudo yum install -y httpd
sudo service start httpd
sudo chkonfig httpd on
echo "<html><h1>Hello from DevOpsOne ^^</h2></html>" > /var/www/html/index.html
