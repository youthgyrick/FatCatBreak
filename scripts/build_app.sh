#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "错误：此脚本只能在 macOS 上运行。" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/dist/FatCatBreak.app"
OSACOMPILE="${OSACOMPILE_BIN:-/usr/bin/osacompile}"
PLIST_BUDDY="${PLIST_BUDDY_BIN:-/usr/libexec/PlistBuddy}"

if [[ ! -x "$OSACOMPILE" ]]; then
  echo "错误：系统缺少 /usr/bin/osacompile，无法创建 JXA applet。" >&2
  exit 1
fi

rm -rf "$APP"
mkdir -p "$ROOT/dist"
printf '正在创建胖猫休息 applet（无需 Xcode 或 SDK）…\n'
"$OSACOMPILE" -l JavaScript -o "$APP" "$ROOT/Native/main.js"

"$PLIST_BUDDY" -c 'Set :CFBundleIdentifier com.hellocodex.fatcatbreak' "$APP/Contents/Info.plist"
"$PLIST_BUDDY" -c 'Set :CFBundleName 胖猫休息' "$APP/Contents/Info.plist"
"$PLIST_BUDDY" -c 'Add :CFBundleDisplayName string 胖猫休息' "$APP/Contents/Info.plist" 2>/dev/null || \
  "$PLIST_BUDDY" -c 'Set :CFBundleDisplayName 胖猫休息' "$APP/Contents/Info.plist"
"$PLIST_BUDDY" -c 'Add :CFBundleShortVersionString string 1.0.4' "$APP/Contents/Info.plist" 2>/dev/null || \
  "$PLIST_BUDDY" -c 'Set :CFBundleShortVersionString 1.0.4' "$APP/Contents/Info.plist"
"$PLIST_BUDDY" -c 'Add :CFBundleVersion string 5' "$APP/Contents/Info.plist" 2>/dev/null || \
  "$PLIST_BUDDY" -c 'Set :CFBundleVersion 5' "$APP/Contents/Info.plist"
"$PLIST_BUDDY" -c 'Add :LSUIElement bool true' "$APP/Contents/Info.plist" 2>/dev/null || \
  "$PLIST_BUDDY" -c 'Set :LSUIElement true' "$APP/Contents/Info.plist"
"$PLIST_BUDDY" -c 'Add :NSHighResolutionCapable bool true' "$APP/Contents/Info.plist" 2>/dev/null || \
  "$PLIST_BUDDY" -c 'Set :NSHighResolutionCapable true' "$APP/Contents/Info.plist"

plutil -lint "$APP/Contents/Info.plist" >/dev/null
printf '构建完成：%s\n' "$APP"
printf '运行命令：open "%s"\n' "$APP"
printf '如果没有窗口，请运行：%s/scripts/run_debug.sh\n' "$ROOT"
