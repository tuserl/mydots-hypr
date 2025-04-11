##!/bin/bash
#interface="wlan1"
#
## Check if the interface is connected
#state=$(nmcli -t -f DEVICE,STATE device | grep "^$interface:" | cut -d: -f2)
#
#if [[ "$state" == "connected" ]]; then
#  essid=$(nmcli -t -f DEVICE,SSID device wifi | grep "^$interface:" | cut -d: -f2)
#  signal=$(iwconfig "$interface" 2>/dev/null | grep -i --color=never 'signal level' | awk '{for(i=1;i<=NF;i++) if ($i ~ /Signal/) print $i}' | cut -d= -f2)
#  echo "{\"text\": \" $essid (${signal:-0}%)\"}"
#else
#  echo "{\"text\": \"  Disconnected\"}"
#fi

#!/bin/bash
interface="wlan1"

state=$(nmcli -t -f DEVICE,STATE device | grep "^$interface:" | cut -d: -f2)

if [[ "$state" == "connected" ]]; then
  essid=$(nmcli -t -f DEVICE,SSID device wifi | grep "^$interface:" | cut -d: -f2)
  signal=$(iwconfig "$interface" 2>/dev/null | grep -i --color=never 'signal level' | awk '{for(i=1;i<=NF;i++) if ($i ~ /Signal/) print $i}' | cut -d= -f2)
  ipaddr=$(ip -4 addr show "$interface" | grep -oP '(?<=inet\s)\d+(\.\d+){3}')

  #echo "{\"text\": \" $interface: $essid (${signal:-0}%)\", \"tooltip\": \"Connected to $essid\nSignal: ${signal:-0}%\nIP: $ipaddr\"}"
  echo "{\"text\": \" $essid (${signal:-0}%)\", \"tooltip\": \"Connected to $essid\nSignal: ${signal:-0}%\nIP: $ipaddr\"}"
else
  echo "{\"text\": \" Disconnected\", \"tooltip\": \"$interface is not connected\"}"
fi
