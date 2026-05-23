/// Cart cost model for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

/// The cost breakdown of a Shopify cart.
final class CartCost {
  const CartCost({
    required this.subtotalAmount,
    required this.totalAmount,
    required this.currencyCode,
    this.totalTaxAmount,
    this.totalDutyAmount,
    this.checkoutChargeAmount,
  });

  factory CartCost.fromJson(Map<String, dynamic> json) {
    double parseAmount(dynamic raw) {
      if (raw is Map<String, dynamic>) {
        return double.tryParse(raw['amount']?.toString() ?? '0') ?? 0;
      }
      return 0;
    }

    final subtotal = json['subtotalAmount'] as Map<String, dynamic>? ?? {};
    return CartCost(
      subtotalAmount: parseAmount(json['subtotalAmount']),
      totalAmount: parseAmount(json['totalAmount']),
      currencyCode: subtotal['currencyCode'] as String? ?? 'USD',
      totalTaxAmount: json['totalTaxAmount'] != null
          ? parseAmount(json['totalTaxAmount'])
          : null,
      totalDutyAmount: json['totalDutyAmount'] != null
          ? parseAmount(json['totalDutyAmount'])
          : null,
      checkoutChargeAmount: json['checkoutChargeAmount'] != null
          ? parseAmount(json['checkoutChargeAmount'])
          : null,
    );
  }

  final double subtotalAmount;
  final double totalAmount;
  final String currencyCode;
  final double? totalTaxAmount;
  final double? totalDutyAmount;
  final double? checkoutChargeAmount;

  Map<String, dynamic> toJson() => {
        'subtotalAmount': {
          'amount': subtotalAmount.toStringAsFixed(2),
          'currencyCode': currencyCode,
        },
        'totalAmount': {
          'amount': totalAmount.toStringAsFixed(2),
          'currencyCode': currencyCode,
        },
        if (totalTaxAmount != null)
          'totalTaxAmount': {
            'amount': totalTaxAmount!.toStringAsFixed(2),
            'currencyCode': currencyCode,
          },
      };
}
