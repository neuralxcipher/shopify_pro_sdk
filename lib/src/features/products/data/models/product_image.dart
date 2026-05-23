/// Shopify ProductImage model.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

/// A single image associated with a Shopify product or variant.
final class ProductImage {
  const ProductImage({
    required this.id,
    required this.url,
    this.altText,
    this.width,
    this.height,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(
        id: json['id'] as String? ?? '',
        url: json['url'] as String? ?? json['src'] as String? ?? '',
        altText: json['altText'] as String?,
        width: json['width'] as int?,
        height: json['height'] as int?,
      );

  final String id;
  final String url;
  final String? altText;
  final int? width;
  final int? height;

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        if (altText != null) 'altText': altText,
        if (width != null) 'width': width,
        if (height != null) 'height': height,
      };

  ProductImage copyWith({
    String? id,
    String? url,
    String? altText,
    int? width,
    int? height,
  }) =>
      ProductImage(
        id: id ?? this.id,
        url: url ?? this.url,
        altText: altText ?? this.altText,
        width: width ?? this.width,
        height: height ?? this.height,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductImage &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
