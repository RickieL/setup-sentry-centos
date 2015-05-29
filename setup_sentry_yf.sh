#!/bin/bash

yum -y update

yum -y install epel-release

yum  -y install gcc gcc-c++ makegit patch libxslt libxslt-devel libxml2 libxml2-devel libzip libzip-devel libffi libffi-devel openssl openssl-devel mysql-server mysql-devel wget man python-devel zlib-devel bzip2-devel readline-devel sqlite-devel python-setuptools git

RepoDir=/tmp/sentry

# clone 本仓库
git clone https://github.com/RickieL/setup-sentry-centos.git $RepoDir

# 引入变量
source $RepoDir/conf/var.cnf

# 创建sentry用户
groupadd ${Group} &>/dev/null
useradd -g  ${Group} ${User}  &>/dev/null

# 判断是否需要安装mysql
# 配置mysql
if [ -f /etc/my.cnf ]; then
  mv /etc/my.cnf /etc/my.cnf.old
fi
cp -f $RepoDir/conf/my.cnf  /etc/my.cnf

# Create database
service mysqld start
mysql -uroot -e "CREATE DATABASE IF NOT EXISTS ${DBname} DEFAULT CHARSET utf8 COLLATE utf8_general_ci;"
mysql -uroot -e "GRANT ALL PRIVILEGES ON ${DBname}.* TO ${DBuser}@'%' IDENTIFIED BY '${DBpass}';"
mysql -uroot -e "USE mysql; DELETE FROM user WHERE user='';"
mysql -uroot -e "USE mysql; DELETE FROM user WHERE user='root' AND host != 'localhost';"
mysql -uroot -e "FLUSH PRIVILEGES;"

# 配置及启动redis
# redis 需要大于 2.6.12版本，否则报错 ResponseError: wrong number of arguments for 'set' command
$RepoDir/install_redis.sh

# 切换到sentry用户
## pyenv安装
## python2.7安装
## sentry安装
## sentry配置文件
export SENTRY_CONF=/home/$User/.sentry/sentry.conf.py

chmod +x $RepoDir/sentry.sh
su - sentry -c "$RepoDir/sentry.sh"

# 安装supervisor
# 配置supervisor
easy_install pip
pip install supervisor

mkdir -p /etc/supervisord.conf.d
mkdir -p /var/log/supervisor
mkdir -p /var/log/sentry
chown $User:$Group /var/log/sentry

# Setup admin user
/home/$User/.pyenv/shims/python -c "from sentry.utils.runner import configure; configure(); from django.db import DEFAULT_DB_ALIAS as database; from sentry.models import User; User.objects.db_manager(database).create_superuser('admin', '1365274496@qq.com', 'admin')" executable=/bin/bash chdir=/home/$User

# Run Sentry as a service
cp -p $RepoDir/conf/supervisor.conf /etc/supervisord.conf
cp -p $RepoDir/conf/supervisor-sentry.conf /etc/supervisord.conf.d/sentry.conf

# upgrade setuptools
wget --no-check-certificate https://bootstrap.pypa.io/ez_setup.py
python ez_setup.py --insecure

supervisord -c /etc/supervisord.conf
supervisorctl -c /etc/supervisord.conf start all
