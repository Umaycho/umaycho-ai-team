# ai-team

GitHub issue'larını gerçek bir üretim ekibi gibi **planlayan, uygulayan, test eden, dokümante eden ve board statüsünü güncelleyen** Claude Code plugin'i. Tüm projeler bu repodaki ekibi paylaşır; her proje yalnızca kendine özgü birkaç dosya taşır.

## İçerik

```
ai-team/
├── .claude-plugin/marketplace.json     # bu repo bir plugin pazarıdır
├── plugins/agentic-team/               # ekip plugin'i
│   ├── .claude-plugin/plugin.json
│   ├── .mcp.json                       # GitHub MCP (repos, issues, PR, projects)
│   ├── agents/                         # 9 uzman rol
│   ├── skills/                         # orkestra + iş yöntemleri
│   ├── hooks/hooks.json                # git koruma hook'u
│   └── scripts/guard-git.sh
└── templates/project/                  # yeni bir projeye kopyalanacak dosyalar
```

### Roller
| Rol | Nerede | Ne yapar |
| --- | --- | --- |
| Orkestratör / PM | `skills/orkestra` (ana oturum) | Planlar, alt işlere böler, onay ister, dağıtır, statü günceller |
| Mimar | `agents/architect.md` | Teknik tasarım, ADR |
| Geliştirici | `agents/developer.md` | Kod + temel testler |
| QA | `agents/qa.md` | Kabul kriterine göre test |
| Kod inceleme | `agents/code-reviewer.md` | Salt okunur inceleme |
| Teknik yazar | `agents/tech-writer.md` | README, CHANGELOG, docs |
| Oyun tasarımcısı | `agents/game-designer.md` | GDD, mekanikler, asset listesi |
| 3D sanatçı | `agents/artist-3d.md` | Blender MCP + Hunyuan3D (lokal) |
| Motor entegratörü | `agents/engine-integrator.md` | Sahne kurulumu, motorda doğrulama |
| DevOps | `agents/devops.md` | CI/CD, build, sürüm |

Orkestratör bilinçli olarak bir skill'dir: Claude Code'da alt agent'lar başka alt agent başlatamadığı için koordinasyon ana oturumda yapılır.

### Skill'ler
`/agentic-team:orkestra`, `board-durum`, `adr-yaz`, `gdd-yaz`, `pr-hazirla`, `durum-raporu`, `3d-asset-uret`

### Güvenlik
`guard-git.sh` hook'u agent'ların şunları yapmasını engeller: `main`/`master`'a push, force push, `gh pr merge`, `gh pr review --approve`. Asıl güvence yine de repodaki branch koruma kuralıdır.

## Kurulum

### 1. Bu repoyu GitHub'a koy
Bu klasörün içeriği `Umaycho/umaycho-ai-team` reposunda yaşar. İçinde sır olmadığı için **public** tutmak en kolayı; private tutarsan Actions'ın repoyu okuyabileceği bir token gerekir.

Yerelde doğrula:
```bash
claude plugin validate .
```

### 2. Yeni bir projeye ekle
1. `templates/project/` içindeki her şeyi proje reposunun köküne kopyala.
2. Yer tutucuları değiştir:
   - `.claude/settings.json` ve `.github/workflows/claude.yml` → zaten `Umaycho/umaycho-ai-team` olarak ayarlı; farklı bir org kullanırsan değiştir
   - `CLAUDE.md` → proje adı, board owner ve numarası, test komutları
3. Repo → Settings → Secrets and variables → Actions:
   - `ANTHROPIC_API_KEY` — Claude API anahtarı
   - `GITHUB_PAT` — `repo` ve `project` yetkili token (board güncellemesi ve GitHub MCP için)
4. Claude GitHub App'i repoya kur (Claude Code içinde `/install-github-app` veya github.com/apps/claude).
5. Etiketleri oluştur: `type:code`, `type:design`, `type:docs`, `type:3d`.

### 3. Yerelde kullan
Proje klasöründe `claude` çalıştır. `.claude/settings.json` sayesinde Claude Code `ai-team` pazarını tanır ve plugin'i etkinleştirmeyi önerir. Elle kurmak istersen:
```
/plugin install agentic-team --marketplace Umaycho/umaycho-ai-team
```
Kontrol:
```
/plugin          → agentic-team etkin
/agents          → 9 rol
/mcp             → github bağlı (GITHUB_PAT ortam değişkeni gerekli)
```

### 4. İlk görev
Bir issue aç (Ekip görevi şablonu), `type:` etiketini koy ve açıklamaya `@claude` yaz. Ekip plan yorumu yazar ve kartı **Onay bekliyor**'a alır; `@claude onaylandı` yazınca uygulamaya geçer.

## Güncelleme
Bir rolü veya skill'i değiştirdiğinde `plugin.json` içindeki `version`'ı artır ve push et. Projeler bir sonraki çalıştırmada yeni sürümü alır (yerelde `/plugin` → marketplace'i güncelle).

## Lokal aşama (sonra)
3D ve motor işleri için GPU'lu bilgisayarda self-hosted runner, Godot MCP, Blender MCP ve Hunyuan3D kurulacak. Workflow'a `type:3d` etiketli işleri `runs-on: [self-hosted, gpu]`'ya yönlendiren ikinci bir job eklenecek. Ayrıntılar kurulum kılavuzunda.
