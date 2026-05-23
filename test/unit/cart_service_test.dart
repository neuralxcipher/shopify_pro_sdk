/// Unit tests for CartService.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shopify_pro_sdk/src/features/cart/data/models/cart.dart';
import 'package:shopify_pro_sdk/src/features/cart/data/models/cart_cost.dart';
import 'package:shopify_pro_sdk/src/features/cart/data/models/cart_line.dart';
import 'package:shopify_pro_sdk/src/features/cart/domain/cart_service.dart';
import 'package:shopify_pro_sdk/src/features/cart/domain/repositories/cart_repository.dart';

Cart _fakeCart({List<CartLine> lines = const []}) => Cart(
      id: 'gid://shopify/Cart/abc123',
      checkoutUrl: 'https://test.myshopify.com/checkouts/abc123',
      lines: lines,
      cost: const CartCost(
        subtotalAmount: 29.99,
        totalAmount: 32.99,
        currencyCode: 'USD',
      ),
    );

class _FakeCartRepo implements CartRepository {
  Cart? nextCart;
  List<CartLineInput>? lastAddedLines;
  String? lastDiscountCode;

  @override
  Future<Cart> createCart({
    List<CartLineInput>? lines,
    String? note,
    List<CartAttribute>? attributes,
    String? buyerEmail,
    String? customerAccessToken,
    String? country,
    String? language,
  }) async =>
      nextCart!;

  @override
  Future<Cart> getCart(
    String cartId, {
    String? country,
    String? language,
  }) async =>
      nextCart!;

  @override
  Future<Cart> addLines(
    String cartId,
    List<CartLineInput> lines, {
    String? country,
    String? language,
  }) async {
    lastAddedLines = lines;
    return nextCart!;
  }

  @override
  Future<Cart> updateLines(
    String cartId,
    List<CartLineUpdateInput> lines, {
    String? country,
    String? language,
  }) async =>
      nextCart!;

  @override
  Future<Cart> removeLines(
    String cartId,
    List<String> lineIds, {
    String? country,
    String? language,
  }) async =>
      nextCart!;

  @override
  Future<Cart> applyDiscountCode(String cartId, String discountCode) async {
    lastDiscountCode = discountCode;
    return nextCart!;
  }

  @override
  Future<Cart> removeDiscountCodes(String cartId) async => nextCart!;

  @override
  Future<Cart> updateNote(String cartId, String note) async => nextCart!;

  @override
  Future<Cart> updateBuyerIdentity(
    String cartId, {
    String? email,
    String? customerAccessToken,
    String? countryCode,
  }) async =>
      nextCart!;
}

void main() {
  late _FakeCartRepo fakeRepo;
  late CartService service;

  setUp(() {
    fakeRepo = _FakeCartRepo();
    service = CartService(fakeRepo);
  });

  group('CartService', () {
    test('createCart calls repository.createCart', () async {
      fakeRepo.nextCart = _fakeCart();

      final cart = await service.createCart();
      expect(cart.id, equals('gid://shopify/Cart/abc123'));
    });

    test('addItem builds CartLineInput with correct variant and quantity',
        () async {
      fakeRepo.nextCart = _fakeCart();

      await service.addItem(
        'gid://shopify/Cart/abc123',
        variantId: 'gid://shopify/ProductVariant/1',
        quantity: 2,
      );

      expect(fakeRepo.lastAddedLines?.length, equals(1));
      expect(
        fakeRepo.lastAddedLines?.first.merchandiseId,
        equals('gid://shopify/ProductVariant/1'),
      );
      expect(fakeRepo.lastAddedLines?.first.quantity, equals(2));
    });

    test('isEmpty returns true for cart with no lines', () {
      expect(_fakeCart().isEmpty, isTrue);
    });

    test('applyDiscount delegates discount code to repository', () async {
      fakeRepo.nextCart = _fakeCart();

      await service.applyDiscount('gid://shopify/Cart/abc123', 'SAVE10');

      expect(fakeRepo.lastDiscountCode, equals('SAVE10'));
    });
  });
}
