# Changelog

All notable changes to **shopify_pro_sdk** are documented in this file.

Format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
This project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.2] — 2026-05-24

### Fixed

- Removed invalid `COLLECTION` from `search` query `types` argument (`SearchType!` only accepts `PRODUCT`, `ARTICLE`, `PAGE`).
- Removed `... on Collection` inline fragment from `search` query (not part of `SearchResultItem` union).

---

## [1.0.1] — 2026-05-24

### Fixed

- Trimmed `pubspec.yaml` description to 140 characters (pub.dev limit: 60–180).
- Removed premature `documentation:` URL that caused unreachable-URL penalty.

---

## [1.0.0] — 2026-05-23

### Added

- Initial enterprise-grade release by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
- Custom lightweight GraphQL engine built on `http` (no heavy dependency chain)
- Two-tier cache: in-memory LRU + SharedPreferences persistence
- Automatic retry with exponential back-off and jitter
- Rate-limit detection and transparent back-off
- Typed `ShopifyException` hierarchy (network, auth, graphql, rate-limit, not-found)
- `ShopifyConfig` with full multi-store, multi-locale, multi-currency support
- `ShopifyLogger` with configurable levels and structured output
- **Products**: full CRUD, variants, images, options, metafields, selling plans,
  subscriptions, recommendations, inventory, dynamic pricing
- **Collections**: listing, products within collection, smart filtering, pagination
- **Authentication**: customer login, register, token refresh, logout, persistent
  secure session via `flutter_secure_storage`
- **Cart**: Cart API (Storefront 2022-01+), add/remove/update lines, discount codes,
  note, attributes, buyer identity, merge guest cart
- **Checkout**: checkout URL generation, deep-link handling, order tracking
- **Search**: predictive search, full-text search, smart filter builder
- **Customer**: profile management, address CRUD, order history
- Cursor-based pagination helper (`ShopifyPage<T>`)
- `Debouncer` utility for search input
- Extension methods: `StringX`, `MoneyX`, `ListX`
- Repository pattern with abstract interfaces and concrete implementations
- Full unit and mock-based integration test suite
- Production-level example app (home, products, collections, search, cart,
  checkout, auth, orders, dark mode, localization)
- GitHub Actions CI/CD pipeline
- Complete pub.dev metadata and documentation

---

## [Unreleased]

### Planned

- Shopify Payments direct integration
- Storefront API subscriptions via WebSocket
- Analytics event tracking (pixel)
- Augmented reality product viewer helpers
- Shopify Markets advanced routing
