/// Search result models for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../collections/data/models/collection.dart';
import '../../../products/data/models/product.dart';

/// A unified search result that may contain products, collections, or pages.
final class SearchResult {
  const SearchResult({
    this.products = const [],
    this.collections = const [],
    this.totalProductCount = 0,
  });

  factory SearchResult.fromJson(Map<String, dynamic> json) {
    final productEdges = (json['products'] as Map<String, dynamic>?)?['edges']
            as List<dynamic>? ??
        [];
    final collectionEdges = (json['collections']
            as Map<String, dynamic>?)?['edges'] as List<dynamic>? ??
        [];

    return SearchResult(
      products: productEdges
          .map(
            (e) => Product.fromJson(
              (e as Map<String, dynamic>)['node'] as Map<String, dynamic>,
            ),
          )
          .toList(),
      collections: collectionEdges
          .map(
            (e) => Collection.fromJson(
              (e as Map<String, dynamic>)['node'] as Map<String, dynamic>,
            ),
          )
          .toList(),
      totalProductCount:
          (json['products'] as Map<String, dynamic>?)?['totalCount'] as int? ??
              0,
    );
  }

  final List<Product> products;
  final List<Collection> collections;
  final int totalProductCount;

  bool get isEmpty => products.isEmpty && collections.isEmpty;
}

/// A single predictive search suggestion (product, collection, or query).
final class PredictiveSearchResult {
  const PredictiveSearchResult({
    this.products = const [],
    this.collections = const [],
    this.queries = const [],
  });

  factory PredictiveSearchResult.fromJson(Map<String, dynamic> json) {
    final predictive = json['predictiveSearch'] as Map<String, dynamic>? ?? {};
    final productRaw = (predictive['products'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final collectionRaw = (predictive['collections'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final queryRaw = (predictive['queries'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    return PredictiveSearchResult(
      products: productRaw.map(Product.fromJson).toList(),
      collections: collectionRaw.map(Collection.fromJson).toList(),
      queries: queryRaw
          .map((q) => q['text'] as String? ?? '')
          .where((s) => s.isNotEmpty)
          .toList(),
    );
  }

  final List<Product> products;
  final List<Collection> collections;

  /// Suggested search queries (auto-complete strings).
  final List<String> queries;

  bool get isEmpty =>
      products.isEmpty && collections.isEmpty && queries.isEmpty;
}
