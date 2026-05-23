/// CartService — business logic for the cart feature.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../data/models/cart.dart';
import '../data/models/cart_line.dart';
import 'repositories/cart_repository.dart';

/// High-level cart API exposed via `ShopifyClient.cart`.
///
/// ```dart
/// // Start a new cart
/// final cart = await shopify.cart.createCart();
///
/// // Add a variant
/// final updated = await shopify.cart.addItem(
///   cart.id,
///   variantId: 'gid://shopify/ProductVariant/123',
///   quantity: 2,
/// );
///
/// // Open checkout in a WebView / browser
/// launchUrl(Uri.parse(updated.checkoutUrl));
/// ```
class CartService {
  const CartService(this._repository);

  final CartRepository _repository;

  /// Creates a new empty (or pre-populated) cart.
  Future<Cart> createCart({
    String? variantId,
    int quantity = 1,
    String? note,
    String? buyerEmail,
    String? customerAccessToken,
    String? country,
    String? language,
  }) =>
      _repository.createCart(
        lines: variantId != null
            ? [CartLineInput(merchandiseId: variantId, quantity: quantity)]
            : null,
        note: note,
        buyerEmail: buyerEmail,
        customerAccessToken: customerAccessToken,
        country: country,
        language: language,
      );

  /// Fetches the current cart state from Shopify.
  Future<Cart> fetchCart(
    String cartId, {
    String? country,
    String? language,
  }) =>
      _repository.getCart(cartId, country: country, language: language);

  /// Adds a single variant to the cart.
  Future<Cart> addItem(
    String cartId, {
    required String variantId,
    int quantity = 1,
    String? sellingPlanId,
    List<CartAttribute> attributes = const [],
    String? country,
    String? language,
  }) =>
      _repository.addLines(
        cartId,
        [
          CartLineInput(
            merchandiseId: variantId,
            quantity: quantity,
            sellingPlanId: sellingPlanId,
            attributes: attributes,
          ),
        ],
        country: country,
        language: language,
      );

  /// Adds multiple variants in a single round-trip.
  Future<Cart> addItems(
    String cartId,
    List<CartLineInput> lines, {
    String? country,
    String? language,
  }) =>
      _repository.addLines(cartId, lines, country: country, language: language);

  /// Updates the quantity of an existing cart line.
  Future<Cart> updateQuantity(
    String cartId, {
    required String lineId,
    required int quantity,
  }) =>
      _repository.updateLines(
        cartId,
        [CartLineUpdateInput(id: lineId, quantity: quantity)],
      );

  /// Removes a cart line entirely.
  Future<Cart> removeItem(String cartId, String lineId) =>
      _repository.removeLines(cartId, [lineId]);

  /// Removes multiple cart lines in one request.
  Future<Cart> removeItems(String cartId, List<String> lineIds) =>
      _repository.removeLines(cartId, lineIds);

  /// Applies a discount code.
  Future<Cart> applyDiscount(String cartId, String code) =>
      _repository.applyDiscountCode(cartId, code);

  /// Removes all applied discount codes.
  Future<Cart> clearDiscounts(String cartId) =>
      _repository.removeDiscountCodes(cartId);

  /// Updates the cart note (order note visible to merchant).
  Future<Cart> updateNote(String cartId, String note) =>
      _repository.updateNote(cartId, note);

  /// Associates a logged-in customer with the cart (merges guest cart).
  Future<Cart> associateCustomer(
    String cartId, {
    required String customerAccessToken,
    String? email,
    String? countryCode,
  }) =>
      _repository.updateBuyerIdentity(
        cartId,
        email: email,
        customerAccessToken: customerAccessToken,
        countryCode: countryCode,
      );
}
