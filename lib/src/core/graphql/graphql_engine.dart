/// Lightweight GraphQL engine powering shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../cache/cache_manager.dart';
import '../cache/cache_policy.dart';
import '../errors/shopify_exception.dart';
import '../logging/shopify_logger.dart';
import '../network/retry_handler.dart';
import 'graphql_response.dart';
import 'query_builder.dart';

/// Core GraphQL execution engine.
///
/// Features:
/// - Two-tier cache (memory + disk) with configurable TTL and policy
/// - Automatic retry with exponential back-off and jitter
/// - Rate-limit detection and transparent delay
/// - Full request/response logging in debug mode
/// - Typed [GraphQLResponse] results — no raw `dynamic` leaks into consumer code
class GraphQLEngine {
  GraphQLEngine({
    required this.endpoint,
    required this.headers,
    required this.cacheManager,
    this.retryConfig = const RetryConfig(),
    this.defaultCachePolicy = CachePolicy.cacheFirst,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final String endpoint;
  final Map<String, String> headers;
  final ShopifyCacheManager cacheManager;
  final RetryConfig retryConfig;
  final CachePolicy defaultCachePolicy;
  final http.Client _http;

  static final _log = ShopifyLogger.instance;

  /// Executes a GraphQL query, applying [cachePolicy] and [cacheTtl].
  Future<Map<String, dynamic>> query(
    GraphQLRequest request, {
    CachePolicy? cachePolicy,
    CacheTtl? cacheTtl,
  }) =>
      _execute(
        request,
        cachePolicy: cachePolicy ?? defaultCachePolicy,
        cacheTtl: cacheTtl ?? CacheTtl.defaultProducts,
      );

  /// Executes a GraphQL mutation (always bypasses cache).
  Future<Map<String, dynamic>> mutate(GraphQLRequest request) =>
      _execute(request, cachePolicy: CachePolicy.networkOnly);

  Future<Map<String, dynamic>> _execute(
    GraphQLRequest request, {
    required CachePolicy cachePolicy,
    CacheTtl? cacheTtl,
  }) async {
    final cacheKey = request.cacheKey();

    if (cachePolicy == CachePolicy.cacheFirst ||
        cachePolicy == CachePolicy.cacheAndNetwork ||
        cachePolicy == CachePolicy.cacheOnly) {
      final cached = await cacheManager.get(
          cacheKey, cacheTtl ?? CacheTtl.defaultProducts);
      if (cached != null) {
        if (cachePolicy == CachePolicy.cacheAndNetwork) {
          _fetchAndCache(
              request, cacheKey); // fire-and-forget background refresh
        }
        return cached;
      }
      if (cachePolicy == CachePolicy.cacheOnly) {
        throw ShopifyNetworkException('Cache miss for key: $cacheKey');
      }
    }

    return withRetry(
      () => _doRequest(request, cacheKey, cachePolicy),
      config: retryConfig,
    );
  }

  Future<Map<String, dynamic>> _doRequest(
    GraphQLRequest request,
    String cacheKey,
    CachePolicy cachePolicy,
  ) async {
    _log.debug('→ GraphQL request: ${request.operationName ?? "anonymous"}',
        request.variables);

    late http.Response response;
    try {
      response = await _http
          .post(
            Uri.parse(endpoint),
            headers: {...headers, 'Content-Type': 'application/json'},
            body: request.toJsonString(),
          )
          .timeout(const Duration(seconds: 30));
    } on SocketException catch (e) {
      throw ShopifyNetworkException('No internet connection', cause: e);
    } on HttpException catch (e) {
      throw ShopifyNetworkException('HTTP error', cause: e);
    } on Exception catch (e) {
      throw ShopifyNetworkException('Request failed', cause: e);
    }

    _log.debug(
        '← HTTP ${response.statusCode} for ${request.operationName ?? "anonymous"}');

    if (response.statusCode == 429) {
      final retryAfter = int.tryParse(
            response.headers['retry-after'] ?? '',
          ) ??
          2;
      throw ShopifyRateLimitException(retryAfterSeconds: retryAfter);
    }

    if (response.statusCode == 401) {
      throw ShopifyAuthException(
        'Unauthorised: check your Storefront Access Token',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 400) {
      throw ShopifyNetworkException(
        'Server error ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }

    late Map<String, dynamic> json;
    try {
      json = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (e) {
      throw ShopifyDeserializationException(
        'Failed to decode response JSON',
        cause: e,
      );
    }

    _checkGraphQLErrors(json);

    final data = json['data'] as Map<String, dynamic>?;
    if (data == null) {
      throw const ShopifyDeserializationException(
          'Response has no "data" field');
    }

    if (cachePolicy != CachePolicy.networkOnly) {
      await cacheManager.set(cacheKey, data);
    }

    return data;
  }

  void _checkGraphQLErrors(Map<String, dynamic> json) {
    final rawErrors = json['errors'] as List<dynamic>?;
    if (rawErrors == null || rawErrors.isEmpty) return;

    final errors = rawErrors
        .map((e) => GraphQLError.fromJson(e as Map<String, dynamic>))
        .toList();

    if (errors.any((e) => e.isThrottled)) {
      throw const ShopifyRateLimitException();
    }

    throw ShopifyGraphQLException(
      errors.map((e) => e.message).join('; '),
      errors: errors,
    );
  }

  void _fetchAndCache(GraphQLRequest request, String cacheKey) {
    _doRequest(request, cacheKey, CachePolicy.networkFirst).ignore();
  }

  void dispose() => _http.close();
}
