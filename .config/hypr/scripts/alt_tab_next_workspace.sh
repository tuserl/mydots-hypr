#!/bin/bash

# === Config: Set your range here ===
MIN_WS=1
MAX_WS=22

# Get the current workspace ID
current_ws=$(hyprctl activeworkspace -j | jq .id)

# Loop until we find a non-empty workspace or wrap completely
for ((i = 1; i <= (MAX_WS - MIN_WS + 1); i++)); do
  next_ws=$((current_ws + 1))
  if ((next_ws > MAX_WS)); then
    next_ws=$MIN_WS
  fi

  # Check if workspace has any windows
  client_count=$(hyprctl clients -j | jq "[.[] | select(.workspace.id == $next_ws)] | length")

  if ((client_count > 0)); then
    # Found non-empty workspace, switch to it
    hyprctl dispatch workspace "$next_ws"
    exit 0
  fi

  # Move on to next workspace in loop
  current_ws=$next_ws
done

# Optional: No non-empty workspace found — do nothing or fallback
exit 0
