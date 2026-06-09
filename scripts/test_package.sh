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
while [[ $# -gt 0 ]]; do
  case "$1" in
    -o) shift; out="$1" ;;
    *.js) source="$1" ;;
  esac
  shift
done
mkdir -p "$out/Contents/MacOS" "$out/Contents/Resources/Scripts"
printf '#!/bin/bash\n' > "$out/Contents/MacOS/applet"
chmod +x "$out/Contents/MacOS/applet"
printf '<plist version="1.0"><dict><key>CFBundleIdentifier</key><string>mock</string><key>CFBundleName</key><string>mock</string></dict></plist>\n' > "$out/Contents/Info.plist"
cp "$source" "$out/Contents/Resources/Scripts/main.js"
MOCK
cat > "$FAKE_BIN/PlistBuddy" <<'MOCK'
#!/usr/bin/env bash
exit 0
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
[[ -f "$APP/Contents/Resources/Scripts/main.js" ]]
[[ -f "$APP/Contents/Info.plist" ]]
cmp "$ROOT/Native/main.js" "$APP/Contents/Resources/Scripts/main.js"

if rg -n '(^|[[:space:]])(xcrun|clang|swiftc|swift)[[:space:]]' "$ROOT/scripts/build_app.sh"; then
  echo "错误：打包脚本重新引入了编译器依赖。" >&2
  exit 1
fi

printf 'JXA applet 打包检查通过。\n'
