---
name: board-durum
description: GitHub Projects board'unda bir issue veya PR'ın Status alanını günceller (Backlog, Planlanıyor, Onay bekliyor, Devam ediyor, İncelemede, Tamam). Bir task'ın aşaması değiştiğinde kullan.
argument-hint: "<issue/PR URL> <statü adı>"
allowed-tools: Bash(bash:*), Bash(gh:*)
---
# Board statüsünü güncelle

Board bilgileri projenin `CLAUDE.md` dosyasındaki **Board** bölümündedir: `owner` (kullanıcı adı veya organizasyon) ve proje numarası.

## Yöntem 1 (önerilen): hazır betik
```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/board-durum/board-status.sh" <owner> <proje-no> <issue-veya-pr-url> "<Statü adı>"
```
Örnek:
```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/board-durum/board-status.sh" Umaycho 1 https://github.com/Umaycho/umaycho-pilot-game/issues/12 "Devam ediyor"
```
Betik; öğe board'da yoksa ekler, Status alanını ve seçeneğin kimliğini adından bulur ve günceller. Sadece `gh` CLI gerekir (`jq` gerekmez).

## Yöntem 2: GitHub MCP
`github` MCP sunucusunun `projects` araç seti açıksa, proje öğesini ve Status alanını MCP araçlarıyla da güncelleyebilirsin. Betik çalışmazsa bunu kullan.

## Gereksinimler
- `gh` için `project` kapsamına sahip bir token: yerelde `gh auth refresh -s project`, Actions'ta `GH_TOKEN` ortam değişkeni olarak `secrets.GITHUB_PAT`.
- Statü adları board'dakilerle birebir aynı olmalı (Türkçe karakterler dahil).

## Hata durumunda
Betik hangi adımda başarısız olduğunu yazar (proje bulunamadı, seçenek bulunamadı vb.). Statü adını `CLAUDE.md` ile karşılaştır; yine olmuyorsa durumu issue'ya yorum olarak yaz ve akışa devam et. Statü güncellemesi başarısız oldu diye asıl işi durdurma.
