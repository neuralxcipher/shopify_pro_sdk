/// Concrete implementation of AuthRepository using GraphQL + SecureStorage.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/client/shopify_config.dart';
import '../../../../core/errors/shopify_exception.dart';
import '../../../../core/graphql/graphql_engine.dart';
import '../../../../core/graphql/query_builder.dart';
import '../../data/models/customer.dart';
import '../../data/models/customer_access_token.dart';
import '../../data/mutations/auth_mutations.dart';
import '../../data/queries/customer_queries.dart';
import '../../domain/repositories/auth_repository.dart';

const String _tokenStorageKey = 'shopify_pro_sdk_customer_token';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required this.engine,
    required this.config,
    FlutterSecureStorage? secureStorage,
  }) : _storage = secureStorage ??
            const FlutterSecureStorage();

  final GraphQLEngine engine;
  final ShopifyConfig config;
  final FlutterSecureStorage _storage;

  @override
  Future<CustomerAccessToken> login({
    required String email,
    required String password,
  }) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(AuthMutations.customerAccessTokenCreate)
          .variable('input', {'email': email, 'password': password})
          .operationName('CustomerAccessTokenCreate')
          .build(),
    );

    final result = data['customerAccessTokenCreate'] as Map<String, dynamic>;
    _throwIfUserErrors(result['customerUserErrors']);

    final tokenJson =
        result['customerAccessToken'] as Map<String, dynamic>?;
    if (tokenJson == null) {
      throw const ShopifyAuthException('Login failed: no token returned');
    }

    final token = CustomerAccessToken.fromJson(tokenJson);
    await saveToken(token);
    return token;
  }

  @override
  Future<Customer> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    String? phone,
    bool acceptsMarketing = false,
  }) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(AuthMutations.customerCreate)
          .variable('input', {
            'email': email,
            'password': password,
            'firstName': firstName,
            'lastName': lastName,
            if (phone != null) 'phone': phone,
            'acceptsMarketing': acceptsMarketing,
          })
          .operationName('CustomerCreate')
          .build(),
    );

    final result = data['customerCreate'] as Map<String, dynamic>;
    _throwIfUserErrors(result['customerUserErrors']);

    final customerJson = result['customer'] as Map<String, dynamic>?;
    if (customerJson == null) {
      throw const ShopifyAuthException('Registration failed');
    }
    return Customer.fromJson(customerJson);
  }

  @override
  Future<Customer> getCustomer(String accessToken) async {
    final data = await engine.query(
      GraphQLRequestBuilder()
          .query(AuthCustomerQueries.getCustomer)
          .variable('customerAccessToken', accessToken)
          .operationName('GetCustomer')
          .build(),
    );

    final customerJson = data['customer'] as Map<String, dynamic>?;
    if (customerJson == null) {
      throw const ShopifyAuthException('Customer not found or token expired');
    }
    return Customer.fromJson(customerJson);
  }

  @override
  Future<CustomerAccessToken> renewToken(String accessToken) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(AuthMutations.customerAccessTokenRenew)
          .variable('customerAccessToken', accessToken)
          .operationName('CustomerAccessTokenRenew')
          .build(),
    );

    final result = data['customerAccessTokenRenew'] as Map<String, dynamic>;
    _throwIfUserErrors(result['userErrors']);

    final tokenJson =
        result['customerAccessToken'] as Map<String, dynamic>?;
    if (tokenJson == null) {
      throw const ShopifyAuthException('Token renewal failed');
    }
    final token = CustomerAccessToken.fromJson(tokenJson);
    await saveToken(token);
    return token;
  }

  @override
  Future<void> logout(String accessToken) async {
    await engine.mutate(
      GraphQLRequestBuilder()
          .query(AuthMutations.customerAccessTokenDelete)
          .variable('customerAccessToken', accessToken)
          .operationName('CustomerAccessTokenDelete')
          .build(),
    );
    await clearToken();
  }

  @override
  Future<void> recoverPassword(String email) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(AuthMutations.customerRecover)
          .variable('email', email)
          .operationName('CustomerRecover')
          .build(),
    );
    _throwIfUserErrors(
      (data['customerRecover'] as Map<String, dynamic>?)?['customerUserErrors'],
    );
  }

  @override
  Future<CustomerAccessToken?> getSavedToken() async {
    final raw = await _storage.read(key: _tokenStorageKey);
    if (raw == null) return null;
    try {
      return CustomerAccessToken.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      await clearToken();
      return null;
    }
  }

  @override
  Future<void> saveToken(CustomerAccessToken token) async {
    await _storage.write(
      key: _tokenStorageKey,
      value: jsonEncode(token.toJson()),
    );
  }

  @override
  Future<void> clearToken() => _storage.delete(key: _tokenStorageKey);

  void _throwIfUserErrors(dynamic errors) {
    if (errors is! List || errors.isEmpty) return;
    final messages = errors
        .whereType<Map<String, dynamic>>()
        .map((e) => e['message'] as String? ?? 'Unknown error')
        .join('; ');
    if (messages.isNotEmpty) {
      throw ShopifyAuthException(messages);
    }
  }
}
