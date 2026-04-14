# SalesApp API — Entegrasyon Kilavuzu

> Bu dokuman, SalesApp API'ye baglanacak istemciler (mobil app, web app, bot) icin hazirlanmistir.
> Yeterince detaylidir ki bir yapay zeka veya gelistirici bu dokumani okuyup direkt entegrasyonu yapabilsin.

---

## Genel Bilgiler

| Bilgi | Deger |
|-------|-------|
| Base URL | `https://salesgrowthsteps.com` |
| Protokol | HTTPS (zorunlu) |
| Format | JSON |
| Auth | Firebase Auth JWT (Bearer token) |
| Rate Limit | 60 req/dk (recommendations), 20 req/dk (feedbacks) |
| Content-Type | `application/json` |

---

## Kimlik Dogrulama (Authentication)

API, Firebase Authentication JWT token'i kullanir. Her istekte `Authorization` header'i zorunludur.

### Akis

```
1. Kullanici Firebase Auth ile login olur (email/password, Google, Apple vb.)
2. Firebase SDK'dan ID token alinir
3. Bu token her API isteginde header olarak gonderilir
```

### Header Formati

```
Authorization: Bearer <firebase_id_token>
```

### Firebase Projesi

| Bilgi | Deger |
|-------|-------|
| Project ID | `growappp-3b2dd` |
| Auth provider | Firebase Authentication |

### Token Alma (Platform bazli)

**Flutter/Dart:**
```dart
final user = FirebaseAuth.instance.currentUser;
final token = await user?.getIdToken();
// Header: "Authorization": "Bearer $token"
```

**JavaScript/React Native:**
```javascript
const token = await firebase.auth().currentUser.getIdToken();
// Header: "Authorization": `Bearer ${token}`
```

**Swift (iOS):**
```swift
let user = Auth.auth().currentUser
user?.getIDToken { token, error in
    // Header: "Authorization": "Bearer \(token)"
}
```

**Kotlin (Android):**
```kotlin
Firebase.auth.currentUser?.getIdToken(false)?.addOnSuccessListener { result ->
    val token = result.token
    // Header: "Authorization: Bearer $token"
}
```

### Token Yenileme

- Firebase ID token **1 saat** gecerlidir
- Suresi dolmus token gonderilirse API `401 Unauthorized` doner
- Token suresi dolmadan once Firebase SDK'nin `getIdToken(true)` metodu ile yenileyin
- Firebase SDK genelde bunu otomatik yapar

### Tokensiz veya Gecersiz Token

```
HTTP 401 Unauthorized
```

---

## Endpoint'ler

### 1. POST /api/v1/recommendations

Kullaniciya ozel gorev onerileri dondurur. Skorlama algoritmasi kullanicinin cevaplarina, gecmis feedback'lerine ve kategori agirliklarinagore en uygun gorevleri siralar.

#### Request

```
POST https://salesgrowthsteps.com/api/v1/recommendations
Content-Type: application/json
Authorization: Bearer <token>
```

#### Request Body

```json
{
  "industry": "rest",
  "answers": {
    "q1": 8,
    "q2": 5,
    "q3": 3,
    "q4": 9,
    "q5": 7,
    "q6": 2,
    "q7": 6
  }
}
```

#### Parametreler

| Alan | Tip | Zorunlu | Aciklama | Kisitlamalar |
|------|-----|---------|----------|-------------|
| `industry` | string | Evet | Sektorkodu | Max 64 karakter. Gecerli degerler: `"rest"` (restoran), `"cafe"` (kafe). Yeni sektorler eklenecek. |
| `answers` | object | Evet | Onboarding soru cevaplari | En az 1 cevap olmali |
| `answers.q{n}` | int | Evet | Soru cevabi (q1, q2, ... q7) | Deger: 1-10 arasi (dahil). Key formati: `q` + sayi |

#### Basarili Response (200 OK)

```json
{
  "recommendations": [
    {
      "rank": 1,
      "taskId": "task_rest_001",
      "taskName": "Google Isletme Profili olustur",
      "category": "Local",
      "subCategory": "Google My Business",
      "score": 95.2
    },
    {
      "rank": 2,
      "taskId": "task_rest_015",
      "taskName": "Menu fotograflarini guncelle",
      "category": "Experience",
      "subCategory": "Visual Appeal",
      "score": 88.7
    },
    {
      "rank": 3,
      "taskId": "task_rest_042",
      "taskName": "Musterilere NPS anketi gonder",
      "category": "Retention",
      "subCategory": "Customer Feedback",
      "score": 82.1
    }
  ]
}
```

#### Response Alanlari

| Alan | Tip | Aciklama |
|------|-----|----------|
| `recommendations` | array | Sirali gorev listesi (en yuksek skor ilk) |
| `recommendations[].rank` | int | Siralama (1'den baslar) |
| `recommendations[].taskId` | string | Gorev ID (feedback gonderirken kullanilir) |
| `recommendations[].taskName` | string | Gorev adi (kullaniciya gosterilir) |
| `recommendations[].category` | string | Ana kategori (asagidaki listeye bak) |
| `recommendations[].subCategory` | string | Alt kategori |
| `recommendations[].score` | double | Skor (0.0 - 100.0+, yuksek = daha uygun) |

#### Kategoriler (category alani icin gecerli degerler)

```
Acquisition      — Musteri kazanimi
Conversion       — Donusum optimizasyonu
Retention        — Musteri tutma
Operations       — Operasyonel iyilestirme
B2BSales         — B2B satis
Analytics        — Analitik ve olcumleme
StaffManagement  — Personel yonetimi
Profitability    — Karlilik artirma
Local            — Yerel pazarlama
SalesPower       — Satis gucu
Experience       — Musteri deneyimi
SocialProof      — Sosyal kanit
Upsell           — Upsell / cross-sell
```

---

### 2. POST /api/v1/feedbacks

Kullanicinin bir goreve verdigi geri bildirimi kaydeder. Bu feedback, gelecekteki oneri skorlarini etkiler.

#### Request

```
POST https://salesgrowthsteps.com/api/v1/feedbacks
Content-Type: application/json
Authorization: Bearer <token>
```

#### Request Body — Done (gorev tamamlandi)

```json
{
  "industry": "rest",
  "taskId": "task_rest_001",
  "action": "Done"
}
```

#### Request Body — Snooze (ertele)

```json
{
  "industry": "rest",
  "taskId": "task_rest_001",
  "action": "Snooze"
}
```

#### Request Body — Dismiss (istemiyorum)

```json
{
  "industry": "rest",
  "taskId": "task_rest_001",
  "action": "Dismiss",
  "dismissReason": "Bu gorev isletmem icin uygun degil"
}
```

#### Request Body — Blacklist (bir daha gosterme)

```json
{
  "industry": "rest",
  "taskId": "task_rest_001",
  "action": "Blacklist"
}
```

#### Parametreler

| Alan | Tip | Zorunlu | Aciklama | Kisitlamalar |
|------|-----|---------|----------|-------------|
| `industry` | string | Evet | Sektor kodu | Max 64 karakter. `"rest"`, `"cafe"` vb. |
| `taskId` | string | Evet | Gorev ID (recommendations'dan gelen) | Max 10 karakter, bos olamaz |
| `action` | string | Evet | Feedback tipi | Gecerli degerler: `"Done"`, `"Snooze"`, `"Dismiss"`, `"Blacklist"` (buyuk/kucuk harf farketmez) |
| `dismissReason` | string | Kosullu | Red nedeni | **Sadece `action: "Dismiss"` oldugunda zorunlu.** Diger action'larda `null` olmali veya gonderilmemeli. Max 256 karakter. |

#### Feedback Turleri ve Etkileri

| Action | Ne yapar | Algoritma etkisi |
|--------|----------|-----------------|
| `Done` | Gorevi tamamlandi olarak isaretler | 3 gun cooldown — gorev 3 gun onerilmez, sonra geri gelir |
| `Snooze` | Gorevi erteler | 1 gun cooldown — ertesi gun tekrar onerilir |
| `Dismiss` | Gorevi reddeder (nedenle) | Gorev skoru 0.1x carpani ile duser (cok dusuk oncelik) |
| `Blacklist` | Gorevi kalici olarak engeller | Gorev bir daha ASLA onerilmez + ayni kategorideki gorevlerin skoru duser (kategori penalty: her blacklist icin -0.15, min 0.1) |

#### Basarili Response (200 OK)

```json
{
  "userId": "UfSK17nZo9MrsVx2DMODGE3vrLU2",
  "taskId": "task_rest_001",
  "action": "Done",
  "recordedAt": "2026-03-23T10:55:00.000Z",
  "dismissReason": null
}
```

#### Response Alanlari

| Alan | Tip | Aciklama |
|------|-----|----------|
| `userId` | string | Firebase user ID |
| `taskId` | string | Islenen gorev ID |
| `action` | string | Kaydedilen feedback tipi |
| `recordedAt` | string (ISO 8601) | Kayit zamani (UTC) |
| `dismissReason` | string? | Sadece Dismiss icin, diger durumlarda `null` |

---

### 3. GET /health/live

Uygulamanin calisiyor olup olmadigini kontrol eder. Auth gerektirmez.

```
GET https://salesgrowthsteps.com/health/live
```

Response: `200 OK` — Body: `Healthy`

---

### 4. GET /health/ready

Uygulamanin tum bagimliliklar dahil hazir oldugunu kontrol eder. Auth gerektirmez.

```
GET https://salesgrowthsteps.com/health/ready
```

Response: `200 OK` — Body: `Healthy`

---

## Hata Formatlari

Tum hatalar RFC 7807 ProblemDetails formatinda doner.

### 401 Unauthorized (token yok veya gecersiz)

```json
// Body bos olabilir veya:
{
  "type": "https://tools.ietf.org/html/rfc9110#section-15.5.2",
  "title": "Unauthorized",
  "status": 401
}
```

### 400 Validation Error

```json
{
  "type": "https://tools.ietf.org/html/rfc9110#section-15.5.1",
  "title": "One or more validation errors occurred.",
  "status": 400,
  "errors": {
    "Industry": ["'Industry' must not be empty."],
    "Answers": ["At least one answer is required."],
    "Action": ["Invalid action. Valid: Done, Snooze, Dismiss, Blacklist"],
    "DismissReason": ["'Dismiss Reason' must not be empty."]
  }
}
```

### 404 Not Found (task bulunamadi)

```json
{
  "type": "https://tools.ietf.org/html/rfc9110#section-15.5.5",
  "title": "Task Not Found",
  "detail": "Task with ID 'xyz' does not exist.",
  "status": 404
}
```

### 429 Too Many Requests (rate limit asildi)

```json
{
  "type": "https://tools.ietf.org/html/rfc6585#section-4",
  "title": "Too Many Requests",
  "detail": "Rate limit exceeded. Try again later.",
  "status": 429
}
```

Header: `Retry-After: <saniye>` — kac saniye beklemesi gerektigi

### 500 Internal Server Error

```json
{
  "type": "https://tools.ietf.org/html/rfc9110#section-15.6.1",
  "title": "Internal Server Error",
  "detail": "An unexpected error occurred.",
  "status": 500
}
```

---

## Tipik Kullanim Akisi

```
┌─────────────────────────────────────────────────────────────┐
│                     KULLANICI AKISI                          │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  1. LOGIN                                                   │
│     Firebase Auth ile giris yap → ID token al               │
│                                                             │
│  2. ONBOARDING (ilk kullanim)                               │
│     7 soru sor → cevaplari {q1:8, q2:5, ...} olarak sakla   │
│                                                             │
│  3. GUNLUK GOREV ONERISI                                    │
│     POST /api/v1/recommendations                            │
│     Body: { industry, answers }                             │
│     → Sirali gorev listesi alir                             │
│                                                             │
│  4. KULLANICI GOREVI ISLER                                  │
│     Gorevi gorur → Done / Snooze / Dismiss / Blacklist      │
│     POST /api/v1/feedbacks                                  │
│     Body: { industry, taskId, action, dismissReason? }      │
│                                                             │
│  5. TEKRAR ONER (opsiyonel)                                 │
│     Feedback sonrasi listeyi guncellemek icin                │
│     tekrar POST /api/v1/recommendations cagrilir            │
│     → Feedback'e gore guncel liste gelir                    │
│                                                             │
│  6. ERTESI GUN                                              │
│     Adim 3'ten tekrar basla                                 │
│     (Snooze edilenler geri gelir, Done 3 gun sonra gelir)   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Ornek: Tam Bir Oturum (cURL)

```bash
# 1. Token al (Firebase Auth REST API — test amacli)
TOKEN=$(curl -s -X POST \
  "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=FIREBASE_WEB_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"123456","returnSecureToken":true}' \
  | jq -r '.idToken')

# 2. Oneri al
curl -X POST https://salesgrowthsteps.com/api/v1/recommendations \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "industry": "rest",
    "answers": {"q1":8,"q2":5,"q3":3,"q4":9,"q5":7,"q6":2,"q7":6}
  }'

# 3. Gorevi tamamla
curl -X POST https://salesgrowthsteps.com/api/v1/feedbacks \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "industry": "rest",
    "taskId": "task_rest_001",
    "action": "Done"
  }'

# 4. Gorevi reddet (neden zorunlu)
curl -X POST https://salesgrowthsteps.com/api/v1/feedbacks \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "industry": "rest",
    "taskId": "task_rest_015",
    "action": "Dismiss",
    "dismissReason": "Isletmem icin uygun degil"
  }'

# 5. Gorevi kalici engelle
curl -X POST https://salesgrowthsteps.com/api/v1/feedbacks \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "industry": "rest",
    "taskId": "task_rest_042",
    "action": "Blacklist"
  }'

# 6. Guncellenmis onerileri al
curl -X POST https://salesgrowthsteps.com/api/v1/recommendations \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "industry": "rest",
    "answers": {"q1":8,"q2":5,"q3":3,"q4":9,"q5":7,"q6":2,"q7":6}
  }'
# → task_rest_001 (Done, 3 gun cooldown) ve task_rest_042 (Blacklist) listede OLMAZ
# → task_rest_015 (Dismiss) dusuk skorla gorunur
```

---

## Onemli Notlar

1. **`answers` her istekte gonderilir** — API stateless, kullanici profilini saklamaz. Onboarding cevaplari client tarafinda saklanip her recommendation isteginde gonderilmelidir.

2. **`industry` hem recommendations hem feedbacks'te ayni olmali** — `"rest"` sektoru icin alinan gorevlere `"rest"` olarak feedback verilmelidir.

3. **`taskId` recommendations'dan gelir** — Feedback gonderirken, recommendations response'undaki `taskId` degerini kullanin. Gecersiz taskId → 404 hatasi.

4. **Rate limit** — Recommendations: 60 istek/dakika, Feedbacks: 20 istek/dakika. Asilirsa 429 doner, `Retry-After` header'a bakin.

5. **Token yenileme** — Firebase token 1 saat gecerli. 401 alirsan token'i yenile ve tekrar dene.

6. **Buyuk/kucuk harf** — `action` alani case-insensitive: `"done"`, `"Done"`, `"DONE"` hepsi gecerli.

7. **dismissReason kurali** — Sadece `Dismiss` action'inda zorunlu ve sadece `Dismiss`'te gonderilmeli. Diger action'larda gonderilirse validation hatasi alirsiniz.

---

## Gecerli Industry Kodlari

| Kod | Sektor | Firestore Collection |
|-----|--------|---------------------|
| `rest` | Restoran | `rest_week` |
| `cafe` | Kafe | `cafe_week` |

> Yeni sektorler eklenecek: `barber` (berber), `hotel` (otel) vb.
> Yeni sektor eklendiginde bu tabloya eklenir.
