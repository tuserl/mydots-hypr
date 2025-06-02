#!/bin/bash

# Copy Java Projects
rsync -av --progress "/home/sushi/NetBeansProjects/" "/run/media/sushi/LINUX SHARE/NetBeansProjects/"

# Check if Google Drive is mounted; if not, mount it
if ! grep -qs "/home/sushi/gdrive" /proc/mounts; then
  rclone mount gdrive:mydrive ~/gdrive --vfs-cache-mode writes --daemon
  #    rclone mount gdrive:mydrive /home/sushi/gdrive --daemon
  sleep 5 # wait for mount
fi

# Sync the local partition to Google Drive
rsync -av --delete "/run/media/sushi/LINUX SHARE/" "/home/sushi/gdrive/"
