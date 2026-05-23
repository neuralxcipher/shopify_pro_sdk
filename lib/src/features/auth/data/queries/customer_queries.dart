/// GraphQL queries for fetching customer data.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

abstract final class AuthCustomerQueries {
  static const String getCustomer = r'''
    query GetCustomer($customerAccessToken: String!) {
      customer(customerAccessToken: $customerAccessToken) {
        id email firstName lastName phone displayName acceptsMarketing createdAt tags
      }
    }
  ''';
}
