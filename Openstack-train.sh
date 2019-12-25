#!/bin/bash
##
clear
if [[ $EUID -ne 0 ]]; then
   echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
   echo "            Please run this scripts on SU !               "
   echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
   exit 1
fi
yum update -y
systemctl stop postfix firewalld NetworkManager
systemctl disable postfix firewalld NetworkManager
systemctl mask NetworkManager
yum remove postfix NetworkManager NetworkManager-libnm -y
seteforce 0
getenforce
sed -i 's/enforcing/disabled/g' /etc/sysconfig/selinux
yum install centos-release-openstack-train -y
yum install openstack-packstack -y
packstack --gen-answer-file=/root/answer.txt
sed -i 's/CONFIG_NTP_SERVERS=/CONFIG_NTP_SERVERS=0.pool.ntp.org/g' /root/answer.txt
sed -i 's/CONFIG_KEYSTONE_ADMIN_PW=*/#CONFIG_KEYSTONE_ADMIN_PW=*/g' /root/answer.txt
sed -i 's/CONFIG_MARIADB_PW=*/#CONFIG_MARIADB_PW=*/g' /root/answer.txt
sed -i 's/ONFIG_SWIFT_STORAGE_FSTYPE=ext4/ONFIG_SWIFT_STORAGE_FSTYPE=xfs/g' /root/answer.txt
sed -i 's/CONFIG_PROVISION_DEMO=y/CONFIG_PROVISION_DEMO=n/g' /root/answer.txt
sed -i 's/CONFIG_NEUTRON_ML2_MECHANISM_DRIVERS=ovn/CONFIG_NEUTRON_ML2_MECHANISM_DRIVERS=openvswitch/g' /root/answer.txt
sed -i 's/CONFIG_NEUTRON_L2_AGENT=ovn/CONFIG_NEUTRON_L2_AGENT=openvswitch/g' /root/answer.txt
cat <<EOF>> /root/answer.txt
CONFIG_KEYSTONE_ADMIN_PW=arumi2507
CONFIG_MARIADB_PW=arumi2507
EOF
packstack --answer-file /root/answer.txt
echo "--------------------"
echo " password arumi2507 "
echo "--------------------"
echo " For your testing on GCP or AWS, put your external ip to /etc/http/conf.d/15-horizon* search 'ServerAlias' " 
echo " and vnc /etc/nova/nova.conf search 'http://xXx:6080' ad place your external ip "
echo " don't forget, enable nested virtualization on your vm instance AWS or GCP "
