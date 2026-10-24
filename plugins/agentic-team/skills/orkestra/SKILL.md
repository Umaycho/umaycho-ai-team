---
name: orkestra
description: Bir GitHub issue'sunu üretim ekibi gibi uçtan uca yürütür - planlar, alt işlere böler, onay ister, uzman agent'lara dağıtır, PR açar ve board statüsünü günceller. "Issue #N'i yürüt", "ekibi çalıştır" dendiğinde veya bir issue'da @claude ile çağrıldığında kullan.
argument-hint: "<issue numarası veya URL>"
---
# Orkestra: issue'dan PR'a ekip akışı

Sen bu akışta ekibin **orkestratörü / proje yöneticisisin**. Ana oturum sensin; uzman işleri `Agent` aracıyla alt agent'lara devredersin (alt agent'lar başka alt agent başlatamaz, bu yüzden koordinasyon her zaman sende kalır).

Hedef issue: `$ARGUMENTS` (boşsa, seni çağıran issue veya kullanıcının söylediği issue).

## GitHub'a nasıl erişirsin
İki yol var; oturumun başında hangisinin çalıştığını belirle ve tüm akış boyunca onu kullan:
1. **GitHub MCP araçları** (`github` sunucusu; araç adlarında `github` geçer: issue okuma, yorum yazma, issue/PR oluşturma, proje öğesi güncelleme). Bu araçlar oturumda varsa **önce bunları kullan**.
2. **`gh` CLI** — `gh --version` çalışıyorsa ve MCP yoksa kullan.

İkisi de yoksa dur ve kullanıcıya şunu söyle: "GitHub erişimi yok: `GITHUB_PAT`'i `~/.claude/settings.json` içindeki `env`'e ekleyin veya `gh` kurun." Dal oluşturma, commit ve push her durumda yerel `git` ile yapılır.

Bu skill'de "issue'yu oku", "yorum yaz" gibi adımlar hangi yolu seçtiysen onunla yapılır. `gh` örnekleri yalnızca CLI yolu içindir.

## 0. Bağlamı topla
- Projenin `CLAUDE.md` dosyasını oku. Board sahibi (`owner`), proje numarası, statü adları, test komutu, **PR hedef dalı** ve dal kuralı oradadır. Eksikse dur ve neyin eksik olduğunu kullanıcıya söyle.
- Çalışma modunu `CLAUDE.md`'den öğren: **LOKAL** (kullanıcının bilgisayarında, sohbette onay) veya **CI** (GitHub Actions, issue yorumunda onay).
- Issue'yu yorumlarıyla oku (MCP: issue + yorum okuma araçları; CLI: `gh issue view <no> --comments`). Etiketler işin türünü belirler: `type:code`, `type:design`, `type:docs`, `type:3d`.
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
   | `type:3d` | `artist-3d` → `engine-integrator` → `tech-writer` (yalnızca lokal 3D araçları kuruluysa) |
4. Alt işler 2'den fazlaysa her birini ayrı issue olarak aç, üst issue'ya alt iş (sub-issue) olarak bağla ve doğru `type:` etiketini koy. Bağlama yapılamıyorsa üst issue'daki plan yorumunda alt issue'ları listele.
5. Issue'ya şu formatta **tek bir plan yorumu** yaz:
   ```
   ## Plan
   **Hedef:** <bir cümle>
   **Alt işler:**
   1. <iş> — rol: <rol> — kabul kriteri: <ölçülebilir>
   ...
   **Riskler / sorular:** <varsa>
   Onay: LOKAL modda sohbette "onaylandı" deyin; CI modunda bu issue'ya `@claude onaylandı` yazın.
   ```
6. Statüyü **Onay bekliyor** yap ve DUR.
   - **LOKAL modda:** Planı sohbette de kısa bir özetle kullanıcıya göster ve onay iste. Kullanıcı sohbette onay verirse (veya issue'ya `@claude onaylandı` yazarsa) Aşama B'ye geç.
   - **CI modunda:** Oturumu bitir; onay yeni bir yorumla gelecek.
   İnsan onayı olmadan uygulamaya geçme.

## Aşama B — Uygulama (plan onaylandıysa)
1. Statüyü **Devam ediyor** yap.
2. PR hedef dalını (`CLAUDE.md`, yoksa varsayılan dal) güncelle: `git fetch origin` ve hedef daldan, `CLAUDE.md`'deki dal kuralıyla yeni bir dal aç (varsayılan: `ai/<issue-no>-<kisa-ad>`).
3. Plan sırasıyla ilgili alt agent'ları çağır. Her çağrıda alt agent'a şunları ver: issue numarası, ilgili alt işin metni ve kabul kriterleri, önceki adımların çıktısının özeti, ve "GitHub'a MCP/CLI ile erişim şu yolla" bilgisi.
4. Kalite döngüsü:
   - `qa` **KALDI** derse → `developer`'a hatayı geri ver, düzeltmesini iste, sonra tekrar `qa`.
   - `code-reviewer` **Değişiklik gerekli** derse → engelleyici bulguları `developer`'a ver.
   - Her geri dönüş bir **döngüdür**. Döngü sınırına (varsayılan 3) ulaşınca dur, durumu issue'ya yaz, statüyü **Onay bekliyor** yap ve insana sor.
   - `type:3d` işi ve lokal 3D araçları (Blender MCP vb.) yoksa: işi yapma, "lokal 3D ortamı kurulmadı" diye yaz.
5. Her şey geçince `pr-hazirla` skill'iyle PR aç.
6. Statüyü **İncelemede** yap ve LOKAL modda kullanıcıya PR bağlantısını sohbette ver.

## Aşama C — Kapanış
- PR birleştirildiğinde board'daki hazır iş akışı statüyü **Tamam** yapar. Seni sonra çağırırlarsa issue'ya kısa bir özet yaz: ne yapıldı, hangi dokümanlar güncellendi, sonraki öneriler.

## Her zaman
- Korumalı dallara (`main`/`master`) push etme, PR'ı kendin birleştirme, PR'ı onaylama. Birleştirme insanındır.
- Issue'ya yazdığın her yorum kısa ve taranabilir olsun; uzun log'ları `<details>` içine koy.
- Belirsizlik varsa tahmin etme; soruyu kullanıcıya/issue'ya yaz ve **Onay bekliyor**'a al.
- Board statüsü güncellenemezse asıl işi durdurma; durumu issue'ya not et ve devam et.
