#!/usr/bin/env bash
set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG="$HOME/Library/Logs/FatCatBreak.log"

printf '正在前台运行 JXA；错误会直接显示在这里。\n\n'
/usr/bin/osascript -l JavaScript "$ROOT/Native/main.js"
STATUS=$?
printf '\n退出状态：%s\n' "$STATUS"
if [[ -f "$LOG" ]]; then
  printf '\n最近的应用日志（%s）：\n' "$LOG"
  tail -n 40 "$LOG"
else
  printf '\n尚未生成日志：%s\n' "$LOG"
fi
exit "$STATUS"
