---
name: board-durum
description: GitHub Projects board'unda bir issue veya PR'ın Status alanını günceller (Backlog, Planlanıyor, Onay bekliyor, Devam ediyor, İncelemede, Tamam). Bir task'ın aşaması değiştiğinde kullan.
argument-hint: "<issue/PR URL> <statü adı>"
allowed-tools: Bash(bash:*), Bash(gh:*)
---
# Board statüsünü güncelle

Board bilgileri projenin `CLAUDE.md` dosyasındaki **Board** bölümündedir: `owner` (kullanıcı adı veya organizasyon) ve proje numarası. Statü adları board'dakilerle birebir aynı olmalı (Türkçe karakterler dahil).

## Yöntem 1: GitHub MCP (oturumda `github` araçları varsa önce bunu dene)
`github` sunucusunun proje (projects) araçlarıyla:
1. Owner + proje numarasıyla projeyi bul ve alanlarını listele; `Status` alanının kimliğini ve hedef statü seçeneğinin kimliğini al.
2. Issue/PR projede bir öğe olarak yoksa projeye ekle.
3. Öğenin `Status` alanını hedef seçeneğe ayarla.
Araç adları sunucu sürümüne göre değişebilir; oturumdaki `github` araçlarının listesine bakıp proje öğesi/alanı ile ilgili olanları kullan.

## Yöntem 2: hazır betik (`gh` CLI kuruluysa)
```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/board-durum/board-status.sh" <owner> <proje-no> <issue-veya-pr-url> "<Statü adı>"
```
Örnek:
```bash
bash "${CLAUDE_PLUGIN_ROOT}/skills/board-durum/board-status.sh" Umaycho 1 https://github.com/Umaycho/umaycho-pilot-game/issues/12 "Devam ediyor"
```
Betik; öğe board'da yoksa ekler, Status alanını ve seçeneğin kimliğini adından bulur ve günceller. `gh` için `project` kapsamlı giriş gerekir (`gh auth refresh -s project`; Actions'ta `GH_TOKEN`).

## Hata durumunda
Hangi adımda başarısız olduğunu not et (proje bulunamadı, seçenek bulunamadı, yetki yok). Yetki hatasında token'ın `project` (ve organizasyon board'u için `read:org`) kapsamı olmayabilir. Statü güncellemesi başarısız oldu diye asıl işi durdurma; durumu issue'ya kısa bir yorumla yaz ve akışa devam et.
