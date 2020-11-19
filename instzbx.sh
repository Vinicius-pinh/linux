#!/bin/bash

##################
##################
#
#-PACKEGE INSTALATION
#
##################
##################

VERSION=`cat /etc/issue`
if [[ "$VERSION" == *"14"* ]];then

   echo "Ubuntu 14"
   echo "Installing zabbix packege"
   wget repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+trusty_all.deb -P /opt/
   dpkg -i /opt/zabbix-release_5.0-1+trusty_all.deb
   apt-get update
   apt-get install zabbix-agent
   ZBX=`dpkg -l | grep zabbix`
   if [[ "$ZBX" ]];then

       echo "agent installed in version `zabbix_agentd -V`"
   fi
fi

if [[ "$VERSION" == *"16"* ]];then

   echo "Ubuntu 16"
   echo "Installing zabbix packege"
   wget repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+xenial_all.deb -P /opt/
   dpkg -i /opt/zabbix-release_5.0-1+xenial_all.deb
   apt-get update
   apt-get install zabbix-agent
   ZBX=`dpkg -l | grep zabbix`
   if [[ "$ZBX" ]];then

       echo "agent installed in version `zabbix_agentd -V`"
   fi
fi

if [[ "$VERSION" == *"18"* ]];then

   echo "Ubuntu 18"
   echo "Installing zabbix packege"
   wget repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+bionic_all.deb -P /opt/
   dpkg -i /opt/zabbix-release_5.0-1+bionic_all.deb
   apt-get update
   apt-get install zabbix-agent
   ZBX=`dpkg -l | grep zabbix`
   if [[ "$ZBX" ]];then

       echo "agent installed in version `zabbix_agentd -V`"
   fi
fi

if [[ "$VERSION" == *"20"* ]];then

   echo "Ubuntu 20"
   echo "Installing zabbix packege"
   wget repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+focal_all.deb -P /opt/
   dpkg -i /opt/zabbix-release_5.0-1+focal_all.deb
   apt-get update
   apt-get install zabbix-agent
   ZBX=`dpkg -l | grep zabbix`
   if [[ "$ZBX" ]];then

       echo "agent installed in version `zabbix_agentd -V`"
   fi
fi

##################
##################
#
#-CONFIGURATION
#
##################
##################

ZBXFILE="/etc/zabbix/zabbix_agentd.conf"
[[ -a "$ZBXFILE" ]]
service zabbix-agent stop

#####################
#
#Editing zabbix config file
#
####################

IP=`ifconfig | egrep -o 'addr:([[:digit:]]{1,3}\.){3}[[:digit:]]{1,3}' | egrep -o '[[:digit:]].*'`
IPV4GET=`echo $IP | cut -d " " -f "1"`
RANGE=`echo $IPV4GET | cut -d "." -f "3"`
PROXYIP=`echo "192.168.$RANGE.128"`

HOSTNAME=`hostname`
#ZBXFILE="/etc/zabbix/zabbix_agentd.conf"
#[[ -a "$ZBXFILE" ]]

   echo "the file exists"
   echo "removing item"
   rm -f $ZBXFILE
 echo "PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Server=$PROXYIP
ServerActive=$PROXYIP
Hostname=$HOSTNAME
Include=/etc/zabbix/zabbix_agentd.d/*.conf
TLSConnect=psk
TLSAccept=psk
TLSPSKIdentity=PBPSK001
TLSPSKFile=/opt/psk.key" >> $ZBXFILE

#######
#
#Creating PK file
#
#######

touch /opt/psk.key | echo "aef08385704c71abc9f6e39bbef03138e6e2b0d6a4c63940344971ed4653b5d3" > /opt/psk.key
chmod 664 /opt/psk.key
chown zabbix:zabbix /opt/psk.key

service zabbix-agent start

ps aux | grep zabbix
