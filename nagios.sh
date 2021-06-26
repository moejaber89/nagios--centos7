#!/bin/bash

# must be root for the installation

# disable selinux 
sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
# you could disable it manually check the manual page if you want to
yum update
# install required packaging
yum install -y curl gcc glibc glibc-common wget unzip httpd php gd gd-devel perl postfix
mkdir /root/nagios-controller
cd /root/nagios-controller
# download nagios source file
wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.5.tar.gz
# unzip the tar file
tar xzf nagioscore.tar.gz
rm -rf nagioscore.tar.gz
cd nagioscore-nagios-4.4.5
# compiling nagios
./configure
make all
# create nagios user and group 
make install-groups-users
# add apache user to nagios groups
usermod -a -G nagios apache
# install nagios binaries html and cgl
make install
# install daemon and enable the service to start on boot
make install-daemoninit
systemctl enable httpd.service
# install command mode
make install-commandmode
# install sample config file
make install-config
# install apache config file
make install-webconf
# configure firewall and open port 80
firewall-cmd --zone=public --add-port=80/tcp
firewall-cmd --zone=public --add-port=80/tcp --permanent
firewall-cmd --reload
# create nagios web login user
htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
# restart apache service
systemctl restart httpd
# install nagios plugins and packaging
yum install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release
yum install -y perl-Net-SNMP
cd /root/nagios-controller
wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
tar xzf nagios-plugins.tar.gz
rm -rf nagios-plugins.tar.gz
cd nagios-plugins-release-2.2.1
# compile and install nagios plugin
./tools/setup
./configure
make
make install
# restart nagios service and check the status
systemctl restart nagios
clear
systemctl status nagios
echo
echo
ip a | grep inet | grep 192
echo " open your web browser in the URL section type your centos ip address follow with/nagios"
echo " username: nagiosadmin "
