// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get signIn => 'Giriş Yap';

  @override
  String get signUp => 'Üye olmak';

  @override
  String get welcomeBack =>
      'Tekrar hoş geldiniz! Devam etmek için giriş yapın.';

  @override
  String get createAccount => 'Kişisel bilgilerinizle hesabınızı oluşturun.';

  @override
  String get email => 'E-posta';

  @override
  String get password => 'Şifre';

  @override
  String get confirmPassword => 'Şifreyi Onayla';

  @override
  String get fullName => 'Ad Soyad';

  @override
  String get phoneNumber => 'Telefon Numarası';

  @override
  String get forgotPassword => 'Parolanızı mı unuttunuz?';

  @override
  String get forgotPasswordDesc =>
      'E-posta adresinizi girin, 6 haneli doğrulama kodu göndereceğiz.';

  @override
  String get resetPasswordButton => 'Şifreyi Sıfırla';

  @override
  String get resetPasswordSent => 'Kod Gönderildi!';

  @override
  String resetPasswordSentDesc(String email) {
    return '$email adresine 6 haneli kod gönderdik. Lütfen gelen kutunuzu kontrol edin.';
  }

  @override
  String get enterResetCode => 'E-postanıza gönderilen 6 haneli kodu girin.';

  @override
  String get createNewPassword => 'Yeni Şifre Oluştur';

  @override
  String get createNewPasswordDesc =>
      'Yeni şifreniz en az 6 karakter olmalıdır.';

  @override
  String get newPassword => 'Yeni Şifre';

  @override
  String get newPasswordHint => 'Yeni şifrenizi girin';

  @override
  String get confirmNewPassword => 'Yeni Şifreyi Onayla';

  @override
  String get confirmNewPasswordHint => 'Yeni şifrenizi tekrar girin';

  @override
  String get resetPasswordSuccess => 'Şifre başarıyla güncellendi!';

  @override
  String get resetPasswordSuccessDesc =>
      'Şifreniz değiştirildi. Yeni şifrenizle giriş yapabilirsiniz.';

  @override
  String get passwordResetExpired =>
      'Kodun süresi doldu. Lütfen yeni bir kod isteyin.';

  @override
  String get backToLogin => 'Girişe Dön';

  @override
  String get dontHaveAccount => 'Hesabınız yok mu?';

  @override
  String get alreadyHaveAccount => 'Zaten hesabınız var mı?';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get fullNameHint => 'Adınız ve soyadınız';

  @override
  String get phoneHint => '5XX XXX XX XX';

  @override
  String get enterEmail => 'Lütfen e-posta adresinizi girin.';

  @override
  String get validEmail => 'Lütfen geçerli bir e-posta adresi girin.';

  @override
  String get enterPassword => 'Lütfen şifrenizi girin.';

  @override
  String get enterAPassword => 'Lütfen bir şifre girin.';

  @override
  String get passwordMinLength =>
      'Parola en az 6 karakter uzunluğunda olmalıdır.';

  @override
  String get confirmYourPassword => 'Lütfen şifrenizi onaylayın.';

  @override
  String get passwordsNotMatch => 'Şifreler eşleşmiyor.';

  @override
  String get enterName => 'Lütfen adınızı girin.';

  @override
  String get enterPhone => 'Lütfen telefon numaranızı girin.';

  @override
  String get continueButton => 'Devam etmek';

  @override
  String get businessNameFallback => 'İşletmenizin Adı';

  @override
  String get enterBusinessName => 'İşletme adınızı girin';

  @override
  String get businessTypeFallback => 'İşletmenizin türü nedir?';

  @override
  String get comingSoon => 'YAKINDA GELECEK';

  @override
  String get analysisStep1 => 'Yanıtlarınızı inceliyorum...';

  @override
  String get analysisStep2 => 'İşletme türünüzü analiz ediyoruz...';

  @override
  String get analysisStep3 => 'Büyüme fırsatlarını belirlemek...';

  @override
  String get analysisStep4 => 'Kişiselleştirilmiş görevler hazırlanıyor...';

  @override
  String get analysisStep5 => 'Neredeyse hazır!';

  @override
  String get aiAnalyzingTitle => 'Yapay zeka işletmenizi analiz ediyor.';

  @override
  String get aiAnalyzingSubtitle => 'Bu işlem yalnızca bir dakika sürecek.';

  @override
  String get welcome => 'HOŞ GELDİN';

  @override
  String helloName(String name) {
    return 'Merhaba $name';
  }

  @override
  String get boostSales => 'Bugün satışlarınızı artıralım!';

  @override
  String dailyGoalsProgress(int completed, int total) {
    return 'Günlük hedeflerin $completed tanesinden $total tanesi tamamlandı';
  }

  @override
  String get details => 'Detaylar';

  @override
  String get statusCompleted => 'TAMAMLANMIŞ';

  @override
  String get statusViewed => 'GÖRÜNTÜLENDİ';

  @override
  String get statusWontDo => 'YAPMAYACAĞIM';

  @override
  String get statusDontSuggest => 'ÖNERMEYİN';

  @override
  String get highImpact => 'YÜKSEK ETKİ';

  @override
  String get medImpact => 'TIBBİ ETKİ';

  @override
  String get lowImpact => 'DÜŞÜK ETKİLİ';

  @override
  String minutesBadge(int minutes) {
    return '$minutes DAKİKA';
  }

  @override
  String get navHome => 'Ev';

  @override
  String get navAnalytics => 'Analitik';

  @override
  String get navBlog => 'Blog';

  @override
  String get navProfile => 'Profil';

  @override
  String get taskDetails => 'Görev Ayrıntıları';

  @override
  String dailyTaskCounter(int current, int total) {
    return 'GÜNLÜK GÖREV $current/$total';
  }

  @override
  String get whyItMakesMoney => 'Neden Para Kazandırıyor?';

  @override
  String get howToDoIt => 'Nasıl Yapılır';

  @override
  String get readyMadeTemplate => 'Hazır Şablon';

  @override
  String get copied => 'Kopyalandı';

  @override
  String get copy => 'Kopyala';

  @override
  String get wereHereToHelp => 'Yardımcı olmak için buradayız.';

  @override
  String get needHelpTask =>
      'Bu görevi tamamlamakta yardıma mı ihtiyacınız var?\n\nHemen ekibimizle iletişime geçin.';

  @override
  String get contactUs => 'Bize Ulaşın';

  @override
  String get done => 'Yaptım';

  @override
  String get illDoIt => 'Yapacağım';

  @override
  String get snooze => 'Daha Sonra Yapacağım';

  @override
  String get dontSuggest => 'Bir Daha Önerme';

  @override
  String get myBusiness => 'İşletmem';

  @override
  String get growthLevel => 'Büyüme Seviyesi 2';

  @override
  String get levelProgress => 'Seviye İlerlemesi';

  @override
  String get businessInfo => 'İŞ BİLGİLERİ';

  @override
  String get personalInfo => 'KİŞİSEL BİLGİLER';

  @override
  String get name => 'İsim';

  @override
  String get phone => 'Telefon';

  @override
  String get instagram => 'Instagram';

  @override
  String get city => 'Şehir';

  @override
  String get cityHint => 'Örn. İstanbul';

  @override
  String get updateInfo => 'Güncelleme Bilgileri';

  @override
  String get settings => 'AYARLAR';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get subscriptionPlan => 'Abonelik Planı';

  @override
  String get proPlan => 'Profesyonel Plan';

  @override
  String get aboutUs => 'Hakkımızda';

  @override
  String get aboutUsPageTitle => 'Hakkımızda';

  @override
  String get aboutUsDesc =>
      'GrowApp, kafe ve restoran sahiplerinin işletmelerini büyütmelerine yardımcı olan yapay zeka destekli bir platformdur.';

  @override
  String get aboutUsMission => 'Misyonumuz';

  @override
  String get aboutUsMissionDesc =>
      'Her küçük işletme sahibine, büyük şirketlerin sahip olduğu büyüme stratejilerini erişilebilir kılmak. Yapay zeka ile kişiselleştirilmiş günlük görevler sunarak işletmenizi adım adım büyütüyoruz.';

  @override
  String get aboutUsFeatures => 'Ne Sunuyoruz?';

  @override
  String get aboutUsFeature1 => 'Kişiselleştirilmiş günlük görevler';

  @override
  String get aboutUsFeature2 => 'Yapay zeka destekli iş danışmanlığı';

  @override
  String get aboutUsFeature3 => 'Hazır pazarlama şablonları';

  @override
  String get aboutUsFeature4 => 'İlerleme takibi ve analitik';

  @override
  String get aboutUsFeature5 => 'WhatsApp üzerinden görev bildirimleri';

  @override
  String get aboutUsVersion => 'Versiyon';

  @override
  String get aboutUsTeam => 'Ekip';

  @override
  String get aboutUsTeamDesc =>
      'Prag merkezli, küçük işletmelere tutkuyla bağlı bir ekip tarafından geliştirilmektedir.';

  @override
  String get contact => 'İletişim';

  @override
  String get contactPageTitle => 'İletişim';

  @override
  String get contactPageDesc =>
      'Sorularınız veya geri bildirimleriniz için bize ulaşabilirsiniz.';

  @override
  String get contactEmail => 'E-posta';

  @override
  String get contactEmailValue => 'info@salesgrowthsteps.com';

  @override
  String get contactPhone => 'Telefon';

  @override
  String get contactPhoneValue => '+90 850 123 45 67';

  @override
  String get contactWhatsapp => 'WhatsApp';

  @override
  String get contactAddress => 'Adres';

  @override
  String get contactAddressValue => 'Prag, Çek Cumhuriyeti';

  @override
  String get contactWorkingHours => 'Çalışma Saatleri';

  @override
  String get contactWorkingHoursValue => 'Pzt-Cum 09:00 - 18:00';

  @override
  String get sendUsMessage => 'Bize Mesaj Gönderin';

  @override
  String get messageSubject => 'Konu';

  @override
  String get messageSubjectHint => 'Mesajınızın konusu';

  @override
  String get messageBody => 'Mesaj';

  @override
  String get messageBodyHint => 'Mesajınızı buraya yazın...';

  @override
  String get sendMessage => 'Mesaj Gönder';

  @override
  String get messageSent => 'Mesajınız gönderildi!';

  @override
  String get messageSentDesc => 'En kısa sürede size dönüş yapacağız.';

  @override
  String get deleteAccount => 'Hesabı Sil';

  @override
  String get signOut => 'Oturumu Kapat';

  @override
  String get cancel => 'İptal etmek';

  @override
  String get deleteAccountMessage =>
      'Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz ve tüm verileriniz kalıcı olarak silinecektir.';

  @override
  String get signOutMessage =>
      'Oturumu kapatmak istediğinizden emin misiniz? Günlük görev ilerlemeniz kaydedilecektir.';

  @override
  String get editProfile => 'Profil Düzenle';

  @override
  String get businessNameLabel => 'İşletme Adı';

  @override
  String get businessNameHint => 'İşletmenizin adı';

  @override
  String get enterBusinessNameValidation => 'Lütfen işletme adını girin.';

  @override
  String get phoneHintFull => '+90 555 123 45 67';

  @override
  String get enterPhoneValidation => 'Lütfen telefon numaranızı girin.';

  @override
  String get instagramHint => '@işletmeniz';

  @override
  String get saveChanges => 'Değişiklikleri Kaydet';

  @override
  String get notificationSettings => 'Bildirim Ayarları';

  @override
  String get dailyTaskReminders => 'Günlük Görev Hatırlatıcıları';

  @override
  String get offPeakDeals => 'Sezon Dışı Fırsatlar';

  @override
  String get weeklyProgressReport => 'Haftalık İlerleme Raporu';

  @override
  String get newFeaturesUpdates => 'Yeni Özellikler ve Güncellemeler';

  @override
  String get notificationWarning =>
      'Bildirimleri kapatmak, büyüme fırsatlarını ve satış ipuçlarını kaçırmanıza neden olabilir.';

  @override
  String get blog => 'Blog';

  @override
  String get general => 'Genel';

  @override
  String get categoryInstagram => 'Instagram';

  @override
  String get categoryWhatsapp => 'WhatsApp';

  @override
  String get campaignLabel => 'KAMPANYA';

  @override
  String get instagramLabel => 'INSTAGRAM';

  @override
  String get whatsappLabel => 'WHATSAPP';

  @override
  String get share => 'PAYLAŞMAK';

  @override
  String get blogDetail => 'Blog Detayı';

  @override
  String get popular => 'POPÜLER';

  @override
  String get blogFooterText =>
      'Unutmayın, sosyal medya sadece bir vitrin değil, aynı zamanda bir diyalog platformudur. Her soruya hızlıca cevap vermek ve yorumları takip etmek, algoritmanın sizi daha fazla kişiye göstermesine yardımcı olur. Profesyonel hazır şablonlar kullanmak satış rakamlarınızı artırmanıza yardımcı olabilir.';

  @override
  String get copyTemplate => 'Şablonu Kopyala';

  @override
  String get like => 'Beğenmek';

  @override
  String get shareButton => 'Paylaşmak';

  @override
  String get painPointContinue => 'DEVAM ETMEK';

  @override
  String get verifyYourEmail => 'E-postanızı Doğrulayın';

  @override
  String get verificationSent => 'Doğrulama bağlantısını gönderdik:';

  @override
  String get checkInbox =>
      'Lütfen gelen kutunuzu kontrol edin ve devam etmek için doğrulama bağlantısına tıklayın.';

  @override
  String get openEmailApp => 'E-posta Uygulamasını Aç';

  @override
  String get resendEmail => 'Tekrar Gönder';

  @override
  String get iVerified => 'Doğruladım';

  @override
  String get emailNotVerified =>
      'E-posta henüz doğrulanmadı. Lütfen gelen kutunuzu kontrol edin.';

  @override
  String get verificationResent => 'Doğrulama e-postası tekrar gönderildi!';

  @override
  String get checkSpamFolder => 'Spam/Önemsiz klasörünü kontrol etmeyi unutma!';

  @override
  String get accountDeactivated =>
      'Bu hesap devre dışı bırakılmıştır. Lütfen destek ile iletişime geçin.';

  @override
  String get userNotFound => 'Bu e-posta ile kayıtlı bir hesap bulunamadı.';

  @override
  String get wrongPassword => 'E-posta veya şifre hatalı.';

  @override
  String get tooManyRequests =>
      'Çok fazla deneme yaptınız. Lütfen biraz bekleyin.';

  @override
  String get loginError => 'Giriş yapılamadı. Lütfen tekrar deneyin.';

  @override
  String get emailAlreadyInUse => 'Bu e-posta adresi zaten kayıtlı.';

  @override
  String get analyticsTitle => 'Analitik';

  @override
  String get overview => 'GENEL BAKIŞ';

  @override
  String get tasksCompleted => 'Tamamlanan\nGörevler';

  @override
  String get tasksViewed => 'Görüntülenen\nGörevler';

  @override
  String get tasksSkipped => 'Atlanan\nGörevler';

  @override
  String get completionRate => 'Tamamlanma Oranı';

  @override
  String get tasksByStatus => 'DURUMA GÖRE GÖREVLER';

  @override
  String get completed => 'Tamamlandı';

  @override
  String get viewed => 'Görüntülendi';

  @override
  String get skipped => 'Atlandı';

  @override
  String get dismissed => 'Reddedildi';

  @override
  String get pending => 'Bekliyor';

  @override
  String get noTasksYet => 'Henüz görev yok';

  @override
  String get noTasksYetSubtitle =>
      'Analizlerinizi burada görmek için panelden görevleri tamamlayın.';

  @override
  String get currentStreak => 'GÜNCEL SERİ';

  @override
  String streakDays(int count) {
    return '$count Gün';
  }

  @override
  String todayPlus(int count) {
    return '+$count bugün';
  }

  @override
  String get weeklyPerformance => 'Haftalık Performans';

  @override
  String get thisWeek => 'Bu Hafta';

  @override
  String get completedTasksCount => 'Tamamlanan Görevler';

  @override
  String vsLastWeek(int percent) {
    return '+%$percent geçen haftaya göre';
  }

  @override
  String vsLastWeekNeg(int percent) {
    return '%$percent geçen haftaya göre';
  }

  @override
  String get categoryDistribution => 'Kategori Dağılımı';

  @override
  String get catAcquisition => 'Müşteri Kazanımı';

  @override
  String get catConversion => 'Dönüşüm';

  @override
  String get catRetention => 'Müşteri Sadakati';

  @override
  String get catOperations => 'Operasyonlar';

  @override
  String get catB2bSales => 'B2B Satış';

  @override
  String get catAnalytics => 'Analitik';

  @override
  String get catStaffManagement => 'Personel Yönetimi';

  @override
  String get catSocialProof => 'Sosyal Kanıt';

  @override
  String get catProfitability => 'Kârlılık';

  @override
  String get catSalesPower => 'Satış Gücü';

  @override
  String get catExperience => 'Deneyim';

  @override
  String get catLocal => 'Yerel Pazarlama';

  @override
  String get catUpsell => 'Çapraz Satış';

  @override
  String get catOther => 'Diğer';

  @override
  String get successAnalytics => 'Başarı Analizleri';

  @override
  String get myBusinesses => 'İşletmelerim';

  @override
  String get addBusiness => 'İşletme Ekle';

  @override
  String get switchBusiness => 'İşletme Değiştir';

  @override
  String get currentBusiness => 'AKTİF';

  @override
  String get upgradeToPremium => 'Premium\'a Yükselt';

  @override
  String get premiumRequired => 'Premium Gerekli';

  @override
  String get premiumRequiredMessage =>
      'Birden fazla işletme eklemek ve gelişmiş özelliklerin kilidini açmak için Premium\'a yükseltin.';

  @override
  String get upgrade => 'Yükselt';

  @override
  String get businessLimitReached =>
      'Planınız için maksimum işletme sayısına ulaştınız.';

  @override
  String get subscription => 'Abonelik';

  @override
  String get currentPlan => 'Mevcut Plan';

  @override
  String get freePlan => 'Ücretsiz';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get freePlanPrice => 'Ücretsiz';

  @override
  String get premiumPlanPrice => '₺99/ay';

  @override
  String get freePlanDesc => 'Tek bir işletmeyle başlamak için ideal.';

  @override
  String get premiumPlanDesc =>
      'Gelişmiş özelliklerin kilidini açın ve birden fazla işletmeyi yönetin.';

  @override
  String get featureDailyTasks => 'Günlük Büyüme Görevleri';

  @override
  String get featureBlog => 'Blog & Şablonlar';

  @override
  String get featureAnalytics => 'Gelişmiş Analitik';

  @override
  String get featureAiInsights => 'Yapay Zeka İçgörüleri';

  @override
  String get featureMultiBusiness => '5\'e Kadar İşletme';

  @override
  String get featureMultiMember => '3\'e Kadar Takım Üyesi';

  @override
  String get upgradeNow => 'Şimdi Yükselt';

  @override
  String get downgrade => 'Ücretsiz Plana Düşür';

  @override
  String get yourCurrentPlan => 'Mevcut Planınız';

  @override
  String get verificationCodeSent => 'Doğrulama kodunuzu gönderdik:';

  @override
  String get verifyCode => 'Kodu Doğrula';

  @override
  String get resendCode => 'Tekrar Gönder';

  @override
  String get changeEmail => 'Değiştir';

  @override
  String get invalidCode =>
      'Geçersiz veya süresi dolmuş kod. Lütfen tekrar deneyin.';

  @override
  String get markAllRead => 'Tümünü okundu işaretle';

  @override
  String get noNotifications => 'Henüz bildirim yok';

  @override
  String get noNotificationsDesc =>
      'Görev atamaları ve hatırlatmalar aldığınızda burada görünecektir.';

  @override
  String get notifTaskAssignedTitle => 'Yeni görevler atandı!';

  @override
  String notifTaskAssignedBody(int count) {
    return 'Bugün sizi bekleyen $count yeni görev var. Hadi işletmenizi büyütelim!';
  }

  @override
  String get notifTaskReminderTitle => 'Görevlerini unutma!';

  @override
  String notifTaskReminderBody(int count) {
    return 'Bugün hâlâ $count tamamlanmamış görevin var. Gün bitmeden tamamla!';
  }

  @override
  String get notifDailySummaryTitle => 'Günlük Özet';

  @override
  String notifDailySummaryBody(Object completed, Object total) {
    return 'Bugün $total görevden $completed tanesini tamamladın. Devam et!';
  }

  @override
  String get justNow => 'şimdi';

  @override
  String get proPlanPrice => '€19,99/ay';

  @override
  String get proPlanDesc => 'İşletmenizi büyüten tüm araçlara tam erişim.';

  @override
  String get featureFreeAnalysis => '7 boyutta 360° İşletme Analizi (Q1–Q7)';

  @override
  String get featureFreeTopTasks =>
      'Görünürlük & itibar için Top 30 Stratejik Görev';

  @override
  String get featureFreeBasicDashboard => 'Temel Dashboard';

  @override
  String get featureFreeWhatsApp => 'Uygulama + WhatsApp (bildirim yok)';

  @override
  String get featureFreeAiMessages => 'Eğitimli AI Modeli — günde 5 mesaj';

  @override
  String get featureProAnalysis => '360° İnteraktif İşletme Analizi (Q1–Q7)';

  @override
  String get featureProFullLibrary =>
      'Tam Stratejik Görev Kütüphanesi — satış, kâr, sadakat ve daha fazlası';

  @override
  String get featureProDashboard =>
      'Görsel Dashboard & Canlı Analitik Grafikler';

  @override
  String get featureProWhatsApp =>
      'WhatsApp Büyüme Koçu — günlük hatırlatmalar & haftalık raporlar';

  @override
  String get featureProUpdatedContent =>
      'Sürekli Güncellenen İçerik — her ay yeni taktikler';

  @override
  String get featureProIdTracking =>
      'ID Tabanlı Takip — her adımın kazancını görün';

  @override
  String get errorNetwork =>
      'İnternet bağlantısı yok. Lütfen ağınızı kontrol edin.';

  @override
  String get errorRateLimit =>
      'Çok fazla istek gönderildi. Lütfen bir süre bekleyip tekrar deneyin.';

  @override
  String get errorGeneric => 'Bir şeyler ters gitti. Lütfen tekrar deneyin.';

  @override
  String get monthlyPerformance => 'Aylık Performans';

  @override
  String get yearlyPerformance => 'Yıllık Performans';

  @override
  String get thisMonth => 'Bu Ay';

  @override
  String get thisYear => 'Bu Yıl';

  @override
  String get restorePurchases => 'Satın Almaları Geri Yükle';

  @override
  String get purchaseSuccess =>
      'Pro\'ya hoş geldiniz! Yeni özelliklerinizin keyfini çıkarın.';

  @override
  String get purchaseCancelled => 'Satın alma iptal edildi.';

  @override
  String get restoreSuccess => 'Satın almalar başarıyla geri yüklendi.';

  @override
  String get restoreNoPurchases => 'Önceki satın alma bulunamadı.';

  @override
  String get buyNow => 'Yükselt';

  @override
  String pointsEarned(int points) {
    return '+$points puan!';
  }

  @override
  String get taskCompletedMsg =>
      'Harika! Görevi tamamladın. Sonuçları takip etmeyi unutma.';

  @override
  String get ok => 'Tamam';

  @override
  String get resetLinkSent =>
      'Şifre sıfırlama bağlantısı e-posta adresinize gönderildi. Lütfen gelen kutunuzu kontrol edin.';

  @override
  String get privacyPolicyTitle => 'Gizlilik Politikası';

  @override
  String get privacyPolicyUpdated => 'Son Güncelleme: 8 Nisan 2026';

  @override
  String get privacySection1Title => '1. Veri Sorumluluğu Beyanı';

  @override
  String get privacySection1Body =>
      'Hizmetlerimi kullanırken paylaştığınız veriler, 6698 sayılı Kişisel Verilerin Korunması Kanunu (KVKK) ve uluslararası veri koruma standartları çerçevesinde işlenmektedir. Verilerinizin güvenliği, teknik ve idari tedbirlerle en üst düzeyde muhafaza edilmektedir.';

  @override
  String get privacySection2Title => '2. İşlenen Veri Kategorileri';

  @override
  String get privacySection2Body =>
      '• Kimlik ve İletişim Bilgileri: Kayıt ve profil oluşturma aşamasında sağladığınız ad, soyad ve e-posta adresi.\n\n• Abonelik ve Finansal Veriler: Satın aldığınız hizmet paketlerine ilişkin işlem geçmişi ve ödeme doğrulama kayıtları. Bu süreçler teknik olarak RevenueCat altyapısı ile güvence altına alınmaktadır.\n\n• Teknik Tanılama Verileri: Sistem hatalarının tespiti ve kullanıcı deneyiminin iyileştirilmesi amacıyla toplanan hata günlükleri ve uygulama içi istatistikler.';

  @override
  String get privacySection3Title => '3. Veri İşleme Amaçlarım';

  @override
  String get privacySection3Body =>
      '• Hizmet Sunumu: Kişiselleştirilmiş kullanıcı hesabınızın yönetilmesi ve uygulama özelliklerinin aktif edilmesi.\n\n• Ödeme ve Hak Yönetimi: Abonelik süreçlerinizin doğrulanması ve hizmet kesintilerinin önlenmesi.\n\n• Güvenlik ve Denetim: Platformun kötü niyetli kullanımlardan korunması ve yasal mevzuata tam uyum sağlanması.';

  @override
  String get privacySection4Title => '4. Üçüncü Taraflarla Veri Paylaşımı';

  @override
  String get privacySection4Body =>
      'Kişisel verilerinizi asla ticari amaçla satmam veya pazarlamam. Verileriniz yalnızca aşağıdaki güvenilir servis sağlayıcılarla paylaşılır:\n\n• Google Cloud & Firebase: Verilerinizin yüksek güvenlikli bulut sunucularda saklanması ve kimlik doğrulama işlemleri için.\n\n• RevenueCat: Abonelik sistemlerinin teknik altyapısı ve dijital ödeme doğrulamaları için.';

  @override
  String get privacySection5Title => '5. Veri Güvenliği ve Saklama İlkeleri';

  @override
  String get privacySection5Body =>
      'Verileriniz, iletim aşamasında SSL/TLS şifreleme yöntemleriyle korunmaktadır. Verileriniz, hesabınız aktif olduğu sürece güvenli bulut veritabanlarımda saklanır. Hesabınızı silmeniz durumunda tüm kişisel verileriniz kalıcı olarak imha edilir.';

  @override
  String get privacySection6Title => '6. Kullanıcı Hakları ve Veri İmhası';

  @override
  String get privacySection6Body =>
      'KVKK kapsamında aşağıdaki haklara sahipsiniz:\n\n• Verilerinizin işlenip işlenmediğini öğrenme\n• Yanlış veya eksik verilerin düzeltilmesini isteme\n• Verilerinizin silinmesini veya anonim hale getirilmesini talep etme\n\nHesabınızı ve tüm ilişkili verilerinizi uygulama içindeki Ayarlar bölümünden kalıcı olarak silebilirsiniz.';

  @override
  String get privacySection7Title => '7. İletişim';

  @override
  String get privacySection7Body =>
      'Bu gizlilik politikası hakkında daha fazla bilgi almak veya haklarınızı kullanmak için:\n\n• E-posta: info@salesgrowthsteps.com\n• Uygulama içi destek: Ayarlar → Destek';

  @override
  String get premiumContent => 'Premium İçerik';

  @override
  String get premiumContentDesc =>
      'Bu özellik sadece Premium üyeler içindir. Analizlerini derinleştirmek ve potansiyelini keşfetmek için aramıza katıl.';

  @override
  String get premiumBuyNow => 'Premium Satın Al';
}
