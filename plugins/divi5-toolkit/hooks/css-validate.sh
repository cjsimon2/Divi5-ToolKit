#!/usr/bin/env bash
# divi5-toolkit PostToolUse hook
# Exits silently unless the edited file is a stylesheet AND auto_validate is enabled
# in the project's .claude/divi5-toolkit.local.md. Replaces an earlier prompt-type
# hook that asked an LLM to "stay silent for non-CSS edits" — LLMs were unreliable
# at that and kept narrating their decision, which surfaced as a blocking message.

set -e

payload=$(cat)

file_path=$(printf '%s' "$payload" | python3 -c '
import json, sys
try:
    data = json.load(sys.stdin)
    print(data.get("tool_input", {}).get("file_path", ""))
except Exception:
    pass
' 2>/dev/null)

[ -z "$file_path" ] && exit 0

case "$file_path" in
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
