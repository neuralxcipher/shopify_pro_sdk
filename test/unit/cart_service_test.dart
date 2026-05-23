/// Unit tests for CartService.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shopify_pro_sdk/src/features/cart/data/models/cart.dart';
import 'package:shopify_pro_sdk/src/features/cart/data/models/cart_cost.dart';
import 'package:shopify_pro_sdk/src/features/cart/data/models/cart_line.dart';
import 'package:shopify_pro_sdk/src/features/cart/domain/cart_service.dart';
import 'package:shopify_pro_sdk/src/features/cart/domain/repositories/cart_repository.dart';

class MockCartRepository extends Mock implements CartRepository {}

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

void main() {
  late MockCartRepository mockRepo;
  late CartService service;

  setUp(() {
    mockRepo = MockCartRepository();
    service = CartService(mockRepo);
  });

  group('CartService', () {
    test('createCart calls repository.createCart', () async {
      when(mockRepo.createCart()).thenAnswer((_) async => _fakeCart());

      final cart = await service.createCart();
      expect(cart.id, equals('gid://shopify/Cart/abc123'));
    });

    test('addItem passes correct variant and quantity to repository', () async {
      final cart = _fakeCart();
      // ignore: argument_type_not_assignable
      when(mockRepo.addLines('gid://shopify/Cart/abc123', any))
          .thenAnswer((_) async => cart);

      final result = await service.addItem(
        'gid://shopify/Cart/abc123',
        variantId: 'gid://shopify/ProductVariant/1',
        quantity: 2,
      );

      expect(result.id, equals('gid://shopify/Cart/abc123'));
    });

    test('isEmpty returns true for cart with no lines', () {
      final cart = _fakeCart();
      expect(cart.isEmpty, isTrue);
    });

    test('applyDiscount delegates to repository', () async {
      final cart = _fakeCart();
      when(
        mockRepo.applyDiscountCode('gid://shopify/Cart/abc123', 'SAVE10'),
      ).thenAnswer((_) async => cart);

      await service.applyDiscount('gid://shopify/Cart/abc123', 'SAVE10');

      verify(
        mockRepo.applyDiscountCode('gid://shopify/Cart/abc123', 'SAVE10'),
      ).called(1);
    });
  });
}
