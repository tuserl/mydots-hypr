#!/bin/bash

STATE_FILE="/tmp/hypr-prev-ws"

current_ws=$(hyprctl activeworkspace -j | jq .id)

if [[ -f "$STATE_FILE" ]]; then
  prev_ws=$(cat "$STATE_FILE")
else
  prev_ws=$current_ws
fi

# Save current as new "previous"
echo "$current_ws" >"$STATE_FILE"

# Switch to previous
hyprctl dispatch workspace "$prev_ws"
