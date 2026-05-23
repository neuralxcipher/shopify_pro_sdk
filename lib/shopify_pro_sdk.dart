/// shopify_pro_sdk — Enterprise-grade Flutter SDK for Shopify Storefront API.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
/// https://neuralxcipher.com
library shopify_pro_sdk;

// Cache
export 'src/core/cache/cache_manager.dart';
export 'src/core/cache/cache_policy.dart';

// Core client
export 'src/core/client/shopify_client.dart';
export 'src/core/client/shopify_config.dart';

// Errors
export 'src/core/errors/shopify_exception.dart';

// GraphQL engine
export 'src/core/graphql/graphql_engine.dart';
export 'src/core/graphql/graphql_response.dart';
export 'src/core/graphql/query_builder.dart';

// Logging
export 'src/core/logging/shopify_logger.dart';

// Pagination & utilities
export 'src/core/utils/cursor_pagination.dart';
export 'src/core/utils/debouncer.dart';

// Extensions
export 'src/extensions/list_extensions.dart';
export 'src/extensions/money_extensions.dart';
export 'src/extensions/string_extensions.dart';

// Authentication
export 'src/features/auth/data/models/customer.dart';
export 'src/features/auth/data/models/customer_access_token.dart';
export 'src/features/auth/domain/auth_service.dart';
export 'src/features/auth/domain/repositories/auth_repository.dart';

// Cart
export 'src/features/cart/data/models/cart.dart';
export 'src/features/cart/data/models/cart_cost.dart';
export 'src/features/cart/data/models/cart_line.dart';
export 'src/features/cart/domain/cart_service.dart';
export 'src/features/cart/domain/repositories/cart_repository.dart';

// Checkout
export 'src/features/checkout/data/models/checkout.dart';
export 'src/features/checkout/domain/checkout_service.dart';
export 'src/features/checkout/domain/repositories/checkout_repository.dart';

// Collections
export 'src/features/collections/data/models/collection.dart';
export 'src/features/collections/domain/collection_service.dart';
export 'src/features/collections/domain/repositories/collection_repository.dart';

// Customer
export 'src/features/customer/data/models/customer_address.dart';
export 'src/features/customer/data/models/customer_order.dart';
export 'src/features/customer/domain/customer_service.dart';
export 'src/features/customer/domain/repositories/customer_repository.dart';

// Products
export 'src/features/products/data/models/metafield.dart';
export 'src/features/products/data/models/product.dart';
export 'src/features/products/data/models/product_image.dart';
export 'src/features/products/data/models/product_option.dart';
export 'src/features/products/data/models/product_variant.dart';
export 'src/features/products/domain/product_service.dart';
export 'src/features/products/domain/repositories/product_repository.dart';

// Search
export 'src/features/search/data/models/search_result.dart';
export 'src/features/search/domain/repositories/search_repository.dart';
export 'src/features/search/domain/search_service.dart';
