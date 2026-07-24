#!/usr/bin/env bash
set -euo pipefail

source_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
graphics_dir="$(cd "$source_dir/.." && pwd)"
screenshots_dir="$graphics_dir/phone-screenshots"
tablet_7_dir="$graphics_dir/7-inch-tablet-screenshots"
tablet_10_dir="$graphics_dir/10-inch-tablet-screenshots"
tmp_dir="$(mktemp -d "$source_dir/.render.XXXXXX")"
trap 'rm -rf "$tmp_dir"' EXIT

mkdir -p "$screenshots_dir" "$tablet_7_dir" "$tablet_10_dir"

inkscape "$source_dir/app-icon.svg" \
  --export-type=png \
  --export-filename="$graphics_dir/app-icon-512.png"

inkscape "$source_dir/feature-graphic.svg" \
  --export-type=png \
  --export-filename="$graphics_dir/feature-graphic-1024x500.png"

inkscape "$source_dir/phone-screenshots.svg" \
  --export-type=png \
  --export-filename="$tmp_dir/phone-screenshots.png"

names=(
  "01-your-tasks-your-data"
  "02-plan-everything"
  "03-small-steps"
  "04-deadlines-reminders"
  "05-organize-projects"
  "06-optional-dropbox-sync"
)

for index in "${!names[@]}"; do
  convert "$tmp_dir/phone-screenshots.png" \
    -crop "1080x1920+$((index * 1080))+0" +repage \
    -alpha off -colorspace sRGB -strip \
    "$screenshots_dir/${names[$index]}.png"
done

inkscape "$source_dir/tablet-screenshots.svg" \
  --export-type=png \
  --export-filename="$tmp_dir/tablet-screenshots.png"

tablet_names=(
  "01-wide-inbox"
  "02-detailed-task"
  "03-wide-projects"
  "04-offline-or-sync"
)

for index in "${!tablet_names[@]}"; do
  seven_inch="$tablet_7_dir/${tablet_names[$index]}.png"
  ten_inch="$tablet_10_dir/${tablet_names[$index]}.png"

  convert "$tmp_dir/tablet-screenshots.png" \
    -crop "1920x1080+$((index * 1920))+0" +repage \
    -alpha off -colorspace sRGB -strip \
    "$seven_inch"

  convert "$seven_inch" \
    -resize 2560x1440 \
    -alpha off -colorspace sRGB -strip \
    "$ten_inch"
done

convert "$graphics_dir/feature-graphic-1024x500.png" \
  -alpha off -colorspace sRGB -strip \
  "$graphics_dir/feature-graphic-1024x500.png"

convert "$graphics_dir/app-icon-512.png" \
  -colorspace sRGB -strip \
  "$graphics_dir/app-icon-512.png"

printf 'Rendered OwnDo Google Play assets in %s\n' "$graphics_dir"
