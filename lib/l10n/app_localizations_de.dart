// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get signIn => 'Anmelden';

  @override
  String get signUp => 'Melden Sie sich an';

  @override
  String get welcomeBack =>
      'Willkommen zurück! Melden Sie sich an, um fortzufahren.';

  @override
  String get createAccount =>
      'Erstellen Sie Ihr Konto mit Ihren persönlichen Daten.';

  @override
  String get email => 'E-Mail';

  @override
  String get password => 'Passwort';

  @override
  String get confirmPassword => 'Passwort bestätigen';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get phoneNumber => 'Telefonnummer';

  @override
  String get forgotPassword => 'Passwort vergessen?';

  @override
  String get forgotPasswordDesc =>
      'Geben Sie Ihre E-Mail-Adresse ein und wir senden Ihnen einen 6-stelligen Code.';

  @override
  String get resetPasswordButton => 'Passwort zurücksetzen';

  @override
  String get resetPasswordSent => 'Code gesendet!';

  @override
  String resetPasswordSentDesc(String email) {
    return 'Wir haben einen 6-stelligen Code an $email gesendet.';
  }

  @override
  String get enterResetCode =>
      'Geben Sie den 6-stelligen Code ein, der an Ihre E-Mail gesendet wurde.';

  @override
  String get createNewPassword => 'Neues Passwort erstellen';

  @override
  String get createNewPasswordDesc =>
      'Ihr neues Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get newPassword => 'Neues Passwort';

  @override
  String get newPasswordHint => 'Neues Passwort eingeben';

  @override
  String get confirmNewPassword => 'Neues Passwort bestätigen';

  @override
  String get confirmNewPasswordHint => 'Neues Passwort erneut eingeben';

  @override
  String get resetPasswordSuccess => 'Passwort erfolgreich aktualisiert!';

  @override
  String get resetPasswordSuccessDesc =>
      'Ihr Passwort wurde geändert. Sie können sich jetzt mit Ihrem neuen Passwort anmelden.';

  @override
  String get passwordResetExpired =>
      'Code abgelaufen. Bitte fordern Sie einen neuen an.';

  @override
  String get backToLogin => 'Zurück zur Anmeldung';

  @override
  String get dontHaveAccount => 'Sie haben noch kein Konto?';

  @override
  String get alreadyHaveAccount => 'Sie haben bereits ein Konto?';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get fullNameHint => 'Ihr vollständiger Name';

  @override
  String get phoneHint => '5XX XXX XX XX';

  @override
  String get enterEmail => 'Bitte geben Sie Ihre E-Mail-Adresse ein.';

  @override
  String get validEmail => 'Bitte geben Sie eine gültige E-Mail-Adresse ein.';

  @override
  String get enterPassword => 'Bitte geben Sie Ihr Passwort ein.';

  @override
  String get enterAPassword => 'Bitte geben Sie ein Passwort ein.';

  @override
  String get passwordMinLength =>
      'Das Passwort muss mindestens 6 Zeichen lang sein.';

  @override
  String get confirmYourPassword => 'Bitte bestätigen Sie Ihr Passwort.';

  @override
  String get passwordsNotMatch => 'Die Passwörter stimmen nicht überein.';

  @override
  String get enterName => 'Bitte geben Sie Ihren Namen ein';

  @override
  String get enterPhone => 'Bitte geben Sie Ihre Telefonnummer ein.';

  @override
  String get continueButton => 'Weitermachen';

  @override
  String get businessNameFallback => 'Ihr Firmenname';

  @override
  String get enterBusinessName => 'Geben Sie Ihren Firmennamen ein';

  @override
  String get businessTypeFallback => 'Welcher Geschäftsart gehören Sie an?';

  @override
  String get comingSoon => 'Demnächst erhältlich';

  @override
  String get analysisStep1 => 'Ich prüfe Ihre Antworten...';

  @override
  String get analysisStep2 => 'Analyse Ihrer Geschäftsart...';

  @override
  String get analysisStep3 => 'Wachstumschancen erkennen...';

  @override
  String get analysisStep4 => 'Personalisierte Aufgaben vorbereiten...';

  @override
  String get analysisStep5 => 'Fast fertig!';

  @override
  String get aiAnalyzingTitle => 'KI analysiert\nIhr Unternehmen';

  @override
  String get aiAnalyzingSubtitle => 'Das dauert nur einen Augenblick.';

  @override
  String get welcome => 'WILLKOMMEN';

  @override
  String helloName(String name) {
    return 'Hallo $name';
  }

  @override
  String get boostSales => 'Steigern wir noch heute Ihren Umsatz!';

  @override
  String dailyGoalsProgress(int completed, int total) {
    return '$completed von $total Tageszielen erreicht';
  }

  @override
  String get details => 'Details';

  @override
  String get statusCompleted => 'VOLLENDET';

  @override
  String get statusViewed => 'ANGESEHEN';

  @override
  String get statusWontDo => 'Wird nicht funktionieren';

  @override
  String get statusDontSuggest => 'NICHT VORSCHLAGEN';

  @override
  String get highImpact => 'HOHE WIRKUNG';

  @override
  String get medImpact => 'MEDIZINISCHE AUSWIRKUNGEN';

  @override
  String get lowImpact => 'GERINGE AUSWIRKUNGEN';

  @override
  String minutesBadge(int minutes) {
    return '$minutes MIN';
  }

  @override
  String get navHome => 'Heim';

  @override
  String get navAnalytics => 'Analysen';

  @override
  String get navBlog => 'Blog';

  @override
  String get navProfile => 'Profil';

  @override
  String get taskDetails => 'Aufgabendetails';

  @override
  String dailyTaskCounter(int current, int total) {
    return 'TÄGLICHE AUFGABE $current/$total';
  }

  @override
  String get whyItMakesMoney => 'Warum es Geld einbringt';

  @override
  String get howToDoIt => 'So geht\'s';

  @override
  String get readyMadeTemplate => 'Vorgefertigte Vorlage';

  @override
  String get copied => 'Kopiert';

  @override
  String get copy => 'Kopie';

  @override
  String get wereHereToHelp => 'Wir sind hier, um zu helfen.';

  @override
  String get needHelpTask =>
      'Benötigen Sie Hilfe bei dieser Aufgabe? Kontaktieren Sie unser Team umgehend.';

  @override
  String get contactUs => 'Kontaktieren Sie uns';

  @override
  String get done => 'Erledigt';

  @override
  String get illDoIt => 'Ich werde es tun.';

  @override
  String get snooze => 'Mache ich später';

  @override
  String get dontSuggest => 'Nie vorschlagen';

  @override
  String get myBusiness => 'Mein Unternehmen';

  @override
  String get growthLevel => 'Wachstumsstufe 2';

  @override
  String get levelProgress => 'Levelfortschritt';

  @override
  String get businessInfo => 'GESCHÄFTSINFORMATIONEN';

  @override
  String get personalInfo => 'PERSÖNLICHE DATEN';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Telefon';

  @override
  String get instagram => 'Instagram';

  @override
  String get city => 'Stadt';

  @override
  String get cityHint => 'z.B. Istanbul';

  @override
  String get updateInfo => 'Update-Informationen';

  @override
  String get settings => 'EINSTELLUNGEN';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get subscriptionPlan => 'Abonnementplan';

  @override
  String get proPlan => 'Pro-Plan';

  @override
  String get aboutUs => 'Über uns';

  @override
  String get aboutUsPageTitle => 'Über uns';

  @override
  String get aboutUsDesc =>
      'GrowApp ist eine KI-gestützte Plattform, die Café- und Restaurantbesitzern hilft, ihr Geschäft auszubauen.';

  @override
  String get aboutUsMission => 'Unsere Mission';

  @override
  String get aboutUsMissionDesc =>
      'Wachstumsstrategien für jeden Kleinunternehmer zugänglich machen. Wir liefern personalisierte tägliche Aufgaben mit KI, um Ihr Geschäft Schritt für Schritt zu vergrößern.';

  @override
  String get aboutUsFeatures => 'Was wir bieten';

  @override
  String get aboutUsFeature1 => 'Personalisierte tägliche Aufgaben';

  @override
  String get aboutUsFeature2 => 'KI-gestützte Unternehmensberatung';

  @override
  String get aboutUsFeature3 => 'Fertige Marketing-Vorlagen';

  @override
  String get aboutUsFeature4 => 'Fortschrittsverfolgung und Analytik';

  @override
  String get aboutUsFeature5 => 'Aufgabenbenachrichtigungen über WhatsApp';

  @override
  String get aboutUsVersion => 'Version';

  @override
  String get aboutUsTeam => 'Team';

  @override
  String get aboutUsTeamDesc =>
      'Entwickelt von einem leidenschaftlichen Team in Prag, das sich der Stärkung kleiner Unternehmen widmet.';

  @override
  String get contact => 'Kontakt';

  @override
  String get contactPageTitle => 'Kontakt';

  @override
  String get contactPageDesc =>
      'Kontaktieren Sie uns bei Fragen oder Feedback.';

  @override
  String get contactEmail => 'E-Mail';

  @override
  String get contactEmailValue => 'info@salesgrowthsteps.com';

  @override
  String get contactPhone => 'Telefon';

  @override
  String get contactPhoneValue => '+90 850 123 45 67';

  @override
  String get contactWhatsapp => 'WhatsApp';

  @override
  String get contactAddress => 'Adresse';

  @override
  String get contactAddressValue => 'Prag, Tschechische Republik';

  @override
  String get contactWorkingHours => 'Geschäftszeiten';

  @override
  String get contactWorkingHoursValue => 'Mo-Fr 09:00 - 18:00';

  @override
  String get sendUsMessage => 'Nachricht senden';

  @override
  String get messageSubject => 'Betreff';

  @override
  String get messageSubjectHint => 'Betreff Ihrer Nachricht';

  @override
  String get messageBody => 'Nachricht';

  @override
  String get messageBodyHint => 'Schreiben Sie Ihre Nachricht hier...';

  @override
  String get sendMessage => 'Nachricht senden';

  @override
  String get messageSent => 'Ihre Nachricht wurde gesendet!';

  @override
  String get messageSentDesc =>
      'Wir werden uns so schnell wie möglich bei Ihnen melden. Unser Team wird sich in Kürze bei Ihnen melden.';

  @override
  String get deleteAccount => 'Konto löschen';

  @override
  String get signOut => 'Abmelden';

  @override
  String get cancel => 'Stornieren';

  @override
  String get deleteAccountMessage =>
      'Sind Sie sicher, dass Sie Ihr Konto löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden und alle Ihre Daten werden endgültig gelöscht.';

  @override
  String get signOutMessage =>
      'Möchten Sie sich wirklich abmelden? Ihr Fortschritt bei den täglichen Aufgaben wird gespeichert.';

  @override
  String get editProfile => 'Profil bearbeiten';

  @override
  String get businessNameLabel => 'Firmenname';

  @override
  String get businessNameHint => 'Ihr Firmenname';

  @override
  String get enterBusinessNameValidation =>
      'Bitte geben Sie den Firmennamen ein.';

  @override
  String get phoneHintFull => '+90 555 123 45 67';

  @override
  String get enterPhoneValidation => 'Bitte geben Sie Ihre Telefonnummer ein.';

  @override
  String get instagramHint => '@yourbusiness';

  @override
  String get saveChanges => 'Änderungen speichern';

  @override
  String get notificationSettings => 'Benachrichtigungseinstellungen';

  @override
  String get dailyTaskReminders => 'Tägliche Aufgabenerinnerungen';

  @override
  String get offPeakDeals => 'Angebote außerhalb der Stoßzeiten';

  @override
  String get weeklyProgressReport => 'Wöchentlicher Fortschrittsbericht';

  @override
  String get newFeaturesUpdates => 'Neue Funktionen und Updates';

  @override
  String get notificationWarning =>
      'Das Deaktivieren von Benachrichtigungen könnte dazu führen, dass Sie Wachstumschancen und Verkaufstipps verpassen.';

  @override
  String get blog => 'Blog';

  @override
  String get general => 'Allgemein';

  @override
  String get categoryInstagram => 'Instagram';

  @override
  String get categoryWhatsapp => 'WhatsApp';

  @override
  String get campaignLabel => 'KAMPAGNE';

  @override
  String get instagramLabel => 'INSTAGRAM';

  @override
  String get whatsappLabel => 'WhatsApp';

  @override
  String get share => 'AKTIE';

  @override
  String get blogDetail => 'Blog-Details';

  @override
  String get popular => 'BELIEBT';

  @override
  String get blogFooterText =>
      'Denken Sie daran: Soziale Medien sind nicht nur eine Plattform, sondern ein Dialog. Wenn Sie jede Frage zeitnah beantworten und Kommentare im Blick behalten, hilft Ihnen der Algorithmus, mehr Menschen auf Ihre Beiträge aufmerksam zu machen. Professionelle, vorgefertigte Vorlagen können Ihnen helfen, Ihre Verkaufszahlen zu steigern.';

  @override
  String get copyTemplate => 'Vorlage kopieren';

  @override
  String get like => 'Wie';

  @override
  String get shareButton => 'Aktie';

  @override
  String get painPointContinue => 'WEITERMACHEN';

  @override
  String get verifyYourEmail => 'E-Mail bestätigen';

  @override
  String get verificationSent => 'Wir haben einen Bestätigungslink gesendet an';

  @override
  String get checkInbox =>
      'Bitte überprüfen Sie Ihren Posteingang und klicken Sie auf den Bestätigungslink, um fortzufahren.';

  @override
  String get openEmailApp => 'E-Mail-App öffnen';

  @override
  String get resendEmail => 'Erneut senden';

  @override
  String get iVerified => 'Ich habe bestätigt';

  @override
  String get emailNotVerified =>
      'E-Mail noch nicht bestätigt. Bitte überprüfen Sie Ihren Posteingang.';

  @override
  String get verificationResent => 'Bestätigungs-E-Mail erneut gesendet!';

  @override
  String get checkSpamFolder => 'Vergiss nicht, deinen Spam-Ordner zu prüfen!';

  @override
  String get accountDeactivated =>
      'Dieses Konto wurde deaktiviert. Bitte kontaktieren Sie den Support.';

  @override
  String get userNotFound => 'Kein Konto mit dieser E-Mail gefunden.';

  @override
  String get wrongPassword => 'E-Mail oder Passwort falsch.';

  @override
  String get tooManyRequests =>
      'Zu viele Versuche. Bitte warten Sie einen Moment.';

  @override
  String get loginError =>
      'Anmeldung fehlgeschlagen. Bitte versuchen Sie es erneut.';

  @override
  String get emailAlreadyInUse => 'Diese E-Mail ist bereits registriert.';

  @override
  String get analyticsTitle => 'Analysen';

  @override
  String get overview => 'ÜBERBLICK';

  @override
  String get tasksCompleted => 'Aufgaben\nErledigt';

  @override
  String get tasksViewed => 'Aufgaben\nAngesehen';

  @override
  String get tasksSkipped => 'Aufgaben\nÜbersprungen';

  @override
  String get completionRate => 'Abschlussrate';

  @override
  String get tasksByStatus => 'AUFGABEN NACH STATUS';

  @override
  String get completed => 'Erledigt';

  @override
  String get viewed => 'Angesehen';

  @override
  String get skipped => 'Übersprungen';

  @override
  String get dismissed => 'Abgelehnt';

  @override
  String get pending => 'Ausstehend';

  @override
  String get noTasksYet => 'Noch keine Aufgaben';

  @override
  String get noTasksYetSubtitle =>
      'Erledigen Sie Aufgaben vom Dashboard, um Ihre Analysen hier zu sehen.';

  @override
  String get currentStreak => 'AKTUELLE SERIE';

  @override
  String streakDays(int count) {
    return '$count Tage';
  }

  @override
  String todayPlus(int count) {
    return '+$count heute';
  }

  @override
  String get weeklyPerformance => 'Wochenleistung';

  @override
  String get thisWeek => 'Diese Woche';

  @override
  String get completedTasksCount => 'Erledigte Aufgaben';

  @override
  String get snoozed => 'Verschoben';

  @override
  String get allTimeTaskSummary => 'Gesamt';

  @override
  String get activeDaysLabel => 'Aktive Tage';

  @override
  String activeDaysCount(int count) {
    return '$count Tage';
  }

  @override
  String vsLastWeek(int percent) {
    return '+$percent% ggü. letzter Woche';
  }

  @override
  String vsLastWeekNeg(int percent) {
    return '$percent% ggü. letzter Woche';
  }

  @override
  String get categoryDistribution => 'Kategorieverteilung';

  @override
  String get catAcquisition => 'Kundengewinnung';

  @override
  String get catConversion => 'Konversion';

  @override
  String get catRetention => 'Kundenbindung';

  @override
  String get catOperations => 'Betrieb';

  @override
  String get catB2bSales => 'B2B-Vertrieb';

  @override
  String get catAnalytics => 'Analysen';

  @override
  String get catStaffManagement => 'Personalmanagement';

  @override
  String get catSocialProof => 'Soziale Bestätigung';

  @override
  String get catProfitability => 'Rentabilität';

  @override
  String get catSalesPower => 'Verkaufskraft';

  @override
  String get catExperience => 'Erlebnis';

  @override
  String get catLocal => 'Lokales Marketing';

  @override
  String get catUpsell => 'Upselling';

  @override
  String get catOther => 'Sonstiges';

  @override
  String get successAnalytics => 'Erfolgsanalysen';

  @override
  String get myBusinesses => 'Meine Unternehmen';

  @override
  String get addBusiness => 'Unternehmen hinzufügen';

  @override
  String get switchBusiness => 'Unternehmen wechseln';

  @override
  String get currentBusiness => 'AKTUELL';

  @override
  String get upgradeToPremium => 'Auf Premium upgraden';

  @override
  String get premiumRequired => 'Premium erforderlich';

  @override
  String get premiumRequiredMessage =>
      'Upgraden Sie auf Premium, um mehrere Unternehmen hinzuzufügen und erweiterte Funktionen freizuschalten.';

  @override
  String get upgrade => 'Upgraden';

  @override
  String get businessLimitReached =>
      'Sie haben die maximale Anzahl an Unternehmen für Ihren Plan erreicht.';

  @override
  String get subscription => 'Abonnement';

  @override
  String get currentPlan => 'Aktueller Plan';

  @override
  String get freePlan => 'Kostenlos';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get freePlanPrice => 'Kostenlos';

  @override
  String get premiumPlanPrice => '99€/Mo';

  @override
  String get freePlanDesc =>
      'Durchleuchten Sie Ihr Unternehmen und machen Sie die ersten strategischen Schritte.';

  @override
  String get premiumPlanDesc =>
      'Erweiterte Funktionen freischalten und mehrere Unternehmen verwalten.';

  @override
  String get featureDailyTasks => 'Tägliche Wachstumsaufgaben';

  @override
  String get featureBlog => 'Blog & Vorlagen';

  @override
  String get featureAnalytics => 'Erweiterte Analysen';

  @override
  String get featureAiInsights => 'KI-gestützte Einblicke';

  @override
  String get featureMultiBusiness => 'Bis zu 5 Unternehmen';

  @override
  String get featureMultiMember => 'Bis zu 3 Teammitglieder';

  @override
  String get upgradeNow => 'Jetzt upgraden';

  @override
  String get downgrade => 'Auf Kostenlos herabstufen';

  @override
  String get yourCurrentPlan => 'Ihr aktueller Plan';

  @override
  String get verificationCodeSent =>
      'Wir haben einen Bestätigungscode gesendet an';

  @override
  String get verifyCode => 'Code bestätigen';

  @override
  String get resendCode => 'Erneut senden';

  @override
  String get editEmail => 'E-Mail bearbeiten';

  @override
  String get changeEmail => 'Ändern';

  @override
  String get invalidCode =>
      'Ungültiger oder abgelaufener Code. Bitte versuchen Sie es erneut.';

  @override
  String get markAllRead => 'Alle als gelesen markieren';

  @override
  String get noNotifications => 'Noch keine Benachrichtigungen';

  @override
  String get noNotificationsDesc =>
      'Wenn Sie Aufgabenzuweisungen und Erinnerungen erhalten, werden sie hier angezeigt.';

  @override
  String get notifTaskAssignedTitle => 'Neue Aufgaben zugewiesen!';

  @override
  String notifTaskAssignedBody(int count) {
    return 'Sie haben heute $count neue Aufgaben. Lassen Sie Ihr Geschäft wachsen!';
  }

  @override
  String get notifTaskReminderTitle => 'Vergessen Sie Ihre Aufgaben nicht!';

  @override
  String notifTaskReminderBody(int count) {
    return 'Sie haben heute noch $count unerledigte Aufgaben. Erledigen Sie sie vor Tagesende!';
  }

  @override
  String get notifDailySummaryTitle => 'Tageszusammenfassung';

  @override
  String notifDailySummaryBody(Object completed, Object total) {
    return 'Sie haben heute $completed von $total Aufgaben erledigt. Weiter so!';
  }

  @override
  String get justNow => 'jetzt';

  @override
  String get proPlanPrice => '€19,99';

  @override
  String get proPlanDesc =>
      'Die vollständige Bibliothek, um Ihr System mit voller Kapazität zu betreiben.';

  @override
  String get perMonth => '/ Monat';

  @override
  String get monthlySubscriptionLabel =>
      'Automatisch erneuerndes Monatsabonnement';

  @override
  String get subscriptionAutoRenewNotice =>
      'Das Abonnement verlängert sich automatisch monatlich, es sei denn, es wird mindestens 24 Stunden vor Ende des aktuellen Zeitraums gekündigt. Verwalten oder kündigen Sie jederzeit in Ihren App Store-Kontoeinstellungen.';

  @override
  String get featureFreeAnalysis =>
      'Interaktive 360°-Unternehmensanalyse: Visualisieren Sie Ihren Stand in 7 strategischen Dimensionen (Q1–Q7)';

  @override
  String get featureFreePainPoint =>
      'Analyse und Vergleich der wichtigsten Schmerzpunkte';

  @override
  String get featureFreeTasks =>
      '15-Tage-Strategieaufgaben: Sofortiger Zugriff auf grundlegende Sichtbarkeits- und Reputationsschritte (ID: 001–010)';

  @override
  String get featureFreeUpdatedContent =>
      'Ständig aktualisierte Inhalte: Neue Taktiken + digitale Trends jeden Monat';

  @override
  String get featureFreeTemplates =>
      '\"Kopieren & Einfügen\" Fertige Inhalte & Vorlagenbibliothek';

  @override
  String get featureProAnalysis =>
      'Interaktive 360°-Unternehmensanalyse: Visualisieren Sie Ihren Stand in 7 strategischen Dimensionen';

  @override
  String get featureProPainPoint =>
      'Analyse und Vergleich der wichtigsten Schmerzpunkte';

  @override
  String get featureProFullLibrary =>
      'Zugang zu allen strategischen Aufgaben: Schneller Zugriff auf die wirkungsvollsten Aufgaben';

  @override
  String get featureProDashboard =>
      'Visuelles Dashboard & Analytik: Digitale Gesundheits- und Wachstumswertung';

  @override
  String get featureProUpdatedContent =>
      'Ständig aktualisierte Inhalte: Neue Taktiken + digitale Trends jeden Monat';

  @override
  String get featureProWhatsApp =>
      'WhatsApp-Wachstumscoach: Aufgabenverfolgung über WhatsApp';

  @override
  String get featureProIdTracking =>
      'ID-basiertes Tracking-System: Sehen Sie mathematisch, was jeder Schritt einbringt';

  @override
  String get featureProTemplates =>
      '\"Kopieren & Einfügen\" Fertige Inhalte & Vorlagenbibliothek';

  @override
  String get featureProSession =>
      'Monatliche 30-Min. Einzelne Wachstumssitzung';

  @override
  String get errorNetwork =>
      'Keine Internetverbindung. Bitte überprüfen Sie Ihr Netzwerk.';

  @override
  String get errorRateLimit =>
      'Zu viele Anfragen. Bitte warten Sie einen Moment.';

  @override
  String get errorGeneric =>
      'Etwas ist schiefgelaufen. Bitte versuchen Sie es erneut.';

  @override
  String get monthlyPerformance => 'Monatliche Leistung';

  @override
  String get yearlyPerformance => 'Jährliche Leistung';

  @override
  String get thisMonth => 'Diesen Monat';

  @override
  String get thisYear => 'Dieses Jahr';

  @override
  String get restorePurchases => 'Käufe wiederherstellen';

  @override
  String get privacyPolicy => 'Datenschutz';

  @override
  String get termsOfUse => 'Nutzungsbedingungen';

  @override
  String get subscribeAgreeTerms => 'Mit dem Abonnieren stimmen Sie zu:';

  @override
  String get purchaseSuccess =>
      'Willkommen bei Pro! Genießen Sie Ihre neuen Funktionen.';

  @override
  String get purchaseCancelled => 'Kauf abgebrochen.';

  @override
  String get restoreSuccess => 'Käufe erfolgreich wiederhergestellt.';

  @override
  String get restoreNoPurchases => 'Keine früheren Käufe gefunden.';

  @override
  String get buyNow => 'Upgraden';

  @override
  String pointsEarned(int points) {
    return '+$points Punkte!';
  }

  @override
  String get taskCompletedMsg =>
      'Super! Du hast die Aufgabe erledigt. Vergiss nicht, die Ergebnisse zu verfolgen.';

  @override
  String get ok => 'OK';

  @override
  String get resetLinkSent =>
      'Ein Link zum Zurücksetzen des Passworts wurde an Ihre E-Mail gesendet. Bitte überprüfen Sie Ihren Posteingang.';

  @override
  String get privacyPolicyTitle => 'Datenschutzrichtlinie';

  @override
  String get privacyPolicyUpdated => 'Zuletzt aktualisiert: 8. April 2026';

  @override
  String get privacySection1Title => '1. Erklärung zur Datenverantwortung';

  @override
  String get privacySection1Body =>
      'Die Daten, die Sie bei der Nutzung meiner Dienste teilen, werden gemäß der DSGVO und internationalen Datenschutzstandards verarbeitet. Die Sicherheit Ihrer Daten wird durch technische und administrative Maßnahmen auf höchstem Niveau gewährleistet.';

  @override
  String get privacySection2Title => '2. Kategorien der erhobenen Daten';

  @override
  String get privacySection2Body =>
      '• Identitäts- und Kontaktdaten: Ihr Name, Nachname und Ihre E-Mail-Adresse bei der Registrierung.\n\n• Abonnement- und Finanzdaten: Transaktionshistorie und Zahlungsverifizierungen. Diese Prozesse werden durch die RevenueCat-Infrastruktur gesichert.\n\n• Technische Diagnosedaten: Absturzprotokolle und In-App-Statistiken zur Fehlererkennung und Verbesserung der Nutzererfahrung.';

  @override
  String get privacySection3Title => '3. Zwecke der Datenverarbeitung';

  @override
  String get privacySection3Body =>
      '• Dienstleistungserbringung: Verwaltung Ihres personalisierten Benutzerkontos und Aktivierung von App-Funktionen.\n\n• Zahlungs- und Rechteverwaltung: Überprüfung von Abonnementprozessen und Verhinderung von Dienstunterbrechungen.\n\n• Sicherheit & Compliance: Schutz der Plattform vor Missbrauch und Einhaltung gesetzlicher Vorschriften.';

  @override
  String get privacySection4Title => '4. Datenweitergabe an Dritte';

  @override
  String get privacySection4Body =>
      'Ich verkaufe oder vermarkte Ihre persönlichen Daten niemals zu kommerziellen Zwecken. Ihre Daten werden nur mit folgenden vertrauenswürdigen Dienstleistern geteilt:\n\n• Google Cloud & Firebase: Für die sichere Speicherung Ihrer Daten und Authentifizierung.\n\n• RevenueCat: Für die technische Infrastruktur des Abonnementsystems und digitale Zahlungsverifizierungen.';

  @override
  String get privacySection5Title => '5. Datensicherheit & Aufbewahrung';

  @override
  String get privacySection5Body =>
      'Ihre Daten werden während der Übertragung durch SSL/TLS-Verschlüsselung geschützt. Ihre Daten werden sicher in meinen Cloud-Datenbanken gespeichert, solange Ihr Konto aktiv ist. Wenn Sie Ihr Konto löschen, werden alle Ihre persönlichen Daten dauerhaft vernichtet.';

  @override
  String get privacySection6Title => '6. Nutzerrechte & Datenlöschung';

  @override
  String get privacySection6Body =>
      'Sie haben folgende Rechte bezüglich Ihrer Daten:\n\n• Recht zu erfahren, ob Ihre Daten verarbeitet werden\n• Recht auf Berichtigung falscher oder unvollständiger Daten\n• Recht auf Löschung oder Anonymisierung Ihrer Daten\n\nSie können Ihr Konto und alle zugehörigen Daten dauerhaft im Einstellungsbereich der App löschen.';

  @override
  String get privacySection7Title => '7. Kontakt';

  @override
  String get privacySection7Body =>
      'Für weitere Informationen zu dieser Datenschutzrichtlinie oder zur Ausübung Ihrer Rechte:\n\n• E-Mail: info@salesgrowthsteps.com\n• In-App-Support: Einstellungen → Support';

  @override
  String get premiumContent => 'Premium-Inhalt';

  @override
  String get premiumContentDesc =>
      'Diese Funktion ist nur für Premium-Mitglieder. Tritt bei uns bei, um deine Analysen zu vertiefen.';

  @override
  String get premiumBuyNow => 'Premium kaufen';

  @override
  String todayTasksFor(String name) {
    return 'Heutige maßgeschneiderte Aufgaben für $name';
  }

  @override
  String get moreTasksTomorrow =>
      'Mehr individuelle Aufgaben kommen morgen. Bis dann!';

  @override
  String get allDoneToday =>
      'Alles erledigt für heute! 🎉 Neue Aufgaben kommen morgen. Du bist deinen Zielen einen Schritt näher!';
}
