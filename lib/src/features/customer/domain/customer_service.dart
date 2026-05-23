/// CustomerService — business logic for customer profile management.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../core/utils/cursor_pagination.dart';
import '../../auth/data/models/customer.dart';
import '../data/models/customer_address.dart';
import '../data/models/customer_order.dart';
import 'repositories/customer_repository.dart';

/// High-level customer profile API exposed via `ShopifyClient.customer`.
class CustomerService {
  const CustomerService(this._repository);

  final CustomerRepository _repository;

  /// Fetches the customer profile including addresses.
  Future<Customer> fetchProfile(String accessToken) =>
      _repository.getCustomerWithAddresses(accessToken);

  /// Returns paginated order history.
  Future<ShopifyPage<CustomerOrder>> fetchOrders(
    String accessToken, {
    int first = 10,
    String? after,
  }) =>
      _repository.getOrders(accessToken, first: first, after: after);

  /// Adds a new shipping address to the customer account.
  Future<CustomerAddress> addAddress(
    String accessToken,
    CustomerAddress address,
  ) =>
      _repository.createAddress(accessToken, address);

  /// Updates an existing address by ID.
  Future<CustomerAddress> updateAddress(
    String accessToken,
    CustomerAddress address,
  ) =>
      _repository.updateAddress(accessToken, address);

  /// Removes an address by ID.
  Future<void> deleteAddress(String accessToken, String addressId) =>
      _repository.deleteAddress(accessToken, addressId);

  /// Sets an address as the customer's default shipping address.
  Future<void> setDefaultAddress(String accessToken, String addressId) =>
      _repository.setDefaultAddress(accessToken, addressId);

  /// Updates customer profile fields (name, email, phone, marketing opt-in).
  Future<Customer> updateProfile(
    String accessToken, {
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    bool? acceptsMarketing,
  }) =>
      _repository.updateProfile(
        accessToken,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phone: phone,
        acceptsMarketing: acceptsMarketing,
      );
}
