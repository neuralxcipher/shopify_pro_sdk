/// Collections screen for shopify_pro_sdk example app.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shopify_pro_sdk/shopify_pro_sdk.dart';

import '../shopify_providers.dart';
import '../widgets/loading_widget.dart';

final _collectionsProvider =
    FutureProvider.autoDispose<ShopifyPage<Collection>>(
  (ref) => ref.watch(collectionsProvider).fetchCollections(),
);

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(_collectionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Collections')),
      body: collectionsAsync.when(
        loading: () => const LoadingWidget(),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (page) => ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: page.items.length,
          itemBuilder: (context, index) {
            final collection = page.items[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () =>
                    context.push('/products?collection=${collection.handle}'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (collection.image != null)
                      AspectRatio(
                        aspectRatio: 16 / 7,
                        child: Image.network(
                          collection.image!.url,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const ColoredBox(
                            color: Color(0xFFE5E5E5),
                            child: SizedBox(height: 100),
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            collection.title,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          if (collection.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              collection.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
