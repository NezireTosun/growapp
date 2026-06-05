import 'package:growapp/core/utils/app_logger.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:translator/translator.dart';

class FirestoreSeeder {
  static Future<void> seedAll() async {
    await _seedCollection(
      collectionName: 'rest_week',
      assetPath: 'assets/data/rest_week_data.json',
    );
    await _seedCollection(
      collectionName: 'cafe_week',
      assetPath: 'assets/data/cafe_week_data.json',
    );
    await _seedBusinessTypes();
    await _seedStatusTypes();
    await _seedPlans();
    await _migrateTasksIndustryToBusinessType();
    await _migrateTasksCleanup();
    await _reindexTaskIds();
    await seedPrivacyPolicy();
    // Blog seeding runs separately (background) — see splash_page.dart
  }

  static Future<void> seedPrivacyPolicy() async {
    final db = FirebaseFirestore.instance;
    final ref = db.collection('privacy_policy').doc('main');
    final existing = await ref.get();
    if (existing.exists) {
      AppLogger.d('[FirestoreSeeder]', 'privacy_policy zaten mevcut, atlanıyor.');
      return;
    }
    AppLogger.d('[FirestoreSeeder]', 'privacy_policy seed ediliyor...');

    await ref.set({
      'title': {
        'tr': 'Gizlilik Politikası',
        'en': 'Privacy Policy',
        'de': 'Datenschutzrichtlinie',
        'es': 'Política de Privacidad',
        'cs': 'Zásady ochrany osobních údajů',
      },
      'updated': {
        'tr': 'Son Güncelleme: 8 Nisan 2026',
        'en': 'Last Updated: April 8, 2026',
        'de': 'Zuletzt aktualisiert: 8. April 2026',
        'es': 'Última actualización: 8 de abril de 2026',
        'cs': 'Poslední aktualizace: 8. dubna 2026',
      },
      'sections': [
        {
          'title': {
            'tr': '1. Veri Sorumluluğu Beyanı',
            'en': '1. Data Controller Declaration',
            'de': '1. Erklärung zur Datenverantwortung',
            'es': '1. Declaración de Responsabilidad de Datos',
            'cs': '1. Prohlášení o odpovědnosti za data',
          },
          'body': {
            'tr': 'Hizmetlerimi kullanırken paylaştığınız veriler, 6698 sayılı Kişisel Verilerin Korunması Kanunu (KVKK) ve uluslararası veri koruma standartları çerçevesinde işlenmektedir. Verilerinizin güvenliği, teknik ve idari tedbirlerle en üst düzeyde muhafaza edilmektedir.',
            'en': 'The data you share while using my services is processed in accordance with applicable international data protection standards, including GDPR. Your data security is maintained at the highest level through technical and administrative measures.',
            'de': 'Die Daten, die Sie bei der Nutzung meiner Dienste teilen, werden gemäß der DSGVO und internationalen Datenschutzstandards verarbeitet. Die Sicherheit Ihrer Daten wird durch technische und administrative Maßnahmen auf höchstem Niveau gewährleistet.',
            'es': 'Los datos que compartes al usar mis servicios se procesan de acuerdo con el RGPD y los estándares internacionales de protección de datos. La seguridad de tus datos se mantiene al más alto nivel mediante medidas técnicas y administrativas.',
            'cs': 'Data, která sdílíte při používání mých služeb, jsou zpracovávána v souladu s GDPR a mezinárodními standardy ochrany dat. Bezpečnost vašich dat je zajištěna na nejvyšší úrovni technickými a administrativními opatřeními.',
          },
        },
        {
          'title': {
            'tr': '2. İşlenen Veri Kategorileri',
            'en': '2. Categories of Data Collected',
            'de': '2. Kategorien der erhobenen Daten',
            'es': '2. Categorías de Datos Recopilados',
            'cs': '2. Kategorie shromažďovaných údajů',
          },
          'body': {
            'tr': '• Kimlik ve İletişim Bilgileri: Kayıt ve profil oluşturma aşamasında sağladığınız ad, soyad ve e-posta adresi.\n\n• Abonelik ve Finansal Veriler: Satın aldığınız hizmet paketlerine ilişkin işlem geçmişi ve ödeme doğrulama kayıtları. Bu süreçler teknik olarak RevenueCat altyapısı ile güvence altına alınmaktadır.\n\n• Teknik Tanılama Verileri: Sistem hatalarının tespiti ve kullanıcı deneyiminin iyileştirilmesi amacıyla toplanan hata günlükleri ve uygulama içi istatistikler.',
            'en': '• Identity & Contact Information: Your name, surname, and email address provided during registration.\n\n• Subscription & Financial Data: Transaction history and payment verification records related to your purchased service packages. These processes are secured by RevenueCat infrastructure.\n\n• Technical Diagnostics: Crash logs and in-app statistics collected to detect system errors and improve user experience.',
            'de': '• Identitäts- und Kontaktdaten: Ihr Name, Nachname und Ihre E-Mail-Adresse bei der Registrierung.\n\n• Abonnement- und Finanzdaten: Transaktionshistorie und Zahlungsverifizierungen. Diese Prozesse werden durch die RevenueCat-Infrastruktur gesichert.\n\n• Technische Diagnosedaten: Absturzprotokolle und In-App-Statistiken zur Fehlererkennung und Verbesserung der Nutzererfahrung.',
            'es': '• Identidad e Información de Contacto: Tu nombre, apellido y correo electrónico proporcionados durante el registro.\n\n• Datos de Suscripción y Financieros: Historial de transacciones y registros de verificación de pagos. Estos procesos están asegurados por la infraestructura de RevenueCat.\n\n• Datos de Diagnóstico Técnico: Registros de errores y estadísticas dentro de la app para detectar fallas y mejorar la experiencia del usuario.',
            'cs': '• Identifikační a kontaktní údaje: Vaše jméno, příjmení a e-mailová adresa zadané při registraci.\n\n• Data o předplatném a platbách: Historie transakcí a záznamy o ověření plateb. Tyto procesy jsou zabezpečeny infrastrukturou RevenueCat.\n\n• Technická diagnostická data: Protokoly chyb a statistiky v aplikaci pro zjišťování chyb a zlepšování uživatelské zkušenosti.',
          },
        },
        {
          'title': {
            'tr': '3. Veri İşleme Amaçlarım',
            'en': '3. Purposes of Data Processing',
            'de': '3. Zwecke der Datenverarbeitung',
            'es': '3. Finalidades del Tratamiento de Datos',
            'cs': '3. Účely zpracování dat',
          },
          'body': {
            'tr': '• Hizmet Sunumu: Kişiselleştirilmiş kullanıcı hesabınızın yönetilmesi ve uygulama özelliklerinin aktif edilmesi.\n\n• Ödeme ve Hak Yönetimi: Abonelik süreçlerinizin doğrulanması ve hizmet kesintilerinin önlenmesi.\n\n• Güvenlik ve Denetim: Platformun kötü niyetli kullanımlardan korunması ve yasal mevzuata tam uyum sağlanması.',
            'en': '• Service Delivery: Managing your personalized user account and activating app features.\n\n• Payment & Entitlement Management: Verifying subscription processes and preventing service interruptions.\n\n• Security & Compliance: Protecting the platform from misuse and ensuring full legal compliance.',
            'de': '• Dienstleistungserbringung: Verwaltung Ihres personalisierten Benutzerkontos und Aktivierung von App-Funktionen.\n\n• Zahlungs- und Rechteverwaltung: Überprüfung von Abonnementprozessen und Verhinderung von Dienstunterbrechungen.\n\n• Sicherheit & Compliance: Schutz der Plattform vor Missbrauch und Einhaltung gesetzlicher Vorschriften.',
            'es': '• Prestación del Servicio: Gestión de tu cuenta de usuario personalizada y activación de funciones de la app.\n\n• Gestión de Pagos y Derechos: Verificación de procesos de suscripción y prevención de interrupciones del servicio.\n\n• Seguridad y Cumplimiento: Protección de la plataforma contra usos indebidos y cumplimiento legal.',
            'cs': '• Poskytování služeb: Správa vašeho personalizovaného uživatelského účtu a aktivace funkcí aplikace.\n\n• Správa plateb a nároků: Ověření procesů předplatného a prevence přerušení služby.\n\n• Bezpečnost a compliance: Ochrana platformy před zneužitím a zajištění souladu s právními předpisy.',
          },
        },
        {
          'title': {
            'tr': '4. Üçüncü Taraflarla Veri Paylaşımı',
            'en': '4. Data Sharing with Third Parties',
            'de': '4. Datenweitergabe an Dritte',
            'es': '4. Compartición de Datos con Terceros',
            'cs': '4. Sdílení dat s třetími stranami',
          },
          'body': {
            'tr': 'Kişisel verilerinizi asla ticari amaçla satmam veya pazarlamam. Verileriniz yalnızca aşağıdaki güvenilir servis sağlayıcılarla paylaşılır:\n\n• Google Cloud & Firebase: Verilerinizin yüksek güvenlikli bulut sunucularda saklanması ve kimlik doğrulama işlemleri için.\n\n• RevenueCat: Abonelik sistemlerinin teknik altyapısı ve dijital ödeme doğrulamaları için.',
            'en': 'I never sell or market your personal data for commercial purposes. Your data is shared only with the following trusted service providers:\n\n• Google Cloud & Firebase: For storing your data on secure cloud servers and authentication.\n\n• RevenueCat: For the technical infrastructure of subscription systems and digital payment verifications.',
            'de': 'Ich verkaufe oder vermarkte Ihre persönlichen Daten niemals zu kommerziellen Zwecken. Ihre Daten werden nur mit folgenden vertrauenswürdigen Dienstleistern geteilt:\n\n• Google Cloud & Firebase: Für die sichere Speicherung Ihrer Daten und Authentifizierung.\n\n• RevenueCat: Für die technische Infrastruktur des Abonnementsystems und digitale Zahlungsverifizierungen.',
            'es': 'Nunca vendo ni comercializo tus datos personales. Tus datos solo se comparten con los siguientes proveedores de confianza:\n\n• Google Cloud & Firebase: Para almacenamiento seguro y autenticación.\n\n• RevenueCat: Para la infraestructura técnica del sistema de suscripción y verificaciones de pago.',
            'cs': 'Vaše osobní údaje nikdy neprodávám ani neposkytuji pro komerční účely. Vaše data jsou sdílena pouze s následujícími důvěryhodnými poskytovateli:\n\n• Google Cloud & Firebase: Pro bezpečné ukládání dat a autentizaci.\n\n• RevenueCat: Pro technickou infrastrukturu systému předplatného a ověřování digitálních plateb.',
          },
        },
        {
          'title': {
            'tr': '5. Veri Güvenliği ve Saklama İlkeleri',
            'en': '5. Data Security & Retention',
            'de': '5. Datensicherheit & Aufbewahrung',
            'es': '5. Seguridad y Retención de Datos',
            'cs': '5. Bezpečnost a uchovávání dat',
          },
          'body': {
            'tr': 'Verileriniz, iletim aşamasında SSL/TLS şifreleme yöntemleriyle korunmaktadır. Verileriniz, hesabınız aktif olduğu sürece güvenli bulut veritabanlarımda saklanır. Hesabınızı silmeniz durumunda tüm kişisel verileriniz kalıcı olarak imha edilir.',
            'en': 'Your data is protected during transmission using SSL/TLS encryption. Your data is securely stored in my cloud databases as long as your account is active. If you delete your account, all your personal data will be permanently destroyed.',
            'de': 'Ihre Daten werden während der Übertragung durch SSL/TLS-Verschlüsselung geschützt. Ihre Daten werden sicher in meinen Cloud-Datenbanken gespeichert, solange Ihr Konto aktiv ist. Wenn Sie Ihr Konto löschen, werden alle Ihre persönlichen Daten dauerhaft vernichtet.',
            'es': 'Tus datos están protegidos durante la transmisión mediante cifrado SSL/TLS. Tus datos se almacenan de forma segura mientras tu cuenta esté activa. Si eliminas tu cuenta, todos tus datos personales serán destruidos permanentemente.',
            'cs': 'Vaše data jsou při přenosu chráněna šifrováním SSL/TLS. Data jsou bezpečně uložena v mých cloudových databázích po dobu aktivity vašeho účtu. Pokud svůj účet smažete, všechna vaše osobní data budou trvale zničena.',
          },
        },
        {
          'title': {
            'tr': '6. Kullanıcı Hakları ve Veri İmhası',
            'en': '6. User Rights & Data Deletion',
            'de': '6. Nutzerrechte & Datenlöschung',
            'es': '6. Derechos del Usuario y Eliminación de Datos',
            'cs': '6. Práva uživatelů a smazání dat',
          },
          'body': {
            'tr': 'KVKK kapsamında aşağıdaki haklara sahipsiniz:\n\n• Verilerinizin işlenip işlenmediğini öğrenme\n• Yanlış veya eksik verilerin düzeltilmesini isteme\n• Verilerinizin silinmesini veya anonim hale getirilmesini talep etme\n\nHesabınızı ve tüm ilişkili verilerinizi uygulama içindeki Ayarlar bölümünden kalıcı olarak silebilirsiniz.',
            'en': 'You have the following rights regarding your data:\n\n• Right to know whether your data is being processed\n• Right to request correction of incorrect or incomplete data\n• Right to request deletion or anonymization of your data\n\nYou can permanently delete your account and all associated data from the Settings section within the app.',
            'de': 'Sie haben folgende Rechte bezüglich Ihrer Daten:\n\n• Recht zu erfahren, ob Ihre Daten verarbeitet werden\n• Recht auf Berichtigung falscher oder unvollständiger Daten\n• Recht auf Löschung oder Anonymisierung Ihrer Daten\n\nSie können Ihr Konto und alle zugehörigen Daten dauerhaft im Einstellungsbereich der App löschen.',
            'es': 'Tienes los siguientes derechos sobre tus datos:\n\n• Derecho a saber si tus datos están siendo procesados\n• Derecho a solicitar la corrección de datos incorrectos o incompletos\n• Derecho a solicitar la eliminación o anonimización de tus datos\n\nPuedes eliminar permanentemente tu cuenta y todos los datos asociados desde la sección de Ajustes en la app.',
            'cs': 'Máte následující práva ohledně svých dat:\n\n• Právo vědět, zda jsou vaše data zpracovávána\n• Právo požádat o opravu nesprávných nebo neúplných dat\n• Právo požádat o smazání nebo anonymizaci vašich dat\n\nSvůj účet a všechna přidružená data můžete trvale smazat v sekci Nastavení v aplikaci.',
          },
        },
        {
          'title': {
            'tr': '7. İletişim',
            'en': '7. Contact',
            'de': '7. Kontakt',
            'es': '7. Contacto',
            'cs': '7. Kontakt',
          },
          'body': {
            'tr': 'Bu gizlilik politikası hakkında daha fazla bilgi almak veya haklarınızı kullanmak için:\n\n• E-posta: info@salesgrowthsteps.com\n• Uygulama içi destek: Ayarlar → Destek',
            'en': 'For more information about this privacy policy or to exercise your rights:\n\n• Email: info@salesgrowthsteps.com\n• In-app support: Settings → Support',
            'de': 'Für weitere Informationen zu dieser Datenschutzrichtlinie oder zur Ausübung Ihrer Rechte:\n\n• E-Mail: info@salesgrowthsteps.com\n• In-App-Support: Einstellungen → Support',
            'es': 'Para más información sobre esta política de privacidad o para ejercer tus derechos:\n\n• Correo: info@salesgrowthsteps.com\n• Soporte en la app: Ajustes → Soporte',
            'cs': 'Pro více informací o těchto zásadách nebo k uplatnění svých práv:\n\n• E-mail: info@salesgrowthsteps.com\n• Podpora v aplikaci: Nastavení → Podpora',
          },
        },
      ],
    });
    AppLogger.d('[FirestoreSeeder]', 'privacy_policy seed tamamlandı.');
  }

  /// Re-index task document IDs: convert "cafe_004" style IDs to numeric "1", "2", ...
  static Future<void> _reindexTaskIds() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('tasks').get();

    if (snapshot.docs.isEmpty) {
      _log('tasks koleksiyonu boş, reindex atlanıyor.');
      return;
    }

    // Check if already reindexed
    final metaDoc = await firestore.collection('_migrations').doc('reindex_tasks_v2_task_id').get();
    if (metaDoc.exists) {
      _log('tasks reindex (task_id) zaten yapılmış, atlanıyor.');
      return;
    }

    // Check if migration needed: any doc still has 'id' field or missing 'task_id'
    final needsMigration = snapshot.docs.any((d) {
      final data = d.data();
      return data.containsKey('id') || !data.containsKey('task_id');
    });
    if (!needsMigration) {
      _log('tasks zaten task_id kullanıyor, atlanıyor.');
      await firestore.collection('_migrations').doc('reindex_tasks_v2_task_id').set({
        'completed_at': FieldValue.serverTimestamp(),
        'note': 'already has task_id',
      });
      return;
    }

    _log('tasks reindex başlıyor: ${snapshot.docs.length} kayıt ("cafe_004" → sayısal)...');

    // Sort docs by the numeric part of their ID for consistent ordering
    final docs = snapshot.docs.toList();
    docs.sort((a, b) {
      final aNum = _extractNumber(a.id);
      final bNum = _extractNumber(b.id);
      return aNum.compareTo(bNum);
    });

    // Assign sequential numeric IDs: 1, 2, 3, ...
    final batchSize = 225;
    for (var i = 0; i < docs.length; i += batchSize) {
      final batch = firestore.batch();
      final end = (i + batchSize < docs.length) ? i + batchSize : docs.length;

      for (var j = i; j < end; j++) {
        final doc = docs[j];
        final newId = (j + 1).toString(); // 1-based sequential
        final data = Map<String, dynamic>.from(doc.data());
        // Remove old 'id' field, use 'task_id' as int
        data.remove('id');
        data['task_id'] = j + 1;

        // Create new doc with numeric ID
        batch.set(firestore.collection('tasks').doc(newId), data);
        // Delete old doc with string ID (only if different)
        if (doc.id != newId) {
          batch.delete(doc.reference);
        }
      }
      await batch.commit();
    }

    // Mark migration as done
    await firestore.collection('_migrations').doc('reindex_tasks_v2_task_id').set({
      'completed_at': FieldValue.serverTimestamp(),
      'total': docs.length,
    });

    _log('tasks reindex tamamlandı: ${docs.length} kayıt → id kaldırıldı, task_id (int) eklendi.');
  }

  /// Extract numeric part from IDs like "cafe_004" → 4, "rest_012" → 12, "5" → 5
  static int _extractNumber(String id) {
    final match = RegExp(r'(\d+)').firstMatch(id);
    return match != null ? int.parse(match.group(1)!) : 0;
  }

  /// Migrate 'tasks' collection: fix business_typer → business_type (cafe→1, restoran→2)
  static Future<void> _migrateTasksIndustryToBusinessType() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('tasks').get();

    if (snapshot.docs.isEmpty) {
      _log('tasks koleksiyonu boş, migration atlanıyor.');
      return;
    }

    final firstData = snapshot.docs.first.data();

    // Already migrated
    if (firstData.containsKey('business_type') &&
        !firstData.containsKey('business_typer') &&
        !firstData.containsKey('industry')) {
      _log('tasks zaten migrate edilmiş, atlanıyor.');
      return;
    }

    // Find source field: business_typer (typo) or industry
    String? sourceField;
    if (firstData.containsKey('business_typer')) {
      sourceField = 'business_typer';
    } else if (firstData.containsKey('industry')) {
      sourceField = 'industry';
    }

    if (sourceField == null) {
      _log('tasks: kaynak alan bulunamadı, alanlar: ${firstData.keys.toList()}');
      return;
    }

    _log('tasks: $sourceField → business_type migration başlıyor...');

    final batchSize = 450;
    int updated = 0;
    final docs = snapshot.docs;

    for (var i = 0; i < docs.length; i += batchSize) {
      final batch = firestore.batch();
      final end = (i + batchSize < docs.length) ? i + batchSize : docs.length;

      for (var j = i; j < end; j++) {
        final doc = docs[j];
        final data = doc.data();
        final value = (data[sourceField] ?? '').toString().toLowerCase();

        int businessType = 0;
        if (value.contains('cafe') || value.contains('kahve') || value.contains('coffee') || value == '1') {
          businessType = 1;
        } else if (value.contains('restoran') || value.contains('restaurant') || value == '2') {
          businessType = 2;
        }

        batch.update(doc.reference, {
          'business_type': businessType,
          sourceField: FieldValue.delete(),
        });
        updated++;
      }
      await batch.commit();
    }
    _log('tasks: $updated kayıtta $sourceField → business_type olarak güncellendi.');
  }

  /// Migrate 'tasks' collection: remove 'no' field, ensure 'business_type' exists
  static Future<void> _migrateTasksCleanup() async {
    final firestore = FirebaseFirestore.instance;
    final snapshot = await firestore.collection('tasks').get();

    if (snapshot.docs.isEmpty) {
      _log('tasks koleksiyonu boş, cleanup atlanıyor.');
      return;
    }

    // Check if migration is needed
    final firstData = snapshot.docs.first.data();
    if (!firstData.containsKey('no') && firstData.containsKey('business_type')) {
      _log('tasks cleanup zaten yapılmış, atlanıyor.');
      return;
    }

    _log('tasks cleanup başlıyor (no silme, business_type kontrol)...');
    final batchSize = 450;
    int updated = 0;

    for (var i = 0; i < snapshot.docs.length; i += batchSize) {
      final batch = firestore.batch();
      final end = (i + batchSize < snapshot.docs.length) ? i + batchSize : snapshot.docs.length;

      for (var j = i; j < end; j++) {
        final doc = snapshot.docs[j];
        final data = doc.data();
        final updates = <String, dynamic>{};

        if (data.containsKey('no')) {
          updates['no'] = FieldValue.delete();
        }

        if (!data.containsKey('business_type')) {
          // Guess from doc ID: try to match cafe_week or rest_week
          updates['business_type'] = 0;
        }

        if (updates.isNotEmpty) {
          batch.update(doc.reference, updates);
          updated++;
        }
      }
      await batch.commit();
    }
    _log('tasks cleanup: $updated kayıt güncellendi.');
  }

  static Future<void> _seedPlans() async {
    final firestore = FirebaseFirestore.instance;
    final col = firestore.collection('plans');

    final existing = await col.get();
    if (existing.docs.length == 2) {
      _log('plans zaten 2 kayıt içeriyor, atlanıyor.');
      return;
    }

    if (existing.docs.isNotEmpty) {
      final batch = firestore.batch();
      for (final doc in existing.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    final batch = firestore.batch();
    batch.set(col.doc('free'), {
      'name': {'tr': 'Ücretsiz', 'en': 'Free'},
      'price': 0,
      'max_businesses': 1,
      'max_members_per_business': 1,
      'features': ['daily_tasks', 'blog'],
      'is_active': true,
      'order': 0,
    });
    batch.set(col.doc('premium'), {
      'name': {'tr': 'Premium', 'en': 'Premium'},
      'price': 99,
      'max_businesses': 5,
      'max_members_per_business': 3,
      'features': ['daily_tasks', 'blog', 'analytics', 'ai_insights', 'multi_business'],
      'is_active': true,
      'order': 1,
    });
    await batch.commit();
    _log('2 plan kaydı oluşturuldu (free + premium).');
  }

  static Future<void> _seedStatusTypes() async {
    final firestore = FirebaseFirestore.instance;
    final col = firestore.collection('status_types');

    final existing = await col.get();
    if (existing.docs.length == 4) {
      _log('status_types zaten 4 kayıt içeriyor, atlanıyor.');
      return;
    }

    if (existing.docs.isNotEmpty) {
      final batch = firestore.batch();
      for (final doc in existing.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    final types = {
      '0': {
        'name': {'tr': 'Yaptım', 'en': 'Done', 'de': 'Erledigt', 'cs': 'Hotovo', 'es': 'Hecho'},
        'status_type': 0,
        'icon': 'check_circle',
        'color': '#4CAF50',
      },
      '1': {
        'name': {'tr': 'Daha Sonra', 'en': 'Later', 'de': 'Später', 'cs': 'Později', 'es': 'Más tarde'},
        'status_type': 1,
        'icon': 'snooze',
        'color': '#FF9800',
      },
      '2': {
        'name': {'tr': 'Yapmayacağım', 'en': 'Won\'t Do', 'de': 'Geht nicht', 'cs': 'Neudělám', 'es': 'No lo haré'},
        'status_type': 2,
        'icon': 'cancel',
        'color': '#F44336',
      },
      '3': {
        'name': {'tr': 'Bir Daha Önerme', 'en': 'Never Suggest', 'de': 'Nie vorschlagen', 'cs': 'Nikdy nenavrhovat', 'es': 'No sugerir nunca'},
        'status_type': 3,
        'icon': 'block',
        'color': '#9E9E9E',
      },
    };

    final batch = firestore.batch();
    for (final entry in types.entries) {
      batch.set(col.doc(entry.key), entry.value);
    }
    await batch.commit();
    _log('4 status_types kaydı oluşturuldu (0-3).');
  }

  static Future<void> _seedBusinessTypes() async {
    final firestore = FirebaseFirestore.instance;
    final col = firestore.collection('business_types');

    final types = {
      '1': {'name': {'tr': 'Cafe', 'en': 'Cafe', 'de': 'Café', 'cs': 'Kavárna', 'es': 'Cafetería'}, 'icon': 'local_cafe', 'is_available': true, 'business_type': 1},
      '2': {'name': {'tr': 'Restoran', 'en': 'Restaurant', 'de': 'Restaurant', 'cs': 'Restaurace', 'es': 'Restaurante'}, 'icon': 'restaurant', 'is_available': true, 'business_type': 2},
      '3': {'name': {'tr': 'Bijuteri', 'en': 'Jewelry', 'de': 'Schmuck', 'cs': 'Šperky', 'es': 'Joyería'}, 'icon': 'diamond', 'is_available': false, 'business_type': 3},
      '4': {'name': {'tr': 'Servis', 'en': 'Service', 'de': 'Dienstleistung', 'cs': 'Služba', 'es': 'Servicio'}, 'icon': 'build', 'is_available': false, 'business_type': 4},
    };

    // Always overwrite — ensure correct structure with name map and business_type
    final existing = await col.get();
    if (existing.docs.isNotEmpty) {
      final batch = firestore.batch();
      for (final doc in existing.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    final batch = firestore.batch();
    for (final entry in types.entries) {
      batch.set(col.doc(entry.key), entry.value);
    }
    await batch.commit();
    _log('4 business_type kaydı oluşturuldu (name, icon, business_type dahil).');
  }

  static Future<void> _seedCollection({
    required String collectionName,
    required String assetPath,
  }) async {
    final firestore = FirebaseFirestore.instance;

    final existing = await firestore.collection(collectionName).get();
    final jsonString = await rootBundle.loadString(assetPath);
    final List<dynamic> tasks = json.decode(jsonString);

    // Force re-seed if first doc still uses old 'id' field instead of 'task_id'
    final needsReseed = existing.docs.isNotEmpty &&
        (existing.docs.first.data().containsKey('id') && !existing.docs.first.data().containsKey('task_id'));

    if (!needsReseed && existing.docs.length == tasks.length) {
      // Check if migration needed: remove 'no' field, ensure 'task_id' and 'business_type' exist
      final firstData = existing.docs.first.data();
      final needsMigration = firstData.containsKey('no') ||
          !firstData.containsKey('task_id') ||
          !firstData.containsKey('business_type');

      if (needsMigration) {
        _log('$collectionName migration: no → task_id, business_type düzeltiliyor...');
        final batchSize = 450;
        for (var i = 0; i < existing.docs.length; i += batchSize) {
          final batch = firestore.batch();
          final end = (i + batchSize < existing.docs.length) ? i + batchSize : existing.docs.length;
          for (var j = i; j < end; j++) {
            final doc = existing.docs[j];
            final data = doc.data();
            // Find matching JSON task by doc ID
            final docIdNum = int.tryParse(doc.id);
            final jsonTask = tasks.firstWhere(
              (t) => t['task_id'] == docIdNum,
              orElse: () => null,
            );

            final updates = <String, dynamic>{};

            // Remove 'no' and old 'id' fields
            if (data.containsKey('no')) {
              updates['no'] = FieldValue.delete();
            }
            if (data.containsKey('id')) {
              updates['id'] = FieldValue.delete();
            }

            // Add 'task_id' if missing
            if (!data.containsKey('task_id') && docIdNum != null) {
              updates['task_id'] = docIdNum;
            }

            // Add 'business_type' if missing
            if (!data.containsKey('business_type') && jsonTask != null) {
              updates['business_type'] = jsonTask['business_type'];
            }

            if (updates.isNotEmpty) {
              batch.update(doc.reference, updates);
            }
          }
          await batch.commit();
        }
        _log('$collectionName ${existing.docs.length} kayıt migrate edildi.');
      } else {
        _log('$collectionName zaten güncel (${tasks.length} kayıt), atlanıyor.');
      }
      return;
    }

    if (existing.docs.isNotEmpty) {
      _log('$collectionName mevcut ${existing.docs.length} kayıt siliniyor...');
      final deleteBatch = firestore.batch();
      for (final doc in existing.docs) {
        deleteBatch.delete(doc.reference);
      }
      await deleteBatch.commit();
    }

    final batchSize = 450;
    for (var i = 0; i < tasks.length; i += batchSize) {
      final batch = firestore.batch();
      final end = (i + batchSize < tasks.length) ? i + batchSize : tasks.length;

      for (var j = i; j < end; j++) {
        final task = tasks[j];
        final docRef = firestore
            .collection(collectionName)
            .doc(task['task_id'].toString());
        batch.set(docRef, Map<String, dynamic>.from(task));
      }

      await batch.commit();
    }

    _log('${tasks.length} görev "$collectionName" koleksiyonuna yüklendi!');
  }

  // ───────── Blog Posts Seeder ─────────

  static Future<void> seedBlogPosts() async {
    final firestore = FirebaseFirestore.instance;
    final col = firestore.collection('blog_posts');

    final existing = await col.get();
    // Re-seed if first post has no image_url (old data)
    final needsReseed = existing.docs.isNotEmpty &&
        ((existing.docs.first.data()['image_url'] as String?) ?? '').isEmpty;
    if (existing.docs.length >= 10 && !needsReseed) {
      _log('blog_posts zaten ${existing.docs.length} kayıt içeriyor, atlanıyor.');
      return;
    }

    // Clear existing
    if (existing.docs.isNotEmpty) {
      final batch = firestore.batch();
      for (final doc in existing.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    }

    final translator = GoogleTranslator();
    final targetLocales = ['tr', 'de', 'es', 'cs'];
    final posts = _blogPostsData();

    for (int i = 0; i < posts.length; i++) {
      final post = posts[i];
      final titleEn = post['title'] as String;
      final summaryEn = post['summary'] as String;
      final contentEn = post['content'] as String;
      final tipsEn = List<String>.from(post['tips'] as List);

      final titleMap = <String, String>{'en': titleEn};
      final summaryMap = <String, String>{'en': summaryEn};
      final contentMap = <String, String>{'en': contentEn};
      final tipsMap = <String, List<String>>{'en': tipsEn};

      for (final locale in targetLocales) {
        try {
          titleMap[locale] =
              (await translator.translate(titleEn, from: 'en', to: locale)).text;
          summaryMap[locale] =
              (await translator.translate(summaryEn, from: 'en', to: locale)).text;

          // Translate content in chunks (max ~4000 chars per request)
          contentMap[locale] = await _translateLong(translator, contentEn, locale);

          final translatedTips = <String>[];
          for (final tip in tipsEn) {
            translatedTips.add(
                (await translator.translate(tip, from: 'en', to: locale)).text);
          }
          tipsMap[locale] = translatedTips;

          _log('Blog #${i + 1} → $locale çevirisi tamamlandı.');
        } catch (e) {
          _log('Blog #${i + 1} çeviri hatası ($locale): $e');
        }
      }

      // İlk iki blog post'a local asset görseli ata
      String imageUrl = '';
      if (i == 0) imageUrl = 'assets/images/blog/blog_1.png';
      if (i == 1) imageUrl = 'assets/images/blog/blog_2.jpg';

      await col.add({
        'title': titleMap,
        'summary': summaryMap,
        'content': contentMap,
        'tips': tipsMap,
        'category': post['category'],
        'is_published': true,
        'author_id': 'system',
        'image_url': imageUrl,
        'template': post['template'],
        'created_at': Timestamp.fromDate(
            DateTime.now().subtract(Duration(days: 10 - i))),
      });

      _log('Blog #${i + 1}: "$titleEn" Firestore\'a eklendi.');
    }

    _log('${posts.length} blog yazısı oluşturuldu ve çevrildi.');
  }

  static Future<String> _translateLong(
      GoogleTranslator translator, String text, String locale) async {
    if (text.length <= 4000) {
      return (await translator.translate(text, from: 'en', to: locale)).text;
    }

    // Split by paragraphs
    final paragraphs = text.split('\n\n');
    final translated = <String>[];
    var buffer = '';

    for (final p in paragraphs) {
      if ((buffer.length + p.length) > 3800 && buffer.isNotEmpty) {
        translated.add(
            (await translator.translate(buffer, from: 'en', to: locale)).text);
        buffer = p;
      } else {
        buffer = buffer.isEmpty ? p : '$buffer\n\n$p';
      }
    }
    if (buffer.isNotEmpty) {
      translated.add(
          (await translator.translate(buffer, from: 'en', to: locale)).text);
    }

    return translated.join('\n\n');
  }

  static List<Map<String, dynamic>> _blogPostsData() {
    return [
      {
        'title': 'Why Your Business Plan Is Collecting Dust (And What To Do About It)',
        'summary':
            'Most business plans fail not because the goals are wrong, but because they never turn into daily tasks. Learn how to close the execution gap.',
        'content':
            'You had a great meeting last month. Big ideas. Full whiteboard. Everyone excited. You walked out feeling like things were finally going to change. Then... nothing happened.\n\n'
            'You\'re Not Lazy. Your System Is Broken.\n\n'
            'Most small business owners think the problem is motivation. But here\'s what\'s really going on: The plan never turned into actual tasks. "Grow sales" is not a task. "Improve customer experience" is not a task. These are wishes. A real task sounds like: "Call 3 customers today and ask why they haven\'t come back."\n\n'
            'Consultants call it the Execution Gap — the space between what you decided to do and what actually gets done. And it\'s quietly killing more small businesses than bad marketing ever could.\n\n'
            'Why This Keeps Happening: Your tasks are too big. Everything feels equally urgent. Nobody checks what actually happened.\n\n'
            'The Fix Is Boring. That\'s Why It Works. The businesses that actually grow aren\'t the ones with the best plans. They\'re the ones that show up every day and do 2-3 small, focused things — consistently. Small. Consistent. Specific.\n\n'
            'One Question To Start With: Look at your business plan right now. Ask yourself: "What can I actually do tomorrow morning because of this?" If you can\'t answer that in 10 seconds, the plan isn\'t ready yet. Turn it into a task. Make it small enough to do before lunch. Do it tomorrow. Then do it again the next day. That\'s how the gap closes.',
        'tips': [
          'Turn big goals into small, specific daily tasks',
          'Focus on 2-3 actions per day, not a long to-do list',
          'Ask yourself: "What can I do tomorrow morning because of this?"',
          'Consistency beats ambition — show up every day',
          'Check what actually gets done, not just what was planned',
        ],
        'category': 'general',
        'template': null,
      },
      {
        'title': '7 Dimensions of Growth: Understanding the Q1–Q7 Growth Framework',
        'summary':
            'Growing a business is not only about ads or social media. The Q1-Q7 framework helps you focus on 7 key areas that drive stable, sustainable growth.',
        'content':
            'Many small businesses try different tactics — posting on Instagram, running Google Ads, giving discounts. Sometimes these work. Sometimes they don\'t. The real problem is focusing on random actions instead of a clear growth system.\n\n'
            'The Q1–Q7 framework is a simple way to check how healthy your business growth is. Instead of asking "How can we sell more?", it asks better questions like: Where do our customers come from? Are we making real profit? Do customers come back?\n\n'
            'The seven growth areas are:\n'
            'Q1 – Sales Channels: Where do your customers come from? Focus on your best-performing channel first.\n'
            'Q2 – Customer Acquisition: Build a simple system that regularly brings new customers.\n'
            'Q3 – Profit Awareness: Revenue is not profit. Know your real numbers after all costs.\n'
            'Q4 – Average Order Value: Help existing customers buy a little more with bundles, upsells, combos.\n'
            'Q5 – Trust and Reviews: People buy from businesses they trust. Collect reviews and social proof.\n'
            'Q6 – Customer Retention: Keeping existing customers is cheaper than acquiring new ones.\n'
            'Q7 – Operations and Efficiency: Sometimes growth problems are about operations, not marketing.\n\n'
            'Growth is not one trick. It usually comes from improving many small things together. When these seven areas work together, growth becomes more stable and easier to manage.',
        'tips': [
          'Identify your main sales channel and focus on it first',
          'Track how many new leads become customers each week',
          'Know your real profit per product, not just revenue',
          'Increase average order value with simple bundles and combos',
          'Collect customer reviews — trust is a powerful growth driver',
        ],
        'category': 'general',
        'template': null,
      },
      {
        'title': 'Why Most Small Businesses Struggle to Grow Sales (And How to Fix It)',
        'summary':
            'Sales feel unstable? The real issue is not lack of effort — it\'s the lack of a clear sales growth system. Here are the 6 most common problems and how to fix them.',
        'content':
            'Many small business owners work very hard. They post on social media, run ads, create promotions. But sales still feel unstable. Some months are good, some months are very slow.\n\n'
            'Problem 1: No Clear Sales Strategy. Many businesses try many things at once without a clear plan. Start by answering: Where do most of your customers come from? Which channel brings the best results?\n\n'
            'Problem 2: Trying Too Many Marketing Channels. Small teams can\'t manage all channels well. Choose 1-2 main channels and focus on them.\n\n'
            'Problem 3: Not Understanding Real Profit. Some businesses increase sales but still struggle financially. Track the real numbers behind every sale.\n\n'
            'Problem 4: Weak Online Visibility. If people cannot easily find your business, they will choose a competitor. Optimize your Google Maps profile and ask for reviews.\n\n'
            'Problem 5: Customers Do Not Come Back. Existing customers are often the easiest source of growth. Encourage repeat visits with loyalty programs and follow-up messages.\n\n'
            'Problem 6: No System for Daily Sales Actions. Growth often comes from small actions done consistently — responding quickly, contacting leads, asking for reviews.\n\n'
            'The key is to move away from random marketing and start building a simple, consistent growth system.',
        'tips': [
          'Focus on 1-2 marketing channels instead of spreading too thin',
          'Track real profit per sale, not just revenue',
          'Optimize your Google Maps profile for local visibility',
          'Build a retention strategy for existing customers',
          'Create a daily sales routine with small, consistent actions',
        ],
        'category': 'general',
        'template': null,
      },
      {
        'title': 'The Power of 3: Why 3 Small Tasks Every Morning Beat Any Business Plan',
        'summary':
            'Big plans fail because they don\'t survive a real workday. Three daily tasks, ranked by revenue impact, create more growth than any strategy meeting.',
        'content':
            'Let\'s be honest. You\'ve made a business plan before. It felt good. Then a week later, you were back to doing the same things. Not because you gave up — because the plan was too big to fit into a normal Tuesday.\n\n'
            'Big Plans Have a Big Problem. "Increase revenue by 30%" doesn\'t tell you what to do at 9am tomorrow. Big goals are important, but they don\'t show up to work in the morning. You do.\n\n'
            'Why 3 Tasks Change Everything. People who complete small, specific tasks every day grow faster than people with big, ambitious plans they rarely act on. Psychologists call it the "progress principle" — making visible progress keeps you motivated and moving forward.\n\n'
            'But Which 3 Tasks? The right 3 tasks are ranked by one thing only: what actually moves the money. Not what feels productive. Not what looks good on a report.\n\n'
            'Real Life Example: Tomáš runs a café in Prague. When he switched to a daily 3-task system ranked by revenue impact, three things happened: He moved his highest-margin item to the top of the menu. He started a "bring a friend" offer for slow hours. He updated his Google Business profile. None were genius ideas — the system just made sure they got done.\n\n'
            'The Rule Is Simple: Every morning, before the chaos starts, answer: "What are the 3 things I can do today that will have the biggest impact on my revenue?" Write them down. Do them before anything else. Then tomorrow, ask again. That\'s the whole system.',
        'tips': [
          'Pick 3 tasks each morning ranked by revenue impact',
          'Make tasks small enough to finish before lunch',
          'Focus on what moves money, not what feels urgent',
          'The progress principle: small wins create momentum',
          'Consistency beats ambition — do it every single day',
        ],
        'category': 'general',
        'template': null,
      },
      {
        'title': 'Google Maps Mastery: How to Become the #1 Choice for "Restaurants Nearby"',
        'summary':
            'Most customers choose from top Google Maps results. Simple steps like optimizing your profile, collecting reviews, and adding photos can dramatically improve your visibility.',
        'content':
            'When people are hungry, they open their phone and type "restaurants near me." Most choose one of the top results on Google Maps. If your business appears there, you get many new customers. If not, people may never see you.\n\n'
            'How Google Decides Which Businesses Show First: Relevance (how well you match the search), Distance (how close you are), and Prominence (how well known and trusted you are). Prominence is the biggest factor you can influence through reviews, ratings, photos, and profile activity.\n\n'
            'Step 1 — Optimize Your Google Business Profile. Include correct business name, accurate address, updated hours, phone number, and website link. Choose the right category.\n\n'
            'Step 2 — Get More Customer Reviews. Reviews are one of the strongest ranking factors. Ask happy customers politely, add review reminders on receipts, send follow-up messages.\n\n'
            'Step 3 — Add Attractive Photos. Food photos, interior, exterior, menu, and team photos. Profiles with many photos receive more attention.\n\n'
            'Step 4 — Keep Your Profile Active. Post updates, share promotions, add new photos, update menus, respond to reviews.\n\n'
            'Step 5 — Respond to Reviews. Reply to positive, negative, and questions. Even short responses make a difference.\n\n'
            'Step 6 — Build Local Trust. Appear in local directories, restaurant platforms, social media, and tourism websites.\n\n'
            'For local businesses, mastering Google Maps is often one of the simplest ways to grow sales.',
        'tips': [
          'Complete your Google Business profile with accurate details',
          'Collect more customer reviews — the strongest ranking factor',
          'Upload attractive food, interior, and team photos',
          'Keep your profile active with regular updates',
          'Respond to all reviews — positive and negative',
        ],
        'category': 'general',
        'template': null,
      },
      {
        'title': 'Daily Sales Tasks That Actually Increase Revenue',
        'summary':
            'Sales growth rarely comes from one big campaign. It comes from small actions done every day — follow-ups, reviews, visibility, and reconnecting with old customers.',
        'content':
            'Many business owners search for big marketing ideas — new advertising strategies, viral content, big promotions. But in reality, sales growth often comes from small actions done every day.\n\n'
            'Task 1 — Follow Up With Potential Customers. Many don\'t buy immediately. A short message like "Hi, just checking if you still need help" can turn a potential customer into a sale.\n\n'
            'Task 2 — Improve Your Online Visibility. Update your Google Maps profile, post on social media, share product photos, respond to questions online.\n\n'
            'Task 3 — Ask Customers for Reviews. Reviews are extremely powerful. Ask after a successful purchase, a positive conversation, or through a follow-up message.\n\n'
            'Task 4 — Improve Your Product or Offer. Small improvements to product descriptions, photos, prices, and menu presentation make a big difference.\n\n'
            'Task 5 — Reconnect With Old Customers. Existing customers are the easiest to sell to. Send special offers, announce new products, remind them about your service.\n\n'
            'Task 6 — Monitor What Is Working. Track new customers, repeat customers, popular products, and customer feedback.\n\n'
            'Think of it like fitness. Going to the gym once won\'t change your body. But regular workouts over time create big results. Sales growth works the same way.',
        'tips': [
          'Follow up with potential customers who haven\'t purchased yet',
          'Update your online presence daily for better visibility',
          'Ask happy customers for reviews after every good interaction',
          'Reconnect with past customers through special offers',
          'Track what works and focus your efforts there',
        ],
        'category': 'general',
        'template': null,
      },
      {
        'title': 'Your POS Is Lying To You (Not Really — But You\'re Reading It Wrong)',
        'summary':
            'More data doesn\'t mean better decisions. Focus on 3 key numbers: your highest margin item, your slowest hour, and how many customers came back.',
        'content':
            'Every morning, your system spits out numbers. Sales totals. Hourly breakdowns. Best sellers. You look at it, nod, close the tab, and make the same decisions you made yesterday.\n\n'
            'More Data Doesn\'t Mean Better Decisions. Data doesn\'t make decisions — you do. Most small business owners either ignore data completely or drown in it without knowing what the numbers mean.\n\n'
            'The 3 Numbers That Actually Matter:\n'
            '1. Your highest margin item — and how often it sells. Not your most popular item. Your most profitable one.\n'
            '2. Your slowest hour of the day. That empty hour is a missed opportunity sitting there every single day.\n'
            '3. How many customers came back. Returning customers are profitable. If you don\'t know your return rate, you don\'t really know if your business is growing.\n\n'
            'What To Do With What You Find. Discovered your slowest hour is Tuesday at 3pm? A simple WhatsApp message to regulars, a happy hour offer, a combo deal for that slot. The data showed the problem. A small, specific action fixes it.\n\n'
            'The Real Problem With Most Reports. Reports show what happened. They don\'t tell you what to do next. You need something to look at your numbers and say: "Based on this, do these 3 things today."\n\n'
            'Check these three numbers every morning. Make one decision based on them. That\'s it.',
        'tips': [
          'Know your highest margin item — not just the most popular',
          'Identify your slowest hours and create targeted offers',
          'Track returning customer rate as a key growth metric',
          'Turn data into one specific action per day',
          'Focus on 3 key numbers, not endless dashboards',
        ],
        'category': 'general',
        'template': null,
      },
      {
        'title': 'Menu Engineering 101: How to Find Your Star Products and Make More Money',
        'summary':
            'Most restaurants have 40 menu items but only 6 do the heavy lifting. Learn to classify items as Stars, Plowhorses, Puzzles, or Dogs — and act accordingly.',
        'content':
            'You have 40 items on your menu. But maybe 6 of them are doing all the heavy lifting. The rest are taking up space, confusing customers, and quietly costing you money.\n\n'
            'The 2 Questions That Change Everything. Every menu item is judged by: How much profit does it make? How often do people order it?\n\n'
            'Stars are high profit, high popularity — your golden items. Plowhorses sell a lot but don\'t make much money. Puzzles make great profit but nobody orders them — usually a visibility problem. Dogs are low profit and low popularity — they\'re on the menu for no good reason.\n\n'
            'What To Do With Each Group:\n'
            'Stars — Make them impossible to miss. Put them where the eye goes first. Train staff to mention them naturally.\n'
            'Plowhorses — Quiet price adjustment or smaller portion option. Don\'t kill them, make them work harder.\n'
            'Puzzles — Move them, give them a better name, add a description. Sometimes that\'s all it takes.\n'
            'Dogs — Remove them or replace with better items. A shorter menu is almost always more profitable.\n\n'
            'Real Example: A café owner discovered her popular sandwich had a 12% margin while a seasonal soup had 47%. She featured the soup more, mentioned it at the counter, put it on the specials board. Soup sales tripled within three weeks. Same menu. Smarter focus.',
        'tips': [
          'Classify menu items as Stars, Plowhorses, Puzzles, or Dogs',
          'Highlight Star items where customers look first',
          'Give Puzzle items better visibility and descriptions',
          'Remove Dog items — shorter menus are more profitable',
          'Calculate actual margin per item with current supplier prices',
        ],
        'category': 'general',
        'template': null,
      },
      {
        'title': 'From Chaos to System: Why Businesses Need a Sales Growth Framework',
        'summary':
            'When businesses rely on random marketing actions, growth becomes unpredictable. A simple framework turns scattered efforts into structured, consistent progress.',
        'content':
            'Many small businesses work very hard. Owners are busy every day with customer messages, social media, promotions, and daily problems. But even with all this activity, sales sometimes do not grow consistently.\n\n'
            'The Problem: Random Actions. Many businesses try Instagram, ads, discounts, influencer marketing — but these actions are often not connected to a larger plan. Marketing becomes inconsistent, teams focus on urgent instead of important, and results become unpredictable.\n\n'
            'What Is a Sales Growth Framework? A simple system that helps focus on actions that actually increase revenue. It answers: Where do our customers come from? What actions increase sales? What should we improve first?\n\n'
            'Signs Your Business Needs a Growth Framework:\n'
            '• Sales change randomly every month\n'
            '• Marketing feels disorganized\n'
            '• You try many ideas but results are unclear\n'
            '• You rely heavily on promotions or discounts\n'
            '• You\'re not sure which marketing channel works best\n\n'
            'Turning Chaos Into a System:\n'
            'Step 1 — Understand your sales channels and focus on the best ones.\n'
            'Step 2 — Create simple daily sales actions for consistent momentum.\n'
            'Step 3 — Improve customer retention with loyalty programs and follow-ups.\n'
            'Step 4 — Track what works with simple indicators.\n\n'
            'One of the biggest mistakes is searching for one big solution. Growth usually comes from many small improvements working together.',
        'tips': [
          'Identify your top-performing sales channels',
          'Create a simple daily sales routine',
          'Build retention systems for existing customers',
          'Track key metrics: new customers, repeat rate, order value',
          'Small improvements across multiple areas compound into big growth',
        ],
        'category': 'general',
        'template': null,
      },
      {
        'title': 'How to Turn Your Waiters Into Your Best Salespeople',
        'summary':
            'Your staff talk to every customer. With the right approach, natural upselling can increase average ticket without feeling pushy — and customers leave happier.',
        'content':
            'Nobody wants to be sold to. And most waiters don\'t want to sell either. It feels pushy. So they take the order, bring the food, and stay out of the way. The result? You\'re leaving money on every table.\n\n'
            'Upselling Isn\'t Selling. It\'s Helping. When a waiter says "The lamb is really good today — the chef got a fresh delivery," that doesn\'t feel like a sales pitch. It feels like a tip from someone who knows. That\'s good upselling.\n\n'
            'When To Speak:\n'
            '• When a customer is still looking at the menu and seems unsure — mention what\'s popular today.\n'
            '• When someone orders a main — mention a side that pairs well.\n'
            '• When plates are cleared and the table is relaxed — that\'s when dessert makes sense.\n\n'
            'What To Say: Add one specific detail to every suggestion. "We just got a new chocolate tart — it\'s been really popular this week" beats "Would you like dessert?" every time. Specific beats generic.\n\n'
            'The Bridge Phrase Method: A short, natural sentence connecting what they ordered to something extra.\n'
            '"Would you like something small with that? We have fresh pastries from this morning."\n'
            '"That comes with fries — want to add a sauce? The smoky one is really good with it."\n\n'
            'Make It A Team Habit: A quick 5-minute check before each shift. "What are we recommending today and why?" Staff share what worked. You highlight best-margin items. Even a 20% yes rate on these moments adds up to meaningful daily revenue.',
        'tips': [
          'Train staff to suggest, not sell — it should feel like service',
          'Use bridge phrases to naturally connect orders to extras',
          'Time suggestions right: menu browsing, main course, after clearing',
          'Add one specific detail to every recommendation',
          'Do a 5-minute pre-shift briefing on daily recommendations',
        ],
        'category': 'general',
        'template': null,
      },
    ];
  }


  static void _log(String message) {
    assert(() {
      AppLogger.d('[FirestoreSeeder]', message);
      return true;
    }());
  }
}
