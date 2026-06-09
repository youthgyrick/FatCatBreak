#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "错误：此脚本只能在 macOS 上运行。" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/dist/FatCatBreak.app"
MACOS_DIR="$APP/Contents/MacOS"
RESOURCES_DIR="$APP/Contents/Resources"
EXECUTABLE="$MACOS_DIR/FatCatBreak"
OSASCRIPT_CHECK="${OSASCRIPT_BIN:-/usr/bin/osascript}"

if [[ ! -x "$OSASCRIPT_CHECK" ]]; then
  echo "错误：系统缺少 /usr/bin/osascript，无法创建免编译版本。" >&2
  exit 1
fi

rm -rf "$APP"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"
cp "$ROOT/Native/main.js" "$RESOURCES_DIR/main.js"

cat > "$EXECUTABLE" <<'LAUNCHER'
#!/bin/bash
set -e
CONTENTS_DIR="$(cd "$(dirname "$0")/.." && pwd)"
exec /usr/bin/osascript -l JavaScript "$CONTENTS_DIR/Resources/main.js"
LAUNCHER
chmod +x "$EXECUTABLE"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>CFBundleExecutable</key><string>FatCatBreak</string>
  <key>CFBundleIdentifier</key><string>com.hellocodex.fatcatbreak</string>
  <key>CFBundleName</key><string>胖猫休息</string>
  <key>CFBundleDisplayName</key><string>胖猫休息</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.0.3</string>
  <key>CFBundleVersion</key><string>4</string>
  <key>LSMinimumSystemVersion</key><string>10.15</string>
  <key>LSUIElement</key><true/>
  <key>NSHighResolutionCapable</key><true/>
</dict></plist>
PLIST

plutil -lint "$APP/Contents/Info.plist" >/dev/null
printf '正在打包胖猫休息（免编译模式，不使用 clang、Swift、SDK 或 xctest）…\n'
printf '构建完成：%s\n' "$APP"
printf '运行命令：open "%s"\n' "$APP"
