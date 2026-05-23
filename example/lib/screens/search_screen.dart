/// Search screen for shopify_pro_sdk example app.
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

final _searchQueryProvider = StateProvider.autoDispose<String>((_) => '');

final _searchResultsProvider =
    FutureProvider.autoDispose<ShopifyPage<Product>>((ref) async {
  final query = ref.watch(_searchQueryProvider);
  if (query.trim().isEmpty) {
    return const ShopifyPage(
      items: [],
      hasNextPage: false,
      hasPreviousPage: false,
    );
  }
  return ref.watch(searchProvider).search(query);
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  late final TextEditingController _controller;
  final _debouncer = Debouncer(delay: const Duration(milliseconds: 400));

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(_searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products…',
            border: InputBorder.none,
          ),
          onChanged: (value) => _debouncer.run(
            () => ref.read(_searchQueryProvider.notifier).state = value,
          ),
        ),
      ),
      body: resultsAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (page) => page.isEmpty
            ? Center(
                child: Text(
                  ref.read(_searchQueryProvider).isEmpty
                      ? 'Start typing to search'
                      : 'No results found',
                ),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
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
