/// Shopify ProductOption model.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

/// A selectable option on a Shopify product (e.g. Size, Color).
final class ProductOption {
  const ProductOption({
    required this.id,
    required this.name,
    required this.values,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) => ProductOption(
        id: json['id'] as String,
        name: json['name'] as String,
        values: (json['values'] as List<dynamic>).cast<String>(),
      );

  final String id;
  final String name;
  final List<String> values;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'values': values,
      };

  ProductOption copyWith({
    String? id,
    String? name,
    List<String>? values,
  }) =>
      ProductOption(
        id: id ?? this.id,
        name: name ?? this.name,
        values: values ?? this.values,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductOption && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
