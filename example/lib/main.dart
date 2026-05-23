/// shopify_pro_sdk Example App entry point.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shopify_pro_sdk/shopify_pro_sdk.dart';

import 'app.dart';
import 'shopify_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Replace with your store credentials before running.
  final shopify = await ShopifyClient.init(
    config: ShopifyConfig(
      storeDomain: '63ibjc-s9.myshopify.com',
      storefrontAccessToken: '25a1a195add2c42459e8d4ac968ee566',
      logLevel: ShopifyLogLevel.debug,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [shopifyClientProvider.overrideWithValue(shopify)],
      child: const ShopifyExampleApp(),
    ),
  );
}
