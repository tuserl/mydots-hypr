#!/bin/bash

img=$(swww query | grep -oP 'image: \K.*')

if [[ -f "$img" ]]; then
  wal -i "$img"
else
  echo "Could not find wallpaper image."
fi
