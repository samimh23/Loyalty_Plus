import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

final _logger = Logger();

class AppLogger {
  static bool enabled = !kReleaseMode;

  static void d(dynamic message) {
    if (enabled) _logger.d(message);
  }

  static void i(dynamic message) {
    if (enabled) _logger.i(message);
  }

  static void w(dynamic message) {
    if (enabled) _logger.w(message);
  }

  static void e(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (enabled) _logger.e(message, error: error, stackTrace: stackTrace);
  }

  static void v(dynamic message) {
    if (enabled) _logger.v(message);
  }
}