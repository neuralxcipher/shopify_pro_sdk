/// Concrete implementation of CollectionRepository.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../../core/cache/cache_policy.dart';
import '../../../../core/client/shopify_config.dart';
import '../../../../core/errors/shopify_exception.dart';
import '../../../../core/graphql/graphql_engine.dart';
import '../../../../core/graphql/query_builder.dart';
import '../../../../core/utils/cursor_pagination.dart';
import '../../data/models/collection.dart';
import '../../data/queries/collection_queries.dart';
import '../../domain/repositories/collection_repository.dart';

final class CollectionRepositoryImpl implements CollectionRepository {
  const CollectionRepositoryImpl({
    required this.engine,
    required this.config,
  });

  final GraphQLEngine engine;
  final ShopifyConfig config;

  @override
  Future<ShopifyPage<Collection>> getCollections({
    int first = 20,
    String? after,
    String? country,
    String? language,
  }) async {
    final data = await engine.query(
      GraphQLRequestBuilder()
          .query(CollectionQueries.getCollections)
          .variable('first', first)
          .variable('country', country ?? config.country)
          .variable('language', language ?? config.language)
          .variables({if (after != null) 'after': after})
          .operationName('GetCollections')
          .build(),
      cacheTtl: CacheTtl.defaultProducts,
    );
    final connection = data['collections'] as Map<String, dynamic>;
    return ShopifyPage.fromConnection(connection, Collection.fromJson);
  }

  @override
  Future<Collection> getCollectionByHandle(
    String handle, {
    int productsFirst = 20,
    String? productsAfter,
    CollectionProductSortKey sortKey =
        CollectionProductSortKey.collectionDefault,
    bool reverse = false,
    String? country,
    String? language,
  }) async {
    final data = await engine.query(
      GraphQLRequestBuilder()
          .query(CollectionQueries.getCollectionByHandle)
          .variable('handle', handle)
          .variable('productsFirst', productsFirst)
          .variable('sortKey', sortKey.name.toUpperCase())
          .variable('reverse', reverse)
          .variable('country', country ?? config.country)
          .variable('language', language ?? config.language)
          .variables({
            if (productsAfter != null) 'productsAfter': productsAfter,
          })
          .operationName('GetCollectionByHandle')
          .build(),
      cacheTtl: CacheTtl.defaultProducts,
    );
    final collectionJson = data['collectionByHandle'] as Map<String, dynamic>?;
    if (collectionJson == null) {
      throw ShopifyNotFoundException('Collection not found: $handle');
    }
    return Collection.fromJson(collectionJson);
  }

  @override
  Future<Collection> getCollectionById(
    String id, {
    String? country,
    String? language,
  }) async {
    final data = await engine.query(
      GraphQLRequestBuilder()
          .query(CollectionQueries.getCollectionById)
          .variable('id', id)
          .variable('country', country ?? config.country)
          .variable('language', language ?? config.language)
          .operationName('GetCollectionById')
          .build(),
      cacheTtl: CacheTtl.defaultProducts,
    );
    final collectionJson = data['collection'] as Map<String, dynamic>?;
    if (collectionJson == null) {
      throw ShopifyNotFoundException('Collection not found: $id');
    }
    return Collection.fromJson(collectionJson);
  }
}
