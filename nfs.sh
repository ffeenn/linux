

Ndir='/www/web/ysc/public_html'
Nip=`cat Nfs_ip.conf |xargs` 
yum -y install nfs*
for ip in $Nip;
do
	echo "$Ndir $ip(rw,sync,no_root_squash)"  >> /etc/exports
	sed -i "5a-A INPUT -s $ip -j ACCEPT"  /etc/sysconfig/iptables
done
systemctl start rpcbind
systemctl start nfs
systemctl enable rpcbind
systemctl enable nfs
systemctl restart iptables
exportfs -rva


