/// Debouncer utility for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'dart:async';

/// Collapses rapid successive calls into a single deferred execution.
///
/// Typical usage for a search input:
/// ```dart
/// final _debouncer = Debouncer(delay: Duration(milliseconds: 350));
///
/// void onSearchChanged(String query) {
///   _debouncer.run(() => shopify.search.search(query));
/// }
/// ```
final class Debouncer {
  Debouncer({this.delay = const Duration(milliseconds: 300)});

  final Duration delay;
  Timer? _timer;

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Immediately fires any pending action and cancels the timer.
  void flush() {
    _timer?.cancel();
    _timer = null;
  }

  void dispose() {
    _timer?.cancel();
  }
}
