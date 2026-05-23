/// Two-tier cache: in-memory LRU + SharedPreferences persistence.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../logging/shopify_logger.dart';
import 'cache_policy.dart';

final class _CacheEntry {
  const _CacheEntry({required this.data, required this.createdAt});

  factory _CacheEntry.fromJson(Map<String, dynamic> json) => _CacheEntry(
        data: json['data'] as Map<String, dynamic>,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  final Map<String, dynamic> data;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => {
        'data': data,
        'createdAt': createdAt.toIso8601String(),
      };
}

/// Thread-safe two-tier cache used by the GraphQL engine.
///
/// Tier 1: `LinkedHashMap`-based in-memory LRU with a configurable max size.
/// Tier 2: [SharedPreferences]-backed disk persistence for app restarts.
class ShopifyCacheManager {
  ShopifyCacheManager({
    this.maxMemoryEntries = 128,
    this.diskKeyPrefix = 'spro_',
  });

  final int maxMemoryEntries;
  final String diskKeyPrefix;

  final Map<String, _CacheEntry> _memory = {};
  SharedPreferences? _prefs;

  static const String _tag = 'CacheManager';

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    ShopifyLogger.instance.debug('$_tag initialised');
  }

  Future<Map<String, dynamic>?> get(String key, CacheTtl ttl) async {
    final memEntry = _memory[key];
    if (memEntry != null) {
      if (ttl.isExpired(memEntry.createdAt)) {
        _memory.remove(key);
        ShopifyLogger.instance.debug('$_tag memory miss (expired): $key');
      } else {
        ShopifyLogger.instance.debug('$_tag memory hit: $key');
        return memEntry.data;
      }
    }

    final raw = _prefs?.getString('$diskKeyPrefix$key');
    if (raw == null) return null;

    try {
      final entry = _CacheEntry.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      if (ttl.isExpired(entry.createdAt)) {
        await _prefs?.remove('$diskKeyPrefix$key');
        ShopifyLogger.instance.debug('$_tag disk miss (expired): $key');
        return null;
      }
      _evictIfNeeded();
      _memory[key] = entry;
      ShopifyLogger.instance.debug('$_tag disk hit: $key');
      return entry.data;
    } catch (_) {
      await _prefs?.remove('$diskKeyPrefix$key');
      return null;
    }
  }

  Future<void> set(String key, Map<String, dynamic> data) async {
    final entry = _CacheEntry(data: data, createdAt: DateTime.now());
    _evictIfNeeded();
    _memory[key] = entry;
    await _prefs?.setString(
      '$diskKeyPrefix$key',
      jsonEncode(entry.toJson()),
    );
    ShopifyLogger.instance.debug('$_tag written: $key');
  }

  Future<void> invalidate(String key) async {
    _memory.remove(key);
    await _prefs?.remove('$diskKeyPrefix$key');
  }

  Future<void> invalidateAll() async {
    _memory.clear();
    final keys = _prefs?.getKeys().where((k) => k.startsWith(diskKeyPrefix));
    if (keys != null) {
      for (final k in keys) {
        await _prefs?.remove(k);
      }
    }
    ShopifyLogger.instance.info('$_tag invalidated all entries');
  }

  void _evictIfNeeded() {
    if (_memory.length >= maxMemoryEntries) {
      // Remove the oldest (first) entry — LinkedHashMap preserves insertion order.
      _memory.remove(_memory.keys.first);
    }
  }
}
