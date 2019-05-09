#!bin/bash

sudo yum install wget -y

sudo rpm -Uvh https://nginx.org/packages/rhel/7/x86_64/RPMS/nginx-1.8.1-1.el7.ngx.x86_64.rpm

sudo systemctl start nginx
