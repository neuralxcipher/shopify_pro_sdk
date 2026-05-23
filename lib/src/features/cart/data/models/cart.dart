/// Shopify Cart model.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'cart_cost.dart';
import 'cart_line.dart';

/// Represents a Shopify Storefront Cart (Cart API, 2022-01+).
final class Cart {
  const Cart({
    required this.id,
    required this.checkoutUrl,
    required this.lines,
    required this.cost,
    this.discountCodes = const [],
    this.note,
    this.attributes = const [],
    this.totalQuantity = 0,
    this.createdAt,
    this.updatedAt,
  });

  factory Cart.fromJson(Map<String, dynamic> json) {
    final linesEdges =
        (json['lines'] as Map<String, dynamic>?)?['edges'] as List<dynamic>? ?? [];
    final discountRaw =
        (json['discountCodes'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();

    return Cart(
      id: json['id'] as String,
      checkoutUrl: json['checkoutUrl'] as String? ?? '',
      totalQuantity: json['totalQuantity'] as int? ?? 0,
      note: json['note'] as String?,
      lines: linesEdges
          .map(
            (e) => CartLine.fromJson(
              (e as Map<String, dynamic>)['node'] as Map<String, dynamic>,
            ),
          )
          .toList(),
      cost: CartCost.fromJson(
        json['cost'] as Map<String, dynamic>? ?? {},
      ),
      discountCodes: discountRaw
          .map((d) => CartDiscountCode.fromJson(d))
          .toList(),
      attributes: (json['attributes'] as List<dynamic>? ?? [])
          .map(
            (a) => CartLineAttribute.fromJson(a as Map<String, dynamic>),
          )
          .toList(),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  final String id;
  final String checkoutUrl;
  final List<CartLine> lines;
  final CartCost cost;
  final List<CartDiscountCode> discountCodes;
  final String? note;
  final List<CartLineAttribute> attributes;
  final int totalQuantity;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  bool get isEmpty => lines.isEmpty;
  int get itemCount => lines.fold(0, (sum, l) => sum + l.quantity);

  Map<String, dynamic> toJson() => {
        'id': id,
        'checkoutUrl': checkoutUrl,
        'totalQuantity': totalQuantity,
        if (note != null) 'note': note,
        'cost': cost.toJson(),
        'lines': {'edges': lines.map((l) => {'node': l.toJson()}).toList()},
      };
}

/// An applied discount code on a cart.
final class CartDiscountCode {
  const CartDiscountCode({required this.code, required this.applicable});

  factory CartDiscountCode.fromJson(Map<String, dynamic> json) =>
      CartDiscountCode(
        code: json['code'] as String? ?? '',
        applicable: json['applicable'] as bool? ?? false,
      );

  final String code;
  final bool applicable;
}

/// A cart-level key-value attribute.
final class CartLineAttribute {
  const CartLineAttribute({required this.key, required this.value});

  factory CartLineAttribute.fromJson(Map<String, dynamic> json) =>
      CartLineAttribute(
        key: json['key'] as String,
        value: json['value'] as String? ?? '',
      );

  final String key;
  final String value;

  Map<String, dynamic> toJson() => {'key': key, 'value': value};
}
