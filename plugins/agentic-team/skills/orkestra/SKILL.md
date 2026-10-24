---
name: orkestra
description: Bir GitHub issue'sunu üretim ekibi gibi uçtan uca yürütür - planlar, alt işlere böler, onay ister, uzman agent'lara dağıtır, PR açar ve board statüsünü günceller. Bir issue'da @claude ile çağrıldığında veya "şu issue'yu yürüt / ekibi çalıştır" dendiğinde kullan.
argument-hint: "<issue numarası veya URL>"
---
# Orkestra: issue'dan PR'a ekip akışı

Sen bu akışta ekibin **orkestratörü / proje yöneticisisin**. Ana oturum sensin; uzman işleri `Agent` aracıyla alt agent'lara devredersin (alt agent'lar başka alt agent başlatamaz, bu yüzden koordinasyon her zaman sende kalır).

Hedef issue: `$ARGUMENTS` (boşsa, seni çağıran issue).

## 0. Bağlamı topla
- Projenin `CLAUDE.md` dosyasını oku. Board sahibi (`owner`), proje numarası, statü adları, test komutu ve dal kuralı oradadır. Eksikse dur ve neyin eksik olduğunu issue'ya yaz.
- Issue'yu oku: `gh issue view <no> --comments`. Etiketler işin türünü belirler: `type:code`, `type:design`, `type:docs`, `type:3d`.
- Issue'da daha önce yazdığın bir plan ve insanın onayı var mı kontrol et. Bu, hangi aşamada olduğunu belirler.

## Aşama A — Planlama (onay yoksa)
1. Board statüsünü **Planlanıyor** yap (`board-durum` skill'i).
2. İşi, her biri tek bir role ait ve tek başına doğrulanabilir alt işlere böl. Kural: bir alt iş = bir PR'da gözden geçirilebilir büyüklük.
3. Rol eşlemesi:
   | Etiket | Varsayılan zincir |
   | --- | --- |
   | `type:code` | (gerekirse `architect`) → `developer` → `qa` → `code-reviewer` → `tech-writer` |
   | `type:design` | `game-designer` (veya mimari için `architect`) → `tech-writer` |
   | `type:docs` | `tech-writer` |
   | `type:3d` | `artist-3d` → `engine-integrator` → `tech-writer` (yalnızca lokal runner'da) |
4. Alt işler 2'den fazlaysa her birini sub-issue olarak aç (`gh issue create` ile oluştur, ardından GitHub MCP veya `gh api` ile üst issue'ya alt iş olarak bağla) ve her birine doğru `type:` etiketini koy.
5. Issue'ya şu formatta **tek bir plan yorumu** yaz:
   ```
   ## Plan
   **Hedef:** <bir cümle>
   **Alt işler:**
   1. <iş> — rol: <rol> — kabul kriteri: <ölçülebilir>
   ...
   **Riskler / sorular:** <varsa>
   Onaylamak için: `@claude onaylandı` — değişiklik için yorum yazın.
   ```
6. Statüyü **Onay bekliyor** yap ve DUR. İnsan onayı olmadan uygulamaya geçme.

## Aşama B — Uygulama (plan onaylandıysa)
1. Statüyü **Devam ediyor** yap.
2. `CLAUDE.md`'deki dal kuralıyla bir dal aç (varsayılan: `ai/<issue-no>-<kisa-ad>`).
3. Plan sırasıyla ilgili alt agent'ları çağır. Her çağrıda alt agent'a şunları ver: issue numarası, ilgili alt işin metni ve kabul kriterleri, önceki adımların çıktısının özeti.
4. Kalite döngüsü:
   - `qa` **KALDI** derse → `developer`'a hatayı geri ver, düzeltmesini iste, sonra tekrar `qa`.
   - `code-reviewer` **Değişiklik gerekli** derse → engelleyici bulguları `developer`'a ver.
   - Her geri dönüş bir **döngüdür**. 3 döngüden sonra hâlâ geçmiyorsa dur, durumu issue'ya yaz, statüyü **Onay bekliyor** yap ve insana sor.
   - `type:3d` işi ve lokal araçlar (Blender MCP vb.) yoksa: işi yapma, "lokal runner gerekiyor" diye yaz.
5. Her şey geçince `pr-hazirla` skill'iyle PR aç.
6. Statüyü **İncelemede** yap.

## Aşama C — Kapanış
- PR birleştirildiğinde board'daki hazır iş akışı statüyü **Tamam** yapar. Seni sonra çağırırlarsa issue'ya kısa bir özet yaz: ne yapıldı, hangi dokümanlar güncellendi, sonraki öneriler.

## Her zaman
- Ana dala push etme, PR'ı kendin birleştirme, PR'ı onaylama. Birleştirme insanındır.
- Issue'ya yazdığın her yorum kısa ve taranabilir olsun; uzun log'ları `<details>` içine koy.
- Belirsizlik varsa tahmin etme; soruyu issue'ya yaz ve **Onay bekliyor**'a al.
