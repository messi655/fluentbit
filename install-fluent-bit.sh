#!/bin/bash

wget -qO - http://packages.fluentbit.io/fluentbit.key | sudo apt-key add -

echo "deb http://packages.fluentbit.io/ubuntu xenial main" >> vi /etc/apt/sources.list

apt-get update

apt-get install td-agent-bit

export ELASTICSEARCH_HOST=ES_server

rm -f /etc/td-agent-bit/td-agent-bit.conf
rm -f /etc/td-agent-bit/parsers.conf
rm -f /etc/td-agent-bit/plugins.conf

systemctl enable td-agent-bit

systemctl start td-agent-bit

