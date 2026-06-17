#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "错误：此脚本只能在 macOS 上运行。" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
APP="$ROOT/dist/FatCatBreak.app"
ICON="$ROOT/Native/FatCatBreak.icns"
OSACOMPILE="${OSACOMPILE_BIN:-/usr/bin/osacompile}"
PLIST_BUDDY="${PLIST_BUDDY_BIN:-/usr/libexec/PlistBuddy}"

if [[ ! -x "$OSACOMPILE" ]]; then
  echo "错误：系统缺少 /usr/bin/osacompile，无法创建 AppleScriptObjC applet。" >&2
  exit 1
fi

if [[ ! -f "$ICON" ]]; then
  echo "错误：缺少应用图标：$ICON" >&2
  exit 1
fi

rm -rf "$APP"
mkdir -p "$ROOT/dist"
printf '正在检查 AppleScriptObjC 语法并创建 applet（无需 Xcode 或 SDK）…\n'
if ! "$OSACOMPILE" -s -l AppleScript -o "$APP" "$ROOT/Native/main.applescript"; then
  echo "错误：AppleScriptObjC 语法检查失败，未生成应用。" >&2
  exit 1
fi

PLIST="$APP/Contents/Info.plist"
if [[ ! -f "$PLIST" ]]; then
  echo "错误：osacompile 未生成 Info.plist：$PLIST" >&2
  exit 1
fi

set_or_add_plist_value() {
  local key="$1"
  local type="$2"
  local value="$3"

  # Different macOS releases generate different applet plist keys. Update an
  # existing key first; if it is absent, create it with the requested type.
  if ! "$PLIST_BUDDY" -c "Set :$key $value" "$PLIST" 2>/dev/null; then
    "$PLIST_BUDDY" -c "Add :$key $type $value" "$PLIST"
  fi
}

set_or_add_plist_value CFBundleIdentifier string com.hellocodex.fatcatbreak
set_or_add_plist_value CFBundleName string 胖猫休息
set_or_add_plist_value CFBundleDisplayName string 胖猫休息
set_or_add_plist_value CFBundleShortVersionString string 1.6.0
set_or_add_plist_value CFBundleVersion string 21
set_or_add_plist_value CFBundleIconFile string FatCatBreak
set_or_add_plist_value CFBundleIconName string FatCatBreak
set_or_add_plist_value LSUIElement bool false
set_or_add_plist_value NSHighResolutionCapable bool true

mkdir -p "$APP/Contents/Resources"
cp "$ICON" "$APP/Contents/Resources/FatCatBreak.icns"

plutil -lint "$APP/Contents/Info.plist" >/dev/null
printf '构建完成：%s\n' "$APP"
printf '运行命令：open "%s"\n' "$APP"
printf '如果没有窗口，请运行：%s/scripts/run_debug.sh\n' "$ROOT"
