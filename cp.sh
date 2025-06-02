#!/bin/bash
#rsync -av --delete ~/.config/{waybar,wofi,hypr}/ ~/src/mydots-hypr/.config/

## Destination is .config folder inside current Git repo
#DEST="$(pwd)/.config"
#
## Make sure destination exists
#mkdir -p "$DEST"
#
## List of config folders to sync
#CONFIG_LIST=(
#  "$HOME/.config/waybar"
#  "$HOME/.config/wofi"
#  "$HOME/.config/hypr"
#)
#
## Sync each folder
#for SRC in "${CONFIG_LIST[@]}"; do
#  rsync -av --delete "$SRC/" "$DEST/$(basename "$SRC")/"
#done

DEST=~/src/mydots-hypr/.config
DEST1=~/src/mydots-hypr/.local/share

#rsync -av --delete ~/.config/{waybar,wofi,hypr}/ "$DEST"
for dir in waybar wofi cava kitty hypr; do
  rsync -av --delete "$HOME/.config/$dir/" "$DEST/$dir/"
done

for dir in rofi; do
  rsync -av --delete "$HOME/.local/share/$dir/" "$DEST1/$dir/"
done

rsync -av --delete ~/.zshrc .
rsync -av --delete ~/.tmux.conf .
rsync -av --delete ~/mysh/hotspot.sh ./mysh/
rsync -av --delete ~/mysh/funfacts/ ./mysh/funfacts/
rsync -av --delete "$HOME/.cache/funfacts.txt" .cache
