// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get welcomeBack => 'Welcome back! Sign in to continue.';

  @override
  String get createAccount => 'Create your account with your personal info.';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordDesc =>
      'Enter your email address and we\'ll send you a 6-digit verification code.';

  @override
  String get resetPasswordButton => 'Reset Password';

  @override
  String get resetPasswordSent => 'Code Sent!';

  @override
  String resetPasswordSentDesc(String email) {
    return 'We sent a 6-digit code to $email. Please check your inbox.';
  }

  @override
  String get enterResetCode => 'Enter the 6-digit code sent to your email.';

  @override
  String get createNewPassword => 'Create New Password';

  @override
  String get createNewPasswordDesc =>
      'Your new password must be at least 6 characters.';

  @override
  String get newPassword => 'New Password';

  @override
  String get newPasswordHint => 'Enter new password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get confirmNewPasswordHint => 'Re-enter new password';

  @override
  String get resetPasswordSuccess => 'Password updated successfully!';

  @override
  String get resetPasswordSuccessDesc =>
      'Your password has been changed. You can now sign in with your new password.';

  @override
  String get passwordResetExpired =>
      'Code has expired. Please request a new one.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get fullNameHint => 'Your full name';

  @override
  String get phoneHint => '5XX XXX XX XX';

  @override
  String get enterEmail => 'Please enter your email';

  @override
  String get validEmail => 'Please enter a valid email';

  @override
  String get enterPassword => 'Please enter your password';

  @override
  String get enterAPassword => 'Please enter a password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get confirmYourPassword => 'Please confirm your password';

  @override
  String get passwordsNotMatch => 'Passwords do not match';

  @override
  String get enterName => 'Please enter your name';

  @override
  String get enterPhone => 'Please enter your phone number';

  @override
  String get continueButton => 'Continue';

  @override
  String get businessNameFallback => 'Your Business Name';

  @override
  String get enterBusinessName => 'Enter your business name';

  @override
  String get businessTypeFallback => 'What Is Your Business Type?';

  @override
  String get comingSoon => 'COMING SOON';

  @override
  String get analysisStep1 => 'Reviewing your answers...';

  @override
  String get analysisStep2 => 'Analyzing your business type...';

  @override
  String get analysisStep3 => 'Identifying growth opportunities...';

  @override
  String get analysisStep4 => 'Preparing personalized tasks...';

  @override
  String get analysisStep5 => 'Almost ready!';

  @override
  String get aiAnalyzingTitle => 'AI is analyzing\nyour business';

  @override
  String get aiAnalyzingSubtitle => 'This will only take a moment';

  @override
  String get welcome => 'WELCOME';

  @override
  String helloName(String name) {
    return 'Hello $name';
  }

  @override
  String get boostSales => 'Let\'s boost\nyour sales today!';

  @override
  String dailyGoalsProgress(int completed, int total) {
    return '$completed of $total daily goals completed';
  }

  @override
  String get details => 'Details';

  @override
  String get statusCompleted => 'COMPLETED';

  @override
  String get statusViewed => 'VIEWED';

  @override
  String get statusWontDo => 'WON\'T DO';

  @override
  String get statusDontSuggest => 'DON\'T SUGGEST';

  @override
  String get highImpact => 'HIGH IMPACT';

  @override
  String get medImpact => 'MED IMPACT';

  @override
  String get lowImpact => 'LOW IMPACT';

  @override
  String minutesBadge(int minutes) {
    return '$minutes MIN';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navAnalytics => 'Analytics';

  @override
  String get navBlog => 'Blog';

  @override
  String get navProfile => 'Profile';

  @override
  String get taskDetails => 'Task Details';

  @override
  String dailyTaskCounter(int current, int total) {
    return 'DAILY TASK $current/$total';
  }

  @override
  String get whyItMakesMoney => 'Why It Makes Money';

  @override
  String get howToDoIt => 'How To Do It';

  @override
  String get readyMadeTemplate => 'Ready-Made Template';

  @override
  String get copied => 'Copied';

  @override
  String get copy => 'Copy';

  @override
  String get wereHereToHelp => 'We\'re Here to Help';

  @override
  String get needHelpTask =>
      'Need help completing this task?\nReach out to our team right away.';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get done => 'Done';

  @override
  String get illDoIt => 'I\'ll Do It';

  @override
  String get snooze => 'I\'ll Do It Later';

  @override
  String get dontSuggest => 'Never Suggest';

  @override
  String get myBusiness => 'My Business';

  @override
  String get growthLevel => 'Growth Level 2';

  @override
  String get levelProgress => 'Level Progress';

  @override
  String get businessInfo => 'BUSINESS INFO';

  @override
  String get personalInfo => 'PERSONAL INFO';

  @override
  String get name => 'Name';

  @override
  String get phone => 'Phone';

  @override
  String get instagram => 'Instagram';

  @override
  String get city => 'City';

  @override
  String get cityHint => 'e.g. Istanbul';

  @override
  String get updateInfo => 'Update Info';

  @override
  String get settings => 'SETTINGS';

  @override
  String get notifications => 'Notifications';

  @override
  String get subscriptionPlan => 'Subscription Plan';

  @override
  String get proPlan => 'Pro Plan';

  @override
  String get aboutUs => 'About Us';

  @override
  String get aboutUsPageTitle => 'About Us';

  @override
  String get aboutUsDesc =>
      'GrowApp is an AI-powered platform that helps cafe and restaurant owners grow their businesses.';

  @override
  String get aboutUsMission => 'Our Mission';

  @override
  String get aboutUsMissionDesc =>
      'To make growth strategies accessible to every small business owner. We deliver personalized daily tasks powered by AI to help you grow your business step by step.';

  @override
  String get aboutUsFeatures => 'What We Offer';

  @override
  String get aboutUsFeature1 => 'Personalized daily tasks';

  @override
  String get aboutUsFeature2 => 'AI-powered business consulting';

  @override
  String get aboutUsFeature3 => 'Ready-made marketing templates';

  @override
  String get aboutUsFeature4 => 'Progress tracking and analytics';

  @override
  String get aboutUsFeature5 => 'Task notifications via WhatsApp';

  @override
  String get aboutUsVersion => 'Version';

  @override
  String get aboutUsTeam => 'Team';

  @override
  String get aboutUsTeamDesc =>
      'Developed by a passionate team based in Prague, dedicated to empowering small businesses.';

  @override
  String get contact => 'Contact';

  @override
  String get contactPageTitle => 'Contact';

  @override
  String get contactPageDesc => 'Reach out to us for questions or feedback.';

  @override
  String get contactEmail => 'Email';

  @override
  String get contactEmailValue => 'info@salesgrowthsteps.com';

  @override
  String get contactPhone => 'Phone';

  @override
  String get contactPhoneValue => '+90 850 123 45 67';

  @override
  String get contactWhatsapp => 'WhatsApp';

  @override
  String get contactAddress => 'Address';

  @override
  String get contactAddressValue => 'Prague, Czech Republic';

  @override
  String get contactWorkingHours => 'Working Hours';

  @override
  String get contactWorkingHoursValue => 'Mon-Fri 09:00 - 18:00';

  @override
  String get sendUsMessage => 'Send Us a Message';

  @override
  String get messageSubject => 'Subject';

  @override
  String get messageSubjectHint => 'Subject of your message';

  @override
  String get messageBody => 'Message';

  @override
  String get messageBodyHint => 'Write your message here...';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get messageSent => 'Your message has been sent!';

  @override
  String get messageSentDesc =>
      'We will get back to you as soon as possible. Our team will reach out to you soon.';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get signOut => 'Sign Out';

  @override
  String get cancel => 'Cancel';

  @override
  String get deleteAccountMessage =>
      'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.';

  @override
  String get signOutMessage =>
      'Are you sure you want to sign out? Your daily task progress will be saved.';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get businessNameLabel => 'Business Name';

  @override
  String get businessNameHint => 'Your business name';

  @override
  String get enterBusinessNameValidation => 'Please enter business name';

  @override
  String get phoneHintFull => '+90 555 123 45 67';

  @override
  String get enterPhoneValidation => 'Please enter phone number';

  @override
  String get instagramHint => '@yourbusiness';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get notificationSettings => 'Notification Settings';

  @override
  String get dailyTaskReminders => 'Daily Task Reminders';

  @override
  String get offPeakDeals => 'Off-Peak Deals';

  @override
  String get weeklyProgressReport => 'Weekly Progress Report';

  @override
  String get newFeaturesUpdates => 'New Features & Updates';

  @override
  String get notificationWarning =>
      'Turning off notifications may cause you to miss growth opportunities and sales tips.';

  @override
  String get blog => 'Blog';

  @override
  String get general => 'General';

  @override
  String get categoryInstagram => 'Instagram';

  @override
  String get categoryWhatsapp => 'WhatsApp';

  @override
  String get campaignLabel => 'CAMPAIGN';

  @override
  String get instagramLabel => 'INSTAGRAM';

  @override
  String get whatsappLabel => 'WHATSAPP';

  @override
  String get share => 'SHARE';

  @override
  String get blogDetail => 'Blog Detail';

  @override
  String get popular => 'POPULAR';

  @override
  String get blogFooterText =>
      'Remember, social media is not just a showcase, it\'s a dialogue. Answering every question promptly and keeping up with comments helps the algorithm show you to more people. Using professional ready-made templates can help you boost your sales numbers.';

  @override
  String get copyTemplate => 'Copy Template';

  @override
  String get like => 'Like';

  @override
  String get shareButton => 'Share';

  @override
  String get painPointContinue => 'CONTINUE';

  @override
  String get verifyYourEmail => 'Verify Your Email';

  @override
  String get verificationSent => 'We\'ve sent a verification link to';

  @override
  String get checkInbox =>
      'Please check your inbox and click the verification link to continue.';

  @override
  String get openEmailApp => 'Open Email App';

  @override
  String get resendEmail => 'Resend Email';

  @override
  String get iVerified => 'I\'ve Verified';

  @override
  String get emailNotVerified =>
      'Email not verified yet. Please check your inbox.';

  @override
  String get verificationResent => 'Verification email resent!';

  @override
  String get checkSpamFolder => 'Don\'t forget to check your spam folder!';

  @override
  String get accountDeactivated =>
      'This account has been deactivated. Please contact support.';

  @override
  String get userNotFound => 'No account found with this email.';

  @override
  String get wrongPassword => 'Incorrect email or password.';

  @override
  String get tooManyRequests => 'Too many attempts. Please wait a moment.';

  @override
  String get loginError => 'Login failed. Please try again.';

  @override
  String get emailAlreadyInUse => 'This email is already registered.';

  @override
  String get analyticsTitle => 'Analytics';

  @override
  String get overview => 'OVERVIEW';

  @override
  String get tasksCompleted => 'Tasks\nCompleted';

  @override
  String get tasksViewed => 'Tasks\nViewed';

  @override
  String get tasksSkipped => 'Tasks\nSkipped';

  @override
  String get completionRate => 'Completion Rate';

  @override
  String get tasksByStatus => 'TASKS BY STATUS';

  @override
  String get completed => 'Completed';

  @override
  String get viewed => 'Viewed';

  @override
  String get skipped => 'Skipped';

  @override
  String get dismissed => 'Dismissed';

  @override
  String get pending => 'Pending';

  @override
  String get noTasksYet => 'No tasks yet';

  @override
  String get noTasksYetSubtitle =>
      'Complete tasks from the dashboard to see your analytics here.';

  @override
  String get currentStreak => 'CURRENT STREAK';

  @override
  String streakDays(int count) {
    return '$count Days';
  }

  @override
  String todayPlus(int count) {
    return '+$count today';
  }

  @override
  String get weeklyPerformance => 'Weekly Performance';

  @override
  String get thisWeek => 'This Week';

  @override
  String get lastWeek => 'Last Week';

  @override
  String get completedTasksCount => 'Completed Tasks';

  @override
  String get snoozed => 'Snoozed';

  @override
  String get allTimeTaskSummary => 'All Time';

  @override
  String get activeDaysLabel => 'Active Days';

  @override
  String activeDaysCount(int count) {
    return '$count days';
  }

  @override
  String vsLastWeek(int percent) {
    return '+$percent% vs last week';
  }

  @override
  String vsLastWeekNeg(int percent) {
    return '$percent% vs last week';
  }

  @override
  String get categoryDistribution => 'Category Distribution';

  @override
  String get catAcquisition => 'Customer Acquisition';

  @override
  String get catConversion => 'Conversion';

  @override
  String get catRetention => 'Customer Retention';

  @override
  String get catOperations => 'Operations';

  @override
  String get catB2bSales => 'B2B Sales';

  @override
  String get catAnalytics => 'Analytics';

  @override
  String get catStaffManagement => 'Staff Management';

  @override
  String get catSocialProof => 'Social Proof';

  @override
  String get catProfitability => 'Profitability';

  @override
  String get catSalesPower => 'Sales Power';

  @override
  String get catExperience => 'Experience';

  @override
  String get catLocal => 'Local Marketing';

  @override
  String get catUpsell => 'Upselling';

  @override
  String get catOther => 'Other';

  @override
  String get successAnalytics => 'Success Analytics';

  @override
  String get myBusinesses => 'My Businesses';

  @override
  String get addBusiness => 'Add Business';

  @override
  String get switchBusiness => 'Switch Business';

  @override
  String get currentBusiness => 'CURRENT';

  @override
  String get upgradeToPremium => 'Upgrade to Premium';

  @override
  String get premiumRequired => 'Premium Required';

  @override
  String get premiumRequiredMessage =>
      'Upgrade to Premium to add multiple businesses and unlock advanced features.';

  @override
  String get upgrade => 'Upgrade';

  @override
  String get businessLimitReached =>
      'You\'ve reached the maximum number of businesses for your plan.';

  @override
  String get subscription => 'Subscription';

  @override
  String get currentPlan => 'Current Plan';

  @override
  String get freePlan => 'Free';

  @override
  String get premiumPlan => 'Premium';

  @override
  String get freePlanPrice => 'Free';

  @override
  String get premiumPlanPrice => '\$99/mo';

  @override
  String get freePlanDesc =>
      'X-ray your business and take your first strategic steps.';

  @override
  String get premiumPlanDesc =>
      'Unlock advanced features and manage multiple businesses.';

  @override
  String get featureDailyTasks => 'Daily Growth Tasks';

  @override
  String get featureBlog => 'Blog & Templates';

  @override
  String get featureAnalytics => 'Advanced Analytics';

  @override
  String get featureAiInsights => 'AI-Powered Insights';

  @override
  String get featureMultiBusiness => 'Up to 5 Businesses';

  @override
  String get featureMultiMember => 'Up to 3 Team Members';

  @override
  String get upgradeNow => 'Upgrade Now';

  @override
  String get downgrade => 'Downgrade to Free';

  @override
  String get yourCurrentPlan => 'Your Current Plan';

  @override
  String get verificationCodeSent => 'We\'ve sent a verification code to';

  @override
  String get verifyCode => 'Verify Code';

  @override
  String get resendCode => 'Resend Code';

  @override
  String get editEmail => 'Edit Email';

  @override
  String get changeEmail => 'Change';

  @override
  String get invalidCode => 'Invalid or expired code. Please try again.';

  @override
  String get markAllRead => 'Mark all read';

  @override
  String get noNotifications => 'No notifications yet';

  @override
  String get noNotificationsDesc =>
      'When you receive task assignments and reminders, they will appear here.';

  @override
  String get notifTaskAssignedTitle => 'New tasks assigned!';

  @override
  String notifTaskAssignedBody(int count) {
    return 'You have $count new tasks waiting for you today. Let\'s grow your business!';
  }

  @override
  String get notifTaskReminderTitle => 'Don\'t forget your tasks!';

  @override
  String notifTaskReminderBody(int count) {
    return 'You still have $count incomplete tasks today. Complete them before the day ends!';
  }

  @override
  String get notifDailySummaryTitle => 'Daily Summary';

  @override
  String notifDailySummaryBody(Object completed, Object total) {
    return 'You completed $completed out of $total tasks today. Keep the momentum going!';
  }

  @override
  String get justNow => 'now';

  @override
  String get proPlanPrice => '€19.99';

  @override
  String get proPlanDesc =>
      'The complete library to run your system at full capacity.';

  @override
  String get perMonth => '/ month';

  @override
  String get monthlySubscriptionLabel => 'Auto-renewing monthly subscription';

  @override
  String get subscriptionAutoRenewNotice =>
      'Subscription automatically renews monthly unless cancelled at least 24 hours before the end of the current period. Manage or cancel anytime in your App Store account settings.';

  @override
  String get featureFreeAnalysis =>
      'Interactive 360° Business Analysis: Visualize your status across 7 strategic dimensions (Q1–Q7)';

  @override
  String get featureFreePainPoint => 'Core Pain Point Analysis & Benchmarking';

  @override
  String get featureFreeTasks =>
      '15-Day Strategic Tasks: Instant access to core visibility & reputation steps (ID: 001–010)';

  @override
  String get featureFreeUpdatedContent =>
      'Constantly Updated Content: New tactics + digital trends every month';

  @override
  String get featureFreeTemplates =>
      '\"Copy-Paste\" Ready Content & Template Library';

  @override
  String get featureProAnalysis =>
      'Interactive 360° Business Analysis: Visualize your status across 7 strategic dimensions';

  @override
  String get featureProPainPoint => 'Core Pain Point Analysis & Benchmarking';

  @override
  String get featureProFullLibrary =>
      'Access to All Strategic Tasks: Quick access to the highest-impact tasks';

  @override
  String get featureProDashboard =>
      'Visual Dashboard & Analytics: Digital Health and Growth Score';

  @override
  String get featureProUpdatedContent =>
      'Constantly Updated Content: New tactics + digital trends every month';

  @override
  String get featureProWhatsApp =>
      'WhatsApp Growth Coach: Track your tasks via WhatsApp';

  @override
  String get featureProIdTracking =>
      'ID-Based Tracking System: Mathematically see what each step earns you';

  @override
  String get featureProTemplates =>
      '\"Copy-Paste\" Ready Content & Template Library';

  @override
  String get featureProSession => 'Monthly 30-Min One-on-One Growth Session';

  @override
  String get errorNetwork =>
      'No internet connection. Please check your network.';

  @override
  String get errorRateLimit =>
      'Too many requests. Please wait a moment and try again.';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get monthlyPerformance => 'Monthly Performance';

  @override
  String get yearlyPerformance => 'Yearly Performance';

  @override
  String get thisMonth => 'This Month';

  @override
  String get thisYear => 'This Year';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfUse => 'Terms of Use';

  @override
  String get subscribeAgreeTerms => 'By subscribing you agree to our:';

  @override
  String get purchaseSuccess => 'Welcome to Pro! Enjoy your new features.';

  @override
  String get purchaseCancelled => 'Purchase cancelled.';

  @override
  String get restoreSuccess => 'Purchases restored successfully.';

  @override
  String get restoreNoPurchases => 'No previous purchases found.';

  @override
  String get buyNow => 'Upgrade';

  @override
  String pointsEarned(int points) {
    return '+$points points!';
  }

  @override
  String get taskCompletedMsg =>
      'Great! You completed the task. Don\'t forget to track the results.';

  @override
  String get ok => 'OK';

  @override
  String get resetLinkSent =>
      'A password reset link has been sent to your email. Please check your inbox.';

  @override
  String get privacyPolicyTitle => 'Privacy Policy';

  @override
  String get privacyPolicyUpdated => 'Last Updated: April 8, 2026';

  @override
  String get privacySection1Title => '1. Data Controller Declaration';

  @override
  String get privacySection1Body =>
      'The data you share while using my services is processed in accordance with applicable international data protection standards, including GDPR. Your data security is maintained at the highest level through technical and administrative measures.';

  @override
  String get privacySection2Title => '2. Categories of Data Collected';

  @override
  String get privacySection2Body =>
      '• Identity & Contact Information: Your name, surname, and email address provided during registration.\n\n• Subscription & Financial Data: Transaction history and payment verification records related to your purchased service packages. These processes are secured by RevenueCat infrastructure.\n\n• Technical Diagnostics: Crash logs and in-app statistics collected to detect system errors and improve user experience.';

  @override
  String get privacySection3Title => '3. Purposes of Data Processing';

  @override
  String get privacySection3Body =>
      '• Service Delivery: Managing your personalized user account and activating app features.\n\n• Payment & Entitlement Management: Verifying subscription processes and preventing service interruptions.\n\n• Security & Compliance: Protecting the platform from misuse and ensuring full legal compliance.';

  @override
  String get privacySection4Title => '4. Data Sharing with Third Parties';

  @override
  String get privacySection4Body =>
      'I never sell or market your personal data for commercial purposes. Your data is shared only with the following trusted service providers:\n\n• Google Cloud & Firebase: For storing your data on secure cloud servers and authentication.\n\n• RevenueCat: For the technical infrastructure of subscription systems and digital payment verifications.';

  @override
  String get privacySection5Title => '5. Data Security & Retention';

  @override
  String get privacySection5Body =>
      'Your data is protected during transmission using SSL/TLS encryption. Your data is securely stored in my cloud databases as long as your account is active. If you delete your account, all your personal data will be permanently destroyed.';

  @override
  String get privacySection6Title => '6. User Rights & Data Deletion';

  @override
  String get privacySection6Body =>
      'You have the following rights regarding your data:\n\n• Right to know whether your data is being processed\n• Right to request correction of incorrect or incomplete data\n• Right to request deletion or anonymization of your data\n\nYou can permanently delete your account and all associated data from the Settings section within the app.';

  @override
  String get privacySection7Title => '7. Contact';

  @override
  String get privacySection7Body =>
      'For more information about this privacy policy or to exercise your rights:\n\n• Email: info@salesgrowthsteps.com\n• In-app support: Settings → Support';

  @override
  String get premiumContent => 'Premium Content';

  @override
  String get premiumContentDesc =>
      'This feature is for Premium members only. Join us to deepen your analytics and discover your potential.';

  @override
  String get premiumBuyNow => 'Get Premium';

  @override
  String todayTasksFor(String name) {
    return 'Today\'s tailored tasks for $name';
  }

  @override
  String get moreTasksTomorrow =>
      'More customized tasks are coming tomorrow. See you then!';

  @override
  String get allDoneToday =>
      'All done for today! 🎉 New tasks arrive tomorrow. You\'re one step closer to your goals!';
}
