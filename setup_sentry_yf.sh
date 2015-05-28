#!/bin/bash

yum -y update

yum -y install epel-release

yum  -y install gcc git patch libxslt libxslt-devel libxml2 libxml2-devel libzip libzip-devel libffi libffi-devel openssl openssl-devel mysql-server mysql-devel gcc make redis wget man python-devel zlib-devel bzip2-devel readline-devel sqlite-devel


# 变量设定
User=sentry
Group=sentry
DBuser=sentry
DBname=sentry
DBpass=sentry


# 创建sentry用户
groupadd  ${Group} -g 550
useradd -g  ${Group} ${User}  -u 550

# 判断是否需要安装mysql
# 配置mysql
## mysql配置文件
## 创建sentry库及用户
## 去掉root用户的远程登录

# 配置及启动redis

# 切换到sentry用户
## pyenv安装
## python2.7安装
## sentry安装
## sentry配置文件

# 安装supervisor
# 配置supervisor




SentryDir=/data/sentry
SourceDir=/usr/local/src/sentry
# Create database
service mysqld start

mysql -uroot -e "CREATE DATABASE IF NOT EXISTS ${DBname} DEFAULT CHARSET utf8 COLLATE utf8_general_ci;"
mysql -uroot -e "GRANT ALL PRIVILEGES ON ${DBname}.* TO ${DBuser}@'%' IDENTIFIED BY '${DBpass}';"
mysql -uroot -e "FLUSH PRIVILEGES;"

# Create Sentry home directory, user and group
virtualenv $SentryDir/
source $SentryDir/bin/activate
groupadd sentry
useradd -M -g sentry -d $SentryDir/ sentry
chown -R sentry:sentry $SentryDir/

# Setup Sentry and Redis libraries
mkdir -p /usr/local/src
git clone git@github.com:RickieL/setup-sentry-centos.git $SourceDir/
cd $SourceDir/
source $SentryDir/bin/activate
pip install supervisor mysql-python sentry redis django-redis-cache hiredis nydus

# Initialize configuration
cp $SourceDir/sentry.conf.py /etc/sentry.conf.py

# 启动 redis
service redis start

# Setup admin user
export SENTRY_CONF=/etc/sentry.conf.py
$SentryDir/bin/sentry --config=/etc/sentry.conf.py upgrade
python -c "from sentry.utils.runner import configure; configure(); from django.db import DEFAULT_DB_ALIAS as database; from sentry.models import User; User.objects.db_manager(database).create_superuser('admin', 'liaoyongfu@e.hunantv.com', 'admin')" executable=/bin/bash chdir=/var/sentry

# Run Sentry as a service
mkdir -p /root/bin
echo 'source /data/sentry/bin/activate' >> /root/.bashrc
echo 'PATH=$PATH:~/bin/' >> /root/.bashrc
source /root/.bashrc
cp $SourceDir/supervisor.sh /root/bin/supervisor.sh
chmod +x /root/bin/supervisor.sh

mkdir -p /data/sentry/etc/
cp $SourceDir/supervisord_sentry.conf $SentryDir/etc/supervisord.conf

# Configure autostart
chkconfig redis on
chkconfig mysqld on
echo '/root/bin/supervisor.sh istart' >> /etc/rc.local

supervisor.sh istart
