/// GraphQL mutations for customer profile management.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

abstract final class CustomerMutations {
  static const String customerUpdate = r'''
    mutation CustomerUpdate($customerAccessToken: String!, $customer: CustomerUpdateInput!) {
      customerUpdate(customerAccessToken: $customerAccessToken, customer: $customer) {
        customer {
          id email firstName lastName phone acceptsMarketing
        }
        customerUserErrors { code field message }
      }
    }
  ''';

  static const String customerAddressCreate = r'''
    mutation CustomerAddressCreate($customerAccessToken: String!, $address: MailingAddressInput!) {
      customerAddressCreate(customerAccessToken: $customerAccessToken, address: $address) {
        customerAddress {
          id address1 address2 city company country
          firstName lastName phone province zip
        }
        customerUserErrors { code field message }
      }
    }
  ''';

  static const String customerAddressUpdate = r'''
    mutation CustomerAddressUpdate($customerAccessToken: String!, $id: ID!, $address: MailingAddressInput!) {
      customerAddressUpdate(customerAccessToken: $customerAccessToken, id: $id, address: $address) {
        customerAddress {
          id address1 address2 city company country
          firstName lastName phone province zip
        }
        customerUserErrors { code field message }
      }
    }
  ''';

  static const String customerAddressDelete = r'''
    mutation CustomerAddressDelete($customerAccessToken: String!, $id: ID!) {
      customerAddressDelete(customerAccessToken: $customerAccessToken, id: $id) {
        deletedCustomerAddressId
        customerUserErrors { code field message }
      }
    }
  ''';

  static const String customerDefaultAddressUpdate = r'''
    mutation CustomerDefaultAddressUpdate($customerAccessToken: String!, $addressId: ID!) {
      customerDefaultAddressUpdate(
        customerAccessToken: $customerAccessToken
        addressId: $addressId
      ) {
        customer { id }
        customerUserErrors { code field message }
      }
    }
  ''';
}
