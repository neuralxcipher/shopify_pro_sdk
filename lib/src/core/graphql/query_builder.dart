/// Fluent GraphQL request builder for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'dart:convert';

/// Immutable GraphQL request payload.
final class GraphQLRequest {
  const GraphQLRequest({
    required this.query,
    this.variables = const {},
    this.operationName,
  });

  final String query;
  final Map<String, dynamic> variables;
  final String? operationName;

  Map<String, dynamic> toJson() => {
        'query': query,
        if (variables.isNotEmpty) 'variables': variables,
        if (operationName != null) 'operationName': operationName,
      };

  String toJsonString() => jsonEncode(toJson());

  /// Creates a cache key based on the query and sorted variables.
  String cacheKey() {
    final sortedVars = Map.fromEntries(
      variables.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    return '${operationName ?? ""}|${query.trim()}|${jsonEncode(sortedVars)}';
  }
}

/// Fluent builder for constructing [GraphQLRequest] instances.
///
/// ```dart
/// final request = GraphQLRequestBuilder()
///   .query(ProductQueries.getProduct)
///   .variable('id', 'gid://shopify/Product/123')
///   .variable('country', 'US')
///   .build();
/// ```
final class GraphQLRequestBuilder {
  String? _query;
  final Map<String, dynamic> _variables = {};
  String? _operationName;

  GraphQLRequestBuilder query(String query) {
    _query = query;
    return this;
  }

  GraphQLRequestBuilder variable(String key, dynamic value) {
    _variables[key] = value;
    return this;
  }

  GraphQLRequestBuilder variables(Map<String, dynamic> vars) {
    _variables.addAll(vars);
    return this;
  }

  GraphQLRequestBuilder operationName(String name) {
    _operationName = name;
    return this;
  }

  GraphQLRequest build() {
    assert(_query != null && _query!.isNotEmpty, 'Query must not be empty');
    return GraphQLRequest(
      query: _query!,
      variables: Map.unmodifiable(_variables),
      operationName: _operationName,
    );
  }
}
