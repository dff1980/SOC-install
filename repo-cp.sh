mkdir -p /srv/www/suse-12.3/x86_64/repos/Cloud
mount ./SUSE-OPENSTACK-CLOUD-8-x86_64-GM-DVD1.iso /mnt
rsync -avP /mnt/ /srv/www/suse-12.3/x86_64/repos/Cloud/
umount /mnt
