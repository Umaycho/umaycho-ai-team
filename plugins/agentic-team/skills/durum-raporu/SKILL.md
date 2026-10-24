---
name: durum-raporu
description: Projenin board'undaki işlerin özetini çıkarır - statülere göre sayılar, onay bekleyenler, takılan işler. "Proje ne durumda", "ekip ne yapıyor", günlük/haftalık özet istendiğinde kullan.
allowed-tools: Bash(gh:*)
---
# Durum raporu

1. Board bilgisini `CLAUDE.md`'den al (`owner`, proje numarası).
2. Öğeleri çek:
   ```bash
   gh project item-list <no> --owner <owner> --format json --limit 200
   ```
3. Raporu şu sırayla yaz (kısa, taranabilir):
   - **Bir cümlelik özet:** kaç iş açık, kaçı insan bekliyor.
   - **Onayını bekleyenler:** Status = "Onay bekliyor" olanlar; başlık + bağlantı + neyin beklendiği.
   - **Statüye göre dağılım:** Backlog / Planlanıyor / Onay bekliyor / Devam ediyor / İncelemede / Tamam sayıları (tablo).
   - **Takılanlar:** 3 günden uzun süredir "Devam ediyor"da olanlar veya döngü sınırına ulaşanlar.
   - **Son tamamlananlar:** son 7 günde kapanan işler.
4. İstenirse raporu `docs/raporlar/YYYY-MM-DD.md` olarak kaydet; istenmediyse sadece yanıt olarak ver.
