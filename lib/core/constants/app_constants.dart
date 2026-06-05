class AppConstants {
  AppConstants._();

  static const String appName = 'GrowApp';
  static const String appVersion = '1.0.0';

  // Apple Standard EULA — used as Terms of Use for all locales
  static const String appleStandardEulaUrl =
      'https://www.apple.com/legal/internet-services/itunes/dev/stdeula/';

  // Fallback URLs (English) — used when locale-specific URL is not defined
  static const String privacyPolicyUrl =
      'https://salesgrowthsteps.com/en/privacy-policy';
  static const String termsOfUseUrl = appleStandardEulaUrl;

  // Locale-specific Privacy Policy URLs
  static const Map<String, String> privacyPolicyUrls = {
    'en': 'https://salesgrowthsteps.com/en/privacy-policy',
    'tr': 'https://salesgrowthsteps.com/tr/gizlilik-politikasi',
    'de': 'https://salesgrowthsteps.com/de/datenschutz',
    'es': 'https://salesgrowthsteps.com/es/politica-de-privacidad',
    'cs': 'https://salesgrowthsteps.com/cs/zasady-ochrany-osobnich-udaju',
  };

  static String getPrivacyPolicyUrl(String languageCode) =>
      privacyPolicyUrls[languageCode] ?? privacyPolicyUrl;

  // Terms of Use is the Apple Standard EULA for all locales
  static String getTermsOfUseUrl(String languageCode) => appleStandardEulaUrl;
}
