#!/usr/bin/env bash
# PreToolUse hook: agent'ların ana dala push etmesini, force push yapmasını
# ve PR'ları kendi başına birleştirmesini/onaylamasını engeller.
# Girdi: Claude Code'un hook JSON'u (stdin). Çıkış kodu 2 = komutu engelle.
# jq gerektirmez; Windows'ta Git Bash ile de çalışır.

input="$(cat)"

# Sadece komut metniyle ilgileniyoruz; JSON kaçışlarını kabaca çöz.
cmd="$(printf '%s' "$input" | tr '\n' ' ' | sed -e 's/\\"/"/g')"

block() {
  echo "agentic-team guard: $1" >&2
  exit 2
}

if printf '%s' "$cmd" | grep -Eq 'git[^"]*push'; then
  if printf '%s' "$cmd" | grep -Eq 'git[^"]*push[^"]*(--force|--force-with-lease|[[:space:]]-f([[:space:]]|$|"))'; then
    block "Force push yasak. Geçmişi yeniden yazma; yeni bir commit at."
  fi
  if printf '%s' "$cmd" | grep -Eq 'git[^"]*push[^"]*[[:space:]:+](main|master)([[:space:]"]|$)'; then
    block "Ana dala (main/master) doğrudan push yasak. Bir dalda çalış ve PR aç."
  fi
fi

if printf '%s' "$cmd" | grep -Eq 'gh[[:space:]]+pr[[:space:]]+merge'; then
  block "PR birleştirme insanın işidir. PR'ı açık bırak."
fi

if printf '%s' "$cmd" | grep -Eq 'gh[[:space:]]+pr[[:space:]]+review[^"]*--approve'; then
  block "PR onaylamak insanın işidir. --comment kullan."
fi

exit 0
