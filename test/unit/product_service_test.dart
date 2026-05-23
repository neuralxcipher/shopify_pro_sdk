/// Unit tests for ProductService.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shopify_pro_sdk/src/core/utils/cursor_pagination.dart';
import 'package:shopify_pro_sdk/src/features/products/data/models/product.dart';
import 'package:shopify_pro_sdk/src/features/products/domain/product_service.dart';
import 'package:shopify_pro_sdk/src/features/products/domain/repositories/product_repository.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockProductRepository mockRepo;
  late ProductService service;

  setUp(() {
    mockRepo = MockProductRepository();
    service = ProductService(mockRepo);
  });

  group('ProductService', () {
    test('fetchProducts delegates to repository', () async {
      const fakePage = ShopifyPage<Product>(
        items: [],
        hasNextPage: false,
        hasPreviousPage: false,
      );

      when(mockRepo.getProducts()).thenAnswer((_) async => fakePage);

      final result = await service.fetchProducts();
      expect(result, equals(fakePage));
    });

    test('search passes query to repository', () async {
      const fakePage = ShopifyPage<Product>(
        items: [],
        hasNextPage: false,
        hasPreviousPage: false,
      );

      when(
        mockRepo.getProducts(query: 'blue shirt'),
      ).thenAnswer((_) async => fakePage);

      final result = await service.search('blue shirt');
      expect(result, equals(fakePage));

      verify(mockRepo.getProducts(query: 'blue shirt')).called(1);
    });

    test('fetchById delegates with correct id', () async {
      const fakeProduct = Product(
        id: 'gid://shopify/Product/1',
        title: 'Test',
        handle: 'test',
        description: '',
        descriptionHtml: '',
        productType: '',
        vendor: '',
        tags: [],
        availableForSale: true,
        variants: [],
        images: [],
        options: [],
      );

      when(
        mockRepo.getProductById('gid://shopify/Product/1'),
      ).thenAnswer((_) async => fakeProduct);

      final result = await service.fetchById('gid://shopify/Product/1');
      expect(result.id, equals('gid://shopify/Product/1'));
    });
  });
}
