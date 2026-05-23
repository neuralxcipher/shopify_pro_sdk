/// List extension methods for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

extension ShopifyListX<T> on List<T> {
  /// Returns `null` if the list is empty, otherwise the first element.
  T? get firstOrNull => isEmpty ? null : first;

  /// Returns `null` if the list is empty, otherwise the last element.
  T? get lastOrNull => isEmpty ? null : last;

  /// Splits the list into chunks of [size].
  List<List<T>> chunked(int size) {
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      chunks.add(sublist(i, (i + size).clamp(0, length)));
    }
    return chunks;
  }

  /// Returns a new list with duplicate elements removed (preserving order).
  List<T> distinct() {
    final seen = <T>{};
    return where(seen.add).toList();
  }
}
