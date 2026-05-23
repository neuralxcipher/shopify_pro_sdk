/// Shopify Product model.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'metafield.dart';
import 'product_image.dart';
import 'product_option.dart';
import 'product_variant.dart';

/// Full representation of a Shopify Storefront product.
final class Product {
  const Product({
    required this.id,
    required this.title,
    required this.handle,
    required this.description,
    required this.descriptionHtml,
    required this.productType,
    required this.vendor,
    required this.tags,
    required this.availableForSale,
    required this.variants,
    required this.images,
    required this.options,
    this.featuredImage,
    this.seo,
    this.metafields = const [],
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.totalInventory,
    this.priceRange,
    this.compareAtPriceRange,
    this.sellingPlanGroups = const [],
    this.requiresSellingPlan = false,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    final variantsEdges = (json['variants'] as Map<String, dynamic>?)?['edges']
            as List<dynamic>? ??
        [];
    final imagesEdges =
        (json['images'] as Map<String, dynamic>?)?['edges'] as List<dynamic>? ??
            [];
    final optionsRaw =
        (json['options'] as List<dynamic>? ?? []).cast<Map<String, dynamic>>();
    final metafieldsRaw = (json['metafields'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .toList();
    final sellingPlanGroupsEdges = (json['sellingPlanGroups']
            as Map<String, dynamic>?)?['edges'] as List<dynamic>? ??
        [];

    return Product(
      id: json['id'] as String,
      title: json['title'] as String,
      handle: json['handle'] as String,
      description: json['description'] as String? ?? '',
      descriptionHtml: json['descriptionHtml'] as String? ?? '',
      productType: json['productType'] as String? ?? '',
      vendor: json['vendor'] as String? ?? '',
      tags: (json['tags'] as List<dynamic>? ?? []).cast<String>(),
      availableForSale: json['availableForSale'] as bool? ?? true,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'] as String)
          : null,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
      totalInventory: json['totalInventory'] as int?,
      requiresSellingPlan: json['requiresSellingPlan'] as bool? ?? false,
      featuredImage: json['featuredImage'] != null
          ? ProductImage.fromJson(json['featuredImage'] as Map<String, dynamic>)
          : null,
      seo: json['seo'] != null
          ? ProductSeo.fromJson(json['seo'] as Map<String, dynamic>)
          : null,
      priceRange: json['priceRange'] != null
          ? ProductPriceRange.fromJson(
              json['priceRange'] as Map<String, dynamic>,
            )
          : null,
      compareAtPriceRange: json['compareAtPriceRange'] != null
          ? ProductPriceRange.fromJson(
              json['compareAtPriceRange'] as Map<String, dynamic>,
            )
          : null,
      variants: variantsEdges
          .map(
            (e) => ProductVariant.fromJson(
              (e as Map<String, dynamic>)['node'] as Map<String, dynamic>,
            ),
          )
          .toList(),
      images: imagesEdges
          .map(
            (e) => ProductImage.fromJson(
              (e as Map<String, dynamic>)['node'] as Map<String, dynamic>,
            ),
          )
          .toList(),
      options: optionsRaw.map(ProductOption.fromJson).toList(),
      metafields: metafieldsRaw.map(Metafield.fromJson).toList(),
      sellingPlanGroups: sellingPlanGroupsEdges
          .map(
            (e) => SellingPlanGroup.fromJson(
              (e as Map<String, dynamic>)['node'] as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  final String id;
  final String title;
  final String handle;
  final String description;
  final String descriptionHtml;
  final String productType;
  final String vendor;
  final List<String> tags;
  final bool availableForSale;
  final List<ProductVariant> variants;
  final List<ProductImage> images;
  final List<ProductOption> options;
  final ProductImage? featuredImage;
  final ProductSeo? seo;
  final List<Metafield> metafields;
  final DateTime? publishedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? totalInventory;
  final ProductPriceRange? priceRange;
  final ProductPriceRange? compareAtPriceRange;
  final List<SellingPlanGroup> sellingPlanGroups;
  final bool requiresSellingPlan;

  bool get hasVariants => variants.length > 1;
  bool get hasDiscount =>
      compareAtPriceRange?.minVariantPrice != null &&
      priceRange?.minVariantPrice != null &&
      (compareAtPriceRange!.minVariantPrice > priceRange!.minVariantPrice);

  ProductVariant? get defaultVariant =>
      variants.isNotEmpty ? variants.first : null;

  Metafield? metafield(String namespace, String key) => metafields
      .where((m) => m.namespace == namespace && m.key == key)
      .firstOrNull;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'handle': handle,
        'description': description,
        'descriptionHtml': descriptionHtml,
        'productType': productType,
        'vendor': vendor,
        'tags': tags,
        'availableForSale': availableForSale,
        'variants': {
          'edges': variants.map((v) => {'node': v.toJson()}).toList(),
        },
        'images': {
          'edges': images.map((i) => {'node': i.toJson()}).toList(),
        },
        'options': options.map((o) => o.toJson()).toList(),
        if (featuredImage != null) 'featuredImage': featuredImage!.toJson(),
        if (seo != null) 'seo': seo!.toJson(),
        'metafields': metafields.map((m) => m.toJson()).toList(),
        if (publishedAt != null) 'publishedAt': publishedAt!.toIso8601String(),
        if (priceRange != null) 'priceRange': priceRange!.toJson(),
        if (compareAtPriceRange != null)
          'compareAtPriceRange': compareAtPriceRange!.toJson(),
        'requiresSellingPlan': requiresSellingPlan,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// SEO metadata for a product.
final class ProductSeo {
  const ProductSeo({this.title, this.description});

  factory ProductSeo.fromJson(Map<String, dynamic> json) => ProductSeo(
        title: json['title'] as String?,
        description: json['description'] as String?,
      );

  final String? title;
  final String? description;

  Map<String, dynamic> toJson() => {
        if (title != null) 'title': title,
        if (description != null) 'description': description,
      };
}

/// Min/max price range for a product across all variants.
final class ProductPriceRange {
  const ProductPriceRange({
    required this.minVariantPrice,
    required this.maxVariantPrice,
    required this.currencyCode,
  });

  factory ProductPriceRange.fromJson(Map<String, dynamic> json) {
    final min = json['minVariantPrice'] as Map<String, dynamic>? ?? {};
    final max = json['maxVariantPrice'] as Map<String, dynamic>? ?? {};
    return ProductPriceRange(
      minVariantPrice: double.tryParse(min['amount']?.toString() ?? '0') ?? 0,
      maxVariantPrice: double.tryParse(max['amount']?.toString() ?? '0') ?? 0,
      currencyCode: min['currencyCode'] as String? ?? 'USD',
    );
  }

  final double minVariantPrice;
  final double maxVariantPrice;
  final String currencyCode;

  bool get hasRange => minVariantPrice != maxVariantPrice;

  Map<String, dynamic> toJson() => {
        'minVariantPrice': {
          'amount': minVariantPrice.toStringAsFixed(2),
          'currencyCode': currencyCode,
        },
        'maxVariantPrice': {
          'amount': maxVariantPrice.toStringAsFixed(2),
          'currencyCode': currencyCode,
        },
      };
}

/// A group of selling plans (subscriptions / deferred purchase options).
final class SellingPlanGroup {
  const SellingPlanGroup({
    required this.id,
    required this.name,
    required this.sellingPlans,
    this.appName,
  });

  factory SellingPlanGroup.fromJson(Map<String, dynamic> json) {
    final plansEdges = (json['sellingPlans'] as Map<String, dynamic>?)?['edges']
            as List<dynamic>? ??
        [];
    return SellingPlanGroup(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      appName: json['appName'] as String?,
      sellingPlans: plansEdges
          .map(
            (e) => SellingPlan.fromJson(
              (e as Map<String, dynamic>)['node'] as Map<String, dynamic>,
            ),
          )
          .toList(),
    );
  }

  final String id;
  final String name;
  final String? appName;
  final List<SellingPlan> sellingPlans;
}

/// A single selling plan (e.g. "Subscribe and Save 10% — Monthly").
final class SellingPlan {
  const SellingPlan({
    required this.id,
    required this.name,
    required this.description,
    this.recurringDeliveries = false,
  });

  factory SellingPlan.fromJson(Map<String, dynamic> json) => SellingPlan(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String? ?? '',
        recurringDeliveries: json['recurringDeliveries'] as bool? ?? false,
      );

  final String id;
  final String name;
  final String description;
  final bool recurringDeliveries;
}
