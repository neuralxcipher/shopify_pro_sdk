---
name: Bug Report
about: Report a bug in shopify_pro_sdk
title: "[BUG] "
labels: bug
assignees: ""
---

## Bug Description

A clear and concise description of the bug.

## Steps to Reproduce

1. Initialize `ShopifyClient` with config `...`
2. Call `shopify.products.fetchProducts()`
3. See error

## Expected Behavior

What you expected to happen.

## Actual Behavior

What actually happened. Include the full stack trace if available.

## Environment

| Property              | Value          |
| --------------------- | -------------- |
| shopify_pro_sdk       | `1.0.x`        |
| Flutter               | `3.x.x`        |
| Dart                  | `3.x.x`        |
| Platform              | Android / iOS / Web / macOS / Windows / Linux |
| Shopify API Version   | `2025-01`      |

## Minimal Reproduction

```dart
// Paste the smallest possible code that reproduces the issue
final shopify = await ShopifyClient.init(config: ...);
```

## Additional Context

Any other relevant information, screenshots, or logs.

---

*Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED*
