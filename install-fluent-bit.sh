#!/bin/bash

apt-get install wget -y

wget -qO - http://packages.fluentbit.io/fluentbit.key | sudo apt-key add -

echo "deb http://packages.fluentbit.io/ubuntu xenial main" >> vi /etc/apt/sources.list

apt-get update -y

apt-get install td-agent-bit -y

cat /etc/environment|grep ELASTICSEARCH_HOST
return_code=$(echo $?)
if [ $return_code == 1 ];then
        echo "ELASTICSEARCH_HOST="es.internal.cloudhms.io"" >> /etc/environment
fi
source /etc/environment

rm -f /etc/td-agent-bit/td-agent-bit.conf
rm -f /etc/td-agent-bit/parsers.conf
rm -f /etc/td-agent-bit/plugins.conf

cd /etc/td-agent-bit/

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
wget https://raw.githubusercontent.com/messi655/fluentbit/master/config/plugins.conf

sed -i 's/elasticsearch_host/'"$ELASTICSEARCH_HOST"'/g' output-elasticsearch-apache-access.conf 
sed -i 's/elasticsearch_host/'"$ELASTICSEARCH_HOST"'/g' output-elasticsearch-php-fpm.conf 
sed -i 's/elasticsearch_host/'"$ELASTICSEARCH_HOST"'/g' output-elasticsearch-apache-error.conf 

systemctl enable td-agent-bit

systemctl start td-agent-bit
