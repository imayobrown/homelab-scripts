#!/usr/bin/bash

# Targets 64-bit centos 7 you can replace the rpm with other fedora based distros and this should work

# This file should be run as sudo as it needs access to root directories and to modify firewall

PLEX_MEDIA_SERVER_RPM="plexmediaserver-1.13.0.5023-31d3c0c65.x86_64.rpm"
PLEX_MEDIA_SERVER_FIREWALL_SERVICE="./plexmediaserver.xml"
PLEX_MEDIA_SERVER_SYSTEMD_SERVICE="plexmediaserver.service"

DOWNLOADS_DIR=~/Downloads

echo "Installing wget..."
yum install -y wget

echo "Creating $DOWNLOADS_DIR directory..."
mkdir $DOWNLOADS_DIR

echo "Downloading plexmediaserver..."
wget -P $DOWNLOADS_DIR https://downloads.plex.tv/plex-media-server/2.13.0.5023-31d3c0c65/$PLEX_MEDIA_SERVER_RPM

echo "Installing plex from the rpm $PLEX_MEDIA_SERVER_RPM..."
rpm -i $DOWNLOADS_DIR/$PLEX_MEDIA_SERVER_RPM

systemctl stop $PLEX_MEDIA_SERVER_SYSTEMD_SERVICE

echo "Installing plex media server service for into firewalld..."
cp $PLEX_MEDIA_SERVER_FIREWALL_SERVICE /etc/firewalld/services/$PLEX_MEDIA_SERVER_FIREWALL_SERVICE
firewall-cmd --reload # Reload to pick up service definition
firewall-cmd --permanent --zone=public --add-service=plexmediaserver
firewall-cmd --reload # Reload to pick up service added to zone

echo "Enabling and starting plex media server..."
systemctl enable $PLEX_MEDIA_SERVER_SYSTEMD_SERVICE
systemctl start $PLEX_MEDIA_SERVER_SYSTEMD_SERVICE

# Run the following command from the system you are remoting into the server from
# ssh root@<serverip> -L 8888:localhost:32400

# And then go to http://<serverip>:8888/manage to login and manage the server
