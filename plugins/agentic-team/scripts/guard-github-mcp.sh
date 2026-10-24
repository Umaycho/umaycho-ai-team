#!/usr/bin/env bash
# PreToolUse hook (GitHub MCP araçları): agent'ların PR birleştirmesini,
# PR onaylamasını ve korumalı dalları güncellemesini engeller.
# Girdi: Claude Code'un hook JSON'u (stdin). Çıkış kodu 2 = aracı engelle.
# jq gerektirmez.

input="$(cat)"
flat="$(printf '%s' "$input" | tr '\n' ' ' | tr -d '[:space:]')"

block() {
  echo "agentic-team guard: $1" >&2
  exit 2
}

# Araç adı: "tool_name":"mcp__..."
tool="$(printf '%s' "$flat" | sed -n 's/.*"tool_name":"\([^"]*\)".*/\1/p')"

case "$tool" in
  *merge_pull_request*|*merge_pr*)
    block "PR birleştirme insanın işidir. PR'ı açık bırak." ;;
esac

if printf '%s' "$flat" | grep -Eiq '"event":"APPROVE"'; then
  block "PR onaylamak insanın işidir. Yorum (COMMENT) türünde inceleme bırak."
fi

# Korumalı dallara doğrudan dosya yazma / dal güncelleme
if printf '%s' "$tool" | grep -Eiq 'create_or_update_file|push_files|delete_file|update_ref'; then
  if printf '%s' "$flat" | grep -Eq '"(branch|ref)":"(refs/heads/)?(main|master)"'; then
    block "Ana dala (main/master) doğrudan yazma yasak. Bir dalda çalış ve PR aç."
  fi
fi

exit 0
