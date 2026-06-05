import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final _logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
  level: kDebugMode ? Level.trace : Level.warning,
  output: kDebugMode ? ConsoleOutput() : _NoOutput(),
);

class AppLogger {
  AppLogger._();

  static void d(String tag, String message) =>
      _logger.d('[$tag] $message');

  static void i(String tag, String message) =>
      _logger.i('[$tag] $message');

  static void w(String tag, String message, [Object? error]) =>
      _logger.w('[$tag] $message', error: error);

  static void e(String tag, String message, [Object? error, StackTrace? stack]) =>
      _logger.e('[$tag] $message', error: error, stackTrace: stack);

  static void t(String tag, String message) =>
      _logger.t('[$tag] $message');
}

class _NoOutput extends LogOutput {
  @override
  void output(OutputEvent event) {}
}
