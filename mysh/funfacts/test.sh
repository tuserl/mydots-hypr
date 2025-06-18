if grep -qF "|sFingernails grow nearly 4 times faster than toenails!" ~/.cache/funfacts.txt; then
  echo "Duplicate found!"
else
  echo "Not found."
fi
