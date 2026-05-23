/// Concrete implementation of ProductRepository.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../../core/cache/cache_policy.dart';
import '../../../../core/client/shopify_config.dart';
import '../../../../core/errors/shopify_exception.dart';
import '../../../../core/graphql/graphql_engine.dart';
import '../../../../core/graphql/query_builder.dart';
import '../../../../core/utils/cursor_pagination.dart';
import '../../data/models/product.dart';
import '../../data/queries/product_queries.dart';
import '../../domain/repositories/product_repository.dart';

/// GraphQL-backed implementation of [ProductRepository].
final class ProductRepositoryImpl implements ProductRepository {
  const ProductRepositoryImpl({
    required this.engine,
    required this.config,
  });

  final GraphQLEngine engine;
  final ShopifyConfig config;

  @override
  Future<Product> getProductById(
    String id, {
    String? country,
    String? language,
  }) async {
    final data = await engine.query(
      GraphQLRequestBuilder()
          .query(ProductQueries.getProductById)
          .variable('id', id)
          .variable('country', country ?? config.country)
          .variable('language', language ?? config.language)
          .operationName('GetProductById')
          .build(),
      cacheTtl: CacheTtl.defaultProducts,
    );

    final productJson = data['product'] as Map<String, dynamic>?;
    if (productJson == null) {
      throw ShopifyNotFoundException('Product not found: $id');
    }
    return Product.fromJson(productJson);
  }

  @override
  Future<Product> getProductByHandle(
    String handle, {
    String? country,
    String? language,
  }) async {
    final data = await engine.query(
      GraphQLRequestBuilder()
          .query(ProductQueries.getProductByHandle)
          .variable('handle', handle)
          .variable('country', country ?? config.country)
          .variable('language', language ?? config.language)
          .operationName('GetProductByHandle')
          .build(),
      cacheTtl: CacheTtl.defaultProducts,
    );

    final productJson = data['productByHandle'] as Map<String, dynamic>?;
    if (productJson == null) {
      throw ShopifyNotFoundException('Product not found: $handle');
    }
    return Product.fromJson(productJson);
  }

  @override
  Future<ShopifyPage<Product>> getProducts({
    int first = 20,
    String? after,
    ProductSortKey sortKey = ProductSortKey.relevance,
    bool reverse = false,
    String? query,
    String? country,
    String? language,
  }) async {
    final data = await engine.query(
      GraphQLRequestBuilder()
          .query(ProductQueries.getProducts)
          .variable('first', first)
          .variable('sortKey', sortKey.name.toUpperCase())
          .variable('reverse', reverse)
          .variable('country', country ?? config.country)
          .variable('language', language ?? config.language)
          .variables({
            if (after != null) 'after': after,
            if (query != null) 'query': query,
          })
          .operationName('GetProducts')
          .build(),
      cacheTtl: CacheTtl.defaultProducts,
    );

    final connection = data['products'] as Map<String, dynamic>;
    return ShopifyPage.fromConnection(connection, Product.fromJson);
  }

  @override
  Future<List<Product>> getProductRecommendations(
    String productId, {
    String intent = 'RELATED',
  }) async {
    final data = await engine.query(
      GraphQLRequestBuilder()
          .query(ProductQueries.getProductRecommendations)
          .variable('productId', productId)
          .variable('intent', intent)
          .operationName('GetProductRecommendations')
          .build(),
      cachePolicy: CachePolicy.networkFirst,
      cacheTtl: CacheTtl.defaultProducts,
    );

    final recs = data['productRecommendations'] as List<dynamic>? ?? [];
    return recs
        .map((p) => Product.fromJson(p as Map<String, dynamic>))
        .toList();
  }
}
