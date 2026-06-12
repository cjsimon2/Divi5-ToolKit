#!/usr/bin/env bash
# divi5-toolkit PostToolUse hook
# Exits silently unless the edited file is a stylesheet AND auto_validate is enabled
# in the project's .claude/divi5-toolkit.local.md. Replaces an earlier prompt-type
# hook that asked an LLM to "stay silent for non-CSS edits" — LLMs were unreliable
# at that and kept narrating their decision, which surfaced as a blocking message.
#
# Portability notes (v2.2.2):
# - No hard python3 dependency. Windows Git Bash usually has no `python3` shim, so
#   the old version exited 127 on every Write/Edit. Extraction now tries jq, then
#   python3/python/py, then falls back to a sed-based parse.
# - Windows paths (C:\foo\bar.css) are normalized to forward slashes so the
#   extension match and the upward .claude/ directory walk both work.
# - Never exits non-zero: a hook that can't parse its payload should stay silent,
#   not surface an error on every file edit.

payload=$(cat)

extract_file_path() {
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$payload" | jq -r '.tool_input.file_path // empty' 2>/dev/null
    return
  fi
  local py
  for py in python3 python py; do
    if command -v "$py" >/dev/null 2>&1; then
      printf '%s' "$payload" | "$py" -c '
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get("tool_input", {}).get("file_path", ""))
except Exception:
    pass
' 2>/dev/null
      return
    fi
  done
  # Last resort: pull the first "file_path" string value out of the raw JSON.
  printf '%s' "$payload" | sed -n 's/.*"file_path"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1
}

file_path=$(extract_file_path)
[ -z "$file_path" ] && exit 0

# Normalize Windows separators (JSON-escaped paths arrive as C:\\foo or C:\foo).
file_path=${file_path//\\//}

case "$(printf '%s' "$file_path" | tr '[:upper:]' '[:lower:]')" in
  *.css|*.scss|*.sass|*.less) ;;
  *) exit 0 ;;
esac

dir=$(dirname "$file_path")
config=""
while :; do
  if [ -f "$dir/.claude/divi5-toolkit.local.md" ]; then
    config="$dir/.claude/divi5-toolkit.local.md"
    break
  fi
  parent=$(dirname "$dir")
  [ "$parent" = "$dir" ] && break
  dir="$parent"
done

[ -z "$config" ] && exit 0

if ! grep -qE '^auto_validate:[[:space:]]*true' "$config" 2>/dev/null; then
  exit 0
fi

cat <<EOF
A CSS file ($file_path) was just modified and auto_validate is enabled in this project. Use the divi5-validator agent to validate the changed CSS for Divi 5 compatibility. Report only P0 (critical) issues inline; for P1/P2 mention counts and suggest /divi5-toolkit:validate. If the CSS includes animations, transitions, or interactive element styles, also check for focus indicators and prefers-reduced-motion support.
EOF
exit 0
