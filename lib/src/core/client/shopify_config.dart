/// ShopifyConfig — store connection and behaviour settings.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../cache/cache_policy.dart';
import '../errors/shopify_exception.dart';
import '../logging/shopify_logger.dart';
import '../network/retry_handler.dart';

/// Shopify Storefront API version used by the SDK.
///
/// Update this constant when Shopify releases a new stable version.
const String kDefaultApiVersion = '2025-01';

/// All configuration required to connect to a Shopify store.
///
/// ```dart
/// final config = ShopifyConfig(
///   storeDomain: 'my-store.myshopify.com',
///   storefrontAccessToken: 'your_public_token',
/// );
/// ```
final class ShopifyConfig {
  ShopifyConfig({
    required this.storeDomain,
    required this.storefrontAccessToken,
    this.apiVersion = kDefaultApiVersion,
    this.language = 'EN',
    this.country = 'US',
    this.currency,
    this.logLevel = ShopifyLogLevel.info,
    this.defaultCachePolicy = CachePolicy.cacheFirst,
    this.retryConfig = const RetryConfig(),
    this.connectTimeout = const Duration(seconds: 30),
    this.receiveTimeout = const Duration(seconds: 30),
  }) {
    _validate();
  }

  /// e.g. `my-store.myshopify.com` — no protocol prefix, no trailing slash.
  final String storeDomain;

  /// Public Storefront API access token from Shopify Partners dashboard.
  final String storefrontAccessToken;

  /// Shopify Storefront API version string, e.g. `2025-01`.
  final String apiVersion;

  /// BCP 47 language code for localised content, e.g. `EN`, `FR`, `AR`.
  final String language;

  /// ISO 3166-1 alpha-2 country code for markets, e.g. `US`, `GB`, `PK`.
  final String country;

  /// Optional ISO 4217 currency override, e.g. `USD`, `GBP`.
  final String? currency;

  /// Controls SDK console output verbosity.
  final ShopifyLogLevel logLevel;

  /// Default cache strategy applied to all GraphQL queries.
  final CachePolicy defaultCachePolicy;

  /// Retry configuration for transient network failures.
  final RetryConfig retryConfig;

  final Duration connectTimeout;
  final Duration receiveTimeout;

  /// Full Storefront GraphQL endpoint URL.
  String get storefrontEndpoint =>
      'https://$storeDomain/api/$apiVersion/graphql.json';

  void _validate() {
    if (storeDomain.isEmpty) {
      throw const ShopifyConfigException('storeDomain must not be empty');
    }
    if (storeDomain.startsWith('http')) {
      throw const ShopifyConfigException(
        'storeDomain must not include a protocol prefix (e.g. use "my-store.myshopify.com")',
      );
    }
    if (storefrontAccessToken.isEmpty) {
      throw const ShopifyConfigException(
        'storefrontAccessToken must not be empty',
      );
    }
  }
}
