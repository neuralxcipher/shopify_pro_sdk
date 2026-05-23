/// Shopify Collection model.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../products/data/models/product.dart';
import '../../../products/data/models/product_image.dart';

/// A Shopify storefront collection of products.
final class Collection {
  const Collection({
    required this.id,
    required this.title,
    required this.handle,
    required this.description,
    required this.descriptionHtml,
    this.image,
    this.seo,
    this.products = const [],
    this.updatedAt,
  });

  factory Collection.fromJson(Map<String, dynamic> json) {
    final productsEdges =
        (json['products'] as Map<String, dynamic>?)?['edges'] as List<dynamic>? ?? [];

    return Collection(
      id: json['id'] as String,
      title: json['title'] as String,
      handle: json['handle'] as String,
      description: json['description'] as String? ?? '',
      descriptionHtml: json['descriptionHtml'] as String? ?? '',
      image: json['image'] != null
          ? ProductImage.fromJson(json['image'] as Map<String, dynamic>)
          : null,
      seo: json['seo'] != null
          ? ProductSeo.fromJson(json['seo'] as Map<String, dynamic>)
          : null,
      products: productsEdges
          .map(
            (e) => Product.fromJson(
              (e as Map<String, dynamic>)['node'] as Map<String, dynamic>,
            ),
          )
          .toList(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'] as String)
          : null,
    );
  }

  final String id;
  final String title;
  final String handle;
  final String description;
  final String descriptionHtml;
  final ProductImage? image;
  final ProductSeo? seo;
  final List<Product> products;
  final DateTime? updatedAt;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'handle': handle,
        'description': description,
        'descriptionHtml': descriptionHtml,
        if (image != null) 'image': image!.toJson(),
        if (seo != null) 'seo': seo!.toJson(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Collection && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
