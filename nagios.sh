#!/bin/bash

# disable selinux
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
yum update
# install required packaging
yum install -y curl gcc glibc glibc-common wget unzip httpd php gd gd-devel perl postfix
cd /usr/src
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.5.tar.gz
tar xzf nagioscore.tar.gz
cd nagioscore-nagios-4.4.5
./configure
make all
make install-groups-users
usermod -a -G nagios apache
make install
make install-daemoninit
systemctl enable httpd.service
make install-commandmode
make install-config
make install-webconf
firewall-cmd --zone=public --add-port=80/tcp
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
systemctl restart httpd
install nagios plugins
yum install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release
yum install -y perl-Net-SNMP
cd /usr/src
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
tar xzf nagios-plugins.tar.gz
cd nagios-plugins-release-2.2.1
./tools/setup
./configure
make
make install
systemctl restart nagios
systemctl status nagios
