/// Abstract cart repository contract.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../data/models/cart.dart';
import '../../data/models/cart_line.dart';

abstract interface class CartRepository {
  Future<Cart> createCart({
    List<CartLineInput>? lines,
    String? note,
    List<CartAttribute>? attributes,
    String? buyerEmail,
    String? customerAccessToken,
    String? country,
    String? language,
  });

  Future<Cart> getCart(
    String cartId, {
    String? country,
    String? language,
  });

  Future<Cart> addLines(
    String cartId,
    List<CartLineInput> lines, {
    String? country,
    String? language,
  });

  Future<Cart> updateLines(
    String cartId,
    List<CartLineUpdateInput> lines, {
    String? country,
    String? language,
  });

  Future<Cart> removeLines(
    String cartId,
    List<String> lineIds, {
    String? country,
    String? language,
  });

  Future<Cart> applyDiscountCode(String cartId, String discountCode);

  Future<Cart> removeDiscountCodes(String cartId);

  Future<Cart> updateNote(String cartId, String note);

  Future<Cart> updateBuyerIdentity(
    String cartId, {
    String? email,
    String? customerAccessToken,
    String? countryCode,
  });
}

/// Input for adding a new line to the cart.
final class CartLineInput {
  const CartLineInput({
    required this.merchandiseId,
    this.quantity = 1,
    this.attributes = const [],
    this.sellingPlanId,
  });

  final String merchandiseId;
  final int quantity;
  final List<CartAttribute> attributes;
  final String? sellingPlanId;

  Map<String, dynamic> toJson() => {
        'merchandiseId': merchandiseId,
        'quantity': quantity,
        if (attributes.isNotEmpty)
          'attributes': attributes.map((a) => a.toJson()).toList(),
        if (sellingPlanId != null) 'sellingPlanId': sellingPlanId,
      };
}

/// Input for updating an existing cart line quantity.
final class CartLineUpdateInput {
  const CartLineUpdateInput({
    required this.id,
    required this.quantity,
    this.attributes,
  });

  final String id;
  final int quantity;
  final List<CartAttribute>? attributes;

  Map<String, dynamic> toJson() => {
        'id': id,
        'quantity': quantity,
        if (attributes != null)
          'attributes': attributes!.map((a) => a.toJson()).toList(),
      };
}
