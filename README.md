# salt-netcfg
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

