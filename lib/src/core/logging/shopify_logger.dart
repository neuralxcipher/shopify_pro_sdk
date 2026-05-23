/// Structured logger for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:logger/logger.dart';

/// Controls how much output shopify_pro_sdk writes to the console.
enum ShopifyLogLevel {
  /// No output.
  none,

  /// Errors only.
  error,

  /// Warnings and errors.
  warning,

  /// Info, warnings, and errors.
  info,

  /// Full verbose output (requests, responses, cache hits/misses).
  debug,
}

/// Singleton logger used throughout the SDK.
///
/// Configure once during ShopifyClient initialization:
/// ```dart
/// ShopifyLogger.instance.level = ShopifyLogLevel.debug;
/// ```
class ShopifyLogger {
  ShopifyLogger._();

  static final ShopifyLogger instance = ShopifyLogger._();

  ShopifyLogLevel level = ShopifyLogLevel.info;

  late final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      lineLength: 100,
      printEmojis: false,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  static const String _tag = '[ShopifyProSDK]';

  void debug(String message, [Object? data]) {
    if (level.index >= ShopifyLogLevel.debug.index) {
      _logger.d('$_tag $message${data != null ? "\n$data" : ""}');
    }
  }

  void info(String message) {
    if (level.index >= ShopifyLogLevel.info.index) {
      _logger.i('$_tag $message');
    }
  }

  void warning(String message, [Object? data]) {
    if (level.index >= ShopifyLogLevel.warning.index) {
      _logger.w('$_tag $message${data != null ? "\n$data" : ""}');
    }
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    if (level.index >= ShopifyLogLevel.error.index) {
      _logger.e('$_tag $message', error: error, stackTrace: stackTrace);
    }
  }
}
