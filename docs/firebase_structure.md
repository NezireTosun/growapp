# GrowApp - Firebase/Firestore Yapısı

> Firebase Console'daki gerçek yapıya dayanmaktadır.

## Koleksiyonlar (Firebase Console sırası)

```
blog_posts
business_members
business_types
businesses
cafe_week
daily_assignments
onboarding_responses
onboarding_steps
pain_points
plans
questions
rest_week
tasks
users
```

## Koleksiyon İlişki Diyagramı

```
users ──────────────┐
  │ plan_id          │
  ▼                  │ owner_id / user_id
plans               businesses
                     │
                     │ business_id
                     ▼
              business_members
                     │
                     │ business_id + user_id + date
                     ▼
              daily_assignments ──► tasks
                                      ▲
                                      │
              onboarding_responses ───┘
                     ▲
              questions ──► options (subcollection)

              onboarding_steps
              business_types
              pain_points
              blog_posts
              cafe_week / rest_week (ham puanlama verisi)
```

---

## 1. `users/{userId}`
**Document ID:** Firebase Auth UID

| Alan | Tip | Açıklama |
|------|-----|----------|
| `fullname` | String | Kullanıcı adı |
| `email` | String | E-posta |
| `phone` | String | Telefon (opsiyonel) |
| `plan_id` | String | Plan referansı: `"free"` veya `"premium"` |
| `is_active` | Boolean | Hesap aktif mi (default: true) |
| `email_verified` | Boolean | E-posta doğrulandı mı |
| `created_at` | Timestamp | Hesap oluşturulma tarihi |
| `last_login` | Timestamp | Son giriş |
| `deactivated_at` | Timestamp | Hesap deaktif tarihi (opsiyonel) |
| `notification_settings` | Map | Bildirim ayarları (aşağıda) |

**notification_settings alt alanları:**
| Alan | Tip | Default |
|------|-----|---------|
| `daily_reminders` | Boolean | true |
| `off_peak_deals` | Boolean | true |
| `weekly_report` | Boolean | false |
| `new_features` | Boolean | true |

---

## 2. `plans/{planId}`
**Document ID:** Sabit string → `"free"` veya `"premium"`

| Alan | Tip | Açıklama |
|------|-----|----------|
| `name` | Map | `{tr: "Ücretsiz", en: "Free"}` |
| `price` | Number | Fiyat |
| `max_businesses` | Integer | Maks işletme sayısı |
| `max_members_per_business` | Integer | İşletme başına maks üye |
| `features` | Array\<String\> | Özellik listesi |
| `is_active` | Boolean | Plan aktif mi |
| `order` | Integer | Sıralama |

**Mevcut planlar:**
| Plan | Fiyat | Max İşletme | Max Üye | Özellikler |
|------|-------|-------------|---------|------------|
| free | 0 | 1 | 1 | daily_tasks, blog |
| premium | 99 | 5 | 3 | daily_tasks, blog, analytics, ai_insights, multi_business |

---

## 3. `businesses/{businessId}`
**Document ID:** Firestore auto-generated

| Alan | Tip | Açıklama |
|------|-----|----------|
| `name` | String | İşletme adı |
| `owner_id` | String | Sahibin userId'si → `users` referans |
| `sector` | String | Sektör/iş tipi |
| `city` | String | Şehir |
| `instagram` | String | Instagram hesabı |
| `status` | String | Durum (default: "active") |
| `is_active` | Boolean | Soft delete flag |
| `created_at` | Timestamp | Oluşturulma tarihi |

---

## 4. `business_members/{autoId}`
**Document ID:** Firestore auto-generated
**Amaç:** Kullanıcı-İşletme çoktan-çoğa ilişki tablosu

| Alan | Tip | Açıklama |
|------|-----|----------|
| `business_id` | String | → `businesses` referans |
| `user_id` | String | → `users` referans |
| `role` | String | "owner" veya "member" |
| `joined_at` | Timestamp | Katılma tarihi |
| `is_active` | Boolean | Üyelik aktif mi |

---

## 5. `tasks/{taskId}`
**Document ID:** Sayısal string → `"1"`, `"2"`, `"3"`, ...
**Amaç:** Görevlerin lokalize içerik ve detayları

| Alan | Tip | Açıklama |
|------|-----|----------|
| `business_type` | Integer | 1=Cafe, 2=Restoran, 3=Bijuteri, 4=Servis |
| `category` | String | Kategori (ör: "ACQUISITION") |
| `cool_down_days` | Integer | Tekrar gösterilmeden önceki gün |
| `is_active` | Boolean | Görev aktif mi |
| `title` | Map | `{tr: "...", en: "...", de: "...", cs: "...", es: "..."}` |
| `why_title` | Map | Neden başlığı (lokalize) |
| `why_text` | Map | Neden açıklaması (lokalize) |
| `how_title` | Map | Nasıl başlığı (lokalize) |
| `how_steps` | Array\<Map\> | Adımlar dizisi (her eleman lokalize map) |
| `template_title` | Map | Şablon başlığı (lokalize) |
| `template_text` | Map | Paylaşım şablonu (lokalize) |
| `impact_score` | Integer | Etki puanı (1-10) |
| `time_estimate` | Integer | Süre (dakika) |
| `difficulty_level` | String | "easy", "medium", "hard" |

**how_steps array formatı:**
```json
[
  {
    "cs": "Česky text...",
    "de": "Deutsch text...",
    "en": "English text...",
    "es": "Español text...",
    "tr": "Türkçe metin..."
  },
  { ... }
]
```

**Desteklenen diller:** tr, en, de, cs, es

### Alt koleksiyon: `tasks/{taskId}/task_steps/{stepId}`
> Not: Bazı görevlerde `how_steps` array alanı kullanılır, bazılarında `task_steps` alt koleksiyonu.

| Alan | Tip | Açıklama |
|------|-----|----------|
| `step_order` | Integer | Adım sırası |
| `step_text` | Map/String | Adım açıklaması (lokalize) |

---

## 6. `daily_assignments/{userId}_{businessId}_{YYYY-MM-DD}`
**Document ID:** Deterministik → `userId_businessId_tarih`
**Amaç:** Günlük görev ataması ve ilerleme takibi

| Alan | Tip | Açıklama |
|------|-----|----------|
| `user_id` | String | → `users` referans |
| `business_id` | String | → `businesses` referans |
| `date` | String | ISO tarih (YYYY-MM-DD) |
| `tasks` | Array\<Map\> | Atanmış görevler listesi |
| `created_at` | Timestamp | Oluşturulma |
| `updated_at` | Timestamp | Son güncelleme |

**tasks array elemanları:**
| Alan | Tip | Açıklama |
|------|-----|----------|
| `task_id` | String | → `tasks` referans (ör: "1", "2", "3") |
| `status` | String | "pending", "viewed", "completed", "skipped", "dismissed" |

---

## 7. `questions/{questionId}`
**Document ID:** Firestore auto-generated
**Amaç:** Onboarding anket soruları (7 soru)

| Alan | Tip | Açıklama |
|------|-----|----------|
| `title` | Map/String | Soru metni (lokalize) |
| `order_no` | Integer | Soru sırası (1-7) |

### Alt koleksiyon: `questions/{questionId}/options/{optionId}`

| Alan | Tip | Açıklama |
|------|-----|----------|
| `label` | Map/String | Seçenek metni (lokalize) |
| `score` | Integer | Puan (1=sad, 2=neutral, 3+=happy) |

---

## 8. `onboarding_responses/{autoId}`
**Document ID:** Firestore auto-generated
**Amaç:** Onboarding anket cevapları
> Kod tarafında da `onboarding_responses` olarak erişilir

| Alan | Tip | Açıklama |
|------|-----|----------|
| `business_id` | String | → `businesses` referans |
| `question_id` | String | → `questions` referans |
| `option_id` | String | → `questions/{qId}/options` referans |
| `created_at` | Timestamp | Cevap tarihi |

---

## 9. `onboarding_steps/{autoId}`
**Document ID:** Firestore auto-generated

| Alan | Tip | Açıklama |
|------|-----|----------|
| `type` | String | "business_name", "business_type", "survey", "pain_points", "ai_analysis" |
| `title` | Map/String | Adım başlığı (lokalize) |
| `subtitle` | Map/String | Alt başlık (opsiyonel, lokalize) |
| `order` | Integer | Sıra (1-5) |

---

## 10. `business_types/{typeId}`
**Document ID:** Sabit string → "1", "2", "3", "4"

| Alan | Tip | Açıklama |
|------|-----|----------|
| `name` | Map | `{tr: "Cafe", en: "Cafe"}` |
| `icon` | String | Material icon adı |
| `is_available` | Boolean | Seçilebilir mi |

**Mevcut tipler:**
| ID | TR | EN | Icon |
|----|----|----|------|
| 1 | Cafe | Cafe | local_cafe |
| 2 | Restoran | Restaurant | restaurant |
| 3 | Bijuteri | Jewelry | diamond |
| 4 | Servis | Service | build |

---

## 11. `pain_points/{autoId}`
**Document ID:** Firestore auto-generated

| Alan | Tip | Açıklama |
|------|-----|----------|
| `label` | Map/String | Ağrı noktası etiketi (lokalize) |
| `icon` | String | Material icon adı |

---

## 12. `blog_posts/{autoId}`
**Document ID:** Firestore auto-generated

| Alan | Tip | Açıklama |
|------|-----|----------|
| `author_id` | String | → `users` referans |
| `title` | String | Blog başlığı |
| `summary` | String | Özet |
| `content` | String | İçerik (HTML/Markdown) |
| `image_url` | String | Kapak görseli URL |
| `category` | String | "general", "instagram", "whatsapp" |
| `is_published` | Boolean | Yayında mı |
| `tips` | Array\<String\> | İpuçları listesi |
| `template` | String | Paylaşım şablonu (opsiyonel) |
| `created_at` | Timestamp | Oluşturulma tarihi |

---

## 13. `cafe_week/{id}` ve `rest_week/{id}`
**Document ID:** JSON'dan `id` alanı (string: "1", "2", ...)
**Amaç:** Ham görev puanlama verisi (JSON'dan seed ediliyor)

| Alan | Tip | Açıklama |
|------|-----|----------|
| `id` | Integer | Görev numarası (ör: 1, 2, 3) |
| `main_category` | String | Ana kategori (ör: "Acquisition") |
| `sub_category` | String | Alt kategori (ör: "Physical Vis.") |
| `task_name` | String | Görev adı (Türkçe) |
| `importance` | Integer | Önem puanı (1-10) |
| `ease` | Integer | Kolaylık puanı (1-10) |
| `impact` | Integer | Etki puanı (1-10) |
| `q1_visibility` | Float | Soru 1 ağırlığı |
| `q2_digital` | Float | Soru 2 ağırlığı |
| `q3_profit` | Float | Soru 3 ağırlığı |
| `q4_upsell` | Float | Soru 4 ağırlığı (cafe) |
| `q4_waiter` | Float | Soru 4 ağırlığı (restoran) |
| `q5_loyalty` | Float | Soru 5 ağırlığı |
| `q6_delivery` | Float | Soru 6 ağırlığı (cafe) |
| `q6_delivery_b2b` | Float | Soru 6 ağırlığı (restoran) |
| `q7_speed` | Float | Soru 7 ağırlığı (cafe) |
| `q7_dead_hours` | Float | Soru 7 ağırlığı (restoran) |
| `business_type` | Integer | 1=Cafe, 2=Restoran |

- `cafe_week`: 167 kayıt (Cafe görevleri)
- `rest_week`: 120 kayıt (Restoran görevleri)

> Bu koleksiyonlar algoritma puanlaması içindir. Görev içerikleri (lokalize başlık, açıklama, adımlar) `tasks` koleksiyonunda tutulur.

---

## 14. `notifications/{autoId}`
**Document ID:** Firestore auto-generated
**Amaç:** Kullanıcı bildirimleri (görev ataması, hatırlatma, günlük özet)

| Alan | Tip | Açıklama |
|------|-----|----------|
| `user_id` | String | → `users` referans |
| `business_id` | String | → `businesses` referans (opsiyonel) |
| `type` | String | "taskAssigned", "taskReminder", "dailySummary" |
| `title` | String | Bildirim başlığı |
| `body` | String | Bildirim içeriği |
| `is_read` | Boolean | Okundu mu (default: false) |
| `created_at` | Timestamp | Oluşturulma tarihi |
| `data` | Map | Ek veri (opsiyonel, ör: task_id) |

**Bildirim Türleri:**
| Type | Tetikleyici |
|------|------------|
| `taskAssigned` | Günlük görevler atandığında |
| `taskReminder` | Kullanıcı görevleri tamamlamadığında (gün içi hatırlatma) |
| `dailySummary` | Gün sonu özet bildirimi |

---

## 15. `email_verifications/{userId}`
**Document ID:** Firebase Auth UID
**Amaç:** E-posta doğrulama kodları

| Alan | Tip | Açıklama |
|------|-----|----------|
| `code` | String | 6 haneli doğrulama kodu |
| `email` | String | Kullanıcı e-posta adresi |
| `created_at` | Timestamp | Kod oluşturulma tarihi |
| `expires_at` | Timestamp | Kod geçerlilik süresi (10 dakika) |
| `verified` | Boolean | Doğrulandı mı (default: false) |

---

## Önemli Desenler

### Lokalizasyon
Firestore'da çok dilli alanlar Map olarak saklanır:
```json
{
  "tr": "Türkçe metin",
  "en": "English text",
  "de": "Deutsch text",
  "cs": "Český text",
  "es": "Texto en español"
}
```
Uygulama tarafında `_localized()` / `_loc()` helper fonksiyonu ile dil seçimine göre çekilir. Fallback sırası: seçili dil → tr → boş string.

### Soft Delete
`is_active: false` ile işaretlenir, doküman silinmez. Sorgularda `where('is_active', isEqualTo: true)` filtresi uygulanır.

### Composite Index Kaçınma
- `daily_assignments`: Deterministik document ID kullanarak composite query yerine direkt erişim
- `tasks`: `is_active` ile tek where, `business_type` filtresi client-side

### Seeding Stratejisi
- `FirestoreSeeder.seedAll()` uygulama açılışında çalışır
- `cafe_week` ve `rest_week` koleksiyonları JSON dosyalarından seed edilir
- `business_types` ve `plans` koleksiyonları koddan seed edilir
- Mevcut kayıt sayısı kontrolü yapılır (gereksiz yeniden yazma önlenir)
- Batch boyutu: 450 (Firestore limiti 500)

### tasks vs cafe_week/rest_week
- `cafe_week` / `rest_week`: Ham puanlama verisi (ağırlıklar, önem, kolaylık). Algoritma hesaplaması için.
- `tasks`: Lokalize görev içeriği (başlık, açıklama, adımlar, şablon). Kullanıcıya gösterilir.
- İki koleksiyon `id` alanı ile eşleşir: `cafe_week.id = 1` → `tasks` doc ID `"1"`
