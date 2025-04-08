#!/bin/bash

read -p "Main public IP: " main_public_ip
read -p "Enter port number (default is 10000, press Enter to use default): " port
port=${port:-10000}

apt install ufw -y

echo 'net/ipv4/ip_forward=1' >> /etc/ufw/sysctl.conf

cat >> /etc/ufw/before.rules << EOF
*nat
:PREROUTING ACCEPT [0:0]
-A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port $port
COMMIT
EOF

ufw allow 443/tcp comment "HTTPS (Reality)" && ufw allow 22/tcp comment "SSH"

ufw allow $port/tcp comment 'HTTPS (Reality)'

ufw allow from "$main_public_ip" to any port 62050 proto tcp comment 'Marzmain'

ufw allow from "$main_public_ip" to any port 62051 proto tcp comment 'Marzmain'

ufw enable
