#!/usr/bin/env bash
# GitHub Projects (v2) board'unda bir issue/PR'ın tek seçimli Status alanını günceller.
# Kullanım: board-status.sh <owner> <proje-no> <issue-veya-pr-url> "<Statü adı>" [alan-adı]
# Gereken: gh CLI, "project" kapsamlı token (GH_TOKEN veya gh auth).
set -euo pipefail

if [ "$#" -lt 4 ]; then
  echo "Kullanım: $0 <owner> <proje-no> <issue-veya-pr-url> \"<Statü adı>\" [alan-adı]" >&2
  exit 1
fi

OWNER="$1"
NUMBER="$2"
URL="$3"
STATUS="$4"
FIELD="${5:-Status}"

fail() { echo "board-status: $1" >&2; exit 1; }

PROJECT_ID=$(gh project view "$NUMBER" --owner "$OWNER" --format json --jq '.id') \
  || fail "Proje bulunamadı (owner=$OWNER, no=$NUMBER). Token'da 'project' kapsamı var mı?"

FIELD_ID=$(gh project field-list "$NUMBER" --owner "$OWNER" --format json --limit 100 \
  --jq ".fields[] | select(.name == \"$FIELD\") | .id")
[ -n "$FIELD_ID" ] || fail "'$FIELD' alanı bulunamadı."

OPTION_ID=$(gh project field-list "$NUMBER" --owner "$OWNER" --format json --limit 100 \
  --jq ".fields[] | select(.name == \"$FIELD\") | .options[] | select(.name == \"$STATUS\") | .id")
[ -n "$OPTION_ID" ] || fail "'$FIELD' alanında '$STATUS' seçeneği yok. Board'daki statü adlarını kontrol et."

# Öğe zaten board'daysa item-add mevcut öğeyi döndürür.
ITEM_ID=$(gh project item-add "$NUMBER" --owner "$OWNER" --url "$URL" --format json --jq '.id') \
  || fail "Öğe board'a eklenemedi: $URL"

gh project item-edit --id "$ITEM_ID" --project-id "$PROJECT_ID" \
  --field-id "$FIELD_ID" --single-select-option-id "$OPTION_ID" >/dev/null \
  || fail "Statü güncellenemedi."

echo "board-status: $URL → $STATUS"
