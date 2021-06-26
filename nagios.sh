#!/bin/bash

# disable selinux 
sudo sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
# you could disable it manually check the manual page if you want to
sudo yum update
# install required packaging
sudo yum install -y curl gcc glibc glibc-common wget unzip httpd php gd gd-devel perl postfix
cd /usr/src
# download nagios source file
sudo wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.5.tar.gz
# unzip the tar file
sudo tar xzf nagioscore.tar.gz
sudo rm -rf nagioscore.tar.gz
sudo cd nagioscore-nagios-4.4.5
# compiling nagios
sudo ./configure
sudo make all
# create nagios user and group 
sudo make install-groups-users
# add apache user to nagios groups
sudo usermod -a -G nagios apache
# install nagios binaries html and cgl
sudo make install
# install daemon and enable the service to start on boot
sudo make install-daemoninit
sudo systemctl enable httpd.service
# install command mode
sudo make install-commandmode
# install sample config file
sudo make install-config
# install apache config file
sudo make install-webconf
# configure firewall and open port 80
sudo firewall-cmd --zone=public --add-port=80/tcp
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --reload
# create nagios web login user
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
# restart apache service
sudo systemctl restart httpd
# install nagios plugins and packaging
sudo yum install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release
sudo yum install -y perl-Net-SNMP
cd /usr/src
sudo wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
sudo tar xzf nagios-plugins.tar.gz
sudo rm -rf nagios-plugins.tar.gz
cd nagios-plugins-release-2.2.1
# compile and install nagios plugin
sudo ./tools/setup
sudo ./configure
sudo make
sudo make install
# restart nagios service and check the status
sudo systemctl restart nagios
clear
sudo systemctl status nagios
ip a show enp0s3
echo " open your web browser in the url section type your centos ip address follow with/nagios"
