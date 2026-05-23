/// CollectionService — business logic for the collections feature.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../core/utils/cursor_pagination.dart';
import '../data/models/collection.dart';
import '../data/queries/collection_queries.dart';
import 'repositories/collection_repository.dart';

/// High-level collection API exposed on ShopifyClient.collections.
class CollectionService {
  const CollectionService(this._repository);

  final CollectionRepository _repository;

  /// Returns all collections with basic metadata.
  Future<ShopifyPage<Collection>> fetchCollections({
    int first = 20,
    String? after,
    String? country,
    String? language,
  }) =>
      _repository.getCollections(
        first: first,
        after: after,
        country: country,
        language: language,
      );

  /// Fetches a collection and its products by URL handle.
  Future<Collection> fetchByHandle(
    String handle, {
    int productsFirst = 20,
    String? productsAfter,
    CollectionProductSortKey sortKey =
        CollectionProductSortKey.collectionDefault,
    bool reverse = false,
    String? country,
    String? language,
  }) =>
      _repository.getCollectionByHandle(
        handle,
        productsFirst: productsFirst,
        productsAfter: productsAfter,
        sortKey: sortKey,
        reverse: reverse,
        country: country,
        language: language,
      );

  /// Fetches a collection by its Shopify Global ID.
  Future<Collection> fetchById(
    String id, {
    String? country,
    String? language,
  }) =>
      _repository.getCollectionById(id, country: country, language: language);
}
