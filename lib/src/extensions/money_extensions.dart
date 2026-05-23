/// Money formatting extension for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

extension ShopifyMoneyX on double {
  /// Formats the amount as a currency string using [currencyCode].
  ///
  /// Example: `29.99.toCurrencyString('USD')` → `'US$ 29.99'`
  String toCurrencyString(String currencyCode, {int decimalDigits = 2}) {
    final formatted = toStringAsFixed(decimalDigits);
    return '$currencyCode $formatted';
  }

  /// Returns true if this price is lower than [other] (i.e. is on sale).
  bool isDiscountedFrom(double other) => other > 0 && this < other;

  /// Returns the discount percentage relative to [originalPrice].
  double discountPercentageFrom(double originalPrice) {
    if (originalPrice <= 0) return 0;
    return ((originalPrice - this) / originalPrice * 100).clamp(0, 100);
  }
}
