---
name: 3d-asset-uret
description: Blender MCP ve lokal Hunyuan3D ile oyuna hazır 3D model üretir ve .glb olarak dışa aktarır. type:3d task'larında, yalnızca Blender MCP'nin bağlı olduğu lokal oturumda kullan.
argument-hint: "<asset adı>"
---
# 3D asset üret

## 0. Ortam kontrolü
`blender` MCP araçları oturumda yoksa bu skill'i çalıştırma. Issue'ya "Bu iş lokal GPU runner'ında çalışmalı; Blender MCP erişilemiyor." yaz ve dur.

## 1. Girdi
GDD'deki asset satırını oku: ad, tür, üçgen bütçesi, stil notu. Yoksa makul bir varsayılan seç (küçük sahne objesi: 2.000 üçgen; karakter: 10.000 üçgen) ve bunu raporda belirt.

## 2. Üretim
- Önce Blender MCP'nin Hunyuan3D durum aracıyla servisin çalıştığını kontrol et.
- Metinden üretim istemi: nesne + malzeme + stil + "game asset, single object, clean topology, neutral background". Bir referans görsel varsa görselden üretimi tercih et.
- Üretilen modeli Blender sahnesine al.

## 3. Oyuna hazırlama (Blender içinde)
1. Ölçek: gerçek dünya metre ölçüsüne getir; tabanı z=0'a, pivotu tabanın ortasına al.
2. Üçgen sayısını ölç; bütçeyi aşıyorsa Decimate ile indir, siluetin bozulmadığını görsel olarak kontrol et.
3. Dönüşümleri uygula (Apply All Transforms), kullanılmayan materyal ve veri bloklarını temizle.
4. Materyal: PBR doku varsa koru; yoksa basit renkli bir materyal ata ve raporda belirt.

## 4. Dışa aktarma
- `.glb` olarak `assets/models/<kategori>/<ad>.glb` yoluna aktar (+Y yukarı ayarı motorun beklentisine göre; Godot glTF'yi doğrudan içe aktarır).
- Önizleme ekran görüntüsünü `assets/models/<kategori>/<ad>.png` olarak kaydet.
- `.gitattributes`'ta `*.glb` ve `*.png` için Git LFS satırı olduğunu doğrula.

## 5. Rapor
Üçgen sayısı, boyutlar (m), dosya yolları ve bilinen sorunlar. Ardından `engine-integrator`'ın sahneye yerleştirmesi için yolu ilet.
