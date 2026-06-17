#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAKE_BIN="$(mktemp -d)"
trap 'rm -rf "$FAKE_BIN" "$ROOT/dist/FatCatBreak.app"' EXIT

cat > "$FAKE_BIN/uname" <<'MOCK'
#!/usr/bin/env bash
echo Darwin
MOCK
cat > "$FAKE_BIN/osacompile" <<'MOCK'
#!/usr/bin/env bash
out=""
source=""
language=""
stay_open=false
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o) shift; out="$1" ;;
    -l) shift; language="$1" ;;
    -s) stay_open=true ;;
    *.applescript) source="$1" ;;
  esac
  shift
done
[[ "$language" == "AppleScript" ]] || exit 3
[[ "$stay_open" == "true" ]] || exit 4
mkdir -p "$out/Contents/MacOS" "$out/Contents/Resources/Scripts"
printf '#!/bin/bash\n' > "$out/Contents/MacOS/applet"
chmod +x "$out/Contents/MacOS/applet"
# Deliberately omit CFBundleIdentifier and most metadata keys while retaining
# one existing key, exercising both the Add and Set branches.
python3 - "$out/Contents/Info.plist" <<'PY'
import plistlib
import sys
with open(sys.argv[1], 'wb') as output:
    plistlib.dump({'CFBundleName': 'mock'}, output)
PY
cp "$source" "$out/Contents/Resources/Scripts/main.scpt"
MOCK
cat > "$FAKE_BIN/PlistBuddy" <<'MOCK'
#!/usr/bin/env python3
import plistlib
import shlex
import sys

command = sys.argv[sys.argv.index('-c') + 1]
path = sys.argv[-1]
parts = shlex.split(command)
action = parts[0]
key = parts[1].lstrip(':')
with open(path, 'rb') as source:
    data = plistlib.load(source)

if action == 'Set':
    if key not in data:
        print(f'Set: Entry, ":{key}", Does Not Exist', file=sys.stderr)
        raise SystemExit(1)
    value = ' '.join(parts[2:])
elif action == 'Add':
    if key in data:
        raise SystemExit(1)
    kind = parts[2]
    value = ' '.join(parts[3:])
    if kind == 'bool':
        value = value.lower() == 'true'
else:
    raise SystemExit(2)

data[key] = value
with open(path, 'wb') as output:
    plistlib.dump(data, output)
MOCK
cat > "$FAKE_BIN/plutil" <<'MOCK'
#!/usr/bin/env bash
exit 0
MOCK
chmod +x "$FAKE_BIN"/*

PATH="$FAKE_BIN:$PATH" \
OSACOMPILE_BIN="$FAKE_BIN/osacompile" \
PLIST_BUDDY_BIN="$FAKE_BIN/PlistBuddy" \
  "$ROOT/scripts/build_app.sh"
APP="$ROOT/dist/FatCatBreak.app"

[[ -x "$APP/Contents/MacOS/applet" ]]
[[ -f "$APP/Contents/Resources/Scripts/main.scpt" ]]
[[ -f "$APP/Contents/Info.plist" ]]
[[ -f "$APP/Contents/Resources/FatCatBreak.icns" ]]
cmp "$ROOT/Native/main.applescript" "$APP/Contents/Resources/Scripts/main.scpt"
cmp "$ROOT/Native/FatCatBreak.icns" "$APP/Contents/Resources/FatCatBreak.icns"

python3 - "$APP/Contents/Info.plist" <<'PY'
import plistlib
import sys
with open(sys.argv[1], 'rb') as source:
    plist = plistlib.load(source)
expected = {
    'CFBundleIdentifier': 'com.hellocodex.fatcatbreak',
    'CFBundleName': '胖猫休息',
    'CFBundleDisplayName': '胖猫休息',
    'CFBundleShortVersionString': '1.6.0',
    'CFBundleVersion': '21',
    'CFBundleIconFile': 'FatCatBreak',
    'CFBundleIconName': 'FatCatBreak',
    'LSUIElement': False,
    'NSHighResolutionCapable': True,
}
for key, value in expected.items():
    assert plist.get(key) == value, (key, plist.get(key), value)
PY


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

if rg -n '(path to library folder from user domain|do shell script|display alert)' "$ROOT/Native/main.applescript"; then
  echo "错误：脚本重新引入了 Tahoe osacompile 无法解析的 Standard Additions 语句。" >&2
  exit 1
fi

rg -Fq 'html,body{width:100%;height:100%;margin:0;overflow:hidden;background:transparent}' "$ROOT/Native/main.applescript"
rg -Fq "theWindow's setBackgroundColor:clearColor" "$ROOT/Native/main.applescript"
rg -Fq "webView's setUnderPageBackgroundColor:clearColor" "$ROOT/Native/main.applescript"
rg -Fq "webView's setValue:(false) forKey:(\"drawsBackground\")" "$ROOT/Native/main.applescript"
rg -Fq 'doubleForKey:"TriggerIntervalHours"' "$ROOT/Native/main.applescript"
rg -Fq 'property breakDuration : 30' "$ROOT/Native/main.applescript"
rg -Fq 'property durationField : missing value' "$ROOT/Native/main.applescript"
rg -Fq 'doubleForKey:"BreakDurationSeconds"' "$ROOT/Native/main.applescript"
rg -Fq 'objectForKey:"BreakDurationSeconds"' "$ROOT/Native/main.applescript"
rg -Fq 'seconds (1–600)' "$ROOT/Native/main.applescript"
rg -Fq 'if s1 < 1 then set s1 to 1' "$ROOT/Native/main.applescript"
rg -Fq 'if s1 > 600 then set s1 to 600' "$ROOT/Native/main.applescript"
rg -Fq "animation:walk-across var(--break-duration)" "$ROOT/Native/main.applescript"
rg -Fq "body style='--break-duration:" "$ROOT/Native/main.applescript"
rg -Fq '/Library/LaunchAgents/com.hellocodex.fatcatbreak.plist' "$ROOT/Native/main.applescript"
rg -Fq 'on build_settings_window()' "$ROOT/Native/main.applescript"
rg -Fq 'on reopen' "$ROOT/Native/main.applescript"
rg -Fq 'on idle' "$ROOT/Native/main.applescript"
rg -Fq 'CGEventSourceButtonState(0, 0)' "$ROOT/Native/main.applescript"
rg -Fq 'on mouse_is_over(b1)' "$ROOT/Native/main.applescript"
rg -Fq 'NSMouseInRect(p1, r2, false)' "$ROOT/Native/main.applescript"
rg -Fq 'property loginHitView : missing value' "$ROOT/Native/main.applescript"
rg -Fq 'my mouse_is_over(loginHitView)' "$ROOT/Native/main.applescript"
rg -Fq 'set loginEnabled to not (my login_item_enabled())' "$ROOT/Native/main.applescript"
rg -Fq 'CGEventSourceKeyState(0, 53)' "$ROOT/Native/main.applescript"
rg -Fq 'property breakEndDate : missing value' "$ROOT/Native/main.applescript"
rg -Fq "settingsWindow's orderOut:(missing value)" "$ROOT/Native/main.applescript"
rg -Fq 'on reopen' "$ROOT/Native/main.applescript"
rg -Fq 'my show_settings()' "$ROOT/Native/main.applescript"
rg -Fq 'scene-walk' "$ROOT/Native/main.applescript"
rg -Fq 'scene-nap' "$ROOT/Native/main.applescript"
rg -Fq 'scene-sign' "$ROOT/Native/main.applescript"
rg -Fq 'scene-drink' "$ROOT/Native/main.applescript"
rg -Fq 'scene-neck' "$ROOT/Native/main.applescript"
rg -Fq '喝口水，放松一下' "$ROOT/Native/main.applescript"
rg -Fq '转转脖子，松一松' "$ROOT/Native/main.applescript"
rg -Fq 'class='"'"'cup'"'"'' "$ROOT/Native/main.applescript"
rg -Fq 'class='"'"'neckCue'"'"'' "$ROOT/Native/main.applescript"
rg -Fq '@keyframes sip' "$ROOT/Native/main.applescript"
rg -Fq '@keyframes neck-turn' "$ROOT/Native/main.applescript"
rg -Fq 'Math.floor(Math.random()*scenes.length)' "$ROOT/Native/main.applescript"

if awk '
  /^on run$/ { in_run = 1 }
  /^end run$/ { in_run = 0 }
  in_run && /my show_settings\(\)/ { found = 1 }
  END { exit found ? 0 : 1 }
' "$ROOT/Native/main.applescript"; then
  echo "错误：启动时不能自动显示设置窗口；应通过 Dock reopen 打开。" >&2
  exit 1
fi

if rg -n "runUntilDate" "$ROOT/Native/main.applescript"; then
  echo "错误：休息流程重新引入了阻塞主线程的 runUntilDate，WebKit 动画将无法绘制。" >&2
  exit 1
fi

if rg -n '(^|[[:space:]])(xcrun|clang|swiftc|swift)[[:space:]]' "$ROOT/scripts/build_app.sh"; then
  echo "错误：打包脚本重新引入了编译器依赖。" >&2
  exit 1
fi

printf 'AppleScriptObjC applet 打包及缺失 plist 字段回归检查通过。\n'
