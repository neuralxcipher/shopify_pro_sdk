/// String extension methods for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

extension ShopifyStringX on String {
  /// Converts a Shopify Global ID (gid://shopify/Product/123) to a plain numeric ID.
  String toShopifyId() {
    final parts = split('/');
    return parts.last;
  }

  /// Returns true if the string is a valid Shopify Global ID.
  bool get isShopifyGid => startsWith('gid://shopify/');

  /// Capitalises the first letter of the string.
  String capitalised() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// Converts `snake_case` or `UPPER_CASE` to `Title Case`.
  String toTitleCase() => split(RegExp(r'[_\s]+'))
      .map((w) => w.isEmpty
          ? ''
          : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
      .join(' ');

  /// Truncates the string to [maxLength] and appends [suffix] if truncated.
  String truncate(int maxLength, {String suffix = '…'}) =>
      length <= maxLength ? this : '${substring(0, maxLength)}$suffix';

  /// Strips all HTML tags from the string (for rendering description without WebView).
  String stripHtml() => replaceAll(RegExp('<[^>]*>'), '').trim();
}
