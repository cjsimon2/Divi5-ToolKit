#!/usr/bin/env bash
# Divi5 Toolkit repo lint. Run from the repo root: bash scripts/lint.sh
# Deterministic checks that don't need the Claude CLI. CI runs this, then
# `claude plugin validate .` for the marketplace/plugin schema.
set -u
cd "$(dirname "$0")/.." || exit 1

PLUGIN=plugins/divi5-toolkit
fail=0
note() { printf '  %s\n' "$*"; }
bad()  { printf 'FAIL: %s\n' "$*"; fail=1; }

echo "1. JSON files parse"
for f in .claude-plugin/marketplace.json "$PLUGIN/.claude-plugin/plugin.json" "$PLUGIN/hooks/hooks.json" "$PLUGIN/.mcp.json"; do
  if command -v jq >/dev/null 2>&1; then
    jq -e . "$f" >/dev/null 2>&1 || bad "$f is not valid JSON"
  elif command -v python3 >/dev/null 2>&1; then
    python3 -c "import json,sys; json.load(open(sys.argv[1], encoding='utf-8'))" "$f" 2>/dev/null || bad "$f is not valid JSON"
  fi
done

echo "2. Shell scripts have valid syntax and LF endings"
for f in "$PLUGIN"/hooks/*.sh scripts/*.sh; do
  bash -n "$f" || bad "$f has a syntax error"
  if grep -q $'\r' "$f"; then bad "$f contains CRLF line endings"; fi
done

echo "3. Command frontmatter: name matches filename"
for f in "$PLUGIN"/commands/*.md; do
  base=$(basename "$f" .md)
  head -n 1 "$f" | grep -q '^---$' || bad "$f missing frontmatter"
  name=$(sed -n '2,12p' "$f" | sed -n 's/^name:[[:space:]]*//p' | head -n 1)
  [ "$name" = "$base" ] || bad "$f frontmatter name '$name' != filename '$base'"
  sed -n '2,12p' "$f" | grep -q '^description:' || bad "$f missing description"
  sed -n '2,12p' "$f" | grep -q '^allowed-tools:' || bad "$f missing allowed-tools"
done

echo "4. Agent frontmatter: name matches filename and uses the divi5- prefix"
for f in "$PLUGIN"/agents/*.md; do
  base=$(basename "$f" .md)
  case "$base" in divi5-*) ;; *) bad "$f is not prefixed with divi5-" ;; esac
  name=$(sed -n '2,12p' "$f" | sed -n 's/^name:[[:space:]]*//p' | head -n 1)
  [ "$name" = "$base" ] || bad "$f frontmatter name '$name' != filename '$base'"
  sed -n '2,12p' "$f" | grep -q '^tools:' || bad "$f missing tools"
  sed -n '2,12p' "$f" | grep -q '^model:' || bad "$f missing model"
done

echo "5. Skills have SKILL.md with name + description"
for d in "$PLUGIN"/skills/*/; do
  f="$d/SKILL.md"
  [ -f "$f" ] || { bad "$d has no SKILL.md"; continue; }
  sed -n '2,12p' "$f" | grep -q '^name:' || bad "$f missing name"
  sed -n '2,12p' "$f" | grep -q '^description:' || bad "$f missing description"
done

echo "6. Every command is documented in README and docs/usage.md"
for f in "$PLUGIN"/commands/*.md; do
  base=$(basename "$f" .md)
  grep -q "/divi5-toolkit:$base" README.md || bad "README.md does not mention /divi5-toolkit:$base"
  grep -q "/divi5-toolkit:$base" docs/usage.md || bad "docs/usage.md does not mention /divi5-toolkit:$base"
done

echo "7. Every agent is documented in README"
for f in "$PLUGIN"/agents/*.md; do
  base=$(basename "$f" .md)
  grep -q "$base" README.md || bad "README.md does not mention agent $base"
done

echo "8. Config template keys are consumed somewhere in the plugin"
keys=$(sed -n '/^---$/,/^---$/p' "$PLUGIN/templates/divi5-toolkit.local.md" | sed -n 's/^\([a-z_]*\):.*/\1/p')
for k in $keys; do
  if ! grep -rq --include='*.md' --include='*.sh' -e "$k" "$PLUGIN/commands" "$PLUGIN/agents" "$PLUGIN/hooks"; then
    bad "template key '$k' is not read by any command, agent, or hook"
  fi
done

echo "9. Version in plugin.json matches the top README changelog entry"
ver=$(sed -n 's/^[[:space:]]*"version":[[:space:]]*"\([^"]*\)".*/\1/p' "$PLUGIN/.claude-plugin/plugin.json" | head -n 1)
grep -q "^### v$ver " README.md || bad "README changelog has no '### v$ver' entry"
grep -q "Current:\*\* $ver" STATE.md || bad "STATE.md does not list $ver as current"

echo "10. \${CLAUDE_PLUGIN_ROOT} references resolve to real files"
grep -rhoE '\$\{CLAUDE_PLUGIN_ROOT\}/[A-Za-z0-9_./-]+' "$PLUGIN" | sort -u | sed 's#\${CLAUDE_PLUGIN_ROOT}/##' | while read -r rel; do
  [ -e "$PLUGIN/$rel" ] || echo "FAIL: \${CLAUDE_PLUGIN_ROOT}/$rel does not exist"
done | tee /tmp/divi5-lint-refs.$$
grep -q FAIL /tmp/divi5-lint-refs.$$ && fail=1
rm -f /tmp/divi5-lint-refs.$$

if [ "$fail" -ne 0 ]; then
  echo "Lint FAILED"
  exit 1
fi
echo "Lint passed"
