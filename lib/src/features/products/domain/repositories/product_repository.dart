/// Abstract product repository contract.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../../core/utils/cursor_pagination.dart';
import '../../data/models/product.dart';
import '../../data/queries/product_queries.dart';

/// Defines the data-access contract for the products feature.
///
/// Concrete implementations live in the `data/repositories/` layer;
/// the service layer depends only on this interface.
abstract interface class ProductRepository {
  /// Fetches a single product by its Shopify GID.
  Future<Product> getProductById(
    String id, {
    String? country,
    String? language,
  });

  /// Fetches a single product by its URL handle.
  Future<Product> getProductByHandle(
    String handle, {
    String? country,
    String? language,
  });

  /// Returns a paginated list of products.
  Future<ShopifyPage<Product>> getProducts({
    int first = 20,
    String? after,
    ProductSortKey sortKey = ProductSortKey.relevance,
    bool reverse = false,
    String? query,
    String? country,
    String? language,
  });

  /// Returns Shopify ML-powered product recommendations.
  Future<List<Product>> getProductRecommendations(
    String productId, {
    String intent = 'RELATED',
  });
}
