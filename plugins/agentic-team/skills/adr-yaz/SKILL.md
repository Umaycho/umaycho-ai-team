---
name: adr-yaz
description: Mimari karar kaydı (ADR) yazar. Teknoloji seçimi, yapı değişikliği veya geri dönmesi zor bir teknik karar verildiğinde kullan.
argument-hint: "<karar başlığı>"
---
# ADR yaz

1. `docs/adr/` klasöründeki en yüksek numarayı bul; yeni numara bir fazlası, 4 haneli (`0001`, `0002`...). Klasör yoksa oluştur.
2. Dosya adı: `docs/adr/NNNN-kisa-baslik.md` (küçük harf, tire, Türkçe karakter yok).
3. Aşağıdaki şablonu doldur. Her bölüm kısa olsun; toplam bir ekranı geçmesin.

```markdown
# NNNN. <Başlık>

- **Durum:** Önerildi | Kabul edildi | Yerine geçildi: NNNN
- **Tarih:** YYYY-MM-DD
- **İlgili issue:** #<no>

## Bağlam
Hangi sorunu çözüyoruz, hangi kısıtlar var? (2–4 cümle)

## Değerlendirilen seçenekler
1. **<Seçenek A>** — artı: … / eksi: …
2. **<Seçenek B>** — artı: … / eksi: …

## Karar
<Seçilen seçenek> çünkü <gerekçe>.

## Sonuçlar
- Olumlu: …
- Olumsuz / bedel: …
- Takip gerektiren: …
```

4. Bir ADR'yi değiştirmek yerine yeni bir ADR yaz ve eskisinin durumunu "Yerine geçildi: NNNN" yap. Kararların geçmişi silinmez.
