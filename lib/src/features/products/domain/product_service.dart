/// ProductService — business logic for the products feature.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../core/utils/cursor_pagination.dart';
import '../data/models/product.dart';
import '../data/queries/product_queries.dart';
import 'repositories/product_repository.dart';

/// High-level product API exposed on ShopifyClient.products.
///
/// ```dart
/// // Fetch first page
/// final page = await shopify.products.fetchProducts(first: 24);
///
/// // Load next page
/// final next = await shopify.products.fetchProducts(after: page.endCursor);
///
/// // Single product
/// final product = await shopify.products.fetchByHandle('classic-tee');
/// ```
class ProductService {
  const ProductService(this._repository);

  final ProductRepository _repository;

  /// Returns the first [first] products. Pass [after] for pagination.
  Future<ShopifyPage<Product>> fetchProducts({
    int first = 20,
    String? after,
    ProductSortKey sortKey = ProductSortKey.relevance,
    bool reverse = false,
    String? query,
    String? country,
    String? language,
  }) =>
      _repository.getProducts(
        first: first,
        after: after,
        sortKey: sortKey,
        reverse: reverse,
        query: query,
        country: country,
        language: language,
      );

  /// Fetches a product by its Shopify Global ID.
  Future<Product> fetchById(String id, {String? country, String? language}) =>
      _repository.getProductById(id, country: country, language: language);

  /// Fetches a product by its URL handle (slug).
  Future<Product> fetchByHandle(
    String handle, {
    String? country,
    String? language,
  }) =>
      _repository.getProductByHandle(
        handle,
        country: country,
        language: language,
      );

  /// Returns Shopify ML recommendations for the given product ID.
  Future<List<Product>> fetchRecommendations(
    String productId, {
    String intent = 'RELATED',
  }) =>
      _repository.getProductRecommendations(productId, intent: intent);

  /// Convenience: search products by keyword using the query filter syntax.
  Future<ShopifyPage<Product>> search(
    String keyword, {
    int first = 20,
    String? after,
  }) =>
      _repository.getProducts(
        first: first,
        after: after,
        query: keyword,
      );
}
