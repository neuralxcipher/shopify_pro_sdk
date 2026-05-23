/// GraphQL mutations for customer authentication.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

abstract final class AuthMutations {
  static const String customerCreate = r'''
    mutation CustomerCreate($input: CustomerCreateInput!) {
      customerCreate(input: $input) {
        customer { id email firstName lastName phone acceptsMarketing createdAt tags }
        customerUserErrors { code field message }
      }
    }
  ''';

  static const String customerAccessTokenCreate = r'''
    mutation CustomerAccessTokenCreate($input: CustomerAccessTokenCreateInput!) {
      customerAccessTokenCreate(input: $input) {
        customerAccessToken { accessToken expiresAt }
        customerUserErrors { code field message }
      }
    }
  ''';

  static const String customerAccessTokenRenew = r'''
    mutation CustomerAccessTokenRenew($customerAccessToken: String!) {
      customerAccessTokenRenew(customerAccessToken: $customerAccessToken) {
        customerAccessToken { accessToken expiresAt }
        userErrors { field message }
      }
    }
  ''';

  static const String customerAccessTokenDelete = r'''
    mutation CustomerAccessTokenDelete($customerAccessToken: String!) {
      customerAccessTokenDelete(customerAccessToken: $customerAccessToken) {
        deletedAccessToken
        deletedCustomerAccessTokenId
        userErrors { field message }
      }
    }
  ''';

  static const String customerRecover = r'''
    mutation CustomerRecover($email: String!) {
      customerRecover(email: $email) {
        customerUserErrors { code field message }
      }
    }
  ''';

  static const String customerReset = r'''
    mutation CustomerReset($id: ID!, $input: CustomerResetInput!) {
      customerReset(id: $id, input: $input) {
        customer { id email }
        customerAccessToken { accessToken expiresAt }
        customerUserErrors { code field message }
      }
    }
  ''';
}
