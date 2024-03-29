# SOC8-install
SOC8 Install file doc and script
## SMT Setup
Adding Mandatory Repositories
`smt-setup.sh`
## Copying the Product Media Repositories
|Repository|Directory|
|----------|---------|
|SUSE OpenStack Cloud 8 DVD #1|/srv/www/suse-12.3/x86_64/repos/Cloud|

Download **SUSE-OPENSTACK-CLOUD-8-x86_64-GM-DVD1.iso**
start from the download directory `repo-cp.sh`

## Users
Creating a User "cloud"
visudo as user root and add the following line to the end of the file:

--`cloud ALL = (root) NOPASSWD:ALL`

++`cloud,ardana ALL = (root) NOPASSWD:ALL`

Set the password for the user ardana:
`sudo passwd ardana`
Become the user ardana:
`su - ardana`
Place a copy of the SUSE Linux Enterprise Server 12 SP3 .iso in the ardana home directory, var/lib/ardana, and rename it to `sles12sp3.iso`.
`ARDANA_INIT_AUTO=1 /usr/bin/ardana-init`

## GIT
`git status
git add -A
git commit -m "My config or other commit message"`
[Using Git for Configuration Management](https://www.suse.com/documentation/suse-openstack-cloud-8/book_install/data/updating-configuration-including-default-config.html)

?Создать Updates-test репозитории?

## Determining Your User Credentials
`grep "pwd" ~/scratch/ansible/next/ardana/ansible/group_vars/*`
`sed -n '/cp_tempest_data:/,/cp_tempest/p' ~/scratch/ansible/next/ardana/ansible/group_vars/all`
`. ~\keystone.osrc`
`. ~\service.osrc`

## Repository Locations
The following tables show the locations of all repositories that can be used for SUSE OpenStack Cloud.

### SMT Repositories Hosted on the Administration Server

|Repository|Directory|
|----------|---------|
|Mandatory Repositories||
|SLES12-SP3-Pool|/srv/www/htdocs/repo/SUSE/Products/SLE-SERVER/12-SP3/x86_64/product/|
|SLES12-SP3-Updates|/srv/www/htdocs/repo/SUSE/Updates/SLE-SERVER/12-SP3/x86_64/update/|
|SUSE-OpenStack-Cloud-8-Pool|/srv/www/htdocs/repo/SUSE/Products/OpenStack-Cloud/8/x86_64/product/|
|SUSE-OpenStack-Cloud-8-Updates|/srv/www/htdocs/repo/SUSE/Updates/OpenStack-Cloud/8/x86_64/update/|

### SUSE Manager Repositories (Channels)

|Repository|URL|
|----------|---|
|Mandatory Repositories||
|SLES12-SP3-Updates|http://manager.example.com/ks/dist/child/sles12-sp3-updates-x86_64/sles12-sp3-x86_64/|
|SUSE-OpenStack-Cloud-8-Pool|http://manager.example.com/ks/dist/child/suse-openstack-cloud-8-pool-x86_64/sles12-sp3-x86_64/|
|SUSE-OpenStack-Cloud-8-Updates|http://manager.example.com/ks/dist/child/suse-openstack-cloud-8-updates-x86_64/sles12-sp3-x86_64/|

### Other
https://yadi.sk/d/VL7iOBOZNF7u5w

### Repository Locations on the Cloud Lifecycle Manager server
The following table shows the required repository locations to use when manually copying, synchronizing, or mounting the repositories.

|Channel|Directory on the Administration Server|
|-------|--------------------------------------|
|Mandatory Repositories||
|SLES12-SP3-Pool|/srv/www/suse-12.3/x86_64/repos/SLES12-SP3-Pool/|
|SLES12-SP3-Updates|/srv/www/suse-12.3/x86_64/repos/SLES12-SP3-Updates/|
|SUSE-OpenStack-Cloud-8-Pool|/srv/www/suse-12.3/x86_64/repos/SUSE-OpenStack-Cloud-8-Pool/|
|SUSE-OpenStack-Cloud-8-Updates|/srv/www/suse-12.3/x86_64/repos/SUSE-OpenStack-Cloud-8-Updates/|

## Update

`cd ~/scratch/ansible/next/ardana/ansible`
`ansible-playbook -i hosts/verb_hosts ardana-update-status.yml -e zypper_update_include_reboot_patches=true -e skip_single_host_checks=true`

## Add Node

- Commit Configuration to Git

`cd ~/openstack
git add -A
git commit -m "<description of changes>"`

- Run the Configuration Processor

`cd ~/openstack/ardana/ansible/
ansible-playbook -i hosts/localhost config-processor-run.yml`

- Run ready-deployment Playbook

`cd ~/openstack/ardana/ansible/
ansible-playbook -i hosts/localhost ready-deployment.yml`

- Redeploy Cobbler with New Node Info

  - Redeploy Cobbler

  `cd ~/openstack/ardana/ansible/
   ansible-playbook -i hosts/localhost cobbler-deploy.yml`

  - Get list of Cobbler Nodes (so we know the node's name):

  `sudo cobbler list`

- (Re)Image the New Node

`cd ~/openstack/ardana/ansible/
ansible-playbook -i hosts/localhost bm-reimage.yml -e nodelist=NODE_NAME`

- Run the site Playbook for the New Node

  - Determine the node's hostname

  `cd ~/scratch/ansible/next/ardana/ansible/
  grep NODE_IP_ADDR generated_file/etc/hosts | awk '{ print $2 }'`

  - Run site playbook for that node:

  `ansible-playbook -i hosts/verb_hosts site.yml --limit NODE_NAME`

## Doc
http://docserv.nue.suse.com/documents/#SUSE_OpenStack_Cloud_8

https://downloads.hpe.com/pub/softlib2/software1/pubsw-linux/p1857046646/v146094/ssacli-3.30-14.0.x86_64.rpm
https://downloads.hpe.com/pub/softlib2/software1/pubsw-linux/p219801368/v146098/ssaducli-3.30-14.0.x86_64.rpm
