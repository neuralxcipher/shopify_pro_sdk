/// CustomerAccessToken model for shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

/// Represents a Shopify customer access token with its expiry time.
final class CustomerAccessToken {
  const CustomerAccessToken({
    required this.accessToken,
    required this.expiresAt,
  });

  factory CustomerAccessToken.fromJson(Map<String, dynamic> json) =>
      CustomerAccessToken(
        accessToken: json['accessToken'] as String,
        expiresAt: DateTime.parse(json['expiresAt'] as String),
      );

  final String accessToken;
  final DateTime expiresAt;

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'expiresAt': expiresAt.toIso8601String(),
      };
}
