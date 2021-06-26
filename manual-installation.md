1) disable selinux 
# setenforce 0                  then enter
# getenforce        output Permissive this command will temporaily disabe selinux to disable selinux peranently use:
# sed -i 's/SELINUX=.*/SELINUX=disabled/g' /etc/selinux/config
  (sed - stream editor for filtering and transforming text)
  (-i edit files in place)
# cat /etc/selinux/config | grep SELINUX
or your could disable it manually thru vi /etc/selinux/config       then
change what after selinux= to disable  there is two of them
2) update the system then install all required pacages
# yum update 
# yum install -y curl gcc glibc glibc-common wget unzip httpd php gd gd-devel perl postfix
pacages explanations:
GCC stands for GNU Compiler Collections which is used to compile mainly C and C++ language. It can also be used to compile Objective C and Objective C++
 GNU C Library project provides the core libraries for the GNU system and GNU/Linux systems
glibc-common - Common binaries and locale data for glibc
Wget is the non-interactive network downloader which is used to download files from the serve
unzip is a utility that helps you list, test, and extract compressed ZIP archives
Hypertext Transfer Protocol (HTTP) is a method for encoding and transporting information #
PHP is an open source server side scripting Language which originally stood for 'Personal Home Page' now stands for 'PHP: Hypertext Preprocessor
gd is an open-source library that allows users to create and manipulate images easily
The gd-devel package contains the development libraries and header files for gd, a graphics library for creating PNG and JPEG graphics
Perl is a programming language that can be used to perform tasks that would be difficult or cumbersome on the command line
Postfix is a popular open-source Mail Transfer Agent (MTA) that can be used to route and deliver email on a Linux system
3) download nagios 
# cd /usr/src
# wget -O nagioscore.tar.gz https://github.com/NagiosEnterprises/nagioscore/archive/nagios-4.4.5.tar.gz
# tar xzf nagioscore.tar.gz
now you could remove the nagioscore.tar.gz
# rm -rf  nagioscore.tar.gz
# cd nagioscore-nagios-4.4.5
# ./configure
# make all
4) create nagios user and group
# make install-groups-users
The make utility requires a file, Makefile (or makefile ), which defines set of tasks to be executed. You may have used make to compile a program from source code
5) add apache user to the nagios groups
# usermod -a -G nagios apache
6) install nagios binaries html and cgl file
# make install
5) install daemon and enable srvice to start on boot
# make install-daemoninit
# systemctl enable httpd.service
7) install command mode
 # make install-commandmode
8) install sample config file
# make install-config
9) install apache config file
# make install-webconf
10) configure firewall and open port 80
# firewall-cmd --zone=public --add-port=80/tcp
# firewall-cmd --zone=public --add-port=80/tcp --permanent
# firewall-cmd --reload
11) create nagios web login user
# htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
output:
new password: enter any password
re-type new password : same password as above
12) restart the apache service
# systemctl restart httpd
13) verify nagios open web browser and insert your ip address then /nagios
insert :
nagiosadmin then the password
14) install nagios plugins
# yum install -y gcc glibc glibc-common make gettext automake autoconf wget openssl-devel net-snmp net-snmp-utils epel-release
# yum install -y perl-Net-SNMP
15) download nagios plugin source file 
# cd /usr/src
# wget --no-check-certificate -O nagios-plugins.tar.gz https://github.com/nagios-plugins/nagios-plugins/archive/release-2.2.1.tar.gz
# tar zxf nagios-plugins.tar.gz
# rm -rf nagios-plugins.tar.gz
# cd nagios-plugins-release-2.2.1
16) compole and install nagios plugin
 # ./tools/setup
 # ./configure
# make
# make install
17) restart the nagios service then check the status
# systemctl restart nagios
# systemctl status nagios
18) open the web browser then re inter ip address/nagios
insert you username and password
192.168.x.xx/nagios in your url web browser
you could copy whats come after # only and it should do the job
