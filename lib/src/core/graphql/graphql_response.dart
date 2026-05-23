/// GraphQL response wrapper for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:shopify_pro_sdk/src/core/errors/shopify_exception.dart';

/// Typed result returned by the GraphQL engine for every query and mutation.
final class GraphQLResponse<T> {
  const GraphQLResponse._({this.data, this.errors, this.extensions});

  factory GraphQLResponse.success(T data, [Map<String, dynamic>? extensions]) =>
      GraphQLResponse._(data: data, extensions: extensions);

  factory GraphQLResponse.failure(List<GraphQLError> errors) =>
      GraphQLResponse._(errors: errors);

  factory GraphQLResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromData,
  ) {
    final rawErrors = json['errors'] as List<dynamic>?;
    final errors = rawErrors
        ?.map((e) => GraphQLError.fromJson(e as Map<String, dynamic>))
        .toList();

    if (errors != null && errors.isNotEmpty) {
      return GraphQLResponse.failure(errors);
    }

    final rawData = json['data'];
    if (rawData == null) {
      return GraphQLResponse.failure([
        const GraphQLError(message: 'Response contained no data field'),
      ]);
    }

    return GraphQLResponse.success(
      fromData(rawData as Map<String, dynamic>),
      json['extensions'] as Map<String, dynamic>?,
    );
  }

  final T? data;
  final List<GraphQLError>? errors;
  final Map<String, dynamic>? extensions;

  bool get hasErrors => errors != null && errors!.isNotEmpty;
  bool get hasData => data != null;

  /// Throws [ShopifyGraphQLException] if the response contains errors.
  T get dataOrThrow {
    if (hasErrors) {
      throw ShopifyGraphQLException(
        errors!.map((e) => e.message).join('; '),
        errors: errors!,
      );
    }
    if (data == null) {
      throw const ShopifyGraphQLException(
        'No data in response',
        errors: [],
      );
    }
    return data as T;
  }

  /// Cost info from the Shopify query cost extension.
  QueryCost? get queryCost {
    final costRaw = extensions?['cost'] as Map<String, dynamic>?;
    if (costRaw == null) return null;
    return QueryCost.fromJson(costRaw);
  }
}

/// Shopify Storefront API query cost (useful for rate-limit budgeting).
final class QueryCost {
  const QueryCost({
    required this.requestedQueryCost,
    required this.actualQueryCost,
    required this.throttleStatus,
  });

  factory QueryCost.fromJson(Map<String, dynamic> json) => QueryCost(
        requestedQueryCost: json['requestedQueryCost'] as int? ?? 0,
        actualQueryCost: json['actualQueryCost'] as int? ?? 0,
        throttleStatus: ThrottleStatus.fromJson(
          json['throttleStatus'] as Map<String, dynamic>? ?? {},
        ),
      );

  final int requestedQueryCost;
  final int actualQueryCost;
  final ThrottleStatus throttleStatus;
}

/// Shopify Storefront throttle status from the query cost extension.
final class ThrottleStatus {
  const ThrottleStatus({
    required this.maximumAvailable,
    required this.currentlyAvailable,
    required this.restoreRate,
  });

  factory ThrottleStatus.fromJson(Map<String, dynamic> json) => ThrottleStatus(
        maximumAvailable: (json['maximumAvailable'] as num?)?.toDouble() ?? 0,
        currentlyAvailable:
            (json['currentlyAvailable'] as num?)?.toDouble() ?? 0,
        restoreRate: (json['restoreRate'] as num?)?.toDouble() ?? 0,
      );

  final double maximumAvailable;
  final double currentlyAvailable;
  final double restoreRate;

  bool get isThrottled => currentlyAvailable <= 0;
}
