/// Concrete implementation of CustomerRepository.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../../core/cache/cache_policy.dart';
import '../../../../core/client/shopify_config.dart';
import '../../../../core/errors/shopify_exception.dart';
import '../../../../core/graphql/graphql_engine.dart';
import '../../../../core/graphql/query_builder.dart';
import '../../../../core/utils/cursor_pagination.dart';
import '../../../auth/data/models/customer.dart';
import '../../data/models/customer_address.dart';
import '../../data/models/customer_order.dart';
import '../../data/mutations/customer_mutations.dart';
import '../../data/queries/customer_queries.dart';
import '../../domain/repositories/customer_repository.dart';

final class CustomerRepositoryImpl implements CustomerRepository {
  const CustomerRepositoryImpl({
    required this.engine,
    required this.config,
  });

  final GraphQLEngine engine;
  final ShopifyConfig config;

  @override
  Future<Customer> getCustomerWithAddresses(String accessToken) async {
    final data = await engine.query(
      GraphQLRequestBuilder()
          .query(CustomerProfileQueries.getCustomerWithAddresses)
          .variable('customerAccessToken', accessToken)
          .operationName('GetCustomerWithAddresses')
          .build(),
      cachePolicy: CachePolicy.networkFirst,
    );
    final customerJson = data['customer'] as Map<String, dynamic>?;
    if (customerJson == null) {
      throw const ShopifyAuthException('Customer not found or session expired');
    }
    return Customer.fromJson(customerJson);
  }

  @override
  Future<ShopifyPage<CustomerOrder>> getOrders(
    String accessToken, {
    int first = 10,
    String? after,
  }) async {
    final data = await engine.query(
      GraphQLRequestBuilder()
          .query(CustomerProfileQueries.getCustomerOrders)
          .variable('customerAccessToken', accessToken)
          .variable('first', first)
          .variables({if (after != null) 'after': after})
          .operationName('GetCustomerOrders')
          .build(),
      cachePolicy: CachePolicy.networkFirst,
    );

    final customerJson = data['customer'] as Map<String, dynamic>?;
    final ordersConnection =
        customerJson?['orders'] as Map<String, dynamic>? ?? {};
    return ShopifyPage.fromConnection(ordersConnection, CustomerOrder.fromJson);
  }

  @override
  Future<CustomerAddress> createAddress(
    String accessToken,
    CustomerAddress address,
  ) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CustomerMutations.customerAddressCreate)
          .variable('customerAccessToken', accessToken)
          .variable('address', address.toInputJson())
          .operationName('CustomerAddressCreate')
          .build(),
    );
    final result = data['customerAddressCreate'] as Map<String, dynamic>;
    _throwIfErrors(result['customerUserErrors']);
    return CustomerAddress.fromJson(
      result['customerAddress'] as Map<String, dynamic>,
    );
  }

  @override
  Future<CustomerAddress> updateAddress(
    String accessToken,
    CustomerAddress address,
  ) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CustomerMutations.customerAddressUpdate)
          .variable('customerAccessToken', accessToken)
          .variable('id', address.id)
          .variable('address', address.toInputJson())
          .operationName('CustomerAddressUpdate')
          .build(),
    );
    final result = data['customerAddressUpdate'] as Map<String, dynamic>;
    _throwIfErrors(result['customerUserErrors']);
    return CustomerAddress.fromJson(
      result['customerAddress'] as Map<String, dynamic>,
    );
  }

  @override
  Future<void> deleteAddress(String accessToken, String addressId) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CustomerMutations.customerAddressDelete)
          .variable('customerAccessToken', accessToken)
          .variable('id', addressId)
          .operationName('CustomerAddressDelete')
          .build(),
    );
    _throwIfErrors(
      (data['customerAddressDelete']
          as Map<String, dynamic>?)?['customerUserErrors'],
    );
  }

  @override
  Future<void> setDefaultAddress(
    String accessToken,
    String addressId,
  ) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CustomerMutations.customerDefaultAddressUpdate)
          .variable('customerAccessToken', accessToken)
          .variable('addressId', addressId)
          .operationName('CustomerDefaultAddressUpdate')
          .build(),
    );
    _throwIfErrors(
      (data['customerDefaultAddressUpdate']
          as Map<String, dynamic>?)?['customerUserErrors'],
    );
  }

  @override
  Future<Customer> updateProfile(
    String accessToken, {
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    bool? acceptsMarketing,
  }) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CustomerMutations.customerUpdate)
          .variable('customerAccessToken', accessToken)
          .variable('customer', {
            if (firstName != null) 'firstName': firstName,
            if (lastName != null) 'lastName': lastName,
            if (email != null) 'email': email,
            if (phone != null) 'phone': phone,
            if (acceptsMarketing != null) 'acceptsMarketing': acceptsMarketing,
          })
          .operationName('CustomerUpdate')
          .build(),
    );
    final result = data['customerUpdate'] as Map<String, dynamic>;
    _throwIfErrors(result['customerUserErrors']);
    return Customer.fromJson(result['customer'] as Map<String, dynamic>);
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
