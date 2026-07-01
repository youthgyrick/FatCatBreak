#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
trap 'rm -rf "$ROOT/dist/FatCatBreak.app"' EXIT

"$ROOT/scripts/build_app.sh"
APP="$ROOT/dist/FatCatBreak.app"
PLIST="$APP/Contents/Info.plist"
EXECUTABLE="$APP/Contents/MacOS/FatCatBreak"
ICON="$APP/Contents/Resources/AppIcon.icns"

[[ -x "$EXECUTABLE" ]]
[[ -f "$PLIST" ]]
[[ -f "$ICON" ]]

/usr/bin/python3 - "$PLIST" <<'PY'
import plistlib
import sys

with open(sys.argv[1], "rb") as source:
    plist = plistlib.load(source)

expected = {
    "CFBundleExecutable": "FatCatBreak",
    "CFBundleIconFile": "AppIcon",
    "CFBundleIdentifier": "com.hellocodex.fatcatbreak",
    "CFBundleName": "胖猫休息",
    "CFBundleDisplayName": "胖猫休息",
    "CFBundleShortVersionString": "1.1.0",
    "CFBundleVersion": "11",
    "CFBundlePackageType": "APPL",
    "NSHighResolutionCapable": True,
}

for key, value in expected.items():
    assert plist.get(key) == value, (key, plist.get(key), value)
PY

rg -n 'button Todo|System Settings|Today|All Tasks|Completed|Due date|Launch FatCatBreak at login|Take Break Now|Apply|Quit' "$ROOT/Sources/FatCatBreak" >/dev/null

if rg -n '"Work"|"Personal"|case[[:space:]]+work|case[[:space:]]+personal|[[:<:]]tag[[:>:]]' "$ROOT/Sources/FatCatBreak"; then
  echo "错误：Todo 标签相关代码不应重新出现。" >&2
  exit 1
fi

if rg -n "\(\)'s" "$ROOT/Native/main.applescript"; then
  echo "错误：AppleScriptObjC 中重新出现了旧版解析器不支持的链式调用。" >&2
  exit 1
fi

if rg -n "'s[[:space:]]+bounds\(\)" "$ROOT/Native/main.applescript"; then
  echo "错误：bounds 是旧版 AppleScript 的保留术语，不能直接作为无参 Objective-C 方法调用。" >&2
  exit 1
fi

if rg -n '^[[:space:]]*(property[[:space:]]+app[[:space:]]*:|set[[:space:]]+app[[:space:]]+to|app.s)' "$ROOT/Native/main.applescript"; then
  echo "错误：app 会被旧版 AppleScript 解析为只读的 application 术语。" >&2
  exit 1
fi

printf 'Swift/AppKit app 打包及 Todo/Settings 回归检查通过。\n'
