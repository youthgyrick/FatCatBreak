#!/usr/bin/env bash
set -euo pipefail

# Backward-compatible alias. The documented script uses an underscore.
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
exec "$SCRIPT_DIR/build_app.sh" "$@"
