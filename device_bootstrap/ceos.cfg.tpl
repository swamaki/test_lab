!
hostname {{ .ShortName }}
username admin privilege 15 role network-admin nopassword
username ansible privilege 15 role network-admin secret ansible
!
aaa authentication policy local allow-nopassword-remote-login
!
service routing protocols model multi-agent
!
aaa authorization exec default local
!
ip name-server vrf MGMT 1.1.1.1
ip name-server vrf MGMT 8.8.8.8
!
vrf instance MGMT
!
interface Management0
   description oob_management
   vrf MGMT
{{ if .MgmtIPv4Address }}   ip address {{ .MgmtIPv4Address }}/{{ .MgmtIPv4PrefixLength }}{{end}}
{{ if .MgmtIPv6Address }}   ipv6 address {{ .MgmtIPv6Address }}/{{ .MgmtIPv6PrefixLength }}{{end}}
!
{{ if .MgmtIPv4Gateway }}ip route vrf MGMT 0.0.0.0/0 {{ .MgmtIPv4Gateway }}{{end}}
{{ if .MgmtIPv6Gateway }}ipv6 route vrf MGMT ::0/0 {{ .MgmtIPv6Gateway }}{{end}}
!
ip routing
!
logging monitor debugging
!
management api http-commands
   protocol https
   no shutdown
   !
   vrf MGMT
      no shutdown
   !
   vrf default
      no shutdown
!
end