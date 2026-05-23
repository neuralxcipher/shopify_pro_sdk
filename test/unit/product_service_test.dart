/// Unit tests for ProductService.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shopify_pro_sdk/src/core/utils/cursor_pagination.dart';
import 'package:shopify_pro_sdk/src/features/products/data/models/product.dart';
import 'package:shopify_pro_sdk/src/features/products/data/queries/product_queries.dart';
import 'package:shopify_pro_sdk/src/features/products/domain/product_service.dart';
import 'package:shopify_pro_sdk/src/features/products/domain/repositories/product_repository.dart';

class _FakeProductRepo implements ProductRepository {
  ShopifyPage<Product> nextPage = const ShopifyPage(
    items: [],
    hasNextPage: false,
    hasPreviousPage: false,
  );
  Product? nextProduct;
  String? lastQuery;
  int? lastFirst;

  @override
  Future<ShopifyPage<Product>> getProducts({
    int first = 20,
    String? after,
    ProductSortKey sortKey = ProductSortKey.relevance,
    bool reverse = false,
    String? query,
    String? country,
    String? language,
  }) async {
    lastFirst = first;
    lastQuery = query;
    return nextPage;
  }

  @override
  Future<Product> getProductById(
    String id, {
    String? country,
    String? language,
  }) async =>
      nextProduct!;

  @override
  Future<Product> getProductByHandle(
    String handle, {
    String? country,
    String? language,
  }) async =>
      nextProduct!;

  @override
  Future<List<Product>> getProductRecommendations(
    String productId, {
    String intent = 'RELATED',
  }) async =>
      [];
}

void main() {
  late _FakeProductRepo fakeRepo;
  late ProductService service;

  setUp(() {
    fakeRepo = _FakeProductRepo();
    service = ProductService(fakeRepo);
  });

  group('ProductService', () {
    test('fetchProducts delegates to repository', () async {
      const fakePage = ShopifyPage<Product>(
        items: [],
        hasNextPage: false,
        hasPreviousPage: false,
      );
      fakeRepo.nextPage = fakePage;

      final result = await service.fetchProducts();
      expect(result, equals(fakePage));
      expect(fakeRepo.lastFirst, equals(20));
    });

    test('search passes query to repository', () async {
      const fakePage = ShopifyPage<Product>(
        items: [],
        hasNextPage: false,
        hasPreviousPage: false,
      );
      fakeRepo.nextPage = fakePage;

      final result = await service.search('blue shirt');
      expect(result, equals(fakePage));
      expect(fakeRepo.lastQuery, equals('blue shirt'));
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
      fakeRepo.nextProduct = fakeProduct;

      final result = await service.fetchById('gid://shopify/Product/1');
      expect(result.id, equals('gid://shopify/Product/1'));
    });
  });
}
