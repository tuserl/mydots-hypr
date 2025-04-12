#!/bin/bash

echo swayidle running...

swayidle -w \
  timeout 300 'pgrep swaylock || swaylock-fancy' \
  timeout 600 'hyprctl dispatch dpms off' \
  resume 'hyprctl dispatch dpms on' \
  before-sleep 'swaylock-fancy'

#exec-once = swayidle -w timeout 300 'swaylock-fancy' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock-fancy'
