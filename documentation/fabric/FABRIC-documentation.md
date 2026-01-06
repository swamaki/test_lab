# FABRIC

## Table of Contents

- [Fabric Switches and Management IP](#fabric-switches-and-management-ip)
  - [Fabric Switches with inband Management IP](#fabric-switches-with-inband-management-ip)
- [Fabric Topology](#fabric-topology)
- [Fabric IP Allocation](#fabric-ip-allocation)
  - [Fabric Point-To-Point Links](#fabric-point-to-point-links)
  - [Point-To-Point Links Node Allocation](#point-to-point-links-node-allocation)
  - [Loopback Interfaces (BGP EVPN Peering)](#loopback-interfaces-bgp-evpn-peering)
  - [Loopback0 Interfaces Node Allocation](#loopback0-interfaces-node-allocation)
  - [VTEP Loopback VXLAN Tunnel Source Interfaces (VTEPs Only)](#vtep-loopback-vxlan-tunnel-source-interfaces-vteps-only)
  - [VTEP Loopback Node allocation](#vtep-loopback-node-allocation)

## Fabric Switches and Management IP

| POD | Type | Node | Management IP | Platform | Provisioned in CloudVision | Serial Number |
| --- | ---- | ---- | ------------- | -------- | -------------------------- | ------------- |
| FABRIC | l3leaf | CA1-LEAF1A | 192.168.223.101/24 | vEOS-lab | Provisioned | SN-CA1-LEAF1A |
| FABRIC | l3leaf | CA1-LEAF1B | 192.168.223.102/24 | vEOS-lab | Provisioned | SN-CA1-LEAF1B |
| FABRIC | spine | CA1-SPINE1 | 192.168.223.11/24 | vEOS-lab | Provisioned | SN-CA1-SPINE1 |
| FABRIC | spine | CA1-SPINE2 | 192.168.223.12/24 | vEOS-lab | Provisioned | SN-CA1-SPINE1 |

> Provision status is based on Ansible inventory declaration and do not represent real status from CloudVision.

### Fabric Switches with inband Management IP

| POD | Type | Node | Management IP | Inband Interface |
| --- | ---- | ---- | ------------- | ---------------- |

## Fabric Topology

| Type | Node | Node Interface | Peer Type | Peer Node | Peer Interface |
| ---- | ---- | -------------- | --------- | ----------| -------------- |
| l3leaf | CA1-LEAF1A | Ethernet1 | spine | CA1-SPINE1 | Ethernet1 |
| l3leaf | CA1-LEAF1A | Ethernet2 | spine | CA1-SPINE2 | Ethernet1 |
| l3leaf | CA1-LEAF1A | Ethernet7 | mlag_peer | CA1-LEAF1B | Ethernet7 |
| l3leaf | CA1-LEAF1A | Ethernet8 | mlag_peer | CA1-LEAF1B | Ethernet8 |
| l3leaf | CA1-LEAF1B | Ethernet1 | spine | CA1-SPINE1 | Ethernet2 |
| l3leaf | CA1-LEAF1B | Ethernet2 | spine | CA1-SPINE2 | Ethernet2 |

## Fabric IP Allocation

### Fabric Point-To-Point Links

| Uplink IPv4 Pool | Available Addresses | Assigned addresses | Assigned Address % |
| ---------------- | ------------------- | ------------------ | ------------------ |
| 10.255.255.0/24 | 256 | 8 | 3.13 % |

### Point-To-Point Links Node Allocation

| Node | Node Interface | Node IP Address | Peer Node | Peer Interface | Peer IP Address |
| ---- | -------------- | --------------- | --------- | -------------- | --------------- |
| CA1-LEAF1A | Ethernet1 | 10.255.255.9/31 | CA1-SPINE1 | Ethernet1 | 10.255.255.8/31 |
| CA1-LEAF1A | Ethernet2 | 10.255.255.11/31 | CA1-SPINE2 | Ethernet1 | 10.255.255.10/31 |
| CA1-LEAF1B | Ethernet1 | 10.255.255.13/31 | CA1-SPINE1 | Ethernet2 | 10.255.255.12/31 |
| CA1-LEAF1B | Ethernet2 | 10.255.255.15/31 | CA1-SPINE2 | Ethernet2 | 10.255.255.14/31 |

### Loopback Interfaces (BGP EVPN Peering)

| Loopback Pool | Available Addresses | Assigned addresses | Assigned Address % |
| ------------- | ------------------- | ------------------ | ------------------ |
| 10.1.254.0/24 | 256 | 2 | 0.79 % |
| 10.1.255.0/24 | 256 | 2 | 0.79 % |

### Loopback0 Interfaces Node Allocation

| POD | Node | Loopback0 |
| --- | ---- | --------- |
| FABRIC | CA1-LEAF1A | 10.1.254.5/32 |
| FABRIC | CA1-LEAF1B | 10.1.254.6/32 |
| FABRIC | CA1-SPINE1 | 10.1.255.1/32 |
| FABRIC | CA1-SPINE2 | 10.1.255.2/32 |

### VTEP Loopback VXLAN Tunnel Source Interfaces (VTEPs Only)

| VTEP Loopback Pool | Available Addresses | Assigned addresses | Assigned Address % |
| ------------------ | ------------------- | ------------------ | ------------------ |
| 10.1.253.0/24 | 256 | 2 | 0.79 % |

### VTEP Loopback Node allocation

| POD | Node | Loopback1 |
| --- | ---- | --------- |
| FABRIC | CA1-LEAF1A | 10.1.253.5/32 |
| FABRIC | CA1-LEAF1B | 10.1.253.5/32 |
