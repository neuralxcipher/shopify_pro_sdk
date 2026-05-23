# shopify_pro_sdk

[![pub.dev](https://img.shields.io/pub/v/shopify_pro_sdk.svg?label=pub.dev&color=blue)](https://pub.dev/packages/shopify_pro_sdk)
[![Dart 3](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Flutter](https://img.shields.io/badge/Flutter-stable-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![CI](https://github.com/neuralxcipher/shopify_pro_sdk/actions/workflows/ci.yml/badge.svg)](https://github.com/neuralxcipher/shopify_pro_sdk/actions)
[![pub points](https://img.shields.io/pub/points/shopify_pro_sdk)](https://pub.dev/packages/shopify_pro_sdk/score)
[![popularity](https://img.shields.io/pub/popularity/shopify_pro_sdk)](https://pub.dev/packages/shopify_pro_sdk/score)
[![likes](https://img.shields.io/pub/likes/shopify_pro_sdk)](https://pub.dev/packages/shopify_pro_sdk/score)

**Enterprise-grade Flutter SDK for the Shopify Storefront API.**  
Built for production — custom GraphQL engine, two-tier caching, typed exceptions, full Dart 3 null-safety, and a complete Riverpod example app.

---

## Features

- **Products & Variants** — fetch by handle/ID, paginate, sort, filter, selling plans, metafields
- **Collections** — nested product listings with cursor pagination
- **Cart API** — create, add/update/remove lines, discount codes, attributes, buyer identity
- **Checkout** — legacy Checkout API with address, shipping, and web checkout URL
- **Customer Auth** — register, login, logout, token renewal via `flutter_secure_storage`
- **Search** — full-text search and predictive (typeahead) via Shopify Search API
- **Customer Portal** — fetch orders, manage addresses, update account info
- **Multi-currency & Markets** — configure per-request `country` and `currency`
- **Selling Plans** — subscriptions and recurring purchase support
- **Metafields** — typed metafield resolution on products and collections
- **Custom GraphQL Engine** — built on `http`, no `graphql_flutter` dependency
- **Two-tier Cache** — in-memory LRU + SharedPreferences disk cache with TTL and `CachePolicy`
- **Exponential Backoff Retry** — configurable `RetryConfig` with jitter, retries only on network/rate-limit errors
- **Typed Exception Hierarchy** — sealed `ShopifyException` subclasses for every failure mode
- **Cursor Pagination** — `ShopifyPage<T>` with `hasNextPage`, `endCursor`, `fromConnection`
- **Debouncer** — built-in for search-as-you-type UIs
- **Extensions** — `String`, `num`, `List` helpers for Shopify-specific operations

---

## Installation

```yaml
dependencies:
  shopify_pro_sdk: ^1.0.0
```

```bash
flutter pub get
```

---

## Quick Start

### 1. Initialize the client

```dart
import 'package:shopify_pro_sdk/shopify_pro_sdk.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ShopifyClient.init(
    ShopifyConfig(
      storeDomain: 'your-store.myshopify.com',
      storefrontAccessToken: 'your-storefront-access-token',
      apiVersion: '2024-01',
    ),
  );

  runApp(const MyApp());
}
```

### 2. Fetch products

```dart
final shopify = ShopifyClient.instance;

final page = await shopify.products.fetchProducts(
  first: 20,
  sortKey: ProductSortKey.bestSelling,
);

for (final product in page.items) {
  print('${product.title} — ${product.defaultVariant?.price}');
}
```

### 3. Manage the cart

```dart
// Create cart
final cart = await shopify.cart.createCart();

// Add a variant
final updated = await shopify.cart.addItem(
  cartId: cart.id,
  merchandiseId: variant.id,
  quantity: 1,
);

// Launch Shopify checkout in browser
await launchUrl(Uri.parse(updated.checkoutUrl));
```

### 4. Authenticate a customer

```dart
// Register
await shopify.auth.register(
  email: 'user@example.com',
  password: 'secret123',
  firstName: 'Ada',
  lastName: 'Lovelace',
);

// Login (token is persisted via flutter_secure_storage)
await shopify.auth.login(email: 'user@example.com', password: 'secret123');

// Restore on app launch
await shopify.auth.restoreSession();

// Logout
await shopify.auth.logout();
```

### 5. Search

```dart
final results = await shopify.search.search(query: 'running shoes', first: 10);

for (final product in results.products) {
  print(product.title);
}

// Typeahead / predictive
final predictions = await shopify.search.predictiveSearch(query: 'run');
```

---

## Cache Policies

```dart
final page = await shopify.products.fetchProducts(
  first: 20,
  cachePolicy: CachePolicy.cacheFirst,     // default
  cacheTtl: CacheTtl.defaultProducts,      // 5 minutes
);

// Force network refresh
final fresh = await shopify.products.fetchProducts(
  first: 20,
  cachePolicy: CachePolicy.networkOnly,
);
```

| Policy | Behaviour |
|---|---|
| `cacheFirst` | Return cache if valid; fetch otherwise |
| `networkFirst` | Fetch; fall back to cache on error |
| `networkOnly` | Always fetch; never cache |
| `cacheOnly` | Return cache; throw if missing |
| `cacheAndNetwork` | Return cache immediately, refresh in background |

---

## Multi-currency & Markets

```dart
await ShopifyClient.init(
  ShopifyConfig(
    storeDomain: 'your-store.myshopify.com',
    storefrontAccessToken: 'token',
    country: 'GB',
    currency: 'GBP',
    language: 'EN',
  ),
);
```

---

## Retry Configuration

```dart
ShopifyConfig(
  storeDomain: '...',
  storefrontAccessToken: '...',
  retryConfig: RetryConfig(
    maxAttempts: 4,
    initialDelay: Duration(milliseconds: 300),
    maxDelay: Duration(seconds: 10),
    useJitter: true,
  ),
)
```

---

## Exception Handling

```dart
try {
  await shopify.products.fetchById(id: 'gid://shopify/Product/123');
} on ShopifyNotFoundException catch (e) {
  print('Not found: ${e.message}');
} on ShopifyRateLimitException catch (e) {
  print('Rate limited. Retry after: ${e.retryAfter}');
} on ShopifyNetworkException catch (e) {
  print('Network error: ${e.message}');
} on ShopifyAuthException catch (e) {
  print('Auth error: ${e.message}');
} on ShopifyGraphQLException catch (e) {
  print('GraphQL errors: ${e.errors}');
} on ShopifyException catch (e) {
  print('Shopify error: ${e.message}');
}
```

---

## Architecture

```
lib/
├── shopify_pro_sdk.dart          # Public barrel export
└── src/
    ├── core/
    │   ├── client/               # ShopifyClient, ShopifyConfig
    │   ├── cache/                # CacheManager, CachePolicy, CacheTtl
    │   ├── graphql/              # GraphQLEngine, GraphQLRequest, GraphQLResponse
    │   ├── network/              # RetryHandler, RetryConfig
    │   ├── errors/               # Sealed ShopifyException hierarchy
    │   └── utils/                # ShopifyPage, Debouncer
    ├── features/
    │   ├── products/
    │   │   ├── data/             # Product model, queries, repository impl
    │   │   └── domain/           # Repository interface, ProductService
    │   ├── collections/
    │   ├── auth/
    │   ├── cart/
    │   ├── checkout/
    │   ├── search/
    │   └── customer/
    └── extensions/               # String, num, List extensions
```

Each feature follows clean architecture:
- `data/models/` — Dart models with `fromJson` factories
- `data/queries/` — Raw GraphQL strings
- `data/repositories/` — Concrete `*RepositoryImpl` (GraphQL + cache)
- `domain/repositories/` — Abstract `interface` contracts
- `domain/services/` — Public service facade consumed by `ShopifyClient`

---

## Example App

A complete Riverpod + GoRouter example app is included in [`example/`](example/).

**Screens:**
- Home — navigation hub with hero banner
- Products — infinite-scroll grid with sale badges and sold-out overlays
- Product Detail — variant selector, image gallery, Add to Cart
- Collections — category cards
- Search — debounced real-time search
- Cart — quantity controls, subtotal, Shopify checkout URL
- Login / Register — form validation, auth error handling

```bash
cd example
flutter pub get
flutter run
```

Set your credentials in `example/lib/main.dart` before running.

---

## Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

The test suite covers:
- `GraphQLEngine` — success, GraphQL errors, 401, 429 rate limit
- `ProductService` — fetchProducts, search, fetchById
- `CartService` — createCart, addItem, updateQuantity, applyDiscount

---

## CI/CD

GitHub Actions runs on every push and pull request:

1. **analyze-and-test** — `flutter analyze` (zero warnings) + `flutter test`
2. **dry-run-publish** — `dart pub publish --dry-run` to validate pub.dev readiness

---

## Contributing

Contributions are welcome. Please read the guidelines before submitting a PR.

1. Fork the repository
2. Create a feature branch: `git checkout -b feat/my-feature`
3. Follow the existing architecture (feature-first, repository pattern)
4. Add tests for new functionality
5. Ensure `flutter analyze` passes with zero warnings
6. Open a pull request — use the PR template

Bug reports: use the [bug report template](.github/ISSUE_TEMPLATE/bug_report.md).  
Feature requests: use the [feature request template](.github/ISSUE_TEMPLATE/feature_request.md).

---

## Roadmap

- [ ] Webhooks support (via Shopify Admin API companion)
- [ ] Offline-first mode with SQLite cache tier
- [ ] Widget library (`ShopifyProductCard`, `ShopifyCartButton`, etc.)
- [ ] Persistent cart across sessions
- [ ] Apple Pay / Google Pay integration hooks

---

## Support

If this package saves you time, consider supporting its development:

- Star the repository on [GitHub](https://github.com/neuralxcipher/shopify_pro_sdk)
- Like the package on [pub.dev](https://pub.dev/packages/shopify_pro_sdk)
- Report issues and suggest improvements via [GitHub Issues](https://github.com/neuralxcipher/shopify_pro_sdk/issues)

---

## License

```
MIT License

Copyright (c) 2024 Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

---

## Maintainer

**Abrar Ali**  
[NEURALXCIPHER (PRIVATE) LIMITED](https://neuralxcipher.com)  
[abraralidev@gmail.com](mailto:abraralidev@gmail.com)  
[github.com/neuralxcipher](https://github.com/neuralxcipher)

---

*shopify_pro_sdk is not affiliated with or endorsed by Shopify Inc.*
