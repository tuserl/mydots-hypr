#!/bin/bash

FACT_FILE="$HOME/.cache/funfacts.txt"

if [ ! -s "$FACT_FILE" ]; then
  echo "No fun facts found. Run the fetching script first!" >&2
  exit 1
fi

# Pick a random fact line and extract the fact text (after the date and '|')
FACT=$(shuf -n 1 "$FACT_FILE" | cut -d'|' -f2-)

# Output with cowsay and lolcat
echo "$FACT" | cowsay -f small | lolcat
