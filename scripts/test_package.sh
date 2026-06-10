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
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o) shift; out="$1" ;;
    -l) shift; language="$1" ;;
    *.applescript) source="$1" ;;
  esac
  shift
done
[[ "$language" == "AppleScript" ]] || exit 3
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
cmp "$ROOT/Native/main.applescript" "$APP/Contents/Resources/Scripts/main.scpt"

python3 - "$APP/Contents/Info.plist" <<'PY'
import plistlib
import sys
with open(sys.argv[1], 'rb') as source:
    plist = plistlib.load(source)
expected = {
    'CFBundleIdentifier': 'com.hellocodex.fatcatbreak',
    'CFBundleName': '胖猫休息',
    'CFBundleDisplayName': '胖猫休息',
    'CFBundleShortVersionString': '1.0.8',
    'CFBundleVersion': '9',
    'LSUIElement': True,
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

if rg -n '(^|[[:space:]])(xcrun|clang|swiftc|swift)[[:space:]]' "$ROOT/scripts/build_app.sh"; then
  echo "错误：打包脚本重新引入了编译器依赖。" >&2
  exit 1
fi

printf 'AppleScriptObjC applet 打包及缺失 plist 字段回归检查通过。\n'
