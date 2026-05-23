/// Product detail screen for shopify_pro_sdk example app.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopify_pro_sdk/shopify_pro_sdk.dart';

import '../shopify_providers.dart';
import '../widgets/loading_widget.dart';

final _productDetailProvider =
    FutureProvider.autoDispose.family<Product, String>(
  (ref, handle) => ref.watch(productsProvider).fetchByHandle(handle),
);

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({required this.handle, super.key});

  final String handle;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  ProductVariant? _selectedVariant;

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(_productDetailProvider(widget.handle));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          productAsync.value?.title ?? 'Product',
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => context.push('/cart'),
          ),
        ],
      ),
      body: productAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (product) {
          _selectedVariant ??= product.defaultVariant;
          return CustomScrollView(
            slivers: [
              // Hero image
              SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: product.featuredImage != null
                      ? Image.network(
                          product.featuredImage!.url,
                          fit: BoxFit.cover,
                        )
                      : const ColoredBox(
                          color: Color(0xFFE5E5E5),
                          child: Icon(Icons.image_not_supported, size: 64),
                        ),
                ),
              ),

              // Info
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      product.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    if (_selectedVariant != null)
                      Text(
                        '${_selectedVariant!.currencyCode} ${_selectedVariant!.price.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    const SizedBox(height: 16),

                    // Variant selector
                    if (product.hasVariants) ...[
                      Text(
                        'Options',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: product.variants.map((v) {
                          final isSelected = v.id == _selectedVariant?.id;
                          return ChoiceChip(
                            label: Text(v.title),
                            selected: isSelected,
                            onSelected: (_) =>
                                setState(() => _selectedVariant = v),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Description
                    if (product.description.isNotEmpty) ...[
                      Text(
                        'Description',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(product.description),
                    ],
                    const SizedBox(height: 80),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: productAsync.value != null
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: _selectedVariant?.availableForSale == true
                      ? () async {
                          final cartNotifier =
                              ref.read(cartStateProvider.notifier);
                          await cartNotifier.createCart();
                          await cartNotifier.addItem(_selectedVariant!.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Added to cart!')),
                            );
                          }
                        }
                      : null,
                  icon: const Icon(Icons.shopping_cart_outlined),
                  label: Text(
                    _selectedVariant?.availableForSale == true
                        ? 'Add to Cart'
                        : 'Sold Out',
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
