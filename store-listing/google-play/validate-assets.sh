#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
metadata="$root/metadata/en-US"
graphics="$root/graphics"

fail() {
  printf 'ERROR: %s\n' "$1" >&2
  exit 1
}

character_count() {
  local value
  value="$(<"$1")"
  printf '%s' "${#value}"
}

assert_limit() {
  local label="$1"
  local file="$2"
  local limit="$3"
  local count
  count="$(character_count "$file")"
  (( count <= limit )) || fail "$label is $count characters; limit is $limit"
  printf 'OK: %s is %s/%s characters\n' "$label" "$count" "$limit"
}

assert_image() {
  local file="$1"
  local expected_size="$2"
  local require_opaque="$3"
  local actual_size
  local byte_size
  local opaque
  actual_size="$(identify -format '%wx%h' "$file")"
  [[ "$actual_size" == "$expected_size" ]] ||
    fail "$(basename "$file") is $actual_size; expected $expected_size"
  opaque="$(identify -format '%[opaque]' "$file")"
  if [[ "$require_opaque" == "yes" && "${opaque,,}" != "true" ]]; then
    fail "$(basename "$file") contains transparency"
  fi
  byte_size="$(stat -c '%s' "$file")"
  (( byte_size <= 8 * 1024 * 1024 )) ||
    fail "$(basename "$file") exceeds the 8 MB upload limit"
  printf 'OK: %s is %s, %s bytes (opaque: %s)\n' \
    "$(basename "$file")" "$actual_size" "$byte_size" "$opaque"
}

assert_limit "App name" "$metadata/title.txt" 30
assert_limit "Short description" "$metadata/short-description.txt" 80
assert_limit "Full description" "$metadata/full-description.txt" 4000

assert_image "$graphics/app-icon-512.png" "512x512" "no"
assert_image "$graphics/feature-graphic-1024x500.png" "1024x500" "yes"

shopt -s nullglob
screenshots=("$graphics/phone-screenshots"/*.png)
(( ${#screenshots[@]} >= 4 )) ||
  fail "Expected at least four phone screenshots"
for screenshot in "${screenshots[@]}"; do
  assert_image "$screenshot" "1080x1920" "yes"
done

printf 'Validated %s phone screenshots.\n' "${#screenshots[@]}"

tablet_7=("$graphics/7-inch-tablet-screenshots"/*.png)
(( ${#tablet_7[@]} >= 4 && ${#tablet_7[@]} <= 8 )) ||
  fail "Expected four to eight 7-inch tablet screenshots"
for screenshot in "${tablet_7[@]}"; do
  assert_image "$screenshot" "1920x1080" "yes"
done
printf 'Validated %s 7-inch tablet screenshots.\n' "${#tablet_7[@]}"

tablet_10=("$graphics/10-inch-tablet-screenshots"/*.png)
(( ${#tablet_10[@]} >= 4 && ${#tablet_10[@]} <= 8 )) ||
  fail "Expected four to eight 10-inch tablet screenshots"
for screenshot in "${tablet_10[@]}"; do
  assert_image "$screenshot" "2560x1440" "yes"
done
printf 'Validated %s 10-inch tablet screenshots.\n' "${#tablet_10[@]}"
