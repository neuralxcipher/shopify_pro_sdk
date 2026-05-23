/// CheckoutService — business logic for the checkout feature.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../data/models/checkout.dart';
import 'repositories/checkout_repository.dart';

/// High-level checkout API exposed via `ShopifyClient.checkout`.
///
/// The primary checkout flow uses `cart.checkoutUrl` (Cart API).
/// This service wraps the legacy Checkout API for discount/email mutations.
class CheckoutService {
  const CheckoutService(this._repository);

  final CheckoutRepository _repository;

  /// Creates a checkout session (legacy Checkout API).
  Future<Checkout> createCheckout({
    required String cartId,
    String? email,
    String? note,
  }) =>
      _repository.createCheckout(
        cartId: cartId,
        email: email,
        note: note,
      );

  /// Applies a discount code to an existing checkout.
  Future<Checkout> applyDiscount(String checkoutId, String code) =>
      _repository.applyDiscount(checkoutId, code);

  /// Removes the discount code from an existing checkout.
  Future<Checkout> removeDiscount(String checkoutId) =>
      _repository.removeDiscount(checkoutId);

  /// Updates the email associated with the checkout.
  Future<Checkout> updateEmail(String checkoutId, String email) =>
      _repository.updateEmail(checkoutId, email);
}
