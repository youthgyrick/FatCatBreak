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
set_or_add_plist_value CFBundleShortVersionString string 1.0.5
set_or_add_plist_value CFBundleVersion string 6
set_or_add_plist_value LSUIElement bool true
set_or_add_plist_value NSHighResolutionCapable bool true

plutil -lint "$APP/Contents/Info.plist" >/dev/null
printf '构建完成：%s\n' "$APP"
printf '运行命令：open "%s"\n' "$APP"
printf '如果没有窗口，请运行：%s/scripts/run_debug.sh\n' "$ROOT"
