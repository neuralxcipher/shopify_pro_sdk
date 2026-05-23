/// CartLine model for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../products/data/models/product_variant.dart';

/// A single line item inside a Shopify cart.
final class CartLine {
  const CartLine({
    required this.id,
    required this.quantity,
    required this.variant,
    required this.subtotalAmount,
    required this.currencyCode,
    this.totalAmount,
    this.attributes = const [],
    this.discountAllocations = const [],
  });

  factory CartLine.fromJson(Map<String, dynamic> json) {
    final cost = json['cost'] as Map<String, dynamic>? ?? {};
    final subtotalRaw = cost['subtotalAmount'] as Map<String, dynamic>? ?? {};
    final totalRaw = cost['totalAmount'] as Map<String, dynamic>?;

    return CartLine(
      id: json['id'] as String,
      quantity: json['quantity'] as int? ?? 1,
      variant: ProductVariant.fromJson(
        json['merchandise'] as Map<String, dynamic>,
      ),
      subtotalAmount:
          double.tryParse(subtotalRaw['amount']?.toString() ?? '0') ?? 0,
      currencyCode: subtotalRaw['currencyCode'] as String? ?? 'USD',
      totalAmount: totalRaw != null
          ? double.tryParse(totalRaw['amount']?.toString() ?? '0')
          : null,
      attributes: (json['attributes'] as List<dynamic>? ?? [])
          .map(
            (a) => CartAttribute.fromJson(a as Map<String, dynamic>),
          )
          .toList(),
      discountAllocations: (json['discountAllocations'] as List<dynamic>? ?? [])
          .map(
            (d) => CartDiscountAllocation.fromJson(
              d as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  final String id;
  final int quantity;
  final ProductVariant variant;
  final double subtotalAmount;
  final String currencyCode;
  final double? totalAmount;
  final List<CartAttribute> attributes;
  final List<CartDiscountAllocation> discountAllocations;

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
        'merchandise': variant.toJson(),
        'cost': {
          'subtotalAmount': {
            'amount': subtotalAmount.toStringAsFixed(2),
            'currencyCode': currencyCode,
          },
        },
      };

  CartLine copyWith({int? quantity}) => CartLine(
        id: id,
        quantity: quantity ?? this.quantity,
        variant: variant,
        subtotalAmount: subtotalAmount,
        currencyCode: currencyCode,
        totalAmount: totalAmount,
        attributes: attributes,
        discountAllocations: discountAllocations,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartLine && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// A custom key-value attribute on a cart line.
final class CartAttribute {
  const CartAttribute({required this.key, required this.value});

  factory CartAttribute.fromJson(Map<String, dynamic> json) => CartAttribute(
        key: json['key'] as String,
        value: json['value'] as String? ?? '',
      );

  final String key;
  final String value;

  Map<String, dynamic> toJson() => {'key': key, 'value': value};
}

/// An applied discount on a cart line.
final class CartDiscountAllocation {
  const CartDiscountAllocation({
    required this.discountedAmount,
    required this.currencyCode,
  });

  factory CartDiscountAllocation.fromJson(Map<String, dynamic> json) {
    final amountRaw = json['discountedAmount'] as Map<String, dynamic>? ?? {};
    return CartDiscountAllocation(
      discountedAmount:
          double.tryParse(amountRaw['amount']?.toString() ?? '0') ?? 0,
      currencyCode: amountRaw['currencyCode'] as String? ?? 'USD',
    );
  }

  final double discountedAmount;
  final String currencyCode;
}
