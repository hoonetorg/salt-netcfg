# salt-netcfg
THIS description is a WIP

Configure network on EL/Fedora hosts with Saltstack (tested on EL7)

What is included?

- netcfg.file 
  - creates all files in /etc/sysconfig/network-scripts, /etc/sysconfig/network and (if defined) /etc/resolv.conf and then restarts network
  - works best for difficult setup with vlan interfaces on bridges on bonds on interfaces
- netcfg.module
  - uses Saltstack module ip.build_interface 
- netcfg.state
  - uses Saltstack states network.system and network.managed
 
Why that way?

- netcfg (file,module,state) loops over pillar data, so a bunch of interfaces can be defined in pillar


I would really like to show a pillar top.sls and netcfg.sls, but I simply just don't use it.
I use reclass with saltstack (https://github.com/madduck/reclass), this really opens a new world 
(thank you @madduck, Martin F. Krafft for this really great product and please continue working on it)

That's why I only can provide a salt 'a-server.*' pillar.items which is filtered for netcfg.file and put into the file example_pillar_items.

Applying the pillar items shown in file example_pillar_items to a server:

- would create these network-files

/etc/resolv.conf
/etc/sysconfig/network
/etc/sysconfig/network-scripts/ifcfg-bond0
/etc/sysconfig/network-scripts/ifcfg-bond0.11
/etc/sysconfig/network-scripts/ifcfg-bond0.12
/etc/sysconfig/network-scripts/ifcfg-bond0.13
/etc/sysconfig/network-scripts/ifcfg-bond0.14
/etc/sysconfig/network-scripts/ifcfg-bond0.2
/etc/sysconfig/network-scripts/ifcfg-bond0.21
/etc/sysconfig/network-scripts/ifcfg-bond0.22
/etc/sysconfig/network-scripts/ifcfg-bond0.23
/etc/sysconfig/network-scripts/ifcfg-bond0.24
/etc/sysconfig/network-scripts/ifcfg-bond0.25
/etc/sysconfig/network-scripts/ifcfg-bond0.26
/etc/sysconfig/network-scripts/ifcfg-bond0.27
/etc/sysconfig/network-scripts/ifcfg-bond0.28
/etc/sysconfig/network-scripts/ifcfg-bond0.29
/etc/sysconfig/network-scripts/ifcfg-bond0.3
/etc/sysconfig/network-scripts/ifcfg-bond0.4
/etc/sysconfig/network-scripts/ifcfg-br0
/etc/sysconfig/network-scripts/ifcfg-br0vl11
/etc/sysconfig/network-scripts/ifcfg-br0vl12
/etc/sysconfig/network-scripts/ifcfg-br0vl13
/etc/sysconfig/network-scripts/ifcfg-br0vl14
/etc/sysconfig/network-scripts/ifcfg-br0vl2
/etc/sysconfig/network-scripts/ifcfg-br0vl21
/etc/sysconfig/network-scripts/ifcfg-br0vl22
/etc/sysconfig/network-scripts/ifcfg-br0vl23
/etc/sysconfig/network-scripts/ifcfg-br0vl24
/etc/sysconfig/network-scripts/ifcfg-br0vl25
/etc/sysconfig/network-scripts/ifcfg-br0vl26
/etc/sysconfig/network-scripts/ifcfg-br0vl27
/etc/sysconfig/network-scripts/ifcfg-br0vl28
/etc/sysconfig/network-scripts/ifcfg-br0vl29
/etc/sysconfig/network-scripts/ifcfg-br0vl3
/etc/sysconfig/network-scripts/ifcfg-br0vl4
/etc/sysconfig/network-scripts/ifcfg-i0fa0
/etc/sysconfig/network-scripts/ifcfg-i0fa1


- disable NetworkManager
- enable legacy network
- reboot on initial salt run (as long as grains.get('netcfg_file__initial_run') != 'successful')
  - because network interfaces after Kickstart installation usually have names like eth0, en0ps1 ...
  - they cannot be renamed once activated (rename eth0 to i0fa0 will fail during initial run)
  -> reboot needed
- for each element in vlannumbers of bond0 and br0 vlan interfaces are created (without own IP, netmask ...)
  - useful for creating bridges where virtual machines should run on
  - all vlanparams are set on each of these vlan interfaces respectively for bond0 and br0
  - when adding vlannummbers and doing a subsequent Saltstack run these interfaces get activated immediately during the run (no need to reboot hypervisor, stop or migrate virtual machines on it)
- for vlan 11 a bond, bridge is additionally defined, because it !gets! an additional IP/netmask
- also this states will only run, if all states defined in netcfg.file.sls_requires are finished correctly
