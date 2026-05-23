/// Root app widget for shopify_pro_sdk example.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/collections_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_listing_screen.dart';
import 'screens/search_screen.dart';

class ShopifyExampleApp extends StatelessWidget {
  const ShopifyExampleApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        title: 'Shopify Pro SDK Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF008060),
          ),
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF008060),
            brightness: Brightness.dark,
          ),
        ),
        routerConfig: _router,
      );
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/products', builder: (_, __) => const ProductListingScreen()),
    GoRoute(
      path: '/products/:handle',
      builder: (_, state) =>
          ProductDetailScreen(handle: state.pathParameters['handle']!),
    ),
    GoRoute(path: '/collections', builder: (_, __) => const CollectionsScreen()),
    GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
    GoRoute(path: '/cart', builder: (_, __) => const CartScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/register', builder: (_, __) => const RegisterScreen()),
  ],
);
