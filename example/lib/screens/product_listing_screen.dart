/// Product listing screen for shopify_pro_sdk example app.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopify_pro_sdk/shopify_pro_sdk.dart';

import '../shopify_providers.dart';
import '../widgets/loading_widget.dart';
import '../widgets/product_card.dart';

final _productsPageProvider = FutureProvider.autoDispose<ShopifyPage<Product>>(
  (ref) => ref.watch(productsProvider).fetchProducts(first: 24),
);

class ProductListingScreen extends ConsumerWidget {
  const ProductListingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(_productsPageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: productsAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (page) => GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: page.items.length,
          itemBuilder: (context, index) {
            final product = page.items[index];
            return ProductCard(
              product: product,
              onTap: () => context.push('/products/${product.handle}'),
            );
          },
        ),
      ),
    );
  }
}
