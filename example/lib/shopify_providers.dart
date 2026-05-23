/// Riverpod providers for shopify_pro_sdk services.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopify_pro_sdk/shopify_pro_sdk.dart';

final shopifyClientProvider = Provider<ShopifyClient>(
  (_) => throw UnimplementedError('Override shopifyClientProvider in ProviderScope'),
);

final productsProvider = Provider<ProductService>(
  (ref) => ref.watch(shopifyClientProvider).products,
);

final collectionsProvider = Provider<CollectionService>(
  (ref) => ref.watch(shopifyClientProvider).collections,
);

final cartProvider = Provider<CartService>(
  (ref) => ref.watch(shopifyClientProvider).cart,
);

final authProvider = Provider<AuthService>(
  (ref) => ref.watch(shopifyClientProvider).auth,
);

final searchProvider = Provider<SearchService>(
  (ref) => ref.watch(shopifyClientProvider).search,
);

final customerProvider = Provider<CustomerService>(
  (ref) => ref.watch(shopifyClientProvider).customer,
);

// ── Cart state ─────────────────────────────────────────────────────────────

final cartStateProvider = StateNotifierProvider<CartNotifier, AsyncValue<Cart?>>(
  CartNotifier.new,
);

class CartNotifier extends StateNotifier<AsyncValue<Cart?>> {
  CartNotifier(this._ref) : super(const AsyncValue.data(null));

  final Ref _ref;
  CartService get _cart => _ref.read(cartProvider);

  Future<void> createCart() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _cart.createCart());
  }

  Future<void> addItem(String variantId, {int quantity = 1}) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _cart.addItem(current.id, variantId: variantId, quantity: quantity),
    );
  }

  Future<void> removeItem(String lineId) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _cart.removeItem(current.id, lineId),
    );
  }

  Future<void> updateQuantity(String lineId, int quantity) async {
    final current = state.value;
    if (current == null) return;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _cart.updateQuantity(current.id, lineId: lineId, quantity: quantity),
    );
  }
}
