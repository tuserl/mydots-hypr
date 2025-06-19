#!/bin/bash

FACT_FILE="$HOME/.cache/funfacts.txt"

# Create cache dir and file if not exist
mkdir -p "$(dirname "$FACT_FILE")"
touch "$FACT_FILE"

TODAY=$(date +%Y-%m-%d)

# Check if any facts already fetched today
#FACTS_TODAY=$(grep "^$TODAY|" "$FACT_FILE" | cut -d'|' -f2-)
FACTS_TODAY=$(grep --text "^$TODAY|" "$FACT_FILE" | cut -d'|' -f2-)
#FACTS_TODAY=$(cut -d'|' -f2- "$FACT_FILE")

if [ -n "$FACTS_TODAY" ]; then
  echo "Fun facts for $TODAY:"
  echo "$FACTS_TODAY" | nl -w2 -s'. '
else
  echo "Fetching unique fun facts for $TODAY (Ctrl+C to stop)..."
fi

while true; do
  #  FACT=$(curl -s "https://www.randomfunfacts.com/" | grep "<strong>" | sed -E "s/^.*<i>([^<]*)<\/i>.*$/\1/" | xargs)
  # Fixed xargs: unmatched single quote; by default quotes are special to xargs unless you use the -0 option
  #FACT=$(curl -s "https://www.randomfunfacts.com/" |
  #  grep "<strong>" |
  #  sed -E "s/^.*<i>([^<]*)<\/i>.*$/\1/" |
  #  sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  # For: grep: (standard input): binary file matches
  FACT=$(curl -s "https://www.randomfunfacts.com/" |
    grep -oP '(?<=<i>).*?(?=</i>)' |
    head -n1 |
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//')

  # Optional debug:
  echo "      FACT=$FACT"
  if [ -n "$FACT" ]; then
    # Check if this exact fact already saved today
    #    if grep -qxF "$TODAY|$FACT" "$FACT_FILE"; then
    # Check if this exact fact already saved all time
    if grep -qF "|$FACT" "$FACT_FILE"; then
      echo "⚠️ Duplicate fact, skipping..."
    else
      echo "$TODAY|$FACT" >>"$FACT_FILE"
      echo "✅ Added: $FACT"
    fi
  else
    echo "🛑 Empty result, retrying..."
  fi
  sleep 1
done
