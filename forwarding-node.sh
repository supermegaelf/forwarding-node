#!/bin/bash

read -p "Main public IP: " main_public_ip

apt install ufw -y

echo 'net/ipv4/ip_forward=1' >> /etc/ufw/sysctl.conf

cat >> /etc/ufw/before.rules << EOF
*nat
:PREROUTING ACCEPT [0:0]
-A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 10000
COMMIT
EOF

ufw allow 443/tcp comment "HTTPS (Reality)" && ufw allow 22/tcp comment "SSH"

ufw allow 10000/tcp comment 'HTTPS (Reality)'

ufw allow from "$main_public_ip" to any port 62050 proto tcp comment 'Marzmain'

ufw allow from "$main_public_ip" to any port 62051 proto tcp comment 'Marzmain'

ufw enable
