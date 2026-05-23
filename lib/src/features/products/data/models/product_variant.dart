/// Shopify ProductVariant model.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'product_image.dart';

/// A specific purchasable variant of a Shopify product.
final class ProductVariant {
  const ProductVariant({
    required this.id,
    required this.title,
    required this.price,
    required this.currencyCode,
    required this.availableForSale,
    this.compareAtPrice,
    this.compareAtCurrencyCode,
    this.sku,
    this.barcode,
    this.weight,
    this.weightUnit,
    this.quantityAvailable,
    this.image,
    this.selectedOptions = const [],
    this.requiresShipping = true,
    this.taxable = true,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) {
    final priceV2 = json['price'] as Map<String, dynamic>? ??
        json['priceV2'] as Map<String, dynamic>? ??
        {};
    final compareAtPriceV2 = json['compareAtPrice'] as Map<String, dynamic>? ??
        json['compareAtPriceV2'] as Map<String, dynamic>?;

    return ProductVariant(
      id: json['id'] as String,
      title: json['title'] as String,
      price: double.tryParse(priceV2['amount']?.toString() ?? '0') ?? 0,
      currencyCode: priceV2['currencyCode'] as String? ?? 'USD',
      compareAtPrice: compareAtPriceV2 != null
          ? double.tryParse(compareAtPriceV2['amount']?.toString() ?? '')
          : null,
      compareAtCurrencyCode: compareAtPriceV2?['currencyCode'] as String?,
      availableForSale: json['availableForSale'] as bool? ?? true,
      sku: json['sku'] as String?,
      barcode: json['barcode'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      weightUnit: json['weightUnit'] as String?,
      quantityAvailable: json['quantityAvailable'] as int?,
      image: json['image'] != null
          ? ProductImage.fromJson(json['image'] as Map<String, dynamic>)
          : null,
      selectedOptions: (json['selectedOptions'] as List<dynamic>? ?? [])
          .map((o) => SelectedOption.fromJson(o as Map<String, dynamic>))
          .toList(),
      requiresShipping: json['requiresShipping'] as bool? ?? true,
      taxable: json['taxable'] as bool? ?? true,
    );
  }

  final String id;
  final String title;
  final double price;
  final String currencyCode;
  final double? compareAtPrice;
  final String? compareAtCurrencyCode;
  final bool availableForSale;
  final String? sku;
  final String? barcode;
  final double? weight;
  final String? weightUnit;
  final int? quantityAvailable;
  final ProductImage? image;
  final List<SelectedOption> selectedOptions;
  final bool requiresShipping;
  final bool taxable;

  bool get isOnSale => compareAtPrice != null && compareAtPrice! > price;

  double? get discountPercentage =>
      isOnSale ? ((compareAtPrice! - price) / compareAtPrice! * 100) : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'price': {
          'amount': price.toStringAsFixed(2),
          'currencyCode': currencyCode,
        },
        if (compareAtPrice != null)
          'compareAtPrice': {
            'amount': compareAtPrice!.toStringAsFixed(2),
            'currencyCode': compareAtCurrencyCode ?? currencyCode,
          },
        'availableForSale': availableForSale,
        if (sku != null) 'sku': sku,
        if (barcode != null) 'barcode': barcode,
        if (quantityAvailable != null) 'quantityAvailable': quantityAvailable,
        if (image != null) 'image': image!.toJson(),
        'selectedOptions': selectedOptions.map((o) => o.toJson()).toList(),
        'requiresShipping': requiresShipping,
        'taxable': taxable,
      };

  ProductVariant copyWith({
    String? id,
    String? title,
    double? price,
    String? currencyCode,
    bool? availableForSale,
    int? quantityAvailable,
    ProductImage? image,
    List<SelectedOption>? selectedOptions,
  }) =>
      ProductVariant(
        id: id ?? this.id,
        title: title ?? this.title,
        price: price ?? this.price,
        currencyCode: currencyCode ?? this.currencyCode,
        compareAtPrice: compareAtPrice,
        compareAtCurrencyCode: compareAtCurrencyCode,
        availableForSale: availableForSale ?? this.availableForSale,
        sku: sku,
        barcode: barcode,
        weight: weight,
        weightUnit: weightUnit,
        quantityAvailable: quantityAvailable ?? this.quantityAvailable,
        image: image ?? this.image,
        selectedOptions: selectedOptions ?? this.selectedOptions,
        requiresShipping: requiresShipping,
        taxable: taxable,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductVariant &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// A key-value pair representing a chosen option on a variant (e.g. Size: Large).
final class SelectedOption {
  const SelectedOption({required this.name, required this.value});

  factory SelectedOption.fromJson(Map<String, dynamic> json) => SelectedOption(
        name: json['name'] as String,
        value: json['value'] as String,
      );

  final String name;
  final String value;

  Map<String, dynamic> toJson() => {'name': name, 'value': value};
}
