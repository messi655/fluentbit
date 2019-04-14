#!/bin/bash

apt-get install wget -y

wget -qO - http://packages.fluentbit.io/fluentbit.key | sudo apt-key add -

echo "deb http://packages.fluentbit.io/ubuntu xenial main" >> vi /etc/apt/sources.list

apt-get update -y

apt-get install td-agent-bit -y

# Change Elasticsearch Host and Port
ELASTICSEARCH_HOST="es.host.com"
ELASTICSEARCH_PORT="80"

# PROD_NAME is product name, This will be create a index on Elasticsearch with the name is product name, separate the product name.
PROD_NAME="the_name"

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

# Replace Elasticsearch host
sed -i 's/elasticsearch_host/'"$ELASTICSEARCH_HOST"'/g' output-elasticsearch-apache-access.conf 
sed -i 's/elasticsearch_host/'"$ELASTICSEARCH_HOST"'/g' output-elasticsearch-php-fpm.conf 
sed -i 's/elasticsearch_host/'"$ELASTICSEARCH_HOST"'/g' output-elasticsearch-apache-error.conf 

# Replace Elasticsearch port
sed -i 's/elasticsearch_port/'"$ELASTICSEARCH_PORT"'/g' output-elasticsearch-apache-access.conf 
sed -i 's/elasticsearch_port/'"$ELASTICSEARCH_PORT"'/g' output-elasticsearch-php-fpm.conf 
sed -i 's/elasticsearch_port/'"$ELASTICSEARCH_PORT"'/g' output-elasticsearch-apache-error.conf 

# Replace prod_name for Index on ES
sed -i 's/prod_name/'"$PROD_NAME"'/g' output-elasticsearch-apache-access.conf 
sed -i 's/prod_name/'"$PROD_NAME"'/g' output-elasticsearch-php-fpm.conf 
sed -i 's/prod_name/'"$PROD_NAME"'/g' output-elasticsearch-apache-error.conf 

# Replace prod_name for filter
sed -i 's/prod_name/'"$PROD_NAME"'/g' filter-apache-access.conf 
sed -i 's/prod_name/'"$PROD_NAME"'/g' filter-apache-error.conf 
sed -i 's/prod_name/'"$PROD_NAME"'/g' filter-php-fpm.conf 


systemctl enable td-agent-bit

systemctl start td-agent-bit


