# <PROJE ADI>

Bu repo, `ai-team` marketplace'indeki **agentic-team** plugin'iyle çalışan bir projedir. Bu dosya ekibe projeye özgü bilgileri verir; ekibin rolleri ve çalışma yöntemi plugin'dedir.

## Proje
- **Ne:** <bir-iki cümle: ne yapıyoruz, kimin için>
- **Tür:** Oyun (Godot 4) <!-- veya: web uygulaması, CLI aracı ... -->
- **Dil:** Doküman ve yorumlar Türkçe, kod tanımlayıcıları İngilizce.

## Board (GitHub Projects)
- **owner:** Umaycho
- **Proje numarası:** <1>
- **Statüler (sırayla):** Backlog, Planlanıyor, Onay bekliyor, Devam ediyor, İncelemede, Tamam
- **Döngü sınırı:** 3 (QA/inceleme turu; aşılırsa insana devredilir)

## Ekip akışı
- Bir issue'da `@claude` ile çağrıldığında **`orkestra` skill'ini izle**: önce plan + onay, sonra uygulama.
- `@claude onaylandı` yorumu planın onaylandığı anlamına gelir.
- Etiketler: `type:code`, `type:design`, `type:docs`, `type:3d` (3D işleri yalnızca lokal GPU runner'da).

## Dallar ve commit'ler
- Dal: `ai/<issue-no>-<kisa-ad>` (insanlar için: `<ad>/<issue-no>-<kisa-ad>`)
- Commit: `<tür>(<kapsam>): <özet> (#<issue>)` — tür: feat, fix, refactor, test, docs, chore
- `main` korumalıdır; tüm değişiklikler PR ile gelir. PR'ları yalnızca insanlar birleştirir.

## Komutlar
<!-- Ekip test ve build için bu komutları kullanır. Projenize göre doldurun. -->
- **Test:** `godot --headless --path . -s addons/gut/gut_cmdln.gd -gexit` <!-- GUT kullanıyorsanız -->
- **Lint/format:** `gdformat --check .` <!-- gdtoolkit kuruluysa; yoksa bu satırı silin -->
- **Çalıştır (başsız doğrulama):** `godot --headless --path . --quit`
- **Export:** <henüz yok>

## Klasör yapısı
- `game/` veya proje kökü — Godot projesi (`project.godot`)
- `assets/models/`, `assets/textures/`, `assets/audio/` — Git LFS ile takip edilir
- `docs/adr/` — mimari kararlar
- `docs/design/GDD.md` — oyun tasarım dokümanı
- `docs/CHANGELOG.md` — değişiklik günlüğü

## Projeye özgü kurallar
- <ör. Hedef 60 FPS, mobil uyum yok, sadece klavye + gamepad>
