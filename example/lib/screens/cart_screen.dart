/// Cart screen for shopify_pro_sdk example app.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../shopify_providers.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartStateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: cartAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (cart) {
          if (cart == null || cart.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('Your cart is empty'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () =>
                        ref.read(cartStateProvider.notifier).createCart(),
                    child: const Text('Start Shopping'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cart.lines.length,
                  itemBuilder: (context, index) {
                    final line = cart.lines[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: line.variant.image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  line.variant.image!.url,
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(Icons.image_not_supported),
                        title: Text(line.variant.title, maxLines: 2),
                        subtitle: Text(
                          '${line.currencyCode} ${line.subtotalAmount.toStringAsFixed(2)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: line.quantity > 1
                                  ? () => ref
                                      .read(cartStateProvider.notifier)
                                      .updateQuantity(
                                          line.id, line.quantity - 1)
                                  : null,
                            ),
                            Text('${line.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => ref
                                  .read(cartStateProvider.notifier)
                                  .updateQuantity(line.id, line.quantity + 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: () => ref
                                  .read(cartStateProvider.notifier)
                                  .removeItem(line.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Order summary
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Subtotal'),
                          Text(
                            '${cart.cost.currencyCode} ${cart.cost.subtotalAmount.toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () => launchUrl(Uri.parse(cart.checkoutUrl)),
                        icon: const Icon(Icons.lock_outline),
                        label: const Text('Proceed to Checkout'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
