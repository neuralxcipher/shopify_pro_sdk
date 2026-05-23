/// Home screen for shopify_pro_sdk example app.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopify Pro SDK'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () => context.push('/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/login'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero banner
          Container(
            height: 180,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primary,
                  colorScheme.primaryContainer,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'shopify_pro_sdk',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enterprise Flutter SDK for Shopify',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onPrimary.withValues(alpha: 0.9)),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Explore',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),

          _NavTile(
            icon: Icons.grid_view_rounded,
            label: 'Products',
            subtitle: 'Browse the full catalogue',
            onTap: () => context.push('/products'),
          ),
          _NavTile(
            icon: Icons.folder_copy_outlined,
            label: 'Collections',
            subtitle: 'Shop by category',
            onTap: () => context.push('/collections'),
          ),
          _NavTile(
            icon: Icons.search_rounded,
            label: 'Search',
            subtitle: 'Find what you need',
            onTap: () => context.push('/search'),
          ),
          _NavTile(
            icon: Icons.shopping_cart_outlined,
            label: 'Cart',
            subtitle: 'View and edit your cart',
            onTap: () => context.push('/cart'),
          ),
          _NavTile(
            icon: Icons.person_outline,
            label: 'Account',
            subtitle: 'Login or create account',
            onTap: () => context.push('/login'),
          ),

          const SizedBox(height: 32),
          const Center(
            child: Text(
              'Developed by Abrar Ali\nNEURALXCIPHER (PRIVATE) LIMITED',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 8),
        child: ListTile(
          leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
          title: Text(label),
          subtitle: Text(subtitle),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap,
        ),
      );
}
