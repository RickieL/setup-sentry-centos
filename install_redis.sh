#!/bin/bash

RDSconf=/etc/redis/6379.conf
RDSinit=/etc/init.d/redis_6379

mkdir -p /data/src /etc/redis  /data/redis/6379 /etc/redis
cd /data/src

# 下载安装redis
wget http://download.redis.io/redis-stable.tar.gz
tar xzf redis-stable.tar.gz
cd redis-stable

make
make install

cp utils/redis_init_script $RDSinit
cp redis.conf $RDSconf


sed -i 's/daemonize no/daemonize yes/' $RDSconf
sed -i 's#^dir \./#dir /data/redis/6379/#' $RDSconf
sed -i 's#^pidfile /var/run/redis.pid#pid /var/run/redis_6379.pid#' $RDSconf
sed -i 's#^loglevel notice#loglevel warning#' $RDSconf
sed -i 's#^logfile ""#logfile "/var/log/redis_6379.log"#' $RDSconf


# 内核配置
## transparent huge pages
echo never > /sys/kernel/mm/transparent_hugepage/enabled
echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local

## somaxconn
echo 1024 > /proc/sys/net/core/somaxconn
echo "net.core.somaxconn = 1024" >> /etc/sysctl.conf

## overcommit_memory
echo "vm.overcommit_memory = 1" >> /etc/sysctl.conf


sysctl -p

/etc/init.d/redis_6379 start
