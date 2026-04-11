import 'package:flutter/foundation.dart';

class LocaleProvider extends ChangeNotifier {
  static const _supportedLocales = ['tr', 'en', 'de', 'es', 'cs'];
  static const _fallbackLocale = 'en';

  late String _locale;
  late String _timezone;
  late DateTime _deviceTime;

  LocaleProvider() {
    _deviceTime = DateTime.now();
    _timezone = _deviceTime.timeZoneName;

    // Get device language code
    final deviceLang = PlatformDispatcher.instance.locale.languageCode;

    // Use device language if supported, otherwise fallback to English
    _locale = _supportedLocales.contains(deviceLang)
        ? deviceLang
        : _fallbackLocale;
  }

  String get locale => _locale;
  String get timezone => _timezone;
  DateTime get deviceTime => _deviceTime;

  /// Manually change the locale (e.g. from settings)
  void setLocale(String lang) {
    if (_supportedLocales.contains(lang) && lang != _locale) {
      _locale = lang;
      notifyListeners();
    }
  }

  /// Refresh device time info
  void refreshDeviceTime() {
    _deviceTime = DateTime.now();
    _timezone = _deviceTime.timeZoneName;
    notifyListeners();
  }
}
