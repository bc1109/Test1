accepteula
clearpart --alldrives --overwritevmfs
install --firstdisk=usb-storage,vmw_ahci,ahci,local --overwritevmfs --novmfsondisk 
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


echo "##ESXi1IP## ##ESXi1FQDN## ##ESXi1Name##" >> /etc/hosts
echo "##ESXi2IP## ##ESXi2FQDN## ##ESXi2Name##" >> /etc/hosts
echo "##ESXi3IP## ##ESXi3FQDN## ##ESXi3Name##" >> /etc/hosts
echo "##ESXi4IP## ##ESXi4FQDN## ##ESXi4Name##" >> /etc/hosts
echo "##ESXi5IP## ##ESXi5FQDN## ##ESXi5Name##" >> /etc/hosts
echo "##vCenterIP## ##vCenterFQDN## ##vCenterName##" >> /etc/hosts


##SERIALCONSOLE##


%firstboot --interpreter=busybox

