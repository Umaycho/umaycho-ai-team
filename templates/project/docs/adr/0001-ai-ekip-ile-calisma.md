# 0001. AI ekip ile çalışma

- **Durum:** Kabul edildi
- **Tarih:** <YYYY-MM-DD>
- **İlgili issue:** —

## Bağlam
Bu projede işler GitHub issue'ları olarak tanımlanıyor ve `agentic-team` plugin'indeki AI agent ekibi tarafından planlanıp uygulanıyor. İnsan; görev tanımlama, plan onayı ve PR birleştirme noktalarında devrede.

## Değerlendirilen seçenekler
1. **Tamamen manuel geliştirme** — artı: tam kontrol / eksi: yavaş.
2. **İnsan kapılı AI ekip** — artı: hız, tutarlı dokümantasyon / eksi: API maliyeti, gözden geçirme yükü.

## Karar
İnsan kapılı AI ekip, çünkü hız kazanırken plan onayı ve PR birleştirme insanın kontrolünde kalıyor.

## Sonuçlar
- Olumlu: Her değişiklik PR, test ve doküman güncellemesiyle geliyor.
- Olumsuz / bedel: API kullanımı izlenmeli; döngü sınırı 3.
- Takip gerektiren: Lokal GPU runner (3D işleri) sonraki aşamada eklenecek.
