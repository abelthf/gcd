#!/bin/sh
### BEGIN INIT INFO
# Provides:          Script Firewall for IP-tables
# Required-Start:    $remote_fs $syslog
# Required-Stop:     $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Iptables Firewall
# Description:       This file should be used to construct scripts to be
#                    placed in /etc/init.d.
### END INIT INFO

# script de iptables para compartir internet con enp0s3

echo -n "Aplicando reglas de firewall"

## flush a reglas
iptables -F
iptables -X
iptables -Z
iptables -t nat -F

# establecemos políticas por defecto
iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT

# a localhost se deja conexiones por defecto
iptables -A INPUT -i lo -j ACCEPT

# al firewall tenemos acceso desde la red local
iptables -A INPUT -s 192.168.1.0/24 -i enp0s3 -j ACCEPT
iptables -A INPUT -s 192.168.1.0/24 -i enp0s8 -j ACCEPT

# hacemos puente desde la interfaz local
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
# direccionamos al puente enp0s3
iptables -A INPUT -s 192.168.1.0/24 -i enp0s3 -j ACCEPT

# ejecutamos

echo 1 >  /proc/sys/net/ipv4/ip_forward
echo "ok, verifique lo que se aplico con: iptables -L -n"


