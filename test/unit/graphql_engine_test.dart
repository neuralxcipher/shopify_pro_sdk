/// Unit tests for GraphQLEngine.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:shopify_pro_sdk/src/core/cache/cache_manager.dart';
import 'package:shopify_pro_sdk/src/core/cache/cache_policy.dart';
import 'package:shopify_pro_sdk/src/core/errors/shopify_exception.dart';
import 'package:shopify_pro_sdk/src/core/graphql/graphql_engine.dart';
import 'package:shopify_pro_sdk/src/core/graphql/query_builder.dart';
import 'package:shopify_pro_sdk/src/core/network/retry_handler.dart';

import '../mocks/mock_http_client.dart';

class _FakeHttpClient extends http.BaseClient {
  http.Response nextResponse = http.Response('{}', 200);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async =>
      http.StreamedResponse(
        Stream.value(nextResponse.bodyBytes),
        nextResponse.statusCode,
        headers: nextResponse.headers,
      );
}

void main() {
  late _FakeHttpClient fakeHttp;
  late ShopifyCacheManager cache;
  late GraphQLEngine engine;

  const testEndpoint =
      'https://test-store.myshopify.com/api/2025-01/graphql.json';
  const testHeaders = {'X-Shopify-Storefront-Access-Token': 'test_token'};

  setUp(() async {
    fakeHttp = _FakeHttpClient();
    cache = ShopifyCacheManager();
    engine = GraphQLEngine(
      endpoint: testEndpoint,
      headers: testHeaders,
      cacheManager: cache,
      defaultCachePolicy: CachePolicy.networkOnly,
      retryConfig: const RetryConfig(maxAttempts: 1),
      httpClient: fakeHttp,
    );
  });

  group('GraphQLEngine.query', () {
    test('returns data on successful 200 response', () async {
      fakeHttp.nextResponse = fakeJsonResponse(
        gqlData({
          'product': <String, dynamic>{
            'id': 'gid://shopify/Product/1',
            'title': 'Test',
          },
        }),
      );

      final result = await engine.query(
        GraphQLRequestBuilder()
            .query('{ product(id: "1") { id title } }')
            .build(),
      );

      expect(result['product'], isA<Map<String, dynamic>>());
      expect(
        (result['product'] as Map<String, dynamic>)['title'],
        equals('Test'),
      );
    });

    test('throws ShopifyGraphQLException on GraphQL errors', () async {
      fakeHttp.nextResponse =
          fakeJsonResponse(gqlErrors(['Product not found']));

      await expectLater(
        engine.query(
          GraphQLRequestBuilder()
              .query('{ product(id: "bad") { id } }')
              .build(),
        ),
        throwsA(isA<ShopifyGraphQLException>()),
      );
    });

    test('throws ShopifyAuthException on 401', () async {
      fakeHttp.nextResponse = fakeJsonResponse({}, statusCode: 401);

      await expectLater(
        engine.query(
          GraphQLRequestBuilder().query('{ shop { name } }').build(),
        ),
        throwsA(isA<ShopifyAuthException>()),
      );
    });

    test('throws ShopifyRateLimitException on 429', () async {
      fakeHttp.nextResponse = fakeJsonResponse({}, statusCode: 429);

      await expectLater(
        engine.query(
          GraphQLRequestBuilder().query('{ shop { name } }').build(),
        ),
        throwsA(isA<ShopifyRateLimitException>()),
      );
    });
  });

  group('GraphQLRequestBuilder', () {
    test('builds request with variables', () {
      final request = GraphQLRequestBuilder()
          .query(r'query Test($id: ID!) { product(id: $id) { id } }')
          .variable('id', 'gid://shopify/Product/1')
          .operationName('Test')
          .build();

      expect(request.variables['id'], equals('gid://shopify/Product/1'));
      expect(request.operationName, equals('Test'));
    });

    test('generates stable cache key', () {
      final r1 = GraphQLRequestBuilder()
          .query('{ shop { name } }')
          .variable('a', 1)
          .variable('b', 2)
          .build();

      final r2 = GraphQLRequestBuilder()
          .query('{ shop { name } }')
          .variable('b', 2)
          .variable('a', 1)
          .build();

      // Cache key must be order-independent (variables are sorted).
      expect(r1.cacheKey(), equals(r2.cacheKey()));
    });
  });
}
