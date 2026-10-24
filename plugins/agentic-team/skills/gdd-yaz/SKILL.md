---
name: gdd-yaz
description: Oyun tasarım dokümanı (GDD) oluşturur veya bir bölümünü günceller. Yeni bir oyun, mekanik, seviye veya asset ihtiyacı tanımlanırken kullan.
argument-hint: "<oyun veya bölüm adı>"
---
# GDD yaz / güncelle

Dosya: `docs/design/GDD.md`. Yoksa aşağıdaki şablonla oluştur; varsa yalnızca ilgili bölümü güncelle ve en alttaki **Değişiklik günlüğü**ne bir satır ekle.

```markdown
# <Oyun adı> — Oyun Tasarım Dokümanı

## 1. Özet
- **Tür / perspektif:** …
- **Platform:** …
- **Hedef oturum süresi:** …
- **Tek cümlelik fikir:** …

## 2. Çekirdek döngü
Oyuncu ne yapar → ne kazanır → neden tekrar yapar? (3–5 madde)

## 3. Mekanikler
### 3.x <Mekanik adı>
- **Tanım:** …
- **Parametreler (ayarlanabilir):** | Ad | Değer | Birim |
- **Kabul kriterleri:**
  - [ ] …

## 4. Seviyeler
| Seviye | Amaç | Yeni öğe | Tahmini süre |

## 5. Kontroller
| Eylem | Klavye | Gamepad |

## 6. Asset listesi
| Ad | Tür (model/sprite/ses) | Bütçe (üçgen / px) | Stil notu | Öncelik |

## 7. Kapsam dışı / sonraki sürüm
- …

## Değişiklik günlüğü
| Tarih | Bölüm | Değişiklik | Issue |
```

Kurallar: Sayısal değerleri birimle yaz; her mekanik için en az bir test edilebilir kabul kriteri ver; asset listesindeki her satır sonradan `type:3d` issue'su açılabilecek netlikte olsun.
