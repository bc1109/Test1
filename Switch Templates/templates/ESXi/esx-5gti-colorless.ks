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


echo "##ESXi1IP## ##ESXi1FQDN## ##ESXi1Name##" >> /etc/hosts
echo "##ESXi2IP## ##ESXi2FQDN## ##ESXi2Name##" >> /etc/hosts
echo "##ESXi3IP## ##ESXi3FQDN## ##ESXi3Name##" >> /etc/hosts
echo "##ESXi4IP## ##ESXi4FQDN## ##ESXi4Name##" >> /etc/hosts
echo "##ESXi5IP## ##ESXi5FQDN## ##ESXi5Name##" >> /etc/hosts
echo "##vCenterIP## ##vCenterFQDN## ##vCenterName##" >> /etc/hosts


esxcli network vswitch standard add --vswitch-name=vSwitch1
esxcli network vswitch standard uplink add --uplink-name=vmnic1 --vswitch-name=vSwitch1
esxcli network vswitch standard uplink add --uplink-name=vmnic2 --vswitch-name=vSwitch1

esxcli network vswitch standard add --vswitch-name=vSwitch2
esxcli network vswitch standard uplink add --uplink-name=vmnic3 --vswitch-name=vSwitch2
esxcli network vswitch standard uplink add --uplink-name=vmnic4 --vswitch-name=vSwitch2



esxcli network vswitch standard portgroup add --portgroup-name=ManagementPG --vswitch-name=vSwitch1
esxcli network vswitch standard portgroup set --portgroup-name=ManagementPG --vlan-id=222

esxcli network vswitch standard portgroup add --portgroup-name=CriticalServerPG --vswitch-name=vSwitch1
esxcli network vswitch standard portgroup set --portgroup-name=CriticalServerPG --vlan-id=68

esxcli network vswitch standard portgroup add --portgroup-name=RPSPG --vswitch-name=vSwitch1
esxcli network vswitch standard portgroup set --portgroup-name=RPSPG --vlan-id=996

esxcli network vswitch standard portgroup add --portgroup-name=ESXiManagementVMK --vswitch-name=vSwitch1
esxcli network vswitch standard portgroup set --portgroup-name=ESXiManagementVMK --vlan-id=222

esxcli network vswitch standard portgroup add --portgroup-name=IDSMonitorPG --vswitch-name=vSwitch2
esxcli network vswitch standard portgroup set --portgroup-name=IDSMonitorPG --vlan-id=4095


##SERIALCONSOLE##

cd /etc/init.d


%firstboot --interpreter=busybox

