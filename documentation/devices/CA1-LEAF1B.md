# CA1-LEAF1B

## Table of Contents

- [Management](#management)
  - [Management Interfaces](#management-interfaces)
  - [IP Name Servers](#ip-name-servers)
  - [Clock Settings](#clock-settings)
  - [NTP](#ntp)
  - [Management API HTTP](#management-api-http)
- [Authentication](#authentication)
  - [Local Users](#local-users)
  - [Enable Password](#enable-password)
  - [AAA Authentication](#aaa-authentication)
  - [AAA Authorization](#aaa-authorization)
- [Aliases Device Configuration](#aliases-device-configuration)
- [Monitoring](#monitoring)
  - [TerminAttr Daemon](#terminattr-daemon)
  - [Logging](#logging)
  - [SNMP](#snmp)
  - [SFlow](#sflow)
- [MLAG](#mlag)
  - [MLAG Summary](#mlag-summary)
  - [MLAG Device Configuration](#mlag-device-configuration)
- [Spanning Tree](#spanning-tree)
  - [Spanning Tree Summary](#spanning-tree-summary)
  - [Spanning Tree Device Configuration](#spanning-tree-device-configuration)
- [Internal VLAN Allocation Policy](#internal-vlan-allocation-policy)
  - [Internal VLAN Allocation Policy Summary](#internal-vlan-allocation-policy-summary)
  - [Internal VLAN Allocation Policy Device Configuration](#internal-vlan-allocation-policy-device-configuration)
- [VLANs](#vlans)
  - [VLANs Summary](#vlans-summary)
  - [VLANs Device Configuration](#vlans-device-configuration)
- [Interfaces](#interfaces)
  - [Ethernet Interfaces](#ethernet-interfaces)
  - [Port-Channel Interfaces](#port-channel-interfaces)
  - [VLAN Interfaces](#vlan-interfaces)
- [Routing](#routing)
  - [Service Routing Protocols Model](#service-routing-protocols-model)
  - [IP Routing](#ip-routing)
  - [IPv6 Routing](#ipv6-routing)
  - [Static Routes](#static-routes)
- [Multicast](#multicast)
  - [IP IGMP Snooping](#ip-igmp-snooping)
- [ACL](#acl)
  - [Standard Access-lists](#standard-access-lists)
- [VRF Instances](#vrf-instances)
  - [VRF Instances Summary](#vrf-instances-summary)
  - [VRF Instances Device Configuration](#vrf-instances-device-configuration)
- [EOS CLI Device Configuration](#eos-cli-device-configuration)

## Management

### Management Interfaces

#### Management Interfaces Summary

##### IPv4

| Management Interface | Description | Type | VRF | IP Address | Gateway |
| -------------------- | ----------- | ---- | --- | ---------- | ------- |
| Management0 | OOB_MANAGEMENT | oob | MGMT | 192.168.223.102/24 | 192.168.223.1 |

##### IPv6

| Management Interface | Description | Type | VRF | IPv6 Address | IPv6 Gateway |
| -------------------- | ----------- | ---- | --- | ------------ | ------------ |
| Management0 | OOB_MANAGEMENT | oob | MGMT | - | - |

#### Management Interfaces Device Configuration

```eos
!
interface Management0
   description OOB_MANAGEMENT
   no shutdown
   vrf MGMT
   ip address 192.168.223.102/24
```

### IP Name Servers

#### IP Name Servers Summary

| Name Server | VRF | Priority |
| ----------- | --- | -------- |
| 1.1.1.1 | MGMT | - |
| 8.8.8.8 | MGMT | - |

#### IP Name Servers Device Configuration

```eos
ip name-server vrf MGMT 1.1.1.1
ip name-server vrf MGMT 8.8.8.8
```

### Clock Settings

#### Clock Timezone Settings

Clock Timezone is set to **US/Eastern**.

#### Clock Device Configuration

```eos
!
clock timezone US/Eastern
```

### NTP

#### NTP Summary

##### NTP Servers

| Server | VRF | Preferred | Burst | iBurst | Version | Min Poll | Max Poll | Local-interface | Key |
| ------ | --- | --------- | ----- | ------ | ------- | -------- | -------- | --------------- | --- |
| time.google.com | MGMT | True | - | True | - | - | - | - | - |

#### NTP Device Configuration

```eos
!
ntp server vrf MGMT time.google.com prefer iburst
```

### Management API HTTP

#### Management API HTTP Summary

| HTTP | HTTPS | UNIX-Socket | Default Services |
| ---- | ----- | ----------- | ---------------- |
| False | True | - | - |

#### Management API VRF Access

| VRF Name | IPv4 ACL | IPv6 ACL |
| -------- | -------- | -------- |
| default | - | - |
| MGMT | - | - |

#### Management API HTTP Device Configuration

```eos
!
management api http-commands
   protocol https
   no shutdown
   !
   vrf default
      no shutdown
   !
   vrf MGMT
      no shutdown
```

## Authentication

### Local Users

#### Local Users Summary

| User | Privilege | Role | Disabled | Shell |
| ---- | --------- | ---- | -------- | ----- |
| admin | 15 | network-admin | False | - |
| ansible | 15 | network-admin | False | - |
| arista | 15 | network-admin | False | - |

#### Local Users Device Configuration

```eos
!
username admin privilege 15 role network-admin nopassword
username ansible privilege 15 role network-admin secret sha512 <removed>
username arista privilege 15 role network-admin secret sha512 <removed>
```

### Enable Password

Enable password has been disabled

### AAA Authentication

#### AAA Authentication Summary

| Type | Sub-type | User Stores |
| ---- | -------- | ---------- |

Policy local allow-nopassword-remote-login has been enabled.

#### AAA Authentication Device Configuration

```eos
aaa authentication policy local allow-nopassword-remote-login
!
```

### AAA Authorization

#### AAA Authorization Summary

| Type | User Stores |
| ---- | ----------- |
| Exec | local |

Authorization for configuration commands is disabled.

#### AAA Authorization Device Configuration

```eos
aaa authorization exec default local
!
```

## Aliases Device Configuration

```eos
alias siib show ip interface brief
alias cc clear counters
alias cp clear platform trident counters 
alias senz show interface counter error | nz 
alias snz show interface counter | nz 
alias sqnz show interface counter queue | nz 
alias srnz show interface counter rate | nz
alias shrte show ip route
alias showcon show interfaces status | grep connected    
alias sa show active 
alias clrcounters clear counters
alias wrtme write mem
alias spc show port-channel %1 detail all   
alias ports show int sta | grep "connected\| disabled" 
alias shmc show int | awk '/^[A-Z]/ { intf = $1 } /, address is/ { print intf, $6 }'
alias term_logs sh agent TerminAttr logs | tail
alias spcd show port-channel dense
alias sgr show mpls segment-routing bindings
alias sbv show bgp vpn-ipv4 summary 
alias sbe show bgp evpn summary
alias ping1 bash /mnt/flash/ping_scripts/ping1.sh
alias ping2 bash /mnt/flash/ping_scripts/ping2.sh
alias ping3 bash /mnt/flash/ping_scripts/ping3.sh
alias rates show int eth1-8 counters rates
alias ztpreset
  10 delete flash:zerotouch-config
  20 write erase
  30 reload now
!

!
```

## Monitoring

### TerminAttr Daemon

#### TerminAttr Daemon Summary

| CV Compression | CloudVision Servers | VRF | Authentication | Smash Excludes | Ingest Exclude | Bypass AAA |
| -------------- | ------------------- | --- | -------------- | -------------- | -------------- | ---------- |
| gzip | apiserver.cv-staging.corp.arista.io:443 | MGMT | token-secure,/tmp/cv-onboarding-token | ale,flexCounter,hardware,kni,pulse,strata | /Sysdb/cell/1/agent,/Sysdb/cell/2/agent | True |

#### TerminAttr Daemon Device Configuration

```eos
!
daemon TerminAttr
   exec /usr/bin/TerminAttr -cvaddr=apiserver.cv-staging.corp.arista.io:443 -cvauth=token-secure,/tmp/cv-onboarding-token -cvvrf=MGMT -disableaaa -smashexcludes=ale,flexCounter,hardware,kni,pulse,strata -ingestexclude=/Sysdb/cell/1/agent,/Sysdb/cell/2/agent -taillogs
   no shutdown
```

### Logging

#### Logging Servers and Features Summary

| Type | Level |
| -----| ----- |
| Monitor | debugging |

#### Logging Servers and Features Device Configuration

```eos
!
logging monitor debugging
```

### SNMP

#### SNMP Configuration Summary

| Contact | Location | SNMP Traps | State |
| ------- | -------- | ---------- | ----- |
| snmp@arista.local | - | All | Enabled |

#### SNMP EngineID Configuration

| Type | EngineID (Hex) | IP | Port |
| ---- | -------------- | -- | ---- |
| local | 789d8fb39d20f9bd7e22b5f7c9fda17fc14cad56 | - | - |

#### SNMP VRF Status

| VRF | Status |
| --- | ------ |
| default | Disabled |
| MGMT | Enabled |

#### SNMP Hosts Configuration

| Host | VRF | Community | Username | Authentication level | SNMP Version |
| ---- |---- | --------- | -------- | -------------------- | ------------ |
| 10.7.0.1 | MGMT | <removed> | - | - | 2c |
| 10.7.0.2 | MGMT | <removed> | - | - | 2c |

#### SNMP Communities

| Community | Access | Access List IPv4 | Access List IPv6 | View |
| --------- | ------ | ---------------- | ---------------- | ---- |
| <removed> | ro | READONLY_ACL | - | - |
| <removed> | rw | READWRITE_ACL | - | - |

#### SNMP Groups Configuration

| Group | SNMP Version | Authentication | Read | Write | Notify |
| ----- | ------------ | -------------- | ---- | ----- | ------ |
| nettools | v3 | priv | - | - | - |

#### SNMP Users Configuration

| User | Group | Version | Authentication | Privacy | Remote Address | Remote Port | Engine ID |
| ---- | ----- | ------- | -------------- | ------- | -------------- | ----------- | --------- |
| snmp_user1 | nettools | v3 | sha | aes | - | - | - |
| snmp_user2 | nettools | v3 | sha | aes | - | - | - |

#### SNMP Device Configuration

```eos
!
snmp-server engineID local 789d8fb39d20f9bd7e22b5f7c9fda17fc14cad56
snmp-server contact snmp@arista.local
snmp-server community <removed> ro READONLY_ACL
snmp-server community <removed> rw READWRITE_ACL
snmp-server group nettools v3 priv
snmp-server user snmp_user1 nettools v3 auth sha <removed> priv aes <removed>
snmp-server user snmp_user2 nettools v3 auth sha <removed> priv aes <removed>
snmp-server host 10.7.0.1 vrf MGMT version 2c <removed>
snmp-server host 10.7.0.2 vrf MGMT version 2c <removed>
snmp-server enable traps
no snmp-server vrf default
snmp-server vrf MGMT
```

### SFlow

#### SFlow Summary

| VRF | SFlow Source | SFlow Destination | Port |
| --- | ------------ | ----------------- | ---- |
| default | - | 127.0.0.1 | 6343 |
| default | Loopback0 | - | - |

sFlow Sample Rate: 1000

sFlow Polling Interval: 20

sFlow is enabled.

#### SFlow Device Configuration

```eos
!
sflow sample 1000
sflow polling-interval 20
sflow destination 127.0.0.1
sflow source-interface Loopback0
sflow run
```

## MLAG

### MLAG Summary

| Domain-id | Local-interface | Peer-address | Peer-link |
| --------- | --------------- | ------------ | --------- |
| CA1_L3_LEAFS_IDF1 | Vlan4094 | 169.254.0.4 | Port-Channel7 |

Dual primary detection is disabled.

### MLAG Device Configuration

```eos
!
mlag configuration
   domain-id CA1_L3_LEAFS_IDF1
   local-interface Vlan4094
   peer-address 169.254.0.4
   peer-link Port-Channel7
   reload-delay mlag 300
   reload-delay non-mlag 330
```

## Spanning Tree

### Spanning Tree Summary

STP mode: **mstp**

#### MSTP Instance and Priority

| Instance(s) | Priority |
| -------- | -------- |
| 0 | 16384 |

#### Global Spanning-Tree Settings

- Spanning Tree disabled for VLANs: **4094**

### Spanning Tree Device Configuration

```eos
!
spanning-tree mode mstp
no spanning-tree vlan-id 4094
spanning-tree mst 0 priority 16384
```

## Internal VLAN Allocation Policy

### Internal VLAN Allocation Policy Summary

| Policy Allocation | Range Beginning | Range Ending |
| ------------------| --------------- | ------------ |
| ascending | 1006 | 1199 |

### Internal VLAN Allocation Policy Device Configuration

```eos
!
vlan internal order ascending range 1006 1199
```

## VLANs

### VLANs Summary

| VLAN ID | Name | Trunk Groups |
| ------- | ---- | ------------ |
| 110 | CA1-IDF1-Data | - |
| 111 | CA1-IDF1-Voice | - |
| 112 | CA1-IDF1-Guest | - |
| 1000 | INBAND_MGMT | - |
| 4094 | MLAG | MLAG |

### VLANs Device Configuration

```eos
!
vlan 110
   name CA1-IDF1-Data
!
vlan 111
   name CA1-IDF1-Voice
!
vlan 112
   name CA1-IDF1-Guest
!
vlan 1000
   name INBAND_MGMT
!
vlan 4094
   name MLAG
   trunk group MLAG
```

## Interfaces

### Ethernet Interfaces

#### Ethernet Interfaces Summary

##### L2

| Interface | Description | Mode | VLANs | Native VLAN | Trunk Group | Channel-Group |
| --------- | ----------- | ---- | ----- | ----------- | ----------- | ------------- |
| Ethernet1 | L2_CA1-SPINE1_Ethernet2 | *trunk | *110-112,1000 | *- | *- | 1 |
| Ethernet2 | L2_CA1-SPINE2_Ethernet2 | *trunk | *110-112,1000 | *- | *- | 1 |
| Ethernet6 | HOST1_Po1 | *access | *110 | *- | *- | 6 |
| Ethernet7 | MLAG_CA1-LEAF1A_Ethernet7 | *trunk | *- | *- | *MLAG | 7 |
| Ethernet8 | MLAG_CA1-LEAF1A_Ethernet8 | *trunk | *- | *- | *MLAG | 7 |
| Ethernet9 | CSR_Router_Test_Interface | access | 111 | - | - | - |

*Inherited from Port-Channel Interface

#### Ethernet Interfaces Device Configuration

```eos
!
interface Ethernet1
   description L2_CA1-SPINE1_Ethernet2
   no shutdown
   channel-group 1 mode active
!
interface Ethernet2
   description L2_CA1-SPINE2_Ethernet2
   no shutdown
   channel-group 1 mode active
!
interface Ethernet6
   description HOST1_Po1
   no shutdown
   channel-group 6 mode active
!
interface Ethernet7
   description MLAG_CA1-LEAF1A_Ethernet7
   no shutdown
   channel-group 7 mode active
!
interface Ethernet8
   description MLAG_CA1-LEAF1A_Ethernet8
   no shutdown
   channel-group 7 mode active
!
interface Ethernet9
   description CSR_Router_Test_Interface
   no shutdown
   switchport access vlan 111
   switchport mode access
   switchport
   spanning-tree portfast
```

### Port-Channel Interfaces

#### Port-Channel Interfaces Summary

##### L2

| Interface | Description | Mode | VLANs | Native VLAN | Trunk Group | LACP Fallback Timeout | LACP Fallback Mode | MLAG ID | EVPN ESI |
| --------- | ----------- | ---- | ----- | ----------- | ------------| --------------------- | ------------------ | ------- | -------- |
| Port-Channel1 | L2_CA1_SPINES_Port-Channel1 | trunk | 110-112,1000 | - | - | - | - | 1 | - |
| Port-Channel6 | HOST1_Po1 | access | 110 | - | - | - | - | 6 | - |
| Port-Channel7 | MLAG_CA1-LEAF1A_Port-Channel7 | trunk | - | - | MLAG | - | - | - | - |

#### Port-Channel Interfaces Device Configuration

```eos
!
interface Port-Channel1
   description L2_CA1_SPINES_Port-Channel1
   no shutdown
   switchport trunk allowed vlan 110-112,1000
   switchport mode trunk
   switchport
   mlag 1
!
interface Port-Channel6
   description HOST1_Po1
   no shutdown
   switchport access vlan 110
   switchport mode access
   switchport
   mlag 6
   spanning-tree portfast
!
interface Port-Channel7
   description MLAG_CA1-LEAF1A_Port-Channel7
   no shutdown
   switchport mode trunk
   switchport trunk group MLAG
   switchport
```

### VLAN Interfaces

#### VLAN Interfaces Summary

| Interface | Description | VRF |  MTU | Shutdown |
| --------- | ----------- | --- | ---- | -------- |
| Vlan1000 | Inband Management | default | 1500 | False |
| Vlan4094 | MLAG | default | 1500 | False |

##### IPv4

| Interface | VRF | IP Address | IP Address Virtual | IP Router Virtual Address | ACL In | ACL Out |
| --------- | --- | ---------- | ------------------ | ------------------------- | ------ | ------- |
| Vlan1000 |  default  |  10.1.100.7/24  |  -  |  -  |  -  |  -  |
| Vlan4094 |  default  |  169.254.0.5/31  |  -  |  -  |  -  |  -  |

#### VLAN Interfaces Device Configuration

```eos
!
interface Vlan1000
   description Inband Management
   no shutdown
   mtu 1500
   ip address 10.1.100.7/24
!
interface Vlan4094
   description MLAG
   no shutdown
   mtu 1500
   no autostate
   ip address 169.254.0.5/31
```

## Routing

### Service Routing Protocols Model

Multi agent routing protocol model enabled

```eos
!
service routing protocols model multi-agent
```

### IP Routing

#### IP Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | True |
| MGMT | False |

#### IP Routing Device Configuration

```eos
!
ip routing
no ip routing vrf MGMT
```

### IPv6 Routing

#### IPv6 Routing Summary

| VRF | Routing Enabled |
| --- | --------------- |
| default | False |
| MGMT | false |

### Static Routes

#### Static Routes Summary

| VRF | Destination Prefix | Next Hop IP | Exit interface | Administrative Distance | Tag | Route Name | Metric |
| --- | ------------------ | ----------- | -------------- | ----------------------- | --- | ---------- | ------ |
| MGMT | 0.0.0.0/0 | 192.168.223.1 | - | 1 | - | - | - |
| default | 0.0.0.0/0 | 10.1.100.1 | - | 1 | - | - | - |

#### Static Routes Device Configuration

```eos
!
ip route 0.0.0.0/0 10.1.100.1
ip route vrf MGMT 0.0.0.0/0 192.168.223.1
```

## Multicast

### IP IGMP Snooping

#### IP IGMP Snooping Summary

| IGMP Snooping | Fast Leave | Interface Restart Query | Proxy | Restart Query Interval | Robustness Variable |
| ------------- | ---------- | ----------------------- | ----- | ---------------------- | ------------------- |
| Enabled | - | - | - | - | - |

#### IP IGMP Snooping Device Configuration

```eos
```

## ACL

### Standard Access-lists

#### Standard Access-lists Summary

##### READONLY_ACL

ACL has counting mode `counters per-entry` enabled!

| Sequence | Action |
| -------- | ------ |
| 10 | permit 192.168.221.0/24 |
| 20 | permit 192.168.222.0/24 |

##### READWRITE_ACL

ACL has counting mode `counters per-entry` enabled!

| Sequence | Action |
| -------- | ------ |
| 10 | permit 192.168.223.0/24 |
| 20 | permit 192.168.224.0/24 |

#### Standard Access-lists Device Configuration

```eos
!
ip access-list standard READONLY_ACL
   counters per-entry
   10 permit 192.168.221.0/24
   20 permit 192.168.222.0/24
!
ip access-list standard READWRITE_ACL
   counters per-entry
   10 permit 192.168.223.0/24
   20 permit 192.168.224.0/24
```

## VRF Instances

### VRF Instances Summary

| VRF Name | IP Routing |
| -------- | ---------- |
| MGMT | disabled |

### VRF Instances Device Configuration

```eos
!
vrf instance MGMT
```

## EOS CLI Device Configuration

```eos
!
!
spanning-tree guard loop default
snmp-server location FABRIC RackYY
!

```
