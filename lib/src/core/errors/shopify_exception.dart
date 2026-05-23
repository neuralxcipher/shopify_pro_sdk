/// Typed exception hierarchy for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

/// Base class for all SDK exceptions.
sealed class ShopifyException implements Exception {
  const ShopifyException(this.message, {this.statusCode, this.cause});

  final String message;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() => 'ShopifyException: $message';
}

/// Thrown when a network call fails (timeout, no connection, DNS failure).
final class ShopifyNetworkException extends ShopifyException {
  const ShopifyNetworkException(super.message, {super.statusCode, super.cause});
}

/// Thrown when the Shopify API returns one or more GraphQL errors.
final class ShopifyGraphQLException extends ShopifyException {
  const ShopifyGraphQLException(super.message, {required this.errors});

  final List<GraphQLError> errors;
}

/// Thrown on HTTP 401 / invalid / expired access token.
final class ShopifyAuthException extends ShopifyException {
  const ShopifyAuthException(super.message, {super.statusCode});
}

/// Thrown when the API returns HTTP 429 or a throttled error code.
final class ShopifyRateLimitException extends ShopifyException {
  const ShopifyRateLimitException({this.retryAfterSeconds = 2})
      : super('Rate limit exceeded. Retry after $retryAfterSeconds seconds.');

  final int retryAfterSeconds;
}

/// Thrown when a requested resource (product, collection, etc.) is not found.
final class ShopifyNotFoundException extends ShopifyException {
  const ShopifyNotFoundException(super.message);
}

/// Thrown when JSON deserialization fails on an API response.
final class ShopifyDeserializationException extends ShopifyException {
  const ShopifyDeserializationException(super.message, {super.cause});
}

/// Thrown when configuration is invalid or incomplete.
final class ShopifyConfigException extends ShopifyException {
  const ShopifyConfigException(super.message);
}

/// Represents a single error entry from the GraphQL `errors` array.
final class GraphQLError {
  const GraphQLError({
    required this.message,
    this.extensions,
    this.locations,
    this.path,
  });

  factory GraphQLError.fromJson(Map<String, dynamic> json) => GraphQLError(
        message: json['message'] as String? ?? 'Unknown GraphQL error',
        extensions: json['extensions'] as Map<String, dynamic>?,
        locations: (json['locations'] as List<dynamic>?)
            ?.map(
              (e) => GraphQLErrorLocation.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        path: (json['path'] as List<dynamic>?)?.cast<String>(),
      );

  final String message;
  final Map<String, dynamic>? extensions;
  final List<GraphQLErrorLocation>? locations;
  final List<String>? path;

  String? get code => extensions?['code'] as String?;

  bool get isThrottled =>
      code == 'THROTTLED' || message.toLowerCase().contains('throttled');

  @override
  String toString() =>
      'GraphQLError: $message${code != null ? " [$code]" : ""}';
}

/// Line/column reference within a GraphQL document.
final class GraphQLErrorLocation {
  const GraphQLErrorLocation({required this.line, required this.column});

  factory GraphQLErrorLocation.fromJson(Map<String, dynamic> json) =>
      GraphQLErrorLocation(
        line: json['line'] as int? ?? 0,
        column: json['column'] as int? ?? 0,
      );

  final int line;
  final int column;
}
