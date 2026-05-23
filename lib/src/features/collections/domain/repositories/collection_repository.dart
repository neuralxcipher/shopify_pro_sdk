/// Abstract collection repository contract.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../../core/utils/cursor_pagination.dart';
import '../../data/models/collection.dart';
import '../../data/queries/collection_queries.dart';

abstract interface class CollectionRepository {
  Future<ShopifyPage<Collection>> getCollections({
    int first = 20,
    String? after,
    String? country,
    String? language,
  });

  Future<Collection> getCollectionByHandle(
    String handle, {
    int productsFirst = 20,
    String? productsAfter,
    CollectionProductSortKey sortKey,
    bool reverse,
    String? country,
    String? language,
  });

  Future<Collection> getCollectionById(
    String id, {
    String? country,
    String? language,
  });
}
