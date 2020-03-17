accepteula
clearpart --alldrives --overwritevmfs
install --firstdisk=usb-storage,hpsa,local --overwritevmfs --novmfsondisk 
rootpw ##ROOTPW##
reboot --noeject


%include /tmp/networkconfig
 
%pre --interpreter=busybox
 
# extract network info from bootup
VMK_INT="vmk0"
IPADDR=##ESXIP##
NETMASK=##ESXMASK##
GATEWAY=##ESXGATEWAY##
DNS=##DNSIP##
HOSTNAME=##FQDN##

echo "network --bootproto=static --addvmportgroup=false --device=vmnic0 --ip=${IPADDR} --netmask=${NETMASK} --gateway=${GATEWAY} --nameserver=${DNS} --hostname=${HOSTNAME}" > /tmp/networkconfig


%firstboot --interpreter=busybox

esxcli system coredump partition set --partition="mpx.vmhba32:C0:T0:L0:7"
esxcli system coredump partition set --enable=true
esxcli system settings kernel set -s preferVmklinux -v FALSE
esxcli system module set --enabled=false -m vmkusb


echo "##ESXi1IP## ##ESXi1FQDN## ##ESXi1Name##" >> /etc/hosts
echo "##ESXi2IP## ##ESXi2FQDN## ##ESXi2Name##" >> /etc/hosts
echo "##ESXi3IP## ##ESXi3FQDN## ##ESXi3Name##" >> /etc/hosts
echo "##ESXi4IP## ##ESXi4FQDN## ##ESXi4Name##" >> /etc/hosts
echo "##ESXi5IP## ##ESXi5FQDN## ##ESXi5Name##" >> /etc/hosts
echo "##vCenterIP## ##vCenterFQDN## ##vCenterName##" >> /etc/hosts


echo "enableSSLv3:false" >> /etc/sfcb/sfcb.cfg
echo "enableTLSv1:true" >> /etc/sfcb/sfcb.cfg
echo "enableTLSv1_1:true" >> /etc/sfcb/sfcb.cfg
echo "enableTLSv1_2:true" >> /etc/sfcb/sfcb.cfg

##SERIALCONSOLE##

cd /etc/init.d
/etc/init.d/sfcbd-watchdog restart

%firstboot --interpreter=busybox

