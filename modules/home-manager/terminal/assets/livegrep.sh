#!/usr/bin/env bash
set -euo pipefail

fdfind_cmd=""
if [ -f $(  ) ]; then
  fdfind_cmd="fdfind"
elif [ -f $(command -v fd) ]; then
  fdfind_cmd="fd"
fi

if [ -f "$fdfind_cmd" ]; then
  "$fdfind_cmd" . \
    --type f \
    --size -5k \
    --exclude '**/node_modules/**' \
    --exclude '**/coverage/**' \
    --exclude '**/dist/**' \
    --exclude '**/.git/**' \
    --exec grep -H "$1" {} \;
  exit 0
fi

find . \
  -type f \
  -size -5k \
  -and \( \
    -not -path "*/node_modules/*" \
    -and -not -path '*/coverage/*' \
    -and -not -path "*/dist/*" \
    -and -not -path "*/.git/*" \
  \) \
  -exec grep -H "$1" {} +
