/// AuthService — business logic for customer authentication.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../data/models/customer.dart';
import '../data/models/customer_access_token.dart';
import 'repositories/auth_repository.dart';

/// High-level auth API exposed via `ShopifyClient.auth`.
///
/// Handles login, registration, token persistence, auto-renewal, and logout.
///
/// ```dart
/// final token = await shopify.auth.login(
///   email: 'user@example.com',
///   password: 's3cur3P@ss',
/// );
/// final customer = await shopify.auth.currentCustomer(token.accessToken);
/// ```
class AuthService {
  const AuthService(this._repository);

  final AuthRepository _repository;

  /// Authenticates a customer. Persists the token to secure storage.
  Future<CustomerAccessToken> login({
    required String email,
    required String password,
  }) =>
      _repository.login(email: email, password: password);

  /// Creates a new customer account.
  Future<Customer> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    bool acceptsMarketing = false,
  }) =>
      _repository.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        acceptsMarketing: acceptsMarketing,
      );

  /// Fetches the authenticated customer profile.
  Future<Customer> currentCustomer(String accessToken) =>
      _repository.getCustomer(accessToken);

  /// Extends the token expiry. Call when the token is within 24 h of expiry.
  Future<CustomerAccessToken> renewToken(String accessToken) =>
      _repository.renewToken(accessToken);

  /// Revokes the token on Shopify and clears it from secure storage.
  Future<void> logout(String accessToken) => _repository.logout(accessToken);

  /// Sends a password-reset email to [email].
  Future<void> recoverPassword(String email) =>
      _repository.recoverPassword(email);

  /// Returns the persisted token (or `null` if not logged in / token cleared).
  Future<CustomerAccessToken?> getSavedToken() => _repository.getSavedToken();

  /// Restores session: reads stored token, renews if expired, returns customer.
  ///
  /// Returns `null` if no token is stored.
  Future<Customer?> restoreSession() async {
    final token = await _repository.getSavedToken();
    if (token == null) return null;

    final activeToken = token.isExpired
        ? await _repository.renewToken(token.accessToken)
        : token;

    return _repository.getCustomer(activeToken.accessToken);
  }
}
