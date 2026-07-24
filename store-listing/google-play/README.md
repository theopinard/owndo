# OwnDo Google Play listing

Upload-ready default store listing for Google Play, locale **English (United
States) / en-US**.

## Upload order

1. In Play Console, open **Grow users > Store presence > Main store listing**.
2. Paste the files from `metadata/en-US/` into the matching app details fields.
3. Upload `graphics/app-icon-512.png` as the app icon.
4. Upload `graphics/feature-graphic-1024x500.png` as the feature graphic.
5. Upload the six files in `graphics/phone-screenshots/` in filename order.
6. Upload the four files in `graphics/7-inch-tablet-screenshots/` to the
   7-inch tablet section.
7. Upload the four files in `graphics/10-inch-tablet-screenshots/` to the
   10-inch tablet section.
8. Use the descriptions in `graphics/alt-text.md` for the matching assets.
9. Apply the contact details and recommendations in `metadata/store-settings.md`.

## Asset inventory

| Asset | Specification |
| --- | --- |
| App icon | 512 x 512 PNG |
| Feature graphic | 1024 x 500, 24-bit PNG, no alpha |
| Phone screenshots | 6 x 1080 x 1920, 24-bit PNG, no alpha |
| 7-inch tablet screenshots | 4 x 1920 x 1080, 24-bit PNG, no alpha |
| 10-inch tablet screenshots | 4 x 2560 x 1440, 24-bit PNG, no alpha |

The screenshots use fictional, evergreen sample content. Added captions occupy
less than 20% of each image and make no pricing, ranking, award, or download
claims.

Editable masters are in `graphics/source/`. Regenerate the PNG files with:

```bash
./graphics/source/render-assets.sh
```

The script requires ImageMagick and Inkscape.

Validate the finished package with:

```bash
./validate-assets.sh
```

## Before publishing

- Confirm the app name, description, and screenshots still match the release.
- Confirm the support email is monitored.
- Open the website and privacy-policy links from `metadata/store-settings.md`.
- Preview the listing on phone, 7-inch tablet, and 10-inch tablet surfaces.
- Complete the separate Data safety, App access, Ads, Content rating, and Target
  audience forms based on the release build. These forms are intentionally not
  guessed by this listing package.

Google Play reference:
[Add preview assets](https://support.google.com/googleplay/android-developer/answer/9866151?hl=en).
