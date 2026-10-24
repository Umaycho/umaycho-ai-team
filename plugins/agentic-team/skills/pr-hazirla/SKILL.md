---
name: pr-hazirla
description: Tamamlanan iş için standart formatta pull request açar ve issue'ya bağlar. Testler geçip kod incelemesi tamamlandığında kullan.
argument-hint: "<issue numarası>"
allowed-tools: Bash(git:*), Bash(gh:*)
---
# PR hazırla

## Ön kontrol
- Çalışma dalında olduğunu doğrula (`git branch --show-current`); `main` ise DUR.
- Testler son çalıştırmada geçti mi? Geçmediyse PR açma.
- `docs/CHANGELOG.md` güncellendi mi? Güncellenmediyse önce `tech-writer`'a yaptır.

## PR'ı aç
```bash
git push -u origin HEAD
gh pr create --title "<tür>(<kapsam>): <özet> (#<issue>)" --body-file <geçici-dosya>
```

PR gövdesi şablonu:
```markdown
Closes #<issue>

## Ne değişti
- …

## Nasıl test edildi
- Komut: `<test komutu>` → <sonuç>
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

`Closes #<issue>` satırı sayesinde PR birleşince issue kapanır ve board'daki iş akışı kartı **Tamam**'a taşır.

## Sonra
- PR URL'sini issue'ya kısa bir yorumla yaz.
- Board statüsünü **İncelemede** yap (`board-durum`).
- PR'ı birleştirme veya onaylama; bu insanın işidir.
