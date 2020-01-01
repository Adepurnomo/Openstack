# Openstack raw installer for Centos7
# Problem 
> after you restart openstack host & logon horizon dashboard, select the Imges menu then you get the message "Error: Unable to retrieve the images."
> please check "openstack-glance-api.service" , then you get filed, You can run it service manually & check SElinux
# Install
use > curl -sSL https://raw.githubusercontent.com/Adepurnomo/Openstack_auto_installer/master/Openstack-train.sh | bash 
