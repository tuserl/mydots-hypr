#!/bin/bash

# Connection name
CONN_NAME="nekowifi"
# Interface name
INTERFACE="wlan1"

# Connect to the specified Wi-Fi connection using wlan1
nmcli device disconnect "$INTERFACE"
nmcli connection up "$CONN_NAME" ifname "$INTERFACE"
