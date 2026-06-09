#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "错误：此脚本只能在 macOS 上运行。" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$ROOT/.build/app-release"
APP="$ROOT/dist/FatCatBreak.app"
EXECUTABLE="$APP/Contents/MacOS/FatCatBreak"
SOURCES=("$ROOT"/Sources/FatCatBreak/*.swift)

# Build the application directly with the macOS Swift compiler. Using
# `swift build` here can make SwiftPM look for xctest because this package also
# contains unit tests. xctest is unavailable when xcode-select points at the
# standalone Command Line Tools, even though those tools can compile this app.
if ! SWIFTC="$(xcrun --sdk macosx --find swiftc 2>/dev/null)"; then
  echo "错误：找不到 macOS Swift 编译器。请先安装 Xcode Command Line Tools：" >&2
  echo "  xcode-select --install" >&2
  exit 1
fi

if ! SDK_PATH="$(xcrun --sdk macosx --show-sdk-path 2>/dev/null)"; then
  echo "错误：找不到 macOS SDK。请安装 Xcode 或 Xcode Command Line Tools。" >&2
  exit 1
fi

rm -rf "$BUILD_DIR" "$APP"
mkdir -p "$BUILD_DIR" "$APP/Contents/MacOS" "$APP/Contents/Resources"

printf '正在编译胖猫休息…\n'
MACOSX_DEPLOYMENT_TARGET=13.0 "$SWIFTC" \
  -O \
  -whole-module-optimization \
  -sdk "$SDK_PATH" \
  -framework AppKit \
  "${SOURCES[@]}" \
  -o "$BUILD_DIR/FatCatBreak"

cp "$BUILD_DIR/FatCatBreak" "$EXECUTABLE"
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
  <key>CFBundleShortVersionString</key><string>1.0.1</string>
  <key>CFBundleVersion</key><string>2</string>
  <key>LSMinimumSystemVersion</key><string>13.0</string>
  <key>LSUIElement</key><true/>
  <key>NSHighResolutionCapable</key><true/>
</dict></plist>
PLIST

plutil -lint "$APP/Contents/Info.plist" >/dev/null
printf '构建完成：%s\n' "$APP"
printf '运行命令：open "%s"\n' "$APP"
