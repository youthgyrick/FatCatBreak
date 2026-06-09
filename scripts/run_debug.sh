#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG="$HOME/Library/Logs/FatCatBreak.log"

printf '正在前台运行 AppleScriptObjC；错误会直接显示在这里。\n\n'
/usr/bin/osascript -l AppleScript "$ROOT/Native/main.applescript"
STATUS=$?
printf '\n退出状态：%s\n' "$STATUS"
if [[ -f "$LOG" ]]; then
  printf '\n最近的应用日志（%s）：\n' "$LOG"
  tail -n 40 "$LOG"
else
  printf '\n尚未生成日志：%s\n' "$LOG"
fi
exit "$STATUS"
