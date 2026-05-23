/// Shopify Customer model.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

/// Represents an authenticated Shopify customer.
final class Customer {
  const Customer({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.acceptsMarketing,
    required this.createdAt,
    this.displayName,
    this.tags = const [],
  });

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'] as String,
        email: json['email'] as String? ?? '',
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        displayName: json['displayName'] as String?,
        acceptsMarketing: json['acceptsMarketing'] as bool? ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.now(),
        tags: (json['tags'] as List<dynamic>? ?? []).cast<String>(),
      );

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String phone;
  final String? displayName;
  final bool acceptsMarketing;
  final DateTime createdAt;
  final List<String> tags;

  String get fullName => '$firstName $lastName'.trim();

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'phone': phone,
        if (displayName != null) 'displayName': displayName,
        'acceptsMarketing': acceptsMarketing,
        'createdAt': createdAt.toIso8601String(),
        'tags': tags,
      };

  Customer copyWith({
    String? email,
    String? firstName,
    String? lastName,
    String? phone,
    bool? acceptsMarketing,
  }) =>
      Customer(
        id: id,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phone: phone ?? this.phone,
        displayName: displayName,
        acceptsMarketing: acceptsMarketing ?? this.acceptsMarketing,
        createdAt: createdAt,
        tags: tags,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
