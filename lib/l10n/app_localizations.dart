import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('cs'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('tr'),
  ];

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back! Sign in to continue.'**
  String get welcomeBack;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create your account with your personal info.'**
  String get createAccount;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we\'ll send you a 6-digit verification code.'**
  String get forgotPasswordDesc;

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordButton;

  /// No description provided for @resetPasswordSent.
  ///
  /// In en, this message translates to:
  /// **'Code Sent!'**
  String get resetPasswordSent;

  /// No description provided for @resetPasswordSentDesc.
  ///
  /// In en, this message translates to:
  /// **'We sent a 6-digit code to {email}. Please check your inbox.'**
  String resetPasswordSentDesc(String email);

  /// No description provided for @enterResetCode.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-digit code sent to your email.'**
  String get enterResetCode;

  /// No description provided for @createNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get createNewPassword;

  /// No description provided for @createNewPasswordDesc.
  ///
  /// In en, this message translates to:
  /// **'Your new password must be at least 6 characters.'**
  String get createNewPasswordDesc;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @newPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter new password'**
  String get newPasswordHint;

  /// No description provided for @confirmNewPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// No description provided for @confirmNewPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter new password'**
  String get confirmNewPasswordHint;

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully!'**
  String get resetPasswordSuccess;

  /// No description provided for @resetPasswordSuccessDesc.
  ///
  /// In en, this message translates to:
  /// **'Your password has been changed. You can now sign in with your new password.'**
  String get resetPasswordSuccessDesc;

  /// No description provided for @passwordResetExpired.
  ///
  /// In en, this message translates to:
  /// **'Code has expired. Please request a new one.'**
  String get passwordResetExpired;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get alreadyHaveAccount;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get fullNameHint;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'5XX XXX XX XX'**
  String get phoneHint;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enterEmail;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get validEmail;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enterPassword;

  /// No description provided for @enterAPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter a password'**
  String get enterAPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @confirmYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmYourPassword;

  /// No description provided for @passwordsNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsNotMatch;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterName;

  /// No description provided for @enterPhone.
  ///
  /// In en, this message translates to:
  /// **'Please enter your phone number'**
  String get enterPhone;

  /// No description provided for @continueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// No description provided for @businessNameFallback.
  ///
  /// In en, this message translates to:
  /// **'Your Business Name'**
  String get businessNameFallback;

  /// No description provided for @enterBusinessName.
  ///
  /// In en, this message translates to:
  /// **'Enter your business name'**
  String get enterBusinessName;

  /// No description provided for @businessTypeFallback.
  ///
  /// In en, this message translates to:
  /// **'What Is Your Business Type?'**
  String get businessTypeFallback;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'COMING SOON'**
  String get comingSoon;

  /// No description provided for @analysisStep1.
  ///
  /// In en, this message translates to:
  /// **'Reviewing your answers...'**
  String get analysisStep1;

  /// No description provided for @analysisStep2.
  ///
  /// In en, this message translates to:
  /// **'Analyzing your business type...'**
  String get analysisStep2;

  /// No description provided for @analysisStep3.
  ///
  /// In en, this message translates to:
  /// **'Identifying growth opportunities...'**
  String get analysisStep3;

  /// No description provided for @analysisStep4.
  ///
  /// In en, this message translates to:
  /// **'Preparing personalized tasks...'**
  String get analysisStep4;

  /// No description provided for @analysisStep5.
  ///
  /// In en, this message translates to:
  /// **'Almost ready!'**
  String get analysisStep5;

  /// No description provided for @aiAnalyzingTitle.
  ///
  /// In en, this message translates to:
  /// **'AI is analyzing\nyour business'**
  String get aiAnalyzingTitle;

  /// No description provided for @aiAnalyzingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This will only take a moment'**
  String get aiAnalyzingSubtitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'WELCOME'**
  String get welcome;

  /// No description provided for @helloName.
  ///
  /// In en, this message translates to:
  /// **'Hello {name}'**
  String helloName(String name);

  /// No description provided for @boostSales.
  ///
  /// In en, this message translates to:
  /// **'Let\'s boost\nyour sales today!'**
  String get boostSales;

  /// No description provided for @dailyGoalsProgress.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} daily goals completed'**
  String dailyGoalsProgress(int completed, int total);

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'COMPLETED'**
  String get statusCompleted;

  /// No description provided for @statusViewed.
  ///
  /// In en, this message translates to:
  /// **'VIEWED'**
  String get statusViewed;

  /// No description provided for @statusWontDo.
  ///
  /// In en, this message translates to:
  /// **'WON\'T DO'**
  String get statusWontDo;

  /// No description provided for @statusDontSuggest.
  ///
  /// In en, this message translates to:
  /// **'DON\'T SUGGEST'**
  String get statusDontSuggest;

  /// No description provided for @highImpact.
  ///
  /// In en, this message translates to:
  /// **'HIGH IMPACT'**
  String get highImpact;

  /// No description provided for @medImpact.
  ///
  /// In en, this message translates to:
  /// **'MED IMPACT'**
  String get medImpact;

  /// No description provided for @lowImpact.
  ///
  /// In en, this message translates to:
  /// **'LOW IMPACT'**
  String get lowImpact;

  /// No description provided for @minutesBadge.
  ///
  /// In en, this message translates to:
  /// **'{minutes} MIN'**
  String minutesBadge(int minutes);

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get navAnalytics;

  /// No description provided for @navBlog.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get navBlog;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @taskDetails.
  ///
  /// In en, this message translates to:
  /// **'Task Details'**
  String get taskDetails;

  /// No description provided for @dailyTaskCounter.
  ///
  /// In en, this message translates to:
  /// **'DAILY TASK {current}/{total}'**
  String dailyTaskCounter(int current, int total);

  /// No description provided for @whyItMakesMoney.
  ///
  /// In en, this message translates to:
  /// **'Why It Makes Money'**
  String get whyItMakesMoney;

  /// No description provided for @howToDoIt.
  ///
  /// In en, this message translates to:
  /// **'How To Do It'**
  String get howToDoIt;

  /// No description provided for @readyMadeTemplate.
  ///
  /// In en, this message translates to:
  /// **'Ready-Made Template'**
  String get readyMadeTemplate;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied'**
  String get copied;

  /// No description provided for @copy.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copy;

  /// No description provided for @wereHereToHelp.
  ///
  /// In en, this message translates to:
  /// **'We\'re Here to Help'**
  String get wereHereToHelp;

  /// No description provided for @needHelpTask.
  ///
  /// In en, this message translates to:
  /// **'Need help completing this task?\nReach out to our team right away.'**
  String get needHelpTask;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @illDoIt.
  ///
  /// In en, this message translates to:
  /// **'I\'ll Do It'**
  String get illDoIt;

  /// No description provided for @snooze.
  ///
  /// In en, this message translates to:
  /// **'I\'ll Do It Later'**
  String get snooze;

  /// No description provided for @dontSuggest.
  ///
  /// In en, this message translates to:
  /// **'Never Suggest'**
  String get dontSuggest;

  /// No description provided for @myBusiness.
  ///
  /// In en, this message translates to:
  /// **'My Business'**
  String get myBusiness;

  /// No description provided for @growthLevel.
  ///
  /// In en, this message translates to:
  /// **'Growth Level 2'**
  String get growthLevel;

  /// No description provided for @levelProgress.
  ///
  /// In en, this message translates to:
  /// **'Level Progress'**
  String get levelProgress;

  /// No description provided for @businessInfo.
  ///
  /// In en, this message translates to:
  /// **'BUSINESS INFO'**
  String get businessInfo;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'PERSONAL INFO'**
  String get personalInfo;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get instagram;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @cityHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Istanbul'**
  String get cityHint;

  /// No description provided for @updateInfo.
  ///
  /// In en, this message translates to:
  /// **'Update Info'**
  String get updateInfo;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settings;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @subscriptionPlan.
  ///
  /// In en, this message translates to:
  /// **'Subscription Plan'**
  String get subscriptionPlan;

  /// No description provided for @proPlan.
  ///
  /// In en, this message translates to:
  /// **'Pro Plan'**
  String get proPlan;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @aboutUsPageTitle.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUsPageTitle;

  /// No description provided for @aboutUsDesc.
  ///
  /// In en, this message translates to:
  /// **'GrowApp is an AI-powered platform that helps cafe and restaurant owners grow their businesses.'**
  String get aboutUsDesc;

  /// No description provided for @aboutUsMission.
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get aboutUsMission;

  /// No description provided for @aboutUsMissionDesc.
  ///
  /// In en, this message translates to:
  /// **'To make growth strategies accessible to every small business owner. We deliver personalized daily tasks powered by AI to help you grow your business step by step.'**
  String get aboutUsMissionDesc;

  /// No description provided for @aboutUsFeatures.
  ///
  /// In en, this message translates to:
  /// **'What We Offer'**
  String get aboutUsFeatures;

  /// No description provided for @aboutUsFeature1.
  ///
  /// In en, this message translates to:
  /// **'Personalized daily tasks'**
  String get aboutUsFeature1;

  /// No description provided for @aboutUsFeature2.
  ///
  /// In en, this message translates to:
  /// **'AI-powered business consulting'**
  String get aboutUsFeature2;

  /// No description provided for @aboutUsFeature3.
  ///
  /// In en, this message translates to:
  /// **'Ready-made marketing templates'**
  String get aboutUsFeature3;

  /// No description provided for @aboutUsFeature4.
  ///
  /// In en, this message translates to:
  /// **'Progress tracking and analytics'**
  String get aboutUsFeature4;

  /// No description provided for @aboutUsFeature5.
  ///
  /// In en, this message translates to:
  /// **'Task notifications via WhatsApp'**
  String get aboutUsFeature5;

  /// No description provided for @aboutUsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get aboutUsVersion;

  /// No description provided for @aboutUsTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get aboutUsTeam;

  /// No description provided for @aboutUsTeamDesc.
  ///
  /// In en, this message translates to:
  /// **'Developed by a passionate team based in Prague, dedicated to empowering small businesses.'**
  String get aboutUsTeamDesc;

  /// No description provided for @contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contact;

  /// No description provided for @contactPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactPageTitle;

  /// No description provided for @contactPageDesc.
  ///
  /// In en, this message translates to:
  /// **'Reach out to us for questions or feedback.'**
  String get contactPageDesc;

  /// No description provided for @contactEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get contactEmail;

  /// No description provided for @contactEmailValue.
  ///
  /// In en, this message translates to:
  /// **'info@salesgrowthsteps.com'**
  String get contactEmailValue;

  /// No description provided for @contactPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get contactPhone;

  /// No description provided for @contactPhoneValue.
  ///
  /// In en, this message translates to:
  /// **'+90 850 123 45 67'**
  String get contactPhoneValue;

  /// No description provided for @contactWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get contactWhatsapp;

  /// No description provided for @contactAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get contactAddress;

  /// No description provided for @contactAddressValue.
  ///
  /// In en, this message translates to:
  /// **'Prague, Czech Republic'**
  String get contactAddressValue;

  /// No description provided for @contactWorkingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get contactWorkingHours;

  /// No description provided for @contactWorkingHoursValue.
  ///
  /// In en, this message translates to:
  /// **'Mon-Fri 09:00 - 18:00'**
  String get contactWorkingHoursValue;

  /// No description provided for @sendUsMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Us a Message'**
  String get sendUsMessage;

  /// No description provided for @messageSubject.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get messageSubject;

  /// No description provided for @messageSubjectHint.
  ///
  /// In en, this message translates to:
  /// **'Subject of your message'**
  String get messageSubjectHint;

  /// No description provided for @messageBody.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get messageBody;

  /// No description provided for @messageBodyHint.
  ///
  /// In en, this message translates to:
  /// **'Write your message here...'**
  String get messageBodyHint;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// No description provided for @messageSent.
  ///
  /// In en, this message translates to:
  /// **'Your message has been sent!'**
  String get messageSent;

  /// No description provided for @messageSentDesc.
  ///
  /// In en, this message translates to:
  /// **'We will get back to you as soon as possible.'**
  String get messageSentDesc;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @deleteAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.'**
  String get deleteAccountMessage;

  /// No description provided for @signOutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out? Your daily task progress will be saved.'**
  String get signOutMessage;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @businessNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Business Name'**
  String get businessNameLabel;

  /// No description provided for @businessNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your business name'**
  String get businessNameHint;

  /// No description provided for @enterBusinessNameValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter business name'**
  String get enterBusinessNameValidation;

  /// No description provided for @phoneHintFull.
  ///
  /// In en, this message translates to:
  /// **'+90 555 123 45 67'**
  String get phoneHintFull;

  /// No description provided for @enterPhoneValidation.
  ///
  /// In en, this message translates to:
  /// **'Please enter phone number'**
  String get enterPhoneValidation;

  /// No description provided for @instagramHint.
  ///
  /// In en, this message translates to:
  /// **'@yourbusiness'**
  String get instagramHint;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @notificationSettings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// No description provided for @dailyTaskReminders.
  ///
  /// In en, this message translates to:
  /// **'Daily Task Reminders'**
  String get dailyTaskReminders;

  /// No description provided for @offPeakDeals.
  ///
  /// In en, this message translates to:
  /// **'Off-Peak Deals'**
  String get offPeakDeals;

  /// No description provided for @weeklyProgressReport.
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress Report'**
  String get weeklyProgressReport;

  /// No description provided for @newFeaturesUpdates.
  ///
  /// In en, this message translates to:
  /// **'New Features & Updates'**
  String get newFeaturesUpdates;

  /// No description provided for @notificationWarning.
  ///
  /// In en, this message translates to:
  /// **'Turning off notifications may cause you to miss growth opportunities and sales tips.'**
  String get notificationWarning;

  /// No description provided for @blog.
  ///
  /// In en, this message translates to:
  /// **'Blog'**
  String get blog;

  /// No description provided for @general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get general;

  /// No description provided for @categoryInstagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get categoryInstagram;

  /// No description provided for @categoryWhatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get categoryWhatsapp;

  /// No description provided for @campaignLabel.
  ///
  /// In en, this message translates to:
  /// **'CAMPAIGN'**
  String get campaignLabel;

  /// No description provided for @instagramLabel.
  ///
  /// In en, this message translates to:
  /// **'INSTAGRAM'**
  String get instagramLabel;

  /// No description provided for @whatsappLabel.
  ///
  /// In en, this message translates to:
  /// **'WHATSAPP'**
  String get whatsappLabel;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'SHARE'**
  String get share;

  /// No description provided for @blogDetail.
  ///
  /// In en, this message translates to:
  /// **'Blog Detail'**
  String get blogDetail;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'POPULAR'**
  String get popular;

  /// No description provided for @blogFooterText.
  ///
  /// In en, this message translates to:
  /// **'Remember, social media is not just a showcase, it\'s a dialogue. Answering every question promptly and keeping up with comments helps the algorithm show you to more people. Using professional ready-made templates can help you boost your sales numbers.'**
  String get blogFooterText;

  /// No description provided for @copyTemplate.
  ///
  /// In en, this message translates to:
  /// **'Copy Template'**
  String get copyTemplate;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @shareButton.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareButton;

  /// No description provided for @painPointContinue.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get painPointContinue;

  /// No description provided for @verifyYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Verify Your Email'**
  String get verifyYourEmail;

  /// No description provided for @verificationSent.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification link to'**
  String get verificationSent;

  /// No description provided for @checkInbox.
  ///
  /// In en, this message translates to:
  /// **'Please check your inbox and click the verification link to continue.'**
  String get checkInbox;

  /// No description provided for @openEmailApp.
  ///
  /// In en, this message translates to:
  /// **'Open Email App'**
  String get openEmailApp;

  /// No description provided for @resendEmail.
  ///
  /// In en, this message translates to:
  /// **'Resend Email'**
  String get resendEmail;

  /// No description provided for @iVerified.
  ///
  /// In en, this message translates to:
  /// **'I\'ve Verified'**
  String get iVerified;

  /// No description provided for @emailNotVerified.
  ///
  /// In en, this message translates to:
  /// **'Email not verified yet. Please check your inbox.'**
  String get emailNotVerified;

  /// No description provided for @verificationResent.
  ///
  /// In en, this message translates to:
  /// **'Verification email resent!'**
  String get verificationResent;

  /// No description provided for @checkSpamFolder.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget to check your spam folder!'**
  String get checkSpamFolder;

  /// No description provided for @accountDeactivated.
  ///
  /// In en, this message translates to:
  /// **'This account has been deactivated. Please contact support.'**
  String get accountDeactivated;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'No account found with this email.'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect email or password.'**
  String get wrongPassword;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please wait a moment.'**
  String get tooManyRequests;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'Login failed. Please try again.'**
  String get loginError;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered.'**
  String get emailAlreadyInUse;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'OVERVIEW'**
  String get overview;

  /// No description provided for @tasksCompleted.
  ///
  /// In en, this message translates to:
  /// **'Tasks\nCompleted'**
  String get tasksCompleted;

  /// No description provided for @tasksViewed.
  ///
  /// In en, this message translates to:
  /// **'Tasks\nViewed'**
  String get tasksViewed;

  /// No description provided for @tasksSkipped.
  ///
  /// In en, this message translates to:
  /// **'Tasks\nSkipped'**
  String get tasksSkipped;

  /// No description provided for @completionRate.
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completionRate;

  /// No description provided for @tasksByStatus.
  ///
  /// In en, this message translates to:
  /// **'TASKS BY STATUS'**
  String get tasksByStatus;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @viewed.
  ///
  /// In en, this message translates to:
  /// **'Viewed'**
  String get viewed;

  /// No description provided for @skipped.
  ///
  /// In en, this message translates to:
  /// **'Skipped'**
  String get skipped;

  /// No description provided for @dismissed.
  ///
  /// In en, this message translates to:
  /// **'Dismissed'**
  String get dismissed;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @noTasksYet.
  ///
  /// In en, this message translates to:
  /// **'No tasks yet'**
  String get noTasksYet;

  /// No description provided for @noTasksYetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete tasks from the dashboard to see your analytics here.'**
  String get noTasksYetSubtitle;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'CURRENT STREAK'**
  String get currentStreak;

  /// No description provided for @streakDays.
  ///
  /// In en, this message translates to:
  /// **'{count} Days'**
  String streakDays(int count);

  /// No description provided for @todayPlus.
  ///
  /// In en, this message translates to:
  /// **'+{count} today'**
  String todayPlus(int count);

  /// No description provided for @weeklyPerformance.
  ///
  /// In en, this message translates to:
  /// **'Weekly Performance'**
  String get weeklyPerformance;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @completedTasksCount.
  ///
  /// In en, this message translates to:
  /// **'Completed Tasks'**
  String get completedTasksCount;

  /// No description provided for @vsLastWeek.
  ///
  /// In en, this message translates to:
  /// **'+{percent}% vs last week'**
  String vsLastWeek(int percent);

  /// No description provided for @vsLastWeekNeg.
  ///
  /// In en, this message translates to:
  /// **'{percent}% vs last week'**
  String vsLastWeekNeg(int percent);

  /// No description provided for @categoryDistribution.
  ///
  /// In en, this message translates to:
  /// **'Category Distribution'**
  String get categoryDistribution;

  /// No description provided for @catAcquisition.
  ///
  /// In en, this message translates to:
  /// **'Customer Acquisition'**
  String get catAcquisition;

  /// No description provided for @catConversion.
  ///
  /// In en, this message translates to:
  /// **'Conversion'**
  String get catConversion;

  /// No description provided for @catRetention.
  ///
  /// In en, this message translates to:
  /// **'Customer Retention'**
  String get catRetention;

  /// No description provided for @catOperations.
  ///
  /// In en, this message translates to:
  /// **'Operations'**
  String get catOperations;

  /// No description provided for @catB2bSales.
  ///
  /// In en, this message translates to:
  /// **'B2B Sales'**
  String get catB2bSales;

  /// No description provided for @catAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get catAnalytics;

  /// No description provided for @catStaffManagement.
  ///
  /// In en, this message translates to:
  /// **'Staff Management'**
  String get catStaffManagement;

  /// No description provided for @catSocialProof.
  ///
  /// In en, this message translates to:
  /// **'Social Proof'**
  String get catSocialProof;

  /// No description provided for @catProfitability.
  ///
  /// In en, this message translates to:
  /// **'Profitability'**
  String get catProfitability;

  /// No description provided for @catSalesPower.
  ///
  /// In en, this message translates to:
  /// **'Sales Power'**
  String get catSalesPower;

  /// No description provided for @catExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get catExperience;

  /// No description provided for @catLocal.
  ///
  /// In en, this message translates to:
  /// **'Local Marketing'**
  String get catLocal;

  /// No description provided for @catUpsell.
  ///
  /// In en, this message translates to:
  /// **'Upselling'**
  String get catUpsell;

  /// No description provided for @catOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get catOther;

  /// No description provided for @successAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Success Analytics'**
  String get successAnalytics;

  /// No description provided for @myBusinesses.
  ///
  /// In en, this message translates to:
  /// **'My Businesses'**
  String get myBusinesses;

  /// No description provided for @addBusiness.
  ///
  /// In en, this message translates to:
  /// **'Add Business'**
  String get addBusiness;

  /// No description provided for @switchBusiness.
  ///
  /// In en, this message translates to:
  /// **'Switch Business'**
  String get switchBusiness;

  /// No description provided for @currentBusiness.
  ///
  /// In en, this message translates to:
  /// **'CURRENT'**
  String get currentBusiness;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @premiumRequired.
  ///
  /// In en, this message translates to:
  /// **'Premium Required'**
  String get premiumRequired;

  /// No description provided for @premiumRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium to add multiple businesses and unlock advanced features.'**
  String get premiumRequiredMessage;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get upgrade;

  /// No description provided for @businessLimitReached.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the maximum number of businesses for your plan.'**
  String get businessLimitReached;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Plan'**
  String get currentPlan;

  /// No description provided for @freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get freePlan;

  /// No description provided for @premiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Premium'**
  String get premiumPlan;

  /// No description provided for @freePlanPrice.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get freePlanPrice;

  /// No description provided for @premiumPlanPrice.
  ///
  /// In en, this message translates to:
  /// **'\$99/mo'**
  String get premiumPlanPrice;

  /// No description provided for @freePlanDesc.
  ///
  /// In en, this message translates to:
  /// **'Perfect for getting started with one business.'**
  String get freePlanDesc;

  /// No description provided for @premiumPlanDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlock advanced features and manage multiple businesses.'**
  String get premiumPlanDesc;

  /// No description provided for @featureDailyTasks.
  ///
  /// In en, this message translates to:
  /// **'Daily Growth Tasks'**
  String get featureDailyTasks;

  /// No description provided for @featureBlog.
  ///
  /// In en, this message translates to:
  /// **'Blog & Templates'**
  String get featureBlog;

  /// No description provided for @featureAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Advanced Analytics'**
  String get featureAnalytics;

  /// No description provided for @featureAiInsights.
  ///
  /// In en, this message translates to:
  /// **'AI-Powered Insights'**
  String get featureAiInsights;

  /// No description provided for @featureMultiBusiness.
  ///
  /// In en, this message translates to:
  /// **'Up to 5 Businesses'**
  String get featureMultiBusiness;

  /// No description provided for @featureMultiMember.
  ///
  /// In en, this message translates to:
  /// **'Up to 3 Team Members'**
  String get featureMultiMember;

  /// No description provided for @upgradeNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade Now'**
  String get upgradeNow;

  /// No description provided for @downgrade.
  ///
  /// In en, this message translates to:
  /// **'Downgrade to Free'**
  String get downgrade;

  /// No description provided for @yourCurrentPlan.
  ///
  /// In en, this message translates to:
  /// **'Your Current Plan'**
  String get yourCurrentPlan;

  /// No description provided for @verificationCodeSent.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification code to'**
  String get verificationCodeSent;

  /// No description provided for @verifyCode.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get verifyCode;

  /// No description provided for @resendCode.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get resendCode;

  /// No description provided for @changeEmail.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeEmail;

  /// No description provided for @invalidCode.
  ///
  /// In en, this message translates to:
  /// **'Invalid or expired code. Please try again.'**
  String get invalidCode;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all read'**
  String get markAllRead;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get noNotifications;

  /// No description provided for @noNotificationsDesc.
  ///
  /// In en, this message translates to:
  /// **'When you receive task assignments and reminders, they will appear here.'**
  String get noNotificationsDesc;

  /// No description provided for @notifTaskAssignedTitle.
  ///
  /// In en, this message translates to:
  /// **'New tasks assigned!'**
  String get notifTaskAssignedTitle;

  /// No description provided for @notifTaskAssignedBody.
  ///
  /// In en, this message translates to:
  /// **'You have {count} new tasks waiting for you today. Let\'s grow your business!'**
  String notifTaskAssignedBody(int count);

  /// No description provided for @notifTaskReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Don\'t forget your tasks!'**
  String get notifTaskReminderTitle;

  /// No description provided for @notifTaskReminderBody.
  ///
  /// In en, this message translates to:
  /// **'You still have {count} incomplete tasks today. Complete them before the day ends!'**
  String notifTaskReminderBody(int count);

  /// No description provided for @notifDailySummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Summary'**
  String get notifDailySummaryTitle;

  /// No description provided for @notifDailySummaryBody.
  ///
  /// In en, this message translates to:
  /// **'You completed {completed} out of {total} tasks today. Keep the momentum going!'**
  String notifDailySummaryBody(Object completed, Object total);

  /// No description provided for @justNow.
  ///
  /// In en, this message translates to:
  /// **'now'**
  String get justNow;

  /// No description provided for @proPlanPrice.
  ///
  /// In en, this message translates to:
  /// **'€19.99/mo'**
  String get proPlanPrice;

  /// No description provided for @proPlanDesc.
  ///
  /// In en, this message translates to:
  /// **'Full access to all tools that grow your business.'**
  String get proPlanDesc;

  /// No description provided for @featureFreeAnalysis.
  ///
  /// In en, this message translates to:
  /// **'360° Business Analysis across 7 dimensions (Q1–Q7)'**
  String get featureFreeAnalysis;

  /// No description provided for @featureFreeTopTasks.
  ///
  /// In en, this message translates to:
  /// **'Top 30 Strategic Tasks for visibility & reputation'**
  String get featureFreeTopTasks;

  /// No description provided for @featureFreeBasicDashboard.
  ///
  /// In en, this message translates to:
  /// **'Basic Dashboard'**
  String get featureFreeBasicDashboard;

  /// No description provided for @featureFreeWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'App + WhatsApp (no notifications)'**
  String get featureFreeWhatsApp;

  /// No description provided for @featureFreeAiMessages.
  ///
  /// In en, this message translates to:
  /// **'Trained AI Model — 5 messages/day'**
  String get featureFreeAiMessages;

  /// No description provided for @featureProAnalysis.
  ///
  /// In en, this message translates to:
  /// **'360° Interactive Business Analysis (Q1–Q7)'**
  String get featureProAnalysis;

  /// No description provided for @featureProFullLibrary.
  ///
  /// In en, this message translates to:
  /// **'Full Strategic Task Library — sales, profit, loyalty & more'**
  String get featureProFullLibrary;

  /// No description provided for @featureProDashboard.
  ///
  /// In en, this message translates to:
  /// **'Visual Dashboard & Analytics with live charts'**
  String get featureProDashboard;

  /// No description provided for @featureProWhatsApp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp Growth Coach — daily reminders & weekly reports'**
  String get featureProWhatsApp;

  /// No description provided for @featureProUpdatedContent.
  ///
  /// In en, this message translates to:
  /// **'Constantly Updated Content — new tactics every month'**
  String get featureProUpdatedContent;

  /// No description provided for @featureProIdTracking.
  ///
  /// In en, this message translates to:
  /// **'ID-Based Tracking — see what each step earns you'**
  String get featureProIdTracking;

  /// No description provided for @errorNetwork.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Please check your network.'**
  String get errorNetwork;

  /// No description provided for @errorRateLimit.
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please wait a moment and try again.'**
  String get errorRateLimit;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @monthlyPerformance.
  ///
  /// In en, this message translates to:
  /// **'Monthly Performance'**
  String get monthlyPerformance;

  /// No description provided for @yearlyPerformance.
  ///
  /// In en, this message translates to:
  /// **'Yearly Performance'**
  String get yearlyPerformance;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @purchaseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Pro! Enjoy your new features.'**
  String get purchaseSuccess;

  /// No description provided for @purchaseCancelled.
  ///
  /// In en, this message translates to:
  /// **'Purchase cancelled.'**
  String get purchaseCancelled;

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Purchases restored successfully.'**
  String get restoreSuccess;

  /// No description provided for @restoreNoPurchases.
  ///
  /// In en, this message translates to:
  /// **'No previous purchases found.'**
  String get restoreNoPurchases;

  /// No description provided for @buyNow.
  ///
  /// In en, this message translates to:
  /// **'Upgrade'**
  String get buyNow;

  /// No description provided for @pointsEarned.
  ///
  /// In en, this message translates to:
  /// **'+{points} points!'**
  String pointsEarned(int points);

  /// No description provided for @taskCompletedMsg.
  ///
  /// In en, this message translates to:
  /// **'Great! You completed the task. Don\'t forget to track the results.'**
  String get taskCompletedMsg;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'A password reset link has been sent to your email. Please check your inbox.'**
  String get resetLinkSent;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyPolicyUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated: April 8, 2026'**
  String get privacyPolicyUpdated;

  /// No description provided for @privacySection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. Data Controller Declaration'**
  String get privacySection1Title;

  /// No description provided for @privacySection1Body.
  ///
  /// In en, this message translates to:
  /// **'The data you share while using my services is processed in accordance with applicable international data protection standards, including GDPR. Your data security is maintained at the highest level through technical and administrative measures.'**
  String get privacySection1Body;

  /// No description provided for @privacySection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Categories of Data Collected'**
  String get privacySection2Title;

  /// No description provided for @privacySection2Body.
  ///
  /// In en, this message translates to:
  /// **'• Identity & Contact Information: Your name, surname, and email address provided during registration.\n\n• Subscription & Financial Data: Transaction history and payment verification records related to your purchased service packages. These processes are secured by RevenueCat infrastructure.\n\n• Technical Diagnostics: Crash logs and in-app statistics collected to detect system errors and improve user experience.'**
  String get privacySection2Body;

  /// No description provided for @privacySection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. Purposes of Data Processing'**
  String get privacySection3Title;

  /// No description provided for @privacySection3Body.
  ///
  /// In en, this message translates to:
  /// **'• Service Delivery: Managing your personalized user account and activating app features.\n\n• Payment & Entitlement Management: Verifying subscription processes and preventing service interruptions.\n\n• Security & Compliance: Protecting the platform from misuse and ensuring full legal compliance.'**
  String get privacySection3Body;

  /// No description provided for @privacySection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Data Sharing with Third Parties'**
  String get privacySection4Title;

  /// No description provided for @privacySection4Body.
  ///
  /// In en, this message translates to:
  /// **'I never sell or market your personal data for commercial purposes. Your data is shared only with the following trusted service providers:\n\n• Google Cloud & Firebase: For storing your data on secure cloud servers and authentication.\n\n• RevenueCat: For the technical infrastructure of subscription systems and digital payment verifications.'**
  String get privacySection4Body;

  /// No description provided for @privacySection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Data Security & Retention'**
  String get privacySection5Title;

  /// No description provided for @privacySection5Body.
  ///
  /// In en, this message translates to:
  /// **'Your data is protected during transmission using SSL/TLS encryption. Your data is securely stored in my cloud databases as long as your account is active. If you delete your account, all your personal data will be permanently destroyed.'**
  String get privacySection5Body;

  /// No description provided for @privacySection6Title.
  ///
  /// In en, this message translates to:
  /// **'6. User Rights & Data Deletion'**
  String get privacySection6Title;

  /// No description provided for @privacySection6Body.
  ///
  /// In en, this message translates to:
  /// **'You have the following rights regarding your data:\n\n• Right to know whether your data is being processed\n• Right to request correction of incorrect or incomplete data\n• Right to request deletion or anonymization of your data\n\nYou can permanently delete your account and all associated data from the Settings section within the app.'**
  String get privacySection6Body;

  /// No description provided for @privacySection7Title.
  ///
  /// In en, this message translates to:
  /// **'7. Contact'**
  String get privacySection7Title;

  /// No description provided for @privacySection7Body.
  ///
  /// In en, this message translates to:
  /// **'For more information about this privacy policy or to exercise your rights:\n\n• Email: info@salesgrowthsteps.com\n• In-app support: Settings → Support'**
  String get privacySection7Body;

  /// No description provided for @premiumContent.
  ///
  /// In en, this message translates to:
  /// **'Premium Content'**
  String get premiumContent;

  /// No description provided for @premiumContentDesc.
  ///
  /// In en, this message translates to:
  /// **'This feature is for Premium members only. Join us to deepen your analytics and discover your potential.'**
  String get premiumContentDesc;

  /// No description provided for @premiumBuyNow.
  ///
  /// In en, this message translates to:
  /// **'Get Premium'**
  String get premiumBuyNow;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'de', 'en', 'es', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
