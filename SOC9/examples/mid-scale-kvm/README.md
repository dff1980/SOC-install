<!--
(c) Copyright 2015 Hewlett Packard Enterprise Development LP
(c) Copyright 2017-2019 SUSE LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations
under the License.
-->

## Mid-Size KVM Cloud

This example input model is intended as a template for a moderately sized cloud.
The Control plane is made up of multiple server clusters to provide sufficient
computational, network, and IOPS capacity for a mid-sized production
style cloud.

### Control plane

- Core cluster: Runs Core OpenStack services, (Keystone, Nova, Glance, Neutron,
  Horizon, Heat, Ceilometer, block storage, and object storage). The default
  configuration is two nodes of role type CORE-ROLE.

- Metering and Monitoring cluster: Runs the OpenStack Services for metering
  and monitoring (ceilometer, monasca, and logging). Default configuration is
  three nodes of role type MTRMON-ROLE.

- Database and Message Queue Cluster: Runs clustered MariaDB and RabbitMQ
  services to support the Ardana cloud infrastructure. Default configuration is
  three nodes of role type DBMQ-ROLE. Three nodes are required for high
  availability.

- Swift PAC cluster: Runs the Swift Proxy, Account, and Container services.
  Default configuration is three nodes of role type SWPAC-ROLE.

- Neutron Agent cluster: Runs Neutron VPN (L3), DHCP, Metadata, and OpenVswitch
  agents. Default configuration is two nodes of role type NEUTRON-ROLE.

### Lifecycle Manager

  The lifecycle-manager runs on one of the control-plane nodes. The ip address
  of the node that will run the lifecycle-manager needs to be included in the
  `data/servers.yml` file.

### Resource Nodes

- Compute: Runs nova-compute and associated services. Runs on nodes of role
  type COMPUTE-ROLE. This model lists 3 nodes. One node is the minimum
  requirement.

- Object storage: 3 nodes of type SOWBJ-ROLE run the Swift Object service.
  The minimum node count should match your Swift replica count.

Nineteen (19) nodes are required to run this model unmodified. This can be
reduced by consolidating services on the control plane clusters.

### Networking

This model requires the following networks:

- IMPI/iLO: network connected to the lifecycle-manager and the IPMI/iLO ports
  of all nodes.

- External API: This is the network that users will use to make requests to
  the cloud.

- Internal API: This is the network that will be used within the cloud for API
  access between services.

- External VM: This is the network that will be used to provide external
  access to VMs (via floating IP addresses).

- Guest: This is the network that will carry traffic between VMs on private
  networks within the cloud.

- Cloud Management: This is the network that will be used for all internal
  traffic between cloud services. In this model it is shown as untagged.
  It can be tagged if required.

- SWIFT: This network is used for internal Swift communications between the
  Swift nodes.

The EXTERNAL-API network must be reachable from the EXTERNAL-VM network if you
want VMs to be able to make API calls to the cloud.

An example set of networks is defined in `data/networks.yml`. You will need
to modify this file to reflect your environment.

The example uses `hed3` for the install network interface and `hed4` and `hed5`
for the bonded network interface. If you need to modify these for your
environment use the file `data/net_interfaces.yml`.

### Adapting the mid-size model to fit your environment

The minimum set of changes you need to make to adapt the model for your
environment are:

- Update `servers.yml` to list the details of your bare metal servers.

- Update the `networks.yml` file to replace network CIDRs and VLANs with site
  specific values.

- Update the `nic_mappings.yml` file to ensure that network devices are mapped
  to the correct physical port(s).

- Review the disk models (`disks_*.yml`) and confirm that the associated servers
  have the number of disks required by the disk model. The device names in the
  disk models might need to be adjusted to match the probe order of your
  servers. The default number of disks for the Swift nodes (3 disks) is set low
  on purpose to facilitate deployment on generic hardware. For production scale
  Swift the servers should have more disks: 6 on SWPAC nodes and 12 on SWOBJ
  nodes. If you allocate more Swift disks then you should review the ring power
  in the Swift ring configuration. This is documented in the Swift
  section. Disk models are provided as follows:

     * DISK SET CONTROLLER: Minimum 1 disk.
     * DISK SET DBMQ: Minimum 3 disks.
     * DISK SET COMPUTE: Minimum 2 disks.
     * DISK SET SWPAC: Minimum 3 disks.
     * DISK SET SWOBJ: Minimum 3 disks.

- Update the `net_interfaces.yml` file to match the server NICs used in your
  configuration. This file has a separate interface model definition for each
  of the following:

     * INTERFACE SET CONTROLLER.
     * INTERFACE SET DBMQ.
     * INTERFACE SET SWPAC.
     * INTERFACE SET SWOBJ.
     * INTERFACE SET COMPUTE.
