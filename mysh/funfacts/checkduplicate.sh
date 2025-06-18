#!/bin/bash

FACT_FILE="$HOME/.cache/funfacts.txt"
[[ ! -f "$FACT_FILE" ]] && {
  echo "Fact file not found."
  exit 1
}

declare -A seen
declare -A duplicates
lineno=0
total_to_delete=0

echo "🔍 Scanning for duplicate facts..."

while IFS= read -r line; do
  lineno=$((lineno + 1))
  fact="${line#*|}"
  entry="$(printf '%-5s %s' "$lineno:" "$line")"
  if [[ -n "${seen[$fact]}" ]]; then
    duplicates["$fact"]+="$entry"$'\n'
    ((total_to_delete++))
  else
    seen["$fact"]="$entry"
  fi
done <"$FACT_FILE"

if [[ ${#duplicates[@]} -eq 0 ]]; then
  echo "✅ No duplicate facts found."
  exit 0
fi

echo
echo "⚠️ Found duplicate facts:"
echo

for fact in "${!duplicates[@]}"; do
  echo "Original line:"
  echo "${seen[$fact]}"
  echo "Duplicate line(s):"
  echo "${duplicates[$fact]}"
  echo
done

echo "🗑️  Total lines to be deleted: $total_to_delete"
echo

read -p "Do you want to remove all duplicate lines and keep only the first occurrence? [y/N]: " confirm

if [[ "$confirm" =~ ^[Yy]$ ]]; then
  TMP=$(mktemp)

  awk -F'|' '
    BEGIN { OFS="|" }
    !seen[$2]++ { print }
  ' "$FACT_FILE" >"$TMP"

  cp "$FACT_FILE" "$FACT_FILE.bak"
  mv "$TMP" "$FACT_FILE"

  echo "✅ $total_to_delete duplicate line(s) removed. Backup saved as $FACT_FILE.bak"
else
  echo "❌ No changes made."
fi
