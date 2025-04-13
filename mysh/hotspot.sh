#!/bin/bash

# Connection name
CONN_NAME="nekowifi"
INTERFACE="wlan1"

if zenity --question --title="Wi-Fi Switch" --text="Connect to '$CONN_NAME' on interface '$INTERFACE'?"; then
  nmcli device disconnect "$INTERFACE"
  nmcli connection up "$CONN_NAME" ifname "$INTERFACE"
else
  echo "Cancelled"
fi
