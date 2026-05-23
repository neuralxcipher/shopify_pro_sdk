/// GraphQL mutations for the checkout feature.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

abstract final class CheckoutMutations {
  static const String checkoutCreate = r'''
    mutation CheckoutCreate($input: CheckoutCreateInput!) {
      checkoutCreate(input: $input) {
        checkout {
          id webUrl ready email note orderStatusUrl
          subtotalPriceV2 { amount currencyCode }
          totalPriceV2    { amount currencyCode }
          totalTaxV2      { amount currencyCode }
        }
        checkoutUserErrors { code field message }
      }
    }
  ''';

  static const String checkoutEmailUpdate = r'''
    mutation CheckoutEmailUpdate($checkoutId: ID!, $email: String!) {
      checkoutEmailUpdateV2(checkoutId: $checkoutId, email: $email) {
        checkout { id email webUrl }
        checkoutUserErrors { code field message }
      }
    }
  ''';

  static const String checkoutDiscountCodeApply = r'''
    mutation CheckoutDiscountApply($discountCode: String!, $checkoutId: ID!) {
      checkoutDiscountCodeApplyV2(discountCode: $discountCode, checkoutId: $checkoutId) {
        checkout {
          id webUrl
          subtotalPriceV2 { amount currencyCode }
          totalPriceV2    { amount currencyCode }
        }
        checkoutUserErrors { code field message }
      }
    }
  ''';

  static const String checkoutDiscountCodeRemove = r'''
    mutation CheckoutDiscountRemove($checkoutId: ID!) {
      checkoutDiscountCodeRemove(checkoutId: $checkoutId) {
        checkout { id webUrl totalPriceV2 { amount currencyCode } }
        checkoutUserErrors { code field message }
      }
    }
  ''';
}
