#!/usr/bin/env bash

sudo apt-get update
sudo apt-get upgrade
sudo apt-get install figlet
sudo apt-get install curl
sudo apt install git -y
sudo git clone https://github.com/busyloop/lolcat
cd lolcat/bin
sudo apt install lolcat 

cd 

echo ===================================

figlet -c Hi, installing Ipsec_VPN !!!

echo ===================================



sudo apt-get remove docker docker-engine docker.io containerd runc

echo docker cleared !

curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

echo ======================================================

echo enter ipsec secret:
read VPN_IPSEC_PSK

echo enter username:
read VPN_USER

echo enter password:
read VPN_PASSWORD

if [[ -d ipsec_vpn ]];
then
    echo directory is exits
    cd ipsec_vpn/
    if [[ -f /ipsec_vpn/vpn.env ]];
    then
        echo ENV file is exits
    else
        touch vpn.env
    fi
       rm vpn.env
       echo VPN_IPSEC_PSK=$VPN_IPSEC_PSK >> vpn.env
       echo VPN_USER=$VPN_USER >> vpn.env
       echo VPN_PASSWORD=$VPN_PASSWORD >> vpn.env
       echo VPN_ADDL_USERS= * >> vpn.env
       echo VPN_ADDL_PASSWORDS= * >> vpn.env
       cat  vpn.env
else
    mkdir ipsec_vpn 
    cd ipsec_vpn/
    echo VPN_IPSEC_PSK=$VPN_IPSEC_PSK >> vpn.env
    echo VPN_USER=$VPN_USER >> vpn.env
    echo VPN_PASSWORD=$VPN_PASSWORD >> vpn.env
    echo VPN_ADDL_USERS= username >> vpn.env
    echo VPN_ADDL_PASSWORDS= password >> vpn.env
    
fi

sudo docker run \
    --name ipsec-vpn-server \
    --restart=always \
    -v ikev2-vpn-data:/etc/ipsec.d \
    -v /lib/modules:/lib/modules:ro \
    -p 500:500/udp \
    -p 4500:4500/udp \
    -d --privileged \
    hwdsl2/ipsec-vpn-server



if [ $? -eq 0 ]; then
    figlet -f slant server is running ... | lolcat -a -d 10
    ip_addr=$(hostname -I)
    printf "IP: $ip_addr\n"
    echo ipsec_psk: $VPN_IPSEC_PSK
    echo username: $VPN_USER
    echo password: $VPN_PASSWORD
else
    echo server not running !!!  
    echo * we have problem *
fi
