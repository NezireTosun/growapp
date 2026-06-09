// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get signIn => 'Přihlásit se';

  @override
  String get signUp => 'Registrovat se';

  @override
  String get welcomeBack => 'Vítejte zpět! Pro pokračování se přihlaste.';

  @override
  String get createAccount => 'Vytvořte si účet s vašimi osobními údaji.';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Heslo';

  @override
  String get confirmPassword => 'Potvrzení hesla';

  @override
  String get fullName => 'Celé jméno';

  @override
  String get phoneNumber => 'Telefonní číslo';

  @override
  String get forgotPassword => 'Zapomněli jste heslo?';

  @override
  String get forgotPasswordDesc =>
      'Zadejte e-mail a pošleme vám 6-místný ověřovací kód.';

  @override
  String get resetPasswordButton => 'Resetovat heslo';

  @override
  String get resetPasswordSent => 'Kód odeslán!';

  @override
  String resetPasswordSentDesc(String email) {
    return 'Poslali jsme 6-místný kód na $email.';
  }

  @override
  String get enterResetCode => 'Zadejte 6-místný kód zaslaný na váš e-mail.';

  @override
  String get createNewPassword => 'Vytvořit nové heslo';

  @override
  String get createNewPasswordDesc =>
      'Vaše nové heslo musí mít alespoň 6 znaků.';

  @override
  String get newPassword => 'Nové heslo';

  @override
  String get newPasswordHint => 'Zadejte nové heslo';

  @override
  String get confirmNewPassword => 'Potvrdit nové heslo';

  @override
  String get confirmNewPasswordHint => 'Znovu zadejte nové heslo';

  @override
  String get resetPasswordSuccess => 'Heslo úspěšně aktualizováno!';

  @override
  String get resetPasswordSuccessDesc =>
      'Vaše heslo bylo změněno. Nyní se můžete přihlásit novým heslem.';

  @override
  String get passwordResetExpired =>
      'Platnost kódu vypršela. Požádejte o nový.';

  @override
  String get backToLogin => 'Zpět na přihlášení';

  @override
  String get dontHaveAccount => 'Nemáte účet?';

  @override
  String get alreadyHaveAccount => 'Už máte účet?';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get fullNameHint => 'Vaše celé jméno';

  @override
  String get phoneHint => '5XX XXX XX XX';

  @override
  String get enterEmail => 'Zadejte prosím svůj e-mail';

  @override
  String get validEmail => 'Zadejte prosím platný e-mail';

  @override
  String get enterPassword => 'Zadejte prosím své heslo';

  @override
  String get enterAPassword => 'Zadejte prosím heslo';

  @override
  String get passwordMinLength => 'Heslo musí mít alespoň 6 znaků';

  @override
  String get confirmYourPassword => 'Potvrďte prosím své heslo';

  @override
  String get passwordsNotMatch => 'Hesla se neshodují';

  @override
  String get enterName => 'Zadejte prosím své jméno';

  @override
  String get enterPhone => 'Zadejte prosím své telefonní číslo';

  @override
  String get continueButton => 'Pokračovat';

  @override
  String get businessNameFallback => 'Název vaší firmy';

  @override
  String get enterBusinessName => 'Zadejte název vaší firmy';

  @override
  String get businessTypeFallback => 'Jaký je váš typ podnikání?';

  @override
  String get comingSoon => 'Již brzy';

  @override
  String get analysisStep1 => 'Kontroluji vaše odpovědi...';

  @override
  String get analysisStep2 => 'Analýza typu vaší firmy...';

  @override
  String get analysisStep3 => 'Identifikace příležitostí k růstu...';

  @override
  String get analysisStep4 => 'Příprava individuálních úkolů...';

  @override
  String get analysisStep5 => 'Téměř připraveno!';

  @override
  String get aiAnalyzingTitle => 'Umělá inteligence analyzuje vaše podnikání';

  @override
  String get aiAnalyzingSubtitle => 'Tohle bude trvat jen chvilku';

  @override
  String get welcome => 'VÍTEJTE';

  @override
  String helloName(String name) {
    return 'Dobrý den, $name';
  }

  @override
  String get boostSales => 'Zvyšme vaše prodeje ještě dnes!';

  @override
  String dailyGoalsProgress(int completed, int total) {
    return '$completed z $total splněných denních cílů';
  }

  @override
  String get details => 'Podrobnosti';

  @override
  String get statusCompleted => 'DOKONČENO';

  @override
  String get statusViewed => 'ZOBRAZENO';

  @override
  String get statusWontDo => 'NEDĚLÁM TO';

  @override
  String get statusDontSuggest => 'NEDOPORUČUJI';

  @override
  String get highImpact => 'VYSOKÝ DOPAD';

  @override
  String get medImpact => 'STŘEDNÍ DOPAD';

  @override
  String get lowImpact => 'NÍZKÝ DOPAD';

  @override
  String minutesBadge(int minutes) {
    return '$minutes MIN';
  }

  @override
  String get navHome => 'Domov';

  @override
  String get navAnalytics => 'Analytika';

  @override
  String get navBlog => 'Blog';

  @override
  String get navProfile => 'Profil';

  @override
  String get taskDetails => 'Podrobnosti úkolu';

  @override
  String dailyTaskCounter(int current, int total) {
    return 'DENNÍ ÚKOL $current/$total';
  }

  @override
  String get whyItMakesMoney => 'Proč to vydělává peníze';

  @override
  String get howToDoIt => 'Jak to udělat';

  @override
  String get readyMadeTemplate => 'Připravená šablona';

  @override
  String get copied => 'Zkopírováno';

  @override
  String get copy => 'Kopie';

  @override
  String get wereHereToHelp => 'Jsme tu, abychom vám pomohli';

  @override
  String get needHelpTask =>
      'Potřebujete s tímto úkolem pomoc? Kontaktujte náš tým ihned.';

  @override
  String get contactUs => 'Kontaktujte nás';

  @override
  String get done => 'Hotovo';

  @override
  String get illDoIt => 'Udělám to';

  @override
  String get snooze => 'Udělám to později';

  @override
  String get dontSuggest => 'Nikdy nenavrhovat';

  @override
  String get myBusiness => 'Moje firma';

  @override
  String get growthLevel => 'Úroveň růstu 2';

  @override
  String get levelProgress => 'Postup úrovně';

  @override
  String get businessInfo => 'INFORMACE O OBCHODĚ';

  @override
  String get personalInfo => 'OSOBNÍ ÚDAJE';

  @override
  String get name => 'Jméno';

  @override
  String get phone => 'Telefon';

  @override
  String get instagram => 'Instagram';

  @override
  String get city => 'Město';

  @override
  String get cityHint => 'Např. Istanbul';

  @override
  String get updateInfo => 'Aktualizovat informace';

  @override
  String get settings => 'NASTAVENÍ';

  @override
  String get notifications => 'Oznámení';

  @override
  String get subscriptionPlan => 'Předplatné';

  @override
  String get proPlan => 'Profesionální plán';

  @override
  String get aboutUs => 'O nás';

  @override
  String get aboutUsPageTitle => 'O nás';

  @override
  String get aboutUsDesc =>
      'GrowApp je platforma poháněná umělou inteligencí, která pomáhá majitelům kaváren a restaurací růst jejich podnikání.';

  @override
  String get aboutUsMission => 'Naše mise';

  @override
  String get aboutUsMissionDesc =>
      'Zpřístupnit růstové strategie každému malému podnikateli. Pomocí AI dodáváme personalizované denní úkoly, které vám pomohou krok za krokem růst.';

  @override
  String get aboutUsFeatures => 'Co nabízíme';

  @override
  String get aboutUsFeature1 => 'Personalizované denní úkoly';

  @override
  String get aboutUsFeature2 => 'AI poradenství pro podnikání';

  @override
  String get aboutUsFeature3 => 'Hotové marketingové šablony';

  @override
  String get aboutUsFeature4 => 'Sledování pokroku a analytika';

  @override
  String get aboutUsFeature5 => 'Oznámení úkolů přes WhatsApp';

  @override
  String get aboutUsVersion => 'Verze';

  @override
  String get aboutUsTeam => 'Tým';

  @override
  String get aboutUsTeamDesc =>
      'Vyvinuto nadšeným týmem se sídlem v Praze, který se věnuje posilování malých podniků.';

  @override
  String get contact => 'Kontakt';

  @override
  String get contactPageTitle => 'Kontakt';

  @override
  String get contactPageDesc => 'Kontaktujte nás s dotazy nebo zpětnou vazbou.';

  @override
  String get contactEmail => 'E-mail';

  @override
  String get contactEmailValue => 'info@salesgrowthsteps.com';

  @override
  String get contactPhone => 'Telefon';

  @override
  String get contactPhoneValue => '+90 850 123 45 67';

  @override
  String get contactWhatsapp => 'WhatsApp';

  @override
  String get contactAddress => 'Adresa';

  @override
  String get contactAddressValue => 'Praha, Česká republika';

  @override
  String get contactWorkingHours => 'Pracovní doba';

  @override
  String get contactWorkingHoursValue => 'Po-Pá 09:00 - 18:00';

  @override
  String get sendUsMessage => 'Napište nám';

  @override
  String get messageSubject => 'Předmět';

  @override
  String get messageSubjectHint => 'Předmět vaší zprávy';

  @override
  String get messageBody => 'Zpráva';

  @override
  String get messageBodyHint => 'Napište svou zprávu zde...';

  @override
  String get sendMessage => 'Odeslat zprávu';

  @override
  String get messageSent => 'Vaše zpráva byla odeslána!';

  @override
  String get messageSentDesc =>
      'Ozveme se vám co nejdříve. Náš tým vás brzy kontaktuje.';

  @override
  String get deleteAccount => 'Smazat účet';

  @override
  String get signOut => 'Odhlásit se';

  @override
  String get cancel => 'Zrušit';

  @override
  String get deleteAccountMessage =>
      'Jste si jisti, že chcete smazat svůj účet? Tuto akci nelze vrátit zpět a všechna vaše data budou trvale smazána.';

  @override
  String get signOutMessage =>
      'Opravdu se chcete odhlásit? Váš denní postup v úkolech bude uložen.';

  @override
  String get editProfile => 'Upravit profil';

  @override
  String get businessNameLabel => 'Název firmy';

  @override
  String get businessNameHint => 'Název vaší firmy';

  @override
  String get enterBusinessNameValidation => 'Zadejte prosím název firmy';

  @override
  String get phoneHintFull => '+90 555 123 45 67';

  @override
  String get enterPhoneValidation => 'Zadejte prosím telefonní číslo';

  @override
  String get instagramHint => '@vašefirma';

  @override
  String get saveChanges => 'Uložit změny';

  @override
  String get notificationSettings => 'Nastavení oznámení';

  @override
  String get dailyTaskReminders => 'Denní připomenutí úkolů';

  @override
  String get offPeakDeals => 'Nabídky mimo špičku';

  @override
  String get weeklyProgressReport => 'Týdenní zpráva o pokroku';

  @override
  String get newFeaturesUpdates => 'Nové funkce a aktualizace';

  @override
  String get notificationWarning =>
      'Vypnutí oznámení může vést k tomu, že promeškáte příležitosti k růstu a tipy na prodej.';

  @override
  String get blog => 'Blog';

  @override
  String get general => 'Generál';

  @override
  String get categoryInstagram => 'Instagram';

  @override
  String get categoryWhatsapp => 'WhatsApp';

  @override
  String get campaignLabel => 'KAMPAŇ';

  @override
  String get instagramLabel => 'INSTAGRAM';

  @override
  String get whatsappLabel => 'WHATSAPP';

  @override
  String get share => 'PODÍL';

  @override
  String get blogDetail => 'Detaily blogu';

  @override
  String get popular => 'POPULÁRNÍ';

  @override
  String get blogFooterText =>
      'Nezapomeňte, že sociální média nejsou jen výkladní skříní, ale dialog. Rychlé zodpovězení všech otázek a sledování komentářů pomáhá algoritmu ukázat vás více lidem. Používání profesionálních hotových šablon vám může pomoci zvýšit vaše prodeje.';

  @override
  String get copyTemplate => 'Kopírovat šablonu';

  @override
  String get like => 'Jako';

  @override
  String get shareButton => 'Podíl';

  @override
  String get painPointContinue => 'POKRAČOVAT';

  @override
  String get verifyYourEmail => 'Ověřte svůj e-mail';

  @override
  String get verificationSent => 'Odeslali jsme ověřovací odkaz na';

  @override
  String get checkInbox =>
      'Zkontrolujte prosím svou doručenou poštu a klikněte na ověřovací odkaz pro pokračování.';

  @override
  String get openEmailApp => 'Otevřít e-mail';

  @override
  String get resendEmail => 'Odeslat znovu';

  @override
  String get iVerified => 'Ověřil jsem';

  @override
  String get emailNotVerified =>
      'E-mail ještě nebyl ověřen. Zkontrolujte prosím svou doručenou poštu.';

  @override
  String get verificationResent => 'Ověřovací e-mail byl znovu odeslán!';

  @override
  String get checkSpamFolder => 'Nezapomeň zkontrolovat složku se spamem!';

  @override
  String get accountDeactivated =>
      'Tento účet byl deaktivován. Kontaktujte prosím podporu.';

  @override
  String get userNotFound => 'Účet s tímto e-mailem nebyl nalezen.';

  @override
  String get wrongPassword => 'Nesprávný e-mail nebo heslo.';

  @override
  String get tooManyRequests => 'Příliš mnoho pokusů. Počkejte prosím.';

  @override
  String get loginError => 'Přihlášení se nezdařilo. Zkuste to prosím znovu.';

  @override
  String get emailAlreadyInUse => 'Tento e-mail je již zaregistrován.';

  @override
  String get analyticsTitle => 'Analytika';

  @override
  String get overview => 'PŘEHLED';

  @override
  String get tasksCompleted => 'Úkoly\nDokončeno';

  @override
  String get tasksViewed => 'Úkoly\nZobrazeno';

  @override
  String get tasksSkipped => 'Úkoly\nPřeskočeno';

  @override
  String get completionRate => 'Míra dokončení';

  @override
  String get tasksByStatus => 'ÚKOLY PODLE STAVU';

  @override
  String get completed => 'Dokončeno';

  @override
  String get viewed => 'Zobrazeno';

  @override
  String get skipped => 'Přeskočeno';

  @override
  String get dismissed => 'Zamítnuto';

  @override
  String get pending => 'Nevyřízeno';

  @override
  String get noTasksYet => 'Zatím žádné úkoly';

  @override
  String get noTasksYetSubtitle =>
      'Dokončete úkoly z panelu, abyste zde viděli své analýzy.';

  @override
  String get currentStreak => 'AKTUÁLNÍ SÉRIE';

  @override
  String streakDays(int count) {
    return '$count Dní';
  }

  @override
  String todayPlus(int count) {
    return '+$count dnes';
  }

  @override
  String get weeklyPerformance => 'Týdenní výkon';

  @override
  String get thisWeek => 'Tento týden';

  @override
  String get lastWeek => 'Minulý týden';

  @override
  String get completedTasksCount => 'Dokončené úkoly';

  @override
  String get snoozed => 'Odloženo';

  @override
  String get allTimeTaskSummary => 'Celkem';

  @override
  String get activeDaysLabel => 'Aktivní dny';

  @override
  String activeDaysCount(int count) {
    return '$count dní';
  }

  @override
  String vsLastWeek(int percent) {
    return '+$percent% oproti minulému týdnu';
  }

  @override
  String vsLastWeekNeg(int percent) {
    return '$percent% oproti minulému týdnu';
  }

  @override
  String get categoryDistribution => 'Rozložení kategorií';

  @override
  String get catAcquisition => 'Získávání zákazníků';

  @override
  String get catConversion => 'Konverze';

  @override
  String get catRetention => 'Udržení zákazníků';

  @override
  String get catOperations => 'Provoz';

  @override
  String get catB2bSales => 'B2B prodej';

  @override
  String get catAnalytics => 'Analytika';

  @override
  String get catStaffManagement => 'Řízení personálu';

  @override
  String get catSocialProof => 'Sociální důkaz';

  @override
  String get catProfitability => 'Ziskovost';

  @override
  String get catSalesPower => 'Prodejní síla';

  @override
  String get catExperience => 'Zkušenost';

  @override
  String get catLocal => 'Lokální marketing';

  @override
  String get catUpsell => 'Křížový prodej';

  @override
  String get catOther => 'Ostatní';

  @override
  String get successAnalytics => 'Analýzy úspěchu';

  @override
  String get myBusinesses => 'Moje podniky';

  @override
  String get addBusiness => 'Přidat podnik';

  @override
  String get switchBusiness => 'Přepnout podnik';

  @override
  String get currentBusiness => 'AKTUÁLNÍ';

  @override
  String get upgradeToPremium => 'Upgradovat na Premium';

  @override
  String get premiumRequired => 'Vyžadován Premium';

  @override
  String get premiumRequiredMessage =>
      'Upgradujte na Premium pro přidání více podniků a odemknutí pokročilých funkcí.';

  @override
  String get upgrade => 'Upgradovat';

  @override
  String get businessLimitReached =>
      'Dosáhli jste maximálního počtu podniků pro váš plán.';

  @override
  String get subscription => 'Předplatné';

  @override
  String get currentPlan => 'Aktuální plán';

  @override
  String get freePlan => 'Zdarma';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get freePlanPrice => 'Zdarma';

  @override
  String get premiumPlanPrice => '99 Kč/měs';

  @override
  String get freePlanDesc =>
      'Rentgenujte svůj podnik a udělejte první strategické kroky.';

  @override
  String get premiumPlanDesc =>
      'Odemkněte pokročilé funkce a spravujte více podniků.';

  @override
  String get featureDailyTasks => 'Denní růstové úkoly';

  @override
  String get featureBlog => 'Blog a šablony';

  @override
  String get featureAnalytics => 'Pokročilé analytiky';

  @override
  String get featureAiInsights => 'AI analýzy';

  @override
  String get featureMultiBusiness => 'Až 5 podniků';

  @override
  String get featureMultiMember => 'Až 3 členové týmu';

  @override
  String get upgradeNow => 'Upgradovat nyní';

  @override
  String get downgrade => 'Přejít na Zdarma';

  @override
  String get yourCurrentPlan => 'Váš aktuální plán';

  @override
  String get verificationCodeSent => 'Odeslali jsme ověřovací kód na';

  @override
  String get verifyCode => 'Ověřit kód';

  @override
  String get resendCode => 'Odeslat znovu';

  @override
  String get editEmail => 'Upravit e-mail';

  @override
  String get changeEmail => 'Změnit';

  @override
  String get invalidCode =>
      'Neplatný nebo vypršený kód. Zkuste to prosím znovu.';

  @override
  String get markAllRead => 'Označit vše jako přečtené';

  @override
  String get noNotifications => 'Zatím žádná oznámení';

  @override
  String get noNotificationsDesc =>
      'Když obdržíte přiřazení úkolů a připomínky, zobrazí se zde.';

  @override
  String get notifTaskAssignedTitle => 'Nové úkoly přiřazeny!';

  @override
  String notifTaskAssignedBody(int count) {
    return 'Dnes na vás čeká $count nových úkolů. Pojďme rozšířit váš podnik!';
  }

  @override
  String get notifTaskReminderTitle => 'Nezapomeňte na své úkoly!';

  @override
  String notifTaskReminderBody(int count) {
    return 'Dnes máte ještě $count nedokončených úkolů. Dokončete je před koncem dne!';
  }

  @override
  String get notifDailySummaryTitle => 'Denní shrnutí';

  @override
  String notifDailySummaryBody(Object completed, Object total) {
    return 'Dnes jste splnili $completed z $total úkolů. Pokračujte!';
  }

  @override
  String get justNow => 'nyní';

  @override
  String get proPlanPrice => '€19,99';

  @override
  String get proPlanDesc =>
      'Kompletní knihovna pro provoz vašeho systému na plný výkon.';

  @override
  String get perMonth => '/ měsíc';

  @override
  String get monthlySubscriptionLabel =>
      'Automaticky obnovované měsíční předplatné';

  @override
  String get subscriptionAutoRenewNotice =>
      'Předplatné se automaticky obnovuje měsíčně, pokud není zrušeno alespoň 24 hodin před koncem aktuálního období. Spravujte nebo zrušte kdykoli v nastavení účtu App Store.';

  @override
  String get featureFreeAnalysis =>
      'Interaktivní 360° obchodní analýza: Vizualizujte svůj stav ve 7 strategických dimenzích (Q1–Q7)';

  @override
  String get featureFreePainPoint =>
      'Analýza a srovnání klíčových bolestivých bodů';

  @override
  String get featureFreeTasks =>
      '15denní strategické úkoly: Okamžitý přístup k základním krokům viditelnosti a reputace (ID: 001–010)';

  @override
  String get featureFreeUpdatedContent =>
      'Neustále aktualizovaný obsah: Nové taktiky + digitální trendy každý měsíc';

  @override
  String get featureFreeTemplates =>
      'Knihovna hotového obsahu a šablon \"Kopírovat a vložit\"';

  @override
  String get featureProAnalysis =>
      'Interaktivní 360° obchodní analýza: Vizualizujte svůj stav ve 7 strategických dimenzích';

  @override
  String get featureProPainPoint =>
      'Analýza a srovnání klíčových bolestivých bodů';

  @override
  String get featureProFullLibrary =>
      'Přístup ke všem strategickým úkolům: Rychlý přístup k úkolům s největším dopadem';

  @override
  String get featureProDashboard =>
      'Vizuální přehled a analytika: Skóre digitálního zdraví a růstu';

  @override
  String get featureProUpdatedContent =>
      'Neustále aktualizovaný obsah: Nové taktiky + digitální trendy každý měsíc';

  @override
  String get featureProWhatsApp =>
      'WhatsApp growth koučink: Sledování úkolů přes WhatsApp';

  @override
  String get featureProIdTracking =>
      'Systém sledování podle ID: Matematicky sledujte, co každý krok vydělá';

  @override
  String get featureProTemplates =>
      'Knihovna hotového obsahu a šablon \"Kopírovat a vložit\"';

  @override
  String get featureProSession =>
      'Měsíční 30minutová individuální growth sezení';

  @override
  String get errorNetwork =>
      'Žádné internetové připojení. Zkontrolujte svou síť.';

  @override
  String get errorRateLimit =>
      'Příliš mnoho požadavků. Chvíli počkejte a zkuste to znovu.';

  @override
  String get errorGeneric => 'Něco se pokazilo. Zkuste to prosím znovu.';

  @override
  String get monthlyPerformance => 'Měsíční výkon';

  @override
  String get yearlyPerformance => 'Roční výkon';

  @override
  String get thisMonth => 'Tento měsíc';

  @override
  String get thisYear => 'Tento rok';

  @override
  String get restorePurchases => 'Obnovit nákupy';

  @override
  String get privacyPolicy => 'Zásady ochrany osobních údajů';

  @override
  String get termsOfUse => 'Podmínky použití';

  @override
  String get subscribeAgreeTerms => 'Přihlášením k odběru souhlasíte s:';

  @override
  String get purchaseSuccess => 'Vítejte v Pro! Užívejte si nové funkce.';

  @override
  String get purchaseCancelled => 'Nákup zrušen.';

  @override
  String get restoreSuccess => 'Nákupy úspěšně obnoveny.';

  @override
  String get restoreNoPurchases => 'Žádné předchozí nákupy nenalezeny.';

  @override
  String get buyNow => 'Upgradovat';

  @override
  String pointsEarned(int points) {
    return '+$points bodů!';
  }

  @override
  String get taskCompletedMsg =>
      'Skvělé! Dokončil jsi úkol. Nezapomeň sledovat výsledky.';

  @override
  String get ok => 'OK';

  @override
  String get resetLinkSent =>
      'Na váš e-mail byl odeslán odkaz pro obnovení hesla. Zkontrolujte svou doručenou poštu.';

  @override
  String get privacyPolicyTitle => 'Zásady ochrany osobních údajů';

  @override
  String get privacyPolicyUpdated => 'Poslední aktualizace: 8. dubna 2026';

  @override
  String get privacySection1Title => '1. Prohlášení o odpovědnosti za data';

  @override
  String get privacySection1Body =>
      'Data, která sdílíte při používání mých služeb, jsou zpracovávána v souladu s GDPR a mezinárodními standardy ochrany dat. Bezpečnost vašich dat je zajištěna na nejvyšší úrovni technickými a administrativními opatřeními.';

  @override
  String get privacySection2Title => '2. Kategorie shromažďovaných údajů';

  @override
  String get privacySection2Body =>
      '• Identifikační a kontaktní údaje: Vaše jméno, příjmení a e-mailová adresa zadané při registraci.\n\n• Data o předplatném a platbách: Historie transakcí a záznamy o ověření plateb. Tyto procesy jsou zabezpečeny infrastrukturou RevenueCat.\n\n• Technická diagnostická data: Protokoly chyb a statistiky v aplikaci pro zjišťování chyb a zlepšování uživatelské zkušenosti.';

  @override
  String get privacySection3Title => '3. Účely zpracování dat';

  @override
  String get privacySection3Body =>
      '• Poskytování služeb: Správa vašeho personalizovaného uživatelského účtu a aktivace funkcí aplikace.\n\n• Správa plateb a nároků: Ověření procesů předplatného a prevence přerušení služby.\n\n• Bezpečnost a compliance: Ochrana platformy před zneužitím a zajištění souladu s právními předpisy.';

  @override
  String get privacySection4Title => '4. Sdílení dat s třetími stranami';

  @override
  String get privacySection4Body =>
      'Vaše osobní údaje nikdy neprodávám ani neposkytuji pro komerční účely. Vaše data jsou sdílena pouze s následujícími důvěryhodnými poskytovateli:\n\n• Google Cloud & Firebase: Pro bezpečné ukládání dat a autentizaci.\n\n• RevenueCat: Pro technickou infrastrukturu systému předplatného a ověřování digitálních plateb.';

  @override
  String get privacySection5Title => '5. Bezpečnost a uchovávání dat';

  @override
  String get privacySection5Body =>
      'Vaše data jsou při přenosu chráněna šifrováním SSL/TLS. Data jsou bezpečně uložena v mých cloudových databázích po dobu aktivity vašeho účtu. Pokud svůj účet smažete, všechna vaše osobní data budou trvale zničena.';

  @override
  String get privacySection6Title => '6. Práva uživatelů a smazání dat';

  @override
  String get privacySection6Body =>
      'Máte následující práva ohledně svých dat:\n\n• Právo vědět, zda jsou vaše data zpracovávána\n• Právo požádat o opravu nesprávných nebo neúplných dat\n• Právo požádat o smazání nebo anonymizaci vašich dat\n\nSvůj účet a všechna přidružená data můžete trvale smazat v sekci Nastavení v aplikaci.';

  @override
  String get privacySection7Title => '7. Kontakt';

  @override
  String get privacySection7Body =>
      'Pro více informací o těchto zásadách nebo k uplatnění svých práv:\n\n• E-mail: info@salesgrowthsteps.com\n• Podpora v aplikaci: Nastavení → Podpora';

  @override
  String get premiumContent => 'Prémiový obsah';

  @override
  String get premiumContentDesc =>
      'Tato funkce je pouze pro prémiové členy. Přidejte se k nám a prohloubte své analýzy.';

  @override
  String get premiumBuyNow => 'Získat Premium';

  @override
  String todayTasksFor(String name) {
    return 'Dnešní úkoly šité na míru pro $name';
  }

  @override
  String get moreTasksTomorrow =>
      'Více přizpůsobených úkolů přijde zítra. Na shledanou!';

  @override
  String get allDoneToday =>
      'Hotovo na dnes! 🎉 Nové úkoly přijdou zítra. Jsi o krok blíže ke svým cílům!';
}
