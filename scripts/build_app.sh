#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "错误：此脚本只能在 macOS 上运行。" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/dist/FatCatBreak.app"
EXECUTABLE="$APP/Contents/MacOS/FatCatBreak"
PLIST="$APP/Contents/Info.plist"
SOURCE_ICON="$ROOT/Resources/AppIcon.png"
ICON_TMP="$(mktemp -d "${TMPDIR:-/tmp}/FatCatBreakIcon.XXXXXX")"
ICONSET="$ICON_TMP/AppIcon.iconset"
trap 'rm -rf "$ICON_TMP"' EXIT

if ! command -v swift >/dev/null 2>&1; then
  echo "错误：系统缺少 swift，无法构建完整的 FatCatBreak 应用。" >&2
  exit 1
fi

if [[ ! -f "$SOURCE_ICON" ]]; then
  echo "错误：缺少应用图标源文件：$SOURCE_ICON" >&2
  exit 1
fi

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"

printf '正在构建 Swift/AppKit 主应用…\n'
swift build -c release --package-path "$ROOT"

cp "$ROOT/.build/release/FatCatBreak" "$EXECUTABLE"
chmod +x "$EXECUTABLE"

if [[ -d "$ROOT/Resources/Data" ]]; then
  mkdir -p "$APP/Contents/Resources/Data"
  cp "$ROOT/Resources/Data/"*.json "$APP/Contents/Resources/Data/"
fi

if [[ -f "$ROOT/Resources/HexagramDetailHero.png" ]]; then
  cp "$ROOT/Resources/HexagramDetailHero.png" "$APP/Contents/Resources/HexagramDetailHero.png"
fi

if [[ -f "$ROOT/Resources/HexagramDetailHeaderIcon.png" ]]; then
  cp "$ROOT/Resources/HexagramDetailHeaderIcon.png" "$APP/Contents/Resources/HexagramDetailHeaderIcon.png"
fi

if [[ -d "$ROOT/outputs/64gua_yaoci_images" ]]; then
  mkdir -p "$APP/Contents/Resources/64gua_yaoci_images"
  cp "$ROOT/outputs/64gua_yaoci_images/"*.png "$APP/Contents/Resources/64gua_yaoci_images/" 2>/dev/null || true
fi

if [[ -d "$ROOT/outputs/64gua_detail_images" ]]; then
  mkdir -p "$APP/Contents/Resources/64gua_detail_images"
  cp "$ROOT/outputs/64gua_detail_images/"*.png "$APP/Contents/Resources/64gua_detail_images/" 2>/dev/null || true
fi

printf '正在生成 app 图标…\n'
mkdir -p "$ICONSET"
sips -z 16 16 "$SOURCE_ICON" --out "$ICONSET/icon_16x16.png" >/dev/null
sips -z 32 32 "$SOURCE_ICON" --out "$ICONSET/icon_16x16@2x.png" >/dev/null
sips -z 32 32 "$SOURCE_ICON" --out "$ICONSET/icon_32x32.png" >/dev/null
sips -z 64 64 "$SOURCE_ICON" --out "$ICONSET/icon_32x32@2x.png" >/dev/null
sips -z 128 128 "$SOURCE_ICON" --out "$ICONSET/icon_128x128.png" >/dev/null
sips -z 256 256 "$SOURCE_ICON" --out "$ICONSET/icon_128x128@2x.png" >/dev/null
sips -z 256 256 "$SOURCE_ICON" --out "$ICONSET/icon_256x256.png" >/dev/null
sips -z 512 512 "$SOURCE_ICON" --out "$ICONSET/icon_256x256@2x.png" >/dev/null
sips -z 512 512 "$SOURCE_ICON" --out "$ICONSET/icon_512x512.png" >/dev/null
sips -z 1024 1024 "$SOURCE_ICON" --out "$ICONSET/icon_512x512@2x.png" >/dev/null
iconutil -c icns "$ICONSET" -o "$APP/Contents/Resources/AppIcon.icns"

/usr/bin/python3 - "$PLIST" <<'PY'
import plistlib
import sys

plist = {
    "CFBundleDevelopmentRegion": "zh_CN",
    "CFBundleExecutable": "FatCatBreak",
    "CFBundleIconFile": "AppIcon",
    "CFBundleIdentifier": "com.hellocodex.fatcatbreak",
    "CFBundleInfoDictionaryVersion": "6.0",
    "CFBundleName": "胖猫休息",
    "CFBundleDisplayName": "胖猫休息",
    "CFBundlePackageType": "APPL",
    "CFBundleShortVersionString": "1.1.0",
    "CFBundleVersion": "11",
    "LSMinimumSystemVersion": "13.0",
    "NSHighResolutionCapable": True,
}

with open(sys.argv[1], "wb") as output:
    plistlib.dump(plist, output)
PY

plutil -lint "$PLIST" >/dev/null
printf '构建完成：%s\n' "$APP"
printf '运行命令：open "%s"\n' "$APP"
