/// Cursor-based pagination helpers for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

/// A typed page of results from a Shopify paginated connection.
final class ShopifyPage<T> {
  const ShopifyPage({
    required this.items,
    required this.hasNextPage,
    required this.hasPreviousPage,
    this.startCursor,
    this.endCursor,
  });

  factory ShopifyPage.fromConnection(
    Map<String, dynamic> connection,
    T Function(Map<String, dynamic>) fromNode,
  ) {
    final edges = (connection['edges'] as List<dynamic>? ?? [])
        .cast<Map<String, dynamic>>();
    final pageInfo =
        connection['pageInfo'] as Map<String, dynamic>? ?? {};

    final items = edges.map((edge) {
      final node = edge['node'] as Map<String, dynamic>;
      return fromNode(node);
    }).toList();

    return ShopifyPage(
      items: items,
      hasNextPage: pageInfo['hasNextPage'] as bool? ?? false,
      hasPreviousPage: pageInfo['hasPreviousPage'] as bool? ?? false,
      startCursor: pageInfo['startCursor'] as String?,
      endCursor: pageInfo['endCursor'] as String?,
    );
  }

  /// The decoded items for this page.
  final List<T> items;

  /// Whether there is a next page (forward pagination).
  final bool hasNextPage;

  /// Whether there is a previous page (backward pagination).
  final bool hasPreviousPage;

  /// Cursor of the first edge — used for backward pagination.
  final String? startCursor;

  /// Cursor of the last edge — pass as `after` for the next page.
  final String? endCursor;

  bool get isEmpty => items.isEmpty;
  int get count => items.length;

  ShopifyPage<R> map<R>(R Function(T) transform) => ShopifyPage(
        items: items.map(transform).toList(),
        hasNextPage: hasNextPage,
        hasPreviousPage: hasPreviousPage,
        startCursor: startCursor,
        endCursor: endCursor,
      );
}

/// Standard arguments for forward cursor pagination.
final class PaginationArgs {
  const PaginationArgs({this.first = 20, this.after, this.last, this.before});

  final int first;
  final String? after;
  final int? last;
  final String? before;

  Map<String, dynamic> toVariables() => {
        'first': first,
        if (after != null) 'after': after,
        if (last != null) 'last': last,
        if (before != null) 'before': before,
      };
}
