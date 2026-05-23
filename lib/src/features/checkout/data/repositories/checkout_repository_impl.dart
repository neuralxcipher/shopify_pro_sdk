/// Concrete implementation of CheckoutRepository.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../../core/client/shopify_config.dart';
import '../../../../core/errors/shopify_exception.dart';
import '../../../../core/graphql/graphql_engine.dart';
import '../../../../core/graphql/query_builder.dart';
import '../../data/models/checkout.dart';
import '../../data/mutations/checkout_mutations.dart';
import '../../domain/repositories/checkout_repository.dart';

final class CheckoutRepositoryImpl implements CheckoutRepository {
  const CheckoutRepositoryImpl({
    required this.engine,
    required this.config,
  });

  final GraphQLEngine engine;
  final ShopifyConfig config;

  @override
  Future<Checkout> createCheckout({
    required String cartId,
    String? email,
    String? note,
  }) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CheckoutMutations.checkoutCreate)
          .variable('input', {
            if (email != null) 'email': email,
            if (note != null) 'note': note,
          })
          .operationName('CheckoutCreate')
          .build(),
    );
    return _extractCheckout(data, 'checkoutCreate');
  }

  @override
  Future<Checkout> applyDiscount(
    String checkoutId,
    String discountCode,
  ) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CheckoutMutations.checkoutDiscountCodeApply)
          .variable('checkoutId', checkoutId)
          .variable('discountCode', discountCode)
          .operationName('CheckoutDiscountApply')
          .build(),
    );
    return _extractCheckout(data, 'checkoutDiscountCodeApplyV2');
  }

  @override
  Future<Checkout> removeDiscount(String checkoutId) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CheckoutMutations.checkoutDiscountCodeRemove)
          .variable('checkoutId', checkoutId)
          .operationName('CheckoutDiscountRemove')
          .build(),
    );
    return _extractCheckout(data, 'checkoutDiscountCodeRemove');
  }

  @override
  Future<Checkout> updateEmail(String checkoutId, String email) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CheckoutMutations.checkoutEmailUpdate)
          .variable('checkoutId', checkoutId)
          .variable('email', email)
          .operationName('CheckoutEmailUpdate')
          .build(),
    );
    return _extractCheckout(data, 'checkoutEmailUpdateV2');
  }

  Checkout _extractCheckout(Map<String, dynamic> data, String key) {
    final result = data[key] as Map<String, dynamic>;
    _throwIfErrors(result['checkoutUserErrors']);
    final checkoutJson = result['checkout'] as Map<String, dynamic>?;
    if (checkoutJson == null) {
      throw const ShopifyGraphQLException(
        'Checkout mutation returned no checkout',
        errors: [],
      );
    }
    return Checkout.fromJson(checkoutJson);
  }

  void _throwIfErrors(dynamic errors) {
    if (errors is! List || errors.isEmpty) return;
    final messages = errors
        .whereType<Map<String, dynamic>>()
        .map((e) => e['message'] as String? ?? 'Unknown error')
        .join('; ');
    if (messages.isNotEmpty) {
      throw ShopifyGraphQLException(messages, errors: []);
    }
  }
}
