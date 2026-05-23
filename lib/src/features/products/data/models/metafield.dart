/// Shopify Metafield model.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

/// Represents a Shopify metafield attached to any resource.
final class Metafield {
  const Metafield({
    required this.id,
    required this.namespace,
    required this.key,
    required this.value,
    required this.type,
    this.description,
  });

  factory Metafield.fromJson(Map<String, dynamic> json) => Metafield(
        id: json['id'] as String,
        namespace: json['namespace'] as String,
        key: json['key'] as String,
        value: json['value'] as String,
        type: json['type'] as String,
        description: json['description'] as String?,
      );

  final String id;
  final String namespace;
  final String key;
  final String value;

  /// Shopify metafield type, e.g. `single_line_text_field`, `json`, `integer`.
  final String type;
  final String? description;

  Map<String, dynamic> toJson() => {
        'id': id,
        'namespace': namespace,
        'key': key,
        'value': value,
        'type': type,
        if (description != null) 'description': description,
      };

  Metafield copyWith({
    String? id,
    String? namespace,
    String? key,
    String? value,
    String? type,
    String? description,
  }) =>
      Metafield(
        id: id ?? this.id,
        namespace: namespace ?? this.namespace,
        key: key ?? this.key,
        value: value ?? this.value,
        type: type ?? this.type,
        description: description ?? this.description,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Metafield && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
