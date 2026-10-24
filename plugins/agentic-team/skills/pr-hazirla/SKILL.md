---
name: pr-hazirla
description: Tamamlanan iş için standart formatta pull request açar ve issue'ya bağlar. Testler geçip kod incelemesi tamamlandığında kullan.
argument-hint: "<issue numarası>"
allowed-tools: Bash(git:*), Bash(gh:*)
---
# PR hazırla

## Ön kontrol
- Çalışma dalında olduğunu doğrula (`git branch --show-current`); `main`/`master` veya PR hedef dalının kendisi ise DUR.
- Testler/doğrulama son çalıştırmada geçti mi? Geçmediyse PR açma.
- `docs/CHANGELOG.md` güncellendi mi? Güncellenmediyse önce `tech-writer`'a yaptır.
- **Hedef dal:** `CLAUDE.md`'deki PR hedef dalı (ör. `develop`); belirtilmemişse reponun varsayılan dalı.

## Dalı gönder
```bash
git push -u origin HEAD
```
Push kimlik doğrulama hatası verirse dur ve kullanıcıya söyle (yerelde git'in GitHub girişi yapılmamış olabilir).

## PR'ı aç
- **GitHub MCP varsa:** `github` sunucusunun pull request oluşturma aracıyla; `head` = çalışma dalı, `base` = hedef dal, başlık ve aşağıdaki gövde.
- **Yoksa `gh` ile:** `gh pr create --base <hedef-dal> --title "<başlık>" --body-file <geçici-dosya>`

Başlık: `<tür>(<kapsam>): <özet> (#<issue>)`

Gövde şablonu:
```markdown
Closes #<issue>

## Ne değişti
- …

## Nasıl test edildi
- Komut: `<test/doğrulama komutu>` → <sonuç>
- QA tablosu: <qa çıktısının özeti>

## Kod inceleme
- Karar: <code-reviewer kararı>
- Açık öneriler: <varsa>

## Dokümantasyon
- <güncellenen dosyalar>

## İnsan için kontrol listesi
- [ ] Değişikliği denedim
- [ ] Dokümantasyon yeterli
```

Not: `Closes #<issue>` issue'yu yalnızca PR **varsayılan dala** birleşince otomatik kapatır. Hedef dal varsayılan dal değilse (ör. `develop`), issue `develop` → `main` sürüm birleştirmesinde kapanır; bu beklenen davranıştır.

## Sonra
- PR bağlantısını issue'ya kısa bir yorumla yaz.
- Board statüsünü **İncelemede** yap (`board-durum`).
- PR'ı birleştirme veya onaylama; bu insanın işidir.
