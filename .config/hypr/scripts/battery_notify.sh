#!/bin/bash

LOW_BATTERY_THRESHOLD=15
CHECK_INTERVAL=60 # seconds
ALREADY_WARNED=0

while true; do
  # Get battery percentage
  battery_level=$(upower -i $(upower -e | grep BAT) | grep percentage | awk '{print $2}' | tr -d '%')

  # Check if battery is discharging and low
  state=$(upower -i $(upower -e | grep BAT) | grep state | awk '{print $2}')

  # Print battery level and state to terminal
  echo "$(date): Battery level: ${battery_level}%, State: ${state}"

  if [[ "$state" == "discharging" && "$battery_level" -le "$LOW_BATTERY_THRESHOLD" ]]; then
    if [[ "$ALREADY_WARNED" -eq 0 ]]; then
      echo "$(date): Battery is low. Playing warning."
      flite -voice slt -t "Battery is low. Please charge now."
      notify-send "Battery Low ⚠️" "Battery is at ${battery_level}%. Please plug in your charger." -u critical
      ALREADY_WARNED=1
    fi
  else
    ALREADY_WARNED=0
  fi

  sleep "$CHECK_INTERVAL"
done
