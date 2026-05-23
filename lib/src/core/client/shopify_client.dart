/// ShopifyClient — the single entry point for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/auth_service.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/cart_service.dart';
import '../../features/checkout/data/repositories/checkout_repository_impl.dart';
import '../../features/checkout/domain/checkout_service.dart';
import '../../features/collections/data/repositories/collection_repository_impl.dart';
import '../../features/collections/domain/collection_service.dart';
import '../../features/customer/data/repositories/customer_repository_impl.dart';
import '../../features/customer/domain/customer_service.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/product_service.dart';
import '../../features/search/data/repositories/search_repository_impl.dart';
import '../../features/search/domain/search_service.dart';
import '../cache/cache_manager.dart';
import '../graphql/graphql_engine.dart';
import '../logging/shopify_logger.dart';
import 'shopify_config.dart';

/// The primary entry-point for the shopify_pro_sdk.
///
/// Initialise once at app startup and inject the services you need:
///
/// ```dart
/// final shopify = await ShopifyClient.init(
///   config: ShopifyConfig(
///     storeDomain: 'my-store.myshopify.com',
///     storefrontAccessToken: 'your_public_token',
///   ),
/// );
///
/// // Then use the services:
/// final products = await shopify.products.fetchProducts();
/// final cart     = await shopify.cart.createCart();
/// ```
class ShopifyClient {
  ShopifyClient._({
    required ShopifyConfig config,
    required GraphQLEngine engine,
    required ShopifyCacheManager cache,
  })  : _config = config,
        _engine = engine,
        _cache = cache;

  final ShopifyConfig _config;
  final GraphQLEngine _engine;
  final ShopifyCacheManager _cache;

  // ── Service singletons (lazy) ────────────────────────────────────────────

  late final ProductService products = ProductService(
    ProductRepositoryImpl(engine: _engine, config: _config),
  );

  late final CollectionService collections = CollectionService(
    CollectionRepositoryImpl(engine: _engine, config: _config),
  );

  late final AuthService auth = AuthService(
    AuthRepositoryImpl(engine: _engine, config: _config),
  );

  late final CartService cart = CartService(
    CartRepositoryImpl(engine: _engine, config: _config),
  );

  late final CheckoutService checkout = CheckoutService(
    CheckoutRepositoryImpl(engine: _engine, config: _config),
  );

  late final SearchService search = SearchService(
    SearchRepositoryImpl(engine: _engine, config: _config),
  );

  late final CustomerService customer = CustomerService(
    CustomerRepositoryImpl(engine: _engine, config: _config),
  );

  ShopifyConfig get config => _config;

  // ── Factory ──────────────────────────────────────────────────────────────

  /// Creates and initialises a [ShopifyClient].
  ///
  /// This must be `await`-ed before the client is used — it warms the disk
  /// cache and applies [ShopifyConfig.logLevel] to the logger.
  static Future<ShopifyClient> init({required ShopifyConfig config}) async {
    ShopifyLogger.instance.level = config.logLevel;

    final cache = ShopifyCacheManager();
    await cache.init();

    final engine = GraphQLEngine(
      endpoint: config.storefrontEndpoint,
      headers: {
        'X-Shopify-Storefront-Access-Token': config.storefrontAccessToken,
        'Accept': 'application/json',
        'Accept-Language': config.language,
      },
      cacheManager: cache,
      retryConfig: config.retryConfig,
      defaultCachePolicy: config.defaultCachePolicy,
    );

    ShopifyLogger.instance.info(
      'ShopifyClient initialised → ${config.storefrontEndpoint}',
    );

    return ShopifyClient._(config: config, engine: engine, cache: cache);
  }

  /// Clears all cached responses (memory + disk).
  Future<void> clearCache() => _cache.invalidateAll();

  /// Releases HTTP resources. Call when the client is no longer needed.
  void dispose() => _engine.dispose();
}
