/// Abstract customer profile repository contract.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../../core/utils/cursor_pagination.dart';
import '../../../auth/data/models/customer.dart';
import '../../data/models/customer_address.dart';
import '../../data/models/customer_order.dart';

abstract interface class CustomerRepository {
  Future<Customer> getCustomerWithAddresses(String accessToken);

  Future<ShopifyPage<CustomerOrder>> getOrders(
    String accessToken, {
    int first = 10,
    String? after,
  });

  Future<CustomerAddress> createAddress(
    String accessToken,
    CustomerAddress address,
  );

  Future<CustomerAddress> updateAddress(
    String accessToken,
    CustomerAddress address,
  );

  Future<void> deleteAddress(String accessToken, String addressId);

  Future<void> setDefaultAddress(String accessToken, String addressId);

  Future<Customer> updateProfile(
    String accessToken, {
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    bool? acceptsMarketing,
  });
}
