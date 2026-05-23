/// Abstract auth repository contract.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../data/models/customer.dart';
import '../../data/models/customer_access_token.dart';

abstract interface class AuthRepository {
  Future<CustomerAccessToken> login({
    required String email,
    required String password,
  });

  Future<Customer> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    bool acceptsMarketing = false,
  });

  Future<Customer> getCustomer(String accessToken);

  Future<CustomerAccessToken> renewToken(String accessToken);

  Future<void> logout(String accessToken);

  Future<void> recoverPassword(String email);

  Future<CustomerAccessToken?> getSavedToken();

  Future<void> saveToken(CustomerAccessToken token);

  Future<void> clearToken();
}
