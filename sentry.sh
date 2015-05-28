#!/bin/bash

RepoDir=/tmp/sentry

# 引入变量
source $RepoDir/conf/var.cnf

Home=/home/sentry
export PATH=$PATH:$Home/.pyenv/bin

# 安装 pyenv
curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash

echo  """
export PATH="~/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
""" >> $Home/.bash_profile

source $Home/.bash_profile

# 安装 python 2.7.10
pyenv install 2.7.10

# 使用最新安装的python
pyenv global 2.7.10

# 安装sentry
pip install -U pip
pip install -U sentry
pip install -U sentry[mysql]

# init sentry config
sentry init
cp -f $RepoDir/conf/sentry.conf.py  $Home/.sentry/sentry.conf.py

export SENTRY_CONF=/home/$User/.sentry/sentry.conf.py
cp -f $RepoDir/conf/sentry.conf.py $SENTRY_CONF

sentry upgrade
