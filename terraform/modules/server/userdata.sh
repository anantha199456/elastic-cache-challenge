#! /bin/bash
yum update -y
amazon-linux-extras install epel -y
sudo yum -y install gcc make
sudo yum groupinstall "Development Tools" -y
sudo yum install git 

# INSTALL PYTHON and MODULES
sudo yum install python3 -y
sudo yum install pip -y
sudo yum install python3-pip python3-devel python3-setuptools -y
sudo yum install libpq-dev python-dev -y
sudo yum install python-devel postgresql-devel -y
sudo yum install python-psycopg2 -y
sudo yum install build-dep python-psycopg2
sudo yum install python3-venv

pip3 install psycopg2-binary
alias python=python3
pip3 install psycopg2
pip3 install configparser
pip3 install redis
pip3 install flask
pip3 install gunicorn

# INSTALL PSQL
amazon-linux-extras install postgresql11 -y

# INSTALL NGINX
sudo amazon-linux-extras install nginx1 -y
sudo ystemctl start nginx
sudo systemctl enable nginx