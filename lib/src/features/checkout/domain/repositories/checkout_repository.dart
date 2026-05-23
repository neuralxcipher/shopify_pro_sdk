/// Abstract checkout repository contract.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../data/models/checkout.dart';

abstract interface class CheckoutRepository {
  Future<Checkout> createCheckout({
    required String cartId,
    String? email,
    String? note,
  });

  Future<Checkout> applyDiscount(String checkoutId, String discountCode);

  Future<Checkout> removeDiscount(String checkoutId);

  Future<Checkout> updateEmail(String checkoutId, String email);
}
