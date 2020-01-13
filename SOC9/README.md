# Project #01-19
Enter ntp-server at cloudConfig.yml




#Demo SOC 9 for ESX


added VLAN15 for Ceph Storage Network
```bash
grep "opsconsole: https:" /var/lib/ardana/scratch/ansible/next/ardana/ansible/group_vars/all 
grep "horizon: https:" /var/lib/ardana/scratch/ansible/next/ardana/ansible/group_vars/all
grep "keystone_admin_pwd:" /var/lib/ardana/scratch/ansible/next/ardana/ansible/group_vars/entry-scale-kvm-control-plane-1
```

need restart compute node at next task: (for Huge Page start after reboot)
TASK: [network_interface | configure | SUSE- Restart openvswitch] *************

ansible-playbook -i hosts/localhost config-processor-run.yml -e remove_deleted_servers=True -e free_unused_addresses=True -e encrypt="" -e rekey=""


openstack endpoint create --region region1 object-store internal http://192.168.15.24:80/swift/v1
openstack endpoint create --region region1 object-store admin http://192.168.15.24:80/swift/v1
openstack endpoint create --region region1 object-store public http://192.168.15.24:80/swift/v1
