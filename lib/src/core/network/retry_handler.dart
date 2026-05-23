/// Exponential back-off retry logic for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'dart:math';

import '../errors/shopify_exception.dart';
import '../logging/shopify_logger.dart';

/// Configuration for the retry handler.
final class RetryConfig {
  const RetryConfig({
    this.maxAttempts = 3,
    this.initialDelay = const Duration(milliseconds: 500),
    this.maxDelay = const Duration(seconds: 30),
    this.backoffFactor = 2.0,
    this.jitter = true,
  });

  /// Maximum number of total attempts (1 = no retries).
  final int maxAttempts;
  final Duration initialDelay;
  final Duration maxDelay;

  /// Multiplier applied to the delay after each failure.
  final double backoffFactor;

  /// Adds randomised ±25% jitter to prevent thundering-herd.
  final bool jitter;

  Duration delayFor(int attempt) {
    final ms = initialDelay.inMilliseconds * pow(backoffFactor, attempt);
    final clamped = min(ms, maxDelay.inMilliseconds.toDouble());
    if (!jitter) return Duration(milliseconds: clamped.round());
    final spread = clamped * 0.25;
    final jittered = clamped + (Random().nextDouble() * 2 - 1) * spread;
    return Duration(
        milliseconds: jittered.round().clamp(0, maxDelay.inMilliseconds));
  }
}

/// Executes [operation] with automatic retry on transient failures.
///
/// Retries on [ShopifyNetworkException] and [ShopifyRateLimitException].
/// Never retries on [ShopifyAuthException] or [ShopifyGraphQLException]
/// (those require intervention, not a repeat of the same request).
Future<T> withRetry<T>(
  Future<T> Function() operation, {
  RetryConfig config = const RetryConfig(),
}) async {
  var attempt = 0;
  while (true) {
    try {
      return await operation();
    } on ShopifyRateLimitException catch (e) {
      attempt++;
      if (attempt >= config.maxAttempts) rethrow;
      final delay = Duration(seconds: e.retryAfterSeconds);
      ShopifyLogger.instance.warning(
        'Rate limited. Retrying in ${delay.inSeconds}s (attempt $attempt/${config.maxAttempts})',
      );
      await Future<void>.delayed(delay);
    } on ShopifyNetworkException catch (_) {
      attempt++;
      if (attempt >= config.maxAttempts) rethrow;
      final delay = config.delayFor(attempt - 1);
      ShopifyLogger.instance.warning(
        'Network error. Retrying in ${delay.inMilliseconds}ms (attempt $attempt/${config.maxAttempts})',
      );
      await Future<void>.delayed(delay);
    }
  }
}
