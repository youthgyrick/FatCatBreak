#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FAKE_BIN="$(mktemp -d)"
trap 'rm -rf "$FAKE_BIN" "$ROOT/dist/FatCatBreak.app"' EXIT

cat > "$FAKE_BIN/uname" <<'MOCK'
#!/usr/bin/env bash
echo Darwin
MOCK
cat > "$FAKE_BIN/plutil" <<'MOCK'
#!/usr/bin/env bash
exit 0
MOCK
chmod +x "$FAKE_BIN/uname" "$FAKE_BIN/plutil"

PATH="$FAKE_BIN:$PATH" OSASCRIPT_BIN=/bin/true "$ROOT/scripts/build_app.sh"
APP="$ROOT/dist/FatCatBreak.app"

[[ -x "$APP/Contents/MacOS/FatCatBreak" ]]
[[ -f "$APP/Contents/Resources/main.js" ]]
[[ -f "$APP/Contents/Info.plist" ]]
cmp "$ROOT/Native/main.js" "$APP/Contents/Resources/main.js"

if rg -n '(^|[[:space:]])(xcrun|clang|swiftc|swift)[[:space:]]' "$ROOT/scripts/build_app.sh"; then
  echo "错误：免编译打包脚本重新引入了编译器依赖。" >&2
  exit 1
fi

printf '免编译 .app 打包检查通过。\n'
