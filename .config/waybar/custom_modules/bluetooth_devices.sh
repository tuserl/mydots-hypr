#!/bin/bash

TEXT=""

KEYBOARD_MAC="5C:MAC"
MOUSE_MAC="5C:MAC"
M600_MAC="5C:MAC"
SPEAKER_MAC="5C:MAC"
IEM_MAC="5C:MAC"
SPACE_MAC="5C:MAC"
XBOX_MAC="5C:MAC"

SPEAKER_MAC="C0:86:B3:68:78:50"

keyboard_status=$(bluetoothctl info ${KEYBOARD_MAC} | grep Connected | cut -d ' ' -f 2)
mouse_status=$(bluetoothctl info ${MOUSE_MAC} | grep Connected | cut -d ' ' -f 2)
m600_status=$(bluetoothctl info ${M600_MAC} | grep Connected | cut -d ' ' -f 2)
speaker_status=$(bluetoothctl info ${SPEAKER_MAC} | grep Connected | cut -d ' ' -f 2)
iem_status=$(bluetoothctl info ${IEM_MAC} | grep Connected | cut -d ' ' -f 2)
space_status=$(bluetoothctl info ${SPACE_MAC} | grep Connected | cut -d ' ' -f 2)
xbox_status=$(bluetoothctl info ${XBOX_MAC} | grep Connected | cut -d ' ' -f 2)

if [ "$keyboard_status" = "yes" ]; then
  TEXT=$TEXT""
fi

if [ "$mouse_status" = "yes" ]; then
  TEXT=$TEXT""
fi

if [ "$m600_status" = "yes" ]; then
  TEXT=$TEXT""
fi
if [ "$speaker_status" = "yes" ]; then
  TEXT=$TEXT""
fi

if [ "$iem_status" = "yes" ]; then
  TEXT=$TEXT""
fi

if [ "$space_status" = "yes" ]; then
  TEXT=$TEXT""
fi

if [ "$xbox_status" = "yes" ]; then
  TEXT=$TEXT""
fi

if [ -z "$TEXT" ]; then
  TEXT="󰂲" # Generic Bluetooth icon
  TOOLTIP="No devices connected"
else
  TOOLTIP="Connected Bluetooth devices:\n"
  if [ "$speaker_status" = "yes" ]; then
    TOOLTIP+="• OpenRun Pro\n"
  fi
  # Add more entries here if you reconnect other devices
  # Example:
  # if [ "$keyboard_status" = "yes" ]; then
  #   TOOLTIP+="• Logitech K380\n"
  # fi
fi

#echo "{\"text\": \"${TEXT}\", \"class\": \"bluetooth_devices\", \"tooltip\": \"\"}"
echo "{\"text\": \"${TEXT}\", \"class\": \"bluetooth_devices\", \"tooltip\": \"${TOOLTIP}\"}"
