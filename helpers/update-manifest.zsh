#!/usr/bin/env zsh
set -euo pipefail

MANIFEST="manifest.json"
DATA_DIR="data"

if [[ ! -f "$MANIFEST" ]]; then
  echo "manifest.json not found"
  exit 1
fi

if [[ ! -d "$DATA_DIR" ]]; then
  echo "data directory not found"
  exit 1
fi

typeset -A FILE_HASHES

for f in "$DATA_DIR"/*.txt; do
  name="${f:t}" # filename
  hash=$(shasum -a 256 "$f" | awk '{print $1}')
  FILE_HASHES[$name]="sha256:$hash"
  echo "Hashed $name"
done

# Build JSON object
json_files=$(for k v in ${(kv)FILE_HASHES}; do
  printf '"%s":"%s"\n' "$k" "$v"
done | paste -sd, -)

# Update manifest using jq
jq ".files = { $json_files }" "$MANIFEST" > "$MANIFEST.tmp"
mv "$MANIFEST.tmp" "$MANIFEST"

# Bump dataVersion
jq ".dataVersion = \"$(date +%Y.%m.%d)\"" "$MANIFEST" > "$MANIFEST.tmp" && mv "$MANIFEST.tmp" "$MANIFEST"

echo "manifest.json updated successfully"
