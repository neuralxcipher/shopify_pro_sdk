/// Cache policy definitions for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

/// Controls how the two-tier cache (memory + disk) is consulted.
enum CachePolicy {
  /// Always fetch from network; never read from cache.
  networkOnly,

  /// Read from cache first; fetch from network only on miss.
  cacheFirst,

  /// Fetch from network first; fall back to cache on failure.
  networkFirst,

  /// Return cached data immediately AND fetch from network in background
  /// to update the cache (stale-while-revalidate).
  cacheAndNetwork,

  /// Read from cache only; throw on miss.
  cacheOnly,
}

/// Time-to-live configuration attached to a cache entry.
final class CacheTtl {
  const CacheTtl(this.duration);

  // Named constructors cannot be const because Duration(minutes: variable)
  // is not a constant expression — drop const here.
  CacheTtl.minutes(int minutes) : duration = Duration(minutes: minutes);

  CacheTtl.hours(int hours) : duration = Duration(hours: hours);

  /// Never expire (useful for immutable resources like product IDs).
  static const CacheTtl infinite = CacheTtl(Duration(days: 36500));

  /// Sensible default for product/collection data (5 minutes).
  static const CacheTtl defaultProducts = CacheTtl(Duration(minutes: 5));

  /// Shorter TTL for cart and pricing (30 seconds).
  static const CacheTtl cart = CacheTtl(Duration(seconds: 30));

  final Duration duration;

  bool isExpired(DateTime createdAt) =>
      DateTime.now().difference(createdAt) > duration;
}
