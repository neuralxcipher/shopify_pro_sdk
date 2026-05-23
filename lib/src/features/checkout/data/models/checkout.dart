/// Checkout model for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

/// Lightweight checkout representation — the Cart API's `checkoutUrl`
/// handles the actual checkout flow in a browser / WebView.
final class Checkout {
  const Checkout({
    required this.id,
    required this.webUrl,
    required this.subtotalPrice,
    required this.totalPrice,
    required this.currencyCode,
    this.totalTax,
    this.ready = false,
    this.completedAt,
    this.email,
    this.note,
    this.orderStatusUrl,
  });

  factory Checkout.fromJson(Map<String, dynamic> json) {
    double parseAmount(Map<String, dynamic>? raw) =>
        double.tryParse(raw?['amount']?.toString() ?? '0') ?? 0;

    return Checkout(
      id: json['id'] as String,
      webUrl: json['webUrl'] as String? ?? '',
      subtotalPrice: parseAmount(
        json['subtotalPriceV2'] as Map<String, dynamic>?,
      ),
      totalPrice: parseAmount(json['totalPriceV2'] as Map<String, dynamic>?),
      totalTax: parseAmount(json['totalTaxV2'] as Map<String, dynamic>?),
      currencyCode: (json['subtotalPriceV2']
              as Map<String, dynamic>?)?['currencyCode'] as String? ??
          'USD',
      ready: json['ready'] as bool? ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.tryParse(json['completedAt'] as String)
          : null,
      email: json['email'] as String?,
      note: json['note'] as String?,
      orderStatusUrl: json['orderStatusUrl'] as String?,
    );
  }

  final String id;

  /// URL to open in a browser / WebView to complete the purchase.
  final String webUrl;
  final double subtotalPrice;
  final double totalPrice;
  final double? totalTax;
  final String currencyCode;
  final bool ready;
  final DateTime? completedAt;
  final String? email;
  final String? note;
  final String? orderStatusUrl;

  bool get isCompleted => completedAt != null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'webUrl': webUrl,
        'subtotalPriceV2': {
          'amount': subtotalPrice.toStringAsFixed(2),
          'currencyCode': currencyCode,
        },
        'totalPriceV2': {
          'amount': totalPrice.toStringAsFixed(2),
          'currencyCode': currencyCode,
        },
        'ready': ready,
        if (completedAt != null) 'completedAt': completedAt!.toIso8601String(),
        if (email != null) 'email': email,
        if (orderStatusUrl != null) 'orderStatusUrl': orderStatusUrl,
      };
}
