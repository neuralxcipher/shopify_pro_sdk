/// Concrete implementation of SearchRepository.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../../core/cache/cache_policy.dart';
import '../../../../core/client/shopify_config.dart';
import '../../../../core/graphql/graphql_engine.dart';
import '../../../../core/graphql/query_builder.dart';
import '../../../../core/utils/cursor_pagination.dart';
import '../../../products/data/models/product.dart';
import '../../data/models/search_result.dart';
import '../../data/queries/search_queries.dart';
import '../../domain/repositories/search_repository.dart';

final class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl({
    required this.engine,
    required this.config,
  });

  final GraphQLEngine engine;
  final ShopifyConfig config;

  @override
  Future<ShopifyPage<Product>> search(
    String query, {
    int first = 20,
    String? after,
    String? country,
    String? language,
  }) async {
    final data = await engine.query(
      GraphQLRequestBuilder()
          .query(SearchQueries.search)
          .variable('query', query)
          .variable('first', first)
          .variable('country', country ?? config.country)
          .variable('language', language ?? config.language)
          .variables({if (after != null) 'after': after})
          .operationName('Search')
          .build(),
      cachePolicy: CachePolicy.networkFirst,
      cacheTtl: CacheTtl.defaultProducts,
    );

    // The search connection has a flat `edges` with polymorphic nodes.
    // We extract only Product nodes here.
    final searchData = data['search'] as Map<String, dynamic>;
    final pageInfo = searchData['pageInfo'] as Map<String, dynamic>? ?? {};
    final edges = (searchData['edges'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();

    final products = edges
        .map((e) => e['node'] as Map<String, dynamic>)
        .where((n) => n.containsKey('variants'))
        .map(Product.fromJson)
        .toList();

    return ShopifyPage(
      items: products,
      hasNextPage: pageInfo['hasNextPage'] as bool? ?? false,
      hasPreviousPage: false,
      endCursor: pageInfo['endCursor'] as String?,
    );
  }

  @override
  Future<PredictiveSearchResult> predictiveSearch(
    String query, {
    String? country,
    String? language,
  }) async {
    final data = await engine.query(
      GraphQLRequestBuilder()
          .query(SearchQueries.predictiveSearch)
          .variable('query', query)
          .variable('country', country ?? config.country)
          .variable('language', language ?? config.language)
          .operationName('PredictiveSearch')
          .build(),
      cachePolicy: CachePolicy.networkFirst,
      cacheTtl: CacheTtl.cart,
    );

    return PredictiveSearchResult.fromJson(data);
  }
}
