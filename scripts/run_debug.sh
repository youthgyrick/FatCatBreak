#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"

printf '正在前台运行 AppleScriptObjC；错误会直接显示在这里。\n\n'
/usr/bin/osascript -l AppleScript "$ROOT/Native/main.applescript"
STATUS=$?
printf '\n退出状态：%s\n' "$STATUS"
exit "$STATUS"
