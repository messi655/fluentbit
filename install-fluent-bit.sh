#!/bin/bash

apt-get install wget -y

wget -qO - http://packages.fluentbit.io/fluentbit.key | sudo apt-key add -

echo "deb http://packages.fluentbit.io/ubuntu xenial main" >> vi /etc/apt/sources.list

apt-get update -y

apt-get install td-agent-bit -y

export ELASTICSEARCH_HOST=127.0.0.1

rm -f /etc/td-agent-bit/td-agent-bit.conf
rm -f /etc/td-agent-bit/parsers.conf
rm -f /etc/td-agent-bit/plugins.conf

cd /etc/td-agent-bit/
touch plugins.conf
wget https://raw.githubusercontent.com/messi655/fluentbit/master/config/td-agent-bit.conf
wget https://raw.githubusercontent.com/messi655/fluentbit/master/config/parsers.conf
wget https://raw.githubusercontent.com/messi655/fluentbit/master/config/output-elasticsearch-php-fpm.conf
wget https://raw.githubusercontent.com/messi655/fluentbit/master/config/output-elasticsearch-apache-error.conf
wget https://raw.githubusercontent.com/messi655/fluentbit/master/config/output-elasticsearch-apache-access.conf
wget https://raw.githubusercontent.com/messi655/fluentbit/master/config/input-php-fpm.conf
wget https://raw.githubusercontent.com/messi655/fluentbit/master/config/input-apache-error.conf
wget https://raw.githubusercontent.com/messi655/fluentbit/master/config/input-apache-access.conf
wget https://raw.githubusercontent.com/messi655/fluentbit/master/config/filter-php-fpm.conf
wget https://raw.githubusercontent.com/messi655/fluentbit/master/config/filter-apache-error.conf
wget https://raw.githubusercontent.com/messi655/fluentbit/master/config/filter-apache-access.conf

systemctl enable td-agent-bit

systemctl start td-agent-bit

